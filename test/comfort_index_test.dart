import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/data/services/weather_service.dart';

void main() {
  group('WeatherService Algorithm Unit Tests', () {
    test('computeComfortIndex calculates score between 0 and 100', () {
      // Optimal conditions: 22°C, 50% humidity, 12 km/h wind
      final optimalScore = WeatherService.computeComfortIndex(
        temperature: 22.0,
        relativeHumidity: 50,
        windSpeedKmh: 12.0,
      );
      expect(optimalScore, greaterThanOrEqualTo(95));
      expect(optimalScore, lessThanOrEqualTo(100));

      // Harsh conditions: 40°C, 85% humidity, 2 km/h wind
      final harshScore = WeatherService.computeComfortIndex(
        temperature: 40.0,
        relativeHumidity: 85,
        windSpeedKmh: 2.0,
      );
      expect(harshScore, lessThan(60));
    });

    test('calculateRunningHours flags high AQI conditions', () {
      final severeWindows = WeatherService.calculateRunningHours(
        currentTemp: 26.0,
        aqi: 280,
        windSpeedKmh: 10.0,
      );

      expect(severeWindows.isNotEmpty, true);
      expect(severeWindows.first.rating, equals('Challenging'));
      expect(severeWindows.first.reason.contains('smog'), true);

      final cleanWindows = WeatherService.calculateRunningHours(
        currentTemp: 22.0,
        aqi: 45,
        windSpeedKmh: 12.0,
      );
      expect(cleanWindows.first.rating, equals('Optimal'));
    });

    test('generatePackingSuggestions triggers appropriate items', () {
      final rainyPacking = WeatherService.generatePackingSuggestions(
        temp: 28.0,
        rainProbability: 75,
        uvIndex: 4.0,
        aqi: 60,
      );
      expect(rainyPacking.any((s) => s.contains('Waterproof gear')), true);

      final extremeUvPacking = WeatherService.generatePackingSuggestions(
        temp: 34.0,
        rainProbability: 10,
        uvIndex: 9.5,
        aqi: 190,
      );
      expect(extremeUvPacking.any((s) => s.contains('High UV protection')), true);
      expect(extremeUvPacking.any((s) => s.contains('Respiratory shield')), true);
    });
  });
}
