import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../data/models/weather_data.dart';
import '../data/models/persona_type.dart';
import '../data/models/location_result.dart';
import '../data/repositories/weather_repository.dart';
import '../data/services/india_location_filter.dart';
import '../data/services/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repository;

  WeatherData? _weatherData;
  bool _isLoading = false;
  bool _isOffline = false;
  DateTime? _lastUpdated;
  String? _errorMessage;
  String _selectedCity = 'New Delhi';
  LocationResult _currentLocation = LocationResult.defaultDelhi();
  List<LocationResult> _recentLocations = [
    LocationResult.defaultDelhi(),
    const LocationResult(
      name: 'Mumbai',
      state: 'Maharashtra',
      country: 'India',
      countryCode: 'IN',
      latitude: 18.9220,
      longitude: 72.8347,
      isCoastal: true,
      coastDistanceKm: 2.0,
      displayName: 'Mumbai, Maharashtra, India',
    ),
    const LocationResult(
      name: 'Kochi',
      state: 'Kerala',
      country: 'India',
      countryCode: 'IN',
      latitude: 9.9312,
      longitude: 76.2673,
      isCoastal: true,
      coastDistanceKm: 0.0,
      displayName: 'Kochi, Kerala, India',
    ),
  ];
  PersonaType? _activeFilterPersona;

  WeatherViewModel({WeatherRepository? repository})
      : _repository = repository ?? WeatherRepository();

  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  DateTime? get lastUpdated => _lastUpdated;
  String? get errorMessage => _errorMessage;
  String get selectedCity => _selectedCity;
  LocationResult get currentLocation => _currentLocation;
  List<LocationResult> get recentLocations => _recentLocations;
  PersonaType? get activeFilterPersona => _activeFilterPersona;

  /// Loads saved location and recents from storage with strict India-only sanitization
  Future<void> initialize() async {
    try {
      final prefs = await _repository.loadPreferences();
      _currentLocation = prefs.currentLocation;
      if (IndiaLocationFilter.shouldRejectLocationName(_currentLocation.name) ||
          !_currentLocation.isIndia) {
        _currentLocation = LocationResult.defaultDelhi();
      }
      _selectedCity = _currentLocation.name;

      if (prefs.recentLocations.isNotEmpty) {
        _recentLocations = prefs.recentLocations
            .where((l) =>
                l.isIndia &&
                !IndiaLocationFilter.shouldRejectLocationName(l.name) &&
                l.country.toLowerCase() == 'india')
            .toList();
      }

      if (_recentLocations.isEmpty) {
        _recentLocations = [
          LocationResult.defaultDelhi(),
          const LocationResult(
            name: 'Mumbai',
            state: 'Maharashtra',
            country: 'India',
            countryCode: 'IN',
            latitude: 18.9220,
            longitude: 72.8347,
            isCoastal: true,
            coastDistanceKm: 2.0,
            displayName: 'Mumbai, Maharashtra, India',
          ),
          const LocationResult(
            name: 'Kochi',
            state: 'Kerala',
            country: 'India',
            countryCode: 'IN',
            latitude: 9.9312,
            longitude: 76.2673,
            isCoastal: true,
            coastDistanceKm: 0.0,
            displayName: 'Kochi, Kerala, India',
          ),
        ];
      }

      // Re-save sanitized preferences to permanently wipe foreign entries from localStorage
      await _repository.savePreferences(
        prefs.copyWith(
          currentLocation: _currentLocation,
          recentLocations: _recentLocations,
          defaultCity: _currentLocation.name,
        ),
      );

      notifyListeners();
    } catch (_) {}
  }

  /// Sets the active persona filter (null means show all selected personas)
  void setActiveFilterPersona(PersonaType? persona) {
    _activeFilterPersona = persona;
    notifyListeners();
  }

  /// Searches locations globally (online backend/OSM or offline dictionary)
  Future<List<LocationResult>> searchLocations(String query) async {
    return _repository.searchLocations(query);
  }

  /// Selects a specific location and fetches its weather
  Future<void> selectLocation(
    LocationResult location, {
    bool isOfflineMode = false,
  }) async {
    _currentLocation = location;
    _selectedCity = location.name;

    // Update recents: deduplicate by name, place at top, max 8 items
    _recentLocations.removeWhere(
      (l) => l.name.toLowerCase() == location.name.toLowerCase(),
    );
    _recentLocations.insert(0, location);
    if (_recentLocations.length > 8) {
      _recentLocations = _recentLocations.sublist(0, 8);
    }

    // Persist to user preferences
    try {
      final currentPrefs = await _repository.loadPreferences();
      await _repository.savePreferences(
        currentPrefs.copyWith(
          currentLocation: _currentLocation,
          recentLocations: _recentLocations,
          defaultCity: location.name,
        ),
      );
    } catch (_) {}

    notifyListeners();
    await loadWeather(forceRefresh: true, isOfflineMode: isOfflineMode);
  }

  /// Changes the city by name (backward compatibility)
  Future<void> changeCity(String newCity, {bool isOfflineMode = false}) async {
    if (_selectedCity == newCity && _weatherData != null) return;
    
    final match = WeatherService.fallbackLocations.firstWhere(
      (l) =>
          l.name.toLowerCase() == newCity.toLowerCase() ||
          l.name.toLowerCase().contains(newCity.toLowerCase()) ||
          newCity.toLowerCase().contains(l.name.toLowerCase()),
      orElse: () {
        final lower = newCity.toLowerCase();
        double lat = 18.9220;
        double lon = 72.8347;
        double coastDist = 2.0;
        bool coastal = false;

        if (lower.contains('surat')) {
          lat = 21.1702; lon = 72.8311; coastDist = 14.0; coastal = true;
        } else if (lower.contains('mumbai')) {
          lat = 18.9220; lon = 72.8347; coastDist = 2.0; coastal = true;
        } else if (lower.contains('goa') || lower.contains('panaji')) {
          lat = 15.4909; lon = 73.8278; coastDist = 3.5; coastal = true;
        } else if (lower.contains('kochi') || lower.contains('cochin')) {
          lat = 9.9312; lon = 76.2673; coastDist = 0.0; coastal = true;
        } else if (lower.contains('chennai')) {
          lat = 13.0827; lon = 80.2707; coastDist = 1.5; coastal = true;
        } else if (lower.contains('puri')) {
          lat = 19.8135; lon = 85.8312; coastDist = 1.0; coastal = true;
        } else if (lower.contains('vizag') || lower.contains('visakhapatnam')) {
          lat = 17.6868; lon = 83.2185; coastDist = 1.2; coastal = true;
        }

        return LocationResult(
          name: newCity,
          country: 'India',
          countryCode: 'IN',
          latitude: lat,
          longitude: lon,
          isCoastal: coastal,
          coastDistanceKm: coastal ? coastDist : null,
          displayName: '$newCity, India',
        );
      },
    );

    await selectLocation(match, isOfflineMode: isOfflineMode);
  }

  /// Acquires user device GPS position via geolocator
  Future<String?> useCurrentGpsLocation({bool isOfflineMode = false}) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return 'Location services are disabled on your device.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return 'Location permissions are permanently denied.';
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 6),
        ),
      );

      final location = await _repository.reverseGeocode(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await selectLocation(location, isOfflineMode: isOfflineMode);
      return null;
    } catch (e) {
      _errorMessage = 'GPS Error: $e';
      notifyListeners();
      return 'Could not retrieve GPS location: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads weather data for current location
  Future<void> loadWeather({
    bool forceRefresh = false,
    bool isOfflineMode = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getWeatherForLocation(
        location: _currentLocation,
        forceRefresh: forceRefresh,
        isOfflineDemoMode: isOfflineMode,
      );

      _weatherData = result.data;
      _isOffline = result.isFromCache;
      _lastUpdated = result.cacheTimestamp ?? result.data.lastUpdated;
    } catch (e) {
      _errorMessage = 'Failed to load weather data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Pull-to-refresh
  Future<void> refresh({bool isOfflineMode = false}) async {
    await loadWeather(forceRefresh: true, isOfflineMode: isOfflineMode);
  }
}
