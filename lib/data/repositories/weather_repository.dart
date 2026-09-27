import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';
import '../models/user_preferences.dart';
import '../services/weather_service.dart';
import '../services/mock_weather_data.dart';
import '../services/incois_tide_service.dart';

import '../models/location_result.dart';

class WeatherRepository {
  final WeatherService _service;
  SharedPreferences? _prefs;

  WeatherRepository({WeatherService? service})
      : _service = service ?? WeatherService();

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Searches locations globally with 400ms debouncing and local/OSM fallback
  Future<List<LocationResult>> searchLocations(String query) async {
    return _service.searchLocations(query);
  }

  /// Resolves GPS coordinates into a LocationResult
  Future<LocationResult> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    return _service.reverseGeocode(latitude: latitude, longitude: longitude);
  }

  /// Retrieves weather for a [LocationResult] with offline caching support.
  Future<({WeatherData data, bool isFromCache, DateTime? cacheTimestamp})>
      getWeatherForLocation({
    required LocationResult location,
    bool forceRefresh = false,
    bool isOfflineDemoMode = false,
  }) async {
    final prefs = await _getPrefs();
    final cacheKey = 'mausam_cached_weather_${location.name}';
    final timeKey = 'mausam_cached_time_${location.name}';

    // If offline demo mode is activated, try to return cached data immediately
    if (isOfflineDemoMode && !forceRefresh) {
      final cachedJsonStr = prefs.getString(cacheKey);
      final cachedTimeStr = prefs.getString(timeKey);

      if (cachedJsonStr != null) {
        final cachedMap = jsonDecode(cachedJsonStr) as Map<String, dynamic>;
        var cachedData = WeatherData.fromJson(cachedMap);
        if (location.isCoastal) {
          cachedData = cachedData.copyWith(
            tideSea: IncoisTideService.calculateTideData(
              cityName: location.name,
              latitude: location.latitude,
              longitude: location.longitude,
              coastDistanceKm: location.coastDistanceKm,
            ),
          );
        }
        final cachedTime = cachedTimeStr != null
            ? DateTime.tryParse(cachedTimeStr)
            : null;
        return (
          data: cachedData,
          isFromCache: true,
          cacheTimestamp: cachedTime,
        );
      }
    }

    try {
      if (isOfflineDemoMode) {
        throw Exception('Simulated offline mode enabled.');
      }

      // Live fetch from service (Mock or Node backend / IMD / CAAQMS)
      final freshData = await _service.fetchWeatherForLocation(location);

      // Save to cache
      final jsonStr = jsonEncode(freshData.toJson());
      final nowStr = DateTime.now().toIso8601String();
      await prefs.setString(cacheKey, jsonStr);
      await prefs.setString(timeKey, nowStr);

      return (
        data: freshData,
        isFromCache: false,
        cacheTimestamp: DateTime.now(),
      );
    } catch (e) {
      // Offline fallback: Attempt to load from cache
      final cachedJsonStr = prefs.getString(cacheKey);
      final cachedTimeStr = prefs.getString(timeKey);

      if (cachedJsonStr != null) {
        final cachedMap = jsonDecode(cachedJsonStr) as Map<String, dynamic>;
        var cachedData = WeatherData.fromJson(cachedMap);
        if (location.isCoastal) {
          cachedData = cachedData.copyWith(
            tideSea: IncoisTideService.calculateTideData(
              cityName: location.name,
              latitude: location.latitude,
              longitude: location.longitude,
              coastDistanceKm: location.coastDistanceKm,
            ),
          );
        }
        final cachedTime = cachedTimeStr != null
            ? DateTime.tryParse(cachedTimeStr)
            : null;
        return (
          data: cachedData,
          isFromCache: true,
          cacheTimestamp: cachedTime,
        );
      }

      // If never cached before, synthesize realistic emergency offline cache
      final fallbackData = await _service.fetchWeatherForLocation(location);
      final fallbackTime = DateTime.now().subtract(const Duration(hours: 2));

      await prefs.setString(cacheKey, jsonEncode(fallbackData.toJson()));
      await prefs.setString(timeKey, fallbackTime.toIso8601String());

      return (
        data: fallbackData,
        isFromCache: true,
        cacheTimestamp: fallbackTime,
      );
    }
  }

  /// Retrieves weather for a city with offline caching support (backward compatibility).
  Future<({WeatherData data, bool isFromCache, DateTime? cacheTimestamp})>
      getWeather({
    required String cityName,
    bool forceRefresh = false,
    bool isOfflineDemoMode = false,
  }) async {
    final match = WeatherService.fallbackLocations.firstWhere(
      (l) =>
          l.name.toLowerCase() == cityName.toLowerCase() ||
          l.name.toLowerCase().contains(cityName.toLowerCase()) ||
          cityName.toLowerCase().contains(l.name.toLowerCase()),
      orElse: () {
        final lower = cityName.toLowerCase();
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
          name: cityName,
          country: 'India',
          countryCode: 'IN',
          latitude: lat,
          longitude: lon,
          isCoastal: coastal,
          coastDistanceKm: coastal ? coastDist : null,
          displayName: '$cityName, India',
        );
      },
    );

    return getWeatherForLocation(
      location: match,
      forceRefresh: forceRefresh,
      isOfflineDemoMode: isOfflineDemoMode,
    );
  }

  /// Loads user persona preferences and configuration
  Future<UserPreferences> loadPreferences() async {
    final prefs = await _getPrefs();
    final prefStr = prefs.getString('mausam_user_preferences');
    if (prefStr != null) {
      try {
        final map = jsonDecode(prefStr) as Map<String, dynamic>;
        return UserPreferences.fromJson(map);
      } catch (_) {
        return UserPreferences.defaultPreferences();
      }
    }
    return UserPreferences.defaultPreferences();
  }

  /// Saves user persona preferences and configuration
  Future<void> savePreferences(UserPreferences preferences) async {
    final prefs = await _getPrefs();
    await prefs.setString(
      'mausam_user_preferences',
      jsonEncode(preferences.toJson()),
    );
  }

  /// Clears local cache for testing
  Future<void> clearCache() async {
    final prefs = await _getPrefs();
    final keys = prefs.getKeys().where((k) => k.startsWith('mausam_cached_'));
    for (final k in keys) {
      await prefs.remove(k);
    }
  }
}
