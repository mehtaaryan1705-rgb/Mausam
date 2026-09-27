import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/data/services/cpcb_aqi_calculator.dart';

void main() {
  group('CpcbAqiCalculator Tests (Official CPCB Breakpoint Verification)', () {
    test('Calculates "Good" AQI when PM2.5 and PM10 are in lowest tier', () {
      final aqi = CpcbAqiCalculator.calculateAqi(
        pm25: 15.0, // Sub-index: (50/30)*15 = 25
        pm10: 25.0, // Sub-index: (50/50)*25 = 25
        no2: 20.0,
        so2: 15.0,
        coMgM3: 0.5,
        o3: 25.0,
      );

      expect(aqi.aqi, equals(25));
      expect(aqi.category, equals('Good'));
      expect(aqi.isUnhealthy, isFalse);
    });

    test('Calculates "Satisfactory" AQI matching current monsoon Delhi levels', () {
      // Observed Open-Meteo telemetry for Delhi: PM2.5 = 39.6, PM10 = 39.9
      final aqi = CpcbAqiCalculator.calculateAqi(
        pm25: 39.6,
        pm10: 39.9,
        no2: 29.5,
        so2: 26.1,
        coMgM3: 0.397,
        o3: 63.0,
      );

      // PM2.5: (49/29) * 8.6 + 51 = 65.5 -> ~66
      // O3: (49/49) * 12 + 51 = 63
      expect(aqi.aqi, equals(66));
      expect(aqi.category, equals('Satisfactory'));
      expect(aqi.isUnhealthy, isFalse);
    });

    test('Calculates "Poor" and "Very Poor" for high particulate concentration', () {
      final aqiPoor = CpcbAqiCalculator.calculateAqi(
        pm25: 105.0, // PM2.5 in [91, 120] -> AQI in [201, 300]
        pm10: 180.0,
      );
      expect(aqiPoor.category, equals('Poor'));
      expect(aqiPoor.isUnhealthy, isTrue);

      final aqiVeryPoor = CpcbAqiCalculator.calculateAqi(
        pm25: 180.0, // PM2.5 in [121, 250] -> AQI in [301, 400]
        pm10: 380.0,
      );
      expect(aqiVeryPoor.category, equals('Very Poor'));
      expect(aqiVeryPoor.isUnhealthy, isTrue);
    });
  });
}
