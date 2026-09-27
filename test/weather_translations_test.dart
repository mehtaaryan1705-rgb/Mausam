import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/ui/core/weather_translations.dart';

void main() {
  group('WeatherTranslations Unit Tests', () {
    test('translates weather condition strings to Hindi when language is hi', () {
      expect(
        WeatherTranslations.translateConditionForLanguage('Hazy Sunshine', 'hi'),
        'धुंधली धूप',
      );
      expect(
        WeatherTranslations.translateConditionForLanguage('Thunderstorms & Rain', 'hi'),
        'गरज के साथ बारिश',
      );
      expect(
        WeatherTranslations.translateConditionForLanguage('Clear', 'hi'),
        'साफ आसमान',
      );
      expect(
        WeatherTranslations.translateConditionForLanguage('Heavy Rain', 'hi'),
        'भारी वर्षा',
      );
      expect(
        WeatherTranslations.translateConditionForLanguage('Foggy', 'hi'),
        'घना कोहरा',
      );
    });

    test('preserves English weather condition strings when language is en', () {
      expect(
        WeatherTranslations.translateConditionForLanguage('Hazy Sunshine', 'en'),
        'Hazy Sunshine',
      );
      expect(
        WeatherTranslations.translateConditionForLanguage('Thunderstorms & Rain', 'en'),
        'Thunderstorms & Rain',
      );
      expect(
        WeatherTranslations.translateConditionForLanguage('Clear', 'en'),
        'Clear',
      );
    });

    test('translates all 6 official CPCB NAQI categories to Hindi', () {
      expect(
        WeatherTranslations.translateAqiCategoryForLanguage('Good', 'hi'),
        'अच्छा',
      );
      expect(
        WeatherTranslations.translateAqiCategoryForLanguage('Satisfactory', 'hi'),
        'संतोषजनक',
      );
      expect(
        WeatherTranslations.translateAqiCategoryForLanguage('Moderate', 'hi'),
        'मध्यम',
      );
      expect(
        WeatherTranslations.translateAqiCategoryForLanguage('Poor', 'hi'),
        'खराब',
      );
      expect(
        WeatherTranslations.translateAqiCategoryForLanguage('Very Poor', 'hi'),
        'बहुत खराब',
      );
      expect(
        WeatherTranslations.translateAqiCategoryForLanguage('Severe', 'hi'),
        'गंभीर',
      );
    });

    test('preserves English AQI categories when language is en', () {
      expect(
        WeatherTranslations.translateAqiCategoryForLanguage('Good', 'en'),
        'Good',
      );
      expect(
        WeatherTranslations.translateAqiCategoryForLanguage('Very Poor', 'en'),
        'Very Poor',
      );
    });
  });
}
