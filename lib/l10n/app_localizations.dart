import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// App title
  ///
  /// In en, this message translates to:
  /// **'Mausam'**
  String get appTitle;

  /// No description provided for @ministrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ministry of Earth Sciences, Govt. of India'**
  String get ministrySubtitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mausam'**
  String get welcomeTitle;

  /// No description provided for @onboardingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Select your personas to personalize your weather experience:'**
  String get onboardingPrompt;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue to Mausam'**
  String get continueButton;

  /// No description provided for @savePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get savePreferences;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings & Preferences'**
  String get settingsTitle;

  /// No description provided for @personaSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Personas'**
  String get personaSettingsTitle;

  /// No description provided for @personaSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose which persona cards appear on your home feed'**
  String get personaSettingsSubtitle;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationTitle;

  /// No description provided for @offlineModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline Demo Mode'**
  String get offlineModeTitle;

  /// No description provided for @offlineModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Simulate network outage to test offline caching'**
  String get offlineModeSubtitle;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get lastUpdated;

  /// No description provided for @dataSourceInfo.
  ///
  /// In en, this message translates to:
  /// **'Data Source Information'**
  String get dataSourceInfo;

  /// No description provided for @cachedDataNotice.
  ///
  /// In en, this message translates to:
  /// **'Working Offline — Showing cached data from {time}'**
  String cachedDataNotice(String time);

  /// No description provided for @languageSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get languageSelectTitle;

  /// No description provided for @languageSelectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language for official forecasts, advisories, and alerts.'**
  String get languageSelectSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get languageHindi;

  /// No description provided for @languageEnglishSub.
  ///
  /// In en, this message translates to:
  /// **'Official National English'**
  String get languageEnglishSub;

  /// No description provided for @languageHindiSub.
  ///
  /// In en, this message translates to:
  /// **'भारत की राजभाषा (Hindi)'**
  String get languageHindiSub;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language / भाषा बदलें'**
  String get changeLanguage;

  /// No description provided for @changeLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch language between English and हिंदी'**
  String get changeLanguageDesc;

  /// No description provided for @searchLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Search Indian city, district, or town...'**
  String get searchLocationHint;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location (GPS)'**
  String get useCurrentLocation;

  /// No description provided for @useCurrentLocationSub.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect nearest IMD weather telemetry'**
  String get useCurrentLocationSub;

  /// No description provided for @recentLocationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent & Saved Locations'**
  String get recentLocationsTitle;

  /// No description provided for @searchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResultsTitle;

  /// No description provided for @activeBadge.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeBadge;

  /// No description provided for @coastalZone.
  ///
  /// In en, this message translates to:
  /// **'Coastal Zone'**
  String get coastalZone;

  /// No description provided for @inlandCity.
  ///
  /// In en, this message translates to:
  /// **'Inland City'**
  String get inlandCity;

  /// No description provided for @globalCity.
  ///
  /// In en, this message translates to:
  /// **'Indian Territory'**
  String get globalCity;

  /// No description provided for @retryConnection.
  ///
  /// In en, this message translates to:
  /// **'Retry Connection'**
  String get retryConnection;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @aqiLabel.
  ///
  /// In en, this message translates to:
  /// **'AQI'**
  String get aqiLabel;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feelsLike;

  /// No description provided for @moesMandateNotice.
  ///
  /// In en, this message translates to:
  /// **'Available for Indian regions under Ministry of Earth Sciences mandate'**
  String get moesMandateNotice;

  /// No description provided for @healthConsciousTitle.
  ///
  /// In en, this message translates to:
  /// **'Health-Conscious'**
  String get healthConsciousTitle;

  /// No description provided for @healthConsciousDesc.
  ///
  /// In en, this message translates to:
  /// **'AQI levels, PM2.5, UV index, and pollen alerts'**
  String get healthConsciousDesc;

  /// No description provided for @outdoorFitnessTitle.
  ///
  /// In en, this message translates to:
  /// **'Outdoor Fitness'**
  String get outdoorFitnessTitle;

  /// No description provided for @outdoorFitnessDesc.
  ///
  /// In en, this message translates to:
  /// **'Best running hours, golden hour, wind & thermal comfort'**
  String get outdoorFitnessDesc;

  /// No description provided for @beachgoersSurfersTitle.
  ///
  /// In en, this message translates to:
  /// **'Beachgoers & Surfers'**
  String get beachgoersSurfersTitle;

  /// No description provided for @beachgoersSurfersDesc.
  ///
  /// In en, this message translates to:
  /// **'High/low tide, wave height, sea roughness & water temp'**
  String get beachgoersSurfersDesc;

  /// No description provided for @travelersTitle.
  ///
  /// In en, this message translates to:
  /// **'Travelers'**
  String get travelersTitle;

  /// No description provided for @travelersDesc.
  ///
  /// In en, this message translates to:
  /// **'Saved cities, severe weather alerts & packing suggestions'**
  String get travelersDesc;

  /// No description provided for @parentsFamiliesTitle.
  ///
  /// In en, this message translates to:
  /// **'Parents & Families'**
  String get parentsFamiliesTitle;

  /// No description provided for @parentsFamiliesDesc.
  ///
  /// In en, this message translates to:
  /// **'School commute windows (7-9 AM & 2-4 PM) & rain alerts'**
  String get parentsFamiliesDesc;

  /// No description provided for @agricultureGardenersTitle.
  ///
  /// In en, this message translates to:
  /// **'Agriculture & Gardeners'**
  String get agricultureGardenersTitle;

  /// No description provided for @agricultureGardenersDesc.
  ///
  /// In en, this message translates to:
  /// **'Soil moisture estimates, 48h rainfall & seasonal crop tips'**
  String get agricultureGardenersDesc;

  /// No description provided for @commutersTitle.
  ///
  /// In en, this message translates to:
  /// **'Commuters'**
  String get commutersTitle;

  /// No description provided for @commutersDesc.
  ///
  /// In en, this message translates to:
  /// **'Visibility, traffic impact overlay & fog/storm warnings'**
  String get commutersDesc;

  /// No description provided for @eventPlannersTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Planners'**
  String get eventPlannersTitle;

  /// No description provided for @eventPlannersDesc.
  ///
  /// In en, this message translates to:
  /// **'10-day forecast, rain probabilities & 0-100 Comfort Index'**
  String get eventPlannersDesc;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get navHome;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather Dashboard'**
  String get dashboardTitle;

  /// No description provided for @comfortIndexLabel.
  ///
  /// In en, this message translates to:
  /// **'Comfort Index'**
  String get comfortIndexLabel;

  /// No description provided for @vitalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vitals & Environment'**
  String get vitalsTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
