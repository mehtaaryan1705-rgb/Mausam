// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'मौसम';

  @override
  String get ministrySubtitle => 'पृथ्वी विज्ञान मंत्रालय, भारत सरकार';

  @override
  String get welcomeTitle => 'मौसम में आपका स्वागत है';

  @override
  String get onboardingPrompt =>
      'अपने मौसम अनुभव को अनुकूलित करने के लिए अपने प्रोफाइल चुनें:';

  @override
  String get continueButton => 'मौसम पर आगे बढ़ें';

  @override
  String get savePreferences => 'प्राथमिकताएं सहेजें';

  @override
  String get settingsTitle => 'सेटिंग्स और प्राथमिकताएं';

  @override
  String get personaSettingsTitle => 'सक्रिय प्रोफाइल';

  @override
  String get personaSettingsSubtitle =>
      'चुनें कि आपके होम फ़ीड पर कौन से कार्ड दिखाई देंगे';

  @override
  String get locationTitle => 'स्थान';

  @override
  String get offlineModeTitle => 'ऑफ़लाइन डेमो मोड';

  @override
  String get offlineModeSubtitle =>
      'ऑफ़लाइन कैशिंग का परीक्षण करने के लिए नेटवर्क आउटेज का अनुकरण करें';

  @override
  String get lastUpdated => 'अंतिम अपडेट';

  @override
  String get dataSourceInfo => 'डेटा स्रोत जानकारी';

  @override
  String cachedDataNotice(String time) {
    return 'ऑफ़लाइन कार्य कर रहे हैं — $time से कैश किया गया डेटा';
  }

  @override
  String get languageSelectTitle => 'अपनी भाषा चुनें';

  @override
  String get languageSelectSubtitle =>
      'आधिकारिक मौसम पूर्वानुमान, चेतावनियों और सलाह के लिए अपनी पसंदीदा भाषा चुनें।';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languageEnglishSub => 'Official National English';

  @override
  String get languageHindiSub => 'भारत की राजभाषा (Hindi)';

  @override
  String get changeLanguage => 'भाषा बदलें / Change Language';

  @override
  String get changeLanguageDesc => 'हिंदी और English के बीच भाषा स्विच करें';

  @override
  String get searchLocationHint => 'दुनिया भर में शहर, कस्बा या गाँव खोजें...';

  @override
  String get useCurrentLocation => 'वर्तमान स्थान का उपयोग करें (GPS)';

  @override
  String get useCurrentLocationSub =>
      'निकटतम IMD मौसम केंद्र का स्वतः पता लगाएं';

  @override
  String get recentLocationsTitle => 'हाल ही में सहेजे गए स्थान';

  @override
  String get searchResultsTitle => 'खोज परिणाम';

  @override
  String get activeBadge => 'सक्रिय';

  @override
  String get coastalZone => 'तटीय क्षेत्र';

  @override
  String get inlandCity => 'अंतर्देशीय शहर';

  @override
  String get globalCity => 'वैश्विक शहर';

  @override
  String get retryConnection => 'पुनः प्रयास करें';

  @override
  String get humidity => 'नमी';

  @override
  String get wind => 'हवा';

  @override
  String get aqiLabel => 'AQI';

  @override
  String get updated => 'अपडेटेड';

  @override
  String get feelsLike => 'महसूस होता है';

  @override
  String get moesMandateNotice =>
      'पृथ्वी विज्ञान मंत्रालय के अधिदेश के तहत भारतीय क्षेत्रों के लिए उपलब्ध';

  @override
  String get healthConsciousTitle => 'स्वास्थ्य-जागरूक';

  @override
  String get healthConsciousDesc =>
      'AQI स्तर, PM2.5, UV सूचकांक, और पराग अलर्ट';

  @override
  String get outdoorFitnessTitle => 'आउटडोर फिटनेस';

  @override
  String get outdoorFitnessDesc =>
      'दौड़ने का सबसे अच्छा समय, सूर्योदय-सूर्यास्त और हवा की गति';

  @override
  String get beachgoersSurfersTitle => 'समुद्र तट और सर्फर';

  @override
  String get beachgoersSurfersDesc =>
      'ज्वार का समय, लहर की ऊंचाई, और पानी का तापमान';

  @override
  String get travelersTitle => 'यात्री';

  @override
  String get travelersDesc => 'सहेजे गए शहर, मौसम अलर्ट और पैकिंग सुझाव';

  @override
  String get parentsFamiliesTitle => 'माता-पिता और परिवार';

  @override
  String get parentsFamiliesDesc =>
      'स्कूल आने-जाने का मौसम (7-9 AM व 2-4 PM) और वर्षा अलर्ट';

  @override
  String get agricultureGardenersTitle => 'कृषि एवं बागवानी';

  @override
  String get agricultureGardenersDesc =>
      'मिट्टी की नमी, 48 घंटे की वर्षा और मौसमी फसल सलाह';

  @override
  String get commutersTitle => 'दैनिक यात्री';

  @override
  String get commutersDesc => 'दृश्यता, यातायात प्रभाव और कोहरा/तूफान चेतावनी';

  @override
  String get eventPlannersTitle => 'इवेंट प्लानर';

  @override
  String get eventPlannersDesc =>
      '10-दिवसीय पूर्वानुमान, वर्षा की संभावना और आराम सूचकांक';

  @override
  String get navHome => 'होम';

  @override
  String get navDashboard => 'डैशबोर्ड';

  @override
  String get navSearch => 'खोजें';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get dashboardTitle => 'मौसम डैशबोर्ड';

  @override
  String get comfortIndexLabel => 'आराम सूचकांक';

  @override
  String get vitalsTitle => 'पर्यावरण और स्थिति';
}
