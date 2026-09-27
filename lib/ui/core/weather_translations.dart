import 'package:flutter/widgets.dart';

/// WeatherTranslations provides standard Hindi and English localization mappings
/// for weather condition terms, sky states, and official CPCB National Air Quality Index (NAQI) categories.
class WeatherTranslations {
  static const Map<String, String> conditionHindiMap = {
    'hazy sunshine': 'धुंधली धूप',
    'sunny': 'धूप / साफ',
    'clear': 'साफ आसमान',
    'clear sky': 'साफ आसमान',
    'clear & crisp': 'साफ और सुहावना',
    'dry & sunny': 'शुष्क और धूप',
    'partly cloudy': 'आंशिक रूप से बादल',
    'mostly cloudy': 'अधिकांशतः बादल',
    'cloudy': 'बादल छाए रहेंगे',
    'overcast': 'घने बादल',
    'thunderstorms & rain': 'गरज के साथ बारिश',
    'thunderstorm': 'आंधी-तूफान',
    'thunderstorms': 'आंधी-तूफान',
    'scattered thunderstorms': 'छिटपुट गरज-चमक',
    'heavy rain': 'भारी वर्षा',
    'moderate rain': 'मध्यम वर्षा',
    'light rain': 'हल्की बारिश',
    'rain': 'वर्षा / बारिश',
    'showers': 'बौछारें',
    'rain & showers': 'बारिश और बौछारें',
    'drizzle': 'बूंदाबांदी',
    'fog': 'कोहरा',
    'foggy': 'घना कोहरा',
    'haze': 'धुंध',
    'mist': 'धुंध / कुहासा',
    'smoke': 'धुआं',
    'dust storm': 'धूल भरी आंधी',
    'hot & humid': 'गर्म और उमस भरा',
    'cold wave': 'शीत लहर',
    'heat wave': 'लू / भीषण गर्मी',
    'pleasant': 'सुहावना मौसम',
  };

  /// Official CPCB (Central Pollution Control Board) 6-stage NAQI categories in Hindi
  static const Map<String, String> aqiHindiMap = {
    'good': 'अच्छा',
    'satisfactory': 'संतोषजनक',
    'moderate': 'मध्यम',
    'poor': 'खराब',
    'very poor': 'बहुत खराब',
    'severe': 'गंभीर',
  };

  /// Translates a weather condition string based on the active [BuildContext] locale
  static String translateCondition(String condition, BuildContext context) {
    try {
      final locale = Localizations.localeOf(context);
      return translateConditionForLanguage(condition, locale.languageCode);
    } catch (_) {
      return condition;
    }
  }

  /// Translates a weather condition string for an explicit language code ('hi' or 'en')
  static String translateConditionForLanguage(String condition, String languageCode) {
    if (languageCode.toLowerCase() != 'hi') {
      return condition;
    }

    final key = condition.trim().toLowerCase();
    if (conditionHindiMap.containsKey(key)) {
      return conditionHindiMap[key]!;
    }

    // Partial substring fallback
    for (final entry in conditionHindiMap.entries) {
      if (key.contains(entry.key)) {
        return entry.value;
      }
    }

    return condition;
  }

  /// Translates official CPCB AQI category based on active [BuildContext] locale
  static String translateAqiCategory(String category, BuildContext context) {
    try {
      final locale = Localizations.localeOf(context);
      return translateAqiCategoryForLanguage(category, locale.languageCode);
    } catch (_) {
      return category;
    }
  }

  /// Translates official CPCB AQI category for explicit language code ('hi' or 'en')
  static String translateAqiCategoryForLanguage(String category, String languageCode) {
    if (languageCode.toLowerCase() != 'hi') {
      return category;
    }

    final key = category.trim().toLowerCase();
    return aqiHindiMap[key] ?? category;
  }
}
