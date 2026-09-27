import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/data/models/persona_type.dart';
import 'package:mausam_app/data/services/mock_weather_data.dart';

void main() {
  group('WeatherData & Persona Model Tests', () {
    test('MockWeatherData contains Delhi and Mumbai with correct coastal status', () {
      final delhi = MockWeatherData.citiesData['New Delhi']!;
      final mumbai = MockWeatherData.citiesData['Mumbai']!;

      expect(delhi.isCoastal, isFalse);
      expect(delhi.tideSea, isNull);

      expect(mumbai.isCoastal, isTrue);
      expect(mumbai.tideSea, isNotNull);
      expect(mumbai.tideSea!.seaCondition, contains('Arabian Sea Swell'));
    });

    test('WeatherData serializes and deserializes cleanly to/from JSON', () {
      final original = MockWeatherData.citiesData['Mumbai']!;
      final jsonMap = original.toJson();
      final restored = WeatherData.fromJson(jsonMap);

      expect(restored.cityName, equals('Mumbai'));
      expect(restored.isCoastal, isTrue);
      expect(restored.current.temperature, equals(original.current.temperature));
      expect(restored.aqi.aqi, equals(original.aqi.aqi));
      expect(restored.tideSea!.waveHeightM, equals(original.tideSea!.waveHeightM));
      expect(restored.agriculture.soilMoisturePercent, equals(original.agriculture.soilMoisturePercent));
      expect(restored.commuter.trafficDelayMins, equals(original.commuter.trafficDelayMins));
    });

    test('AqiData triggers isUnhealthy flag when AQI > 200', () {
      final delhiAqi = MockWeatherData.citiesData['New Delhi']!.aqi;
      final mumbaiAqi = MockWeatherData.citiesData['Mumbai']!.aqi;

      expect(delhiAqi.aqi, greaterThan(200));
      expect(delhiAqi.isUnhealthy, isTrue);

      expect(mumbaiAqi.aqi, lessThan(100));
      expect(mumbaiAqi.isUnhealthy, isFalse);
    });

    test('All 8 PersonaTypes map to valid metadata and data source names', () {
      for (final persona in PersonaType.values) {
        expect(persona.id.isNotEmpty, isTrue);
        expect(persona.title.isNotEmpty, isTrue);
        expect(persona.description.isNotEmpty, isTrue);
        expect(persona.dataSourceName.isNotEmpty, isTrue);

        final parsed = PersonaTypeExtension.fromId(persona.id);
        expect(parsed, equals(persona));
      }
    });
  });
}
