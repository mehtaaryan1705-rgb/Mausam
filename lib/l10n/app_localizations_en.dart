// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mausam';

  @override
  String get ministrySubtitle => 'Ministry of Earth Sciences, Govt. of India';

  @override
  String get welcomeTitle => 'Welcome to Mausam';

  @override
  String get onboardingPrompt =>
      'Select your personas to personalize your weather experience:';

  @override
  String get continueButton => 'Continue to Mausam';

  @override
  String get savePreferences => 'Save Preferences';

  @override
  String get settingsTitle => 'Settings & Preferences';

  @override
  String get personaSettingsTitle => 'Active Personas';

  @override
  String get personaSettingsSubtitle =>
      'Choose which persona cards appear on your home feed';

  @override
  String get locationTitle => 'Location';

  @override
  String get offlineModeTitle => 'Offline Demo Mode';

  @override
  String get offlineModeSubtitle =>
      'Simulate network outage to test offline caching';

  @override
  String get lastUpdated => 'Last updated';

  @override
  String get dataSourceInfo => 'Data Source Information';

  @override
  String cachedDataNotice(String time) {
    return 'Working Offline — Showing cached data from $time';
  }

  @override
  String get languageSelectTitle => 'Choose Your Language';

  @override
  String get languageSelectSubtitle =>
      'Select your preferred language for official forecasts, advisories, and alerts.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languageEnglishSub => 'Official National English';

  @override
  String get languageHindiSub => 'भारत की राजभाषा (Hindi)';

  @override
  String get changeLanguage => 'Change Language / भाषा बदलें';

  @override
  String get changeLanguageDesc => 'Switch language between English and हिंदी';

  @override
  String get searchLocationHint => 'Search Indian city, district, or town...';

  @override
  String get useCurrentLocation => 'Use Current Location (GPS)';

  @override
  String get useCurrentLocationSub =>
      'Auto-detect nearest IMD weather telemetry';

  @override
  String get recentLocationsTitle => 'Recent & Saved Locations';

  @override
  String get searchResultsTitle => 'Search Results';

  @override
  String get activeBadge => 'Active';

  @override
  String get coastalZone => 'Coastal Zone';

  @override
  String get inlandCity => 'Inland City';

  @override
  String get globalCity => 'Indian Territory';

  @override
  String get retryConnection => 'Retry Connection';

  @override
  String get humidity => 'Humidity';

  @override
  String get wind => 'Wind';

  @override
  String get aqiLabel => 'AQI';

  @override
  String get updated => 'Updated';

  @override
  String get feelsLike => 'Feels like';

  @override
  String get moesMandateNotice =>
      'Available for Indian regions under Ministry of Earth Sciences mandate';

  @override
  String get healthConsciousTitle => 'Health-Conscious';

  @override
  String get healthConsciousDesc =>
      'AQI levels, PM2.5, UV index, and pollen alerts';

  @override
  String get outdoorFitnessTitle => 'Outdoor Fitness';

  @override
  String get outdoorFitnessDesc =>
      'Best running hours, golden hour, wind & thermal comfort';

  @override
  String get beachgoersSurfersTitle => 'Beachgoers & Surfers';

  @override
  String get beachgoersSurfersDesc =>
      'High/low tide, wave height, sea roughness & water temp';

  @override
  String get travelersTitle => 'Travelers';

  @override
  String get travelersDesc =>
      'Saved cities, severe weather alerts & packing suggestions';

  @override
  String get parentsFamiliesTitle => 'Parents & Families';

  @override
  String get parentsFamiliesDesc =>
      'School commute windows (7-9 AM & 2-4 PM) & rain alerts';

  @override
  String get agricultureGardenersTitle => 'Agriculture & Gardeners';

  @override
  String get agricultureGardenersDesc =>
      'Soil moisture estimates, 48h rainfall & seasonal crop tips';

  @override
  String get commutersTitle => 'Commuters';

  @override
  String get commutersDesc =>
      'Visibility, traffic impact overlay & fog/storm warnings';

  @override
  String get eventPlannersTitle => 'Event Planners';

  @override
  String get eventPlannersDesc =>
      '10-day forecast, rain probabilities & 0-100 Comfort Index';

  @override
  String get navHome => 'Feed';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navSearch => 'Search';

  @override
  String get navSettings => 'Settings';

  @override
  String get dashboardTitle => 'Weather Dashboard';

  @override
  String get comfortIndexLabel => 'Comfort Index';

  @override
  String get vitalsTitle => 'Vitals & Environment';
}
