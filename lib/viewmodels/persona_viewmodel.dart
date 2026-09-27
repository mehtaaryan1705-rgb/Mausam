import 'package:flutter/material.dart';
import '../data/models/persona_type.dart';
import '../data/models/user_preferences.dart';
import '../data/repositories/weather_repository.dart';

class PersonaViewModel extends ChangeNotifier {
  final WeatherRepository _repository;
  UserPreferences _preferences = UserPreferences.defaultPreferences();
  bool _isInitialized = false;

  PersonaViewModel({WeatherRepository? repository})
      : _repository = repository ?? WeatherRepository();

  UserPreferences get preferences => _preferences;
  List<PersonaType> get selectedPersonas => _preferences.selectedPersonas;
  String get defaultCity => _preferences.defaultCity;
  bool get hasCompletedOnboarding => _preferences.hasCompletedOnboarding;
  bool get isOfflineDemoMode => _preferences.isOfflineDemoMode;
  List<String> get savedDestinations => _preferences.savedDestinations;
  String? get languageCode => _preferences.languageCode;
  bool get isInitialized => _isInitialized;

  /// Sets the application language ('en' or 'hi')
  Future<void> setLanguageCode(String code) async {
    _preferences = _preferences.copyWith(languageCode: code);
    notifyListeners();
    await _repository.savePreferences(_preferences);
  }

  /// Initializes preferences from storage
  Future<void> initialize() async {
    _preferences = await _repository.loadPreferences();
    _isInitialized = true;
    notifyListeners();
  }

  /// Toggles a persona on or off
  Future<void> togglePersona(PersonaType persona) async {
    final current = List<PersonaType>.from(_preferences.selectedPersonas);
    if (current.contains(persona)) {
      if (current.length > 1) {
        // Maintain at least one active persona
        current.remove(persona);
      }
    } else {
      current.add(persona);
    }
    _preferences = _preferences.copyWith(selectedPersonas: current);
    notifyListeners();
    await _repository.savePreferences(_preferences);
  }

  /// Sets multiple personas at once (e.g. during onboarding)
  Future<void> setPersonas(List<PersonaType> personas) async {
    if (personas.isEmpty) return;
    _preferences = _preferences.copyWith(selectedPersonas: personas);
    notifyListeners();
    await _repository.savePreferences(_preferences);
  }

  /// Sets default city
  Future<void> setDefaultCity(String city) async {
    _preferences = _preferences.copyWith(defaultCity: city);
    notifyListeners();
    await _repository.savePreferences(_preferences);
  }

  /// Completes onboarding
  Future<void> completeOnboarding() async {
    _preferences = _preferences.copyWith(hasCompletedOnboarding: true);
    notifyListeners();
    await _repository.savePreferences(_preferences);
  }

  /// Toggles offline demo mode to test degraded behavior
  Future<void> toggleOfflineDemoMode() async {
    final newMode = !_preferences.isOfflineDemoMode;
    _preferences = _preferences.copyWith(isOfflineDemoMode: newMode);
    notifyListeners();
    await _repository.savePreferences(_preferences);
  }

  /// Adds a destination for the Traveler persona
  Future<void> addSavedDestination(String city) async {
    if (city.trim().isEmpty) return;
    final current = List<String>.from(_preferences.savedDestinations);
    if (!current.contains(city.trim())) {
      current.add(city.trim());
      _preferences = _preferences.copyWith(savedDestinations: current);
      notifyListeners();
      await _repository.savePreferences(_preferences);
    }
  }

  /// Removes a destination for the Traveler persona
  Future<void> removeSavedDestination(String city) async {
    final current = List<String>.from(_preferences.savedDestinations);
    current.remove(city);
    _preferences = _preferences.copyWith(savedDestinations: current);
    notifyListeners();
    await _repository.savePreferences(_preferences);
  }

  /// Resets preferences for testing
  Future<void> resetPreferences() async {
    _preferences = UserPreferences.defaultPreferences();
    notifyListeners();
    await _repository.savePreferences(_preferences);
  }
}
