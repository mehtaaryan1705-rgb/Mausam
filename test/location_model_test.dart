import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/data/models/location_result.dart';
import 'package:mausam_app/data/models/user_preferences.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/data/services/weather_service.dart';
import 'package:mausam_app/data/services/incois_tide_service.dart';

void main() {
  group('Mausam 2.0 Scope & Oceanographic Telemetry Tests', () {
    test('Indian cities correctly resolve with isIndia == true and appropriate coastal status', () {
      final delhi = LocationResult.defaultDelhi();
      expect(delhi.isIndia, isTrue, reason: 'New Delhi must have isIndia == true');
      expect(delhi.isCoastal, isFalse);

      const mumbai = LocationResult(
        name: 'Mumbai',
        state: 'Maharashtra',
        country: 'India',
        countryCode: 'IN',
        latitude: 18.9220,
        longitude: 72.8347,
        isCoastal: true,
        coastDistanceKm: 2.0,
        displayName: 'Mumbai, Maharashtra, India',
      );
      expect(mumbai.isIndia, isTrue);
      expect(mumbai.isCoastal, isTrue);
      expect(mumbai.coastDistanceKm, lessThanOrEqualTo(25.0));

      const kochi = LocationResult(
        name: 'Kochi',
        state: 'Kerala',
        country: 'India',
        countryCode: 'IN',
        latitude: 9.9312,
        longitude: 76.2673,
        isCoastal: true,
        coastDistanceKm: 0.0,
        displayName: 'Kochi, Kerala, India',
      );
      expect(kochi.isIndia, isTrue);
      expect(kochi.isCoastal, isTrue);
    });

    test('UserPreferences strictly rejects and filters out international/global cities including Switzerland', () {
      final inputJson = {
        'defaultCity': 'New Delhi',
        'savedDestinations': ['Goa', 'London', 'Switzerland', 'Dubai', 'Tokyo', 'Kochi', 'New York'],
        'recentLocations': [
          {
            'name': 'Switzerland',
            'state': '',
            'country': 'India',
            'countryCode': 'IN',
            'latitude': 46.8182,
            'longitude': 8.2275,
            'isCoastal': false,
            'displayName': 'Switzerland, India'
          },
          {
            'name': 'London',
            'state': 'Greater London',
            'country': 'United Kingdom',
            'countryCode': 'GB',
            'latitude': 51.5074,
            'longitude': -0.1278,
            'isCoastal': false,
            'displayName': 'London, UK'
          },
          {
            'name': 'Kochi',
            'state': 'Kerala',
            'country': 'India',
            'countryCode': 'IN',
            'latitude': 9.9312,
            'longitude': 76.2673,
            'isCoastal': true,
            'coastDistanceKm': 0.0,
            'displayName': 'Kochi, Kerala, India'
          }
        ]
      };

      final restored = UserPreferences.fromJson(inputJson);

      // Verify international cities are removed from savedDestinations
      expect(restored.savedDestinations, contains('Goa'));
      expect(restored.savedDestinations, contains('Kochi'));
      expect(restored.savedDestinations.contains('Switzerland'), isFalse);
      expect(restored.savedDestinations.contains('London'), isFalse);
      expect(restored.savedDestinations.contains('Dubai'), isFalse);
      expect(restored.savedDestinations.contains('Tokyo'), isFalse);
      expect(restored.savedDestinations.contains('New York'), isFalse);

      // Verify recent locations only retain Indian cities
      expect(restored.recentLocations.any((l) => l.name == 'Switzerland'), isFalse);
      expect(restored.recentLocations.any((l) => l.name == 'London'), isFalse);
      expect(restored.recentLocations.any((l) => l.name == 'Kochi'), isTrue);
    });

    test('All pre-indexed fallback locations are strictly within India, and foreign searches return empty', () async {
      expect(WeatherService.fallbackLocations.isNotEmpty, isTrue);
      for (final loc in WeatherService.fallbackLocations) {
        expect(loc.isIndia, isTrue, reason: '${loc.name} must be in India');
        expect(loc.country.toLowerCase(), 'india');
      }

      final service = WeatherService();

      // Foreign queries must be blocked immediately
      final switzResults = await service.searchLocations('Switzerland');
      expect(switzResults.isEmpty, isTrue, reason: 'Switzerland search must return empty');

      final londonResults = await service.searchLocations('London');
      expect(londonResults.isEmpty, isTrue, reason: 'London search must return empty');

      final usaResults = await service.searchLocations('USA');
      expect(usaResults.isEmpty, isTrue, reason: 'USA search must return empty');

      // Valid Indian query
      final results = await service.searchLocations('mumbai');
      expect(results.isNotEmpty, isTrue);
      for (final loc in results) {
        expect(loc.isIndia, isTrue);
      }
    });

    test('Coastal Tide Telemetry produces distinct, oceanographically accurate data per coastal zone', () {
      final now = DateTime(2026, 9, 14, 14, 30);

      // 1. Surat (Gujarat Macro-tidal Surge)
      final suratTide = IncoisTideService.calculateTideData(
        cityName: 'Surat',
        latitude: 21.1702,
        longitude: 72.8311,
        currentTime: now,
      );
      expect(suratTide.seaCondition, contains('High Tidal Surge'));
      expect(suratTide.highTideTime, contains('5.85m'));
      expect(suratTide.lowTideTime, contains('1.25m'));
      expect(suratTide.waveHeightM, 2.4);

      // 2. Mumbai (Konkan Coast Arabian Sea Swell)
      final mumbaiTide = IncoisTideService.calculateTideData(
        cityName: 'Mumbai',
        latitude: 18.9220,
        longitude: 72.8347,
        currentTime: now,
      );
      expect(mumbaiTide.seaCondition, contains('Arabian Sea Swell'));
      expect(mumbaiTide.highTideTime, contains('4.32m'));
      expect(mumbaiTide.lowTideTime, contains('0.85m'));
      expect(mumbaiTide.waveHeightM, 2.1);

      // 3. Goa (Calm to Moderate Surf)
      final goaTide = IncoisTideService.calculateTideData(
        cityName: 'Panaji',
        latitude: 15.4909,
        longitude: 73.8278,
        currentTime: now,
      );
      expect(goaTide.seaCondition, contains('Pleasant Surf'));
      expect(goaTide.highTideTime, contains('2.18m'));
      expect(goaTide.lowTideTime, contains('0.52m'));
      expect(goaTide.waveHeightM, 1.3);

      // 4. Kochi (Malabar Coast Micro-tidal Gentle Breakers)
      final kochiTide = IncoisTideService.calculateTideData(
        cityName: 'Kochi',
        latitude: 9.9312,
        longitude: 76.2673,
        currentTime: now,
      );
      expect(kochiTide.seaCondition, contains('Gentle Breakers'));
      expect(kochiTide.highTideTime, contains('1.16m'));
      expect(kochiTide.lowTideTime, contains('0.28m'));
      expect(kochiTide.waveHeightM, 1.1);

      // 5. Kottayam (Vembanad Backwaters Tidal Influence)
      final kottayamTide = IncoisTideService.calculateTideData(
        cityName: 'Kottayam',
        latitude: 9.5916,
        longitude: 76.5222,
        coastDistanceKm: 22.1,
        currentTime: now,
      );
      expect(kottayamTide.seaCondition, contains('Backwater Tidal Influence'));
      expect(kottayamTide.highTideTime, contains('0.72m'));
      expect(kottayamTide.lowTideTime, contains('0.16m'));
      expect(kottayamTide.waveHeightM, 0.4);

      // 6. Chennai (Coromandel Coast Bay of Bengal Swell)
      final chennaiTide = IncoisTideService.calculateTideData(
        cityName: 'Chennai',
        latitude: 13.0827,
        longitude: 80.2707,
        currentTime: now,
      );
      expect(chennaiTide.seaCondition, contains('Bay of Bengal Swell'));
      expect(chennaiTide.highTideTime, contains('1.45m'));
      expect(chennaiTide.lowTideTime, contains('0.38m'));
      expect(chennaiTide.waveHeightM, 1.6);

      // 7. Puri (Odisha Coast Open Ocean Swell)
      final puriTide = IncoisTideService.calculateTideData(
        cityName: 'Puri',
        latitude: 19.8135,
        longitude: 85.8312,
        currentTime: now,
      );
      expect(puriTide.seaCondition, contains('Open Ocean Swell'));
      expect(puriTide.highTideTime, contains('2.38m'));
      expect(puriTide.lowTideTime, contains('0.65m'));
      expect(puriTide.waveHeightM, 1.8);

      // Crucial verification: ensure tide heights and conditions are strictly distinct between zones!
      expect(suratTide.highTideTime != mumbaiTide.highTideTime, isTrue);
      expect(mumbaiTide.highTideTime != kochiTide.highTideTime, isTrue);
      expect(kochiTide.highTideTime != chennaiTide.highTideTime, isTrue);
      expect(chennaiTide.waveHeightM != goaTide.waveHeightM, isTrue);
    });

    test('AQI station transparency displays custom sensor name and distance', () {
      const aqi = AqiData(
        aqi: 142,
        pm25: 58.0,
        pm10: 115.0,
        no2: 32.0,
        so2: 12.0,
        co: 1.1,
        o3: 28.0,
        category: 'Moderate',
        healthAdvisory: 'Air quality is acceptable.',
        stationName: 'CAAQMS Anand Vihar Central',
        stationDistanceKm: 2.8,
      );

      expect(aqi.stationName, 'CAAQMS Anand Vihar Central');
      expect(aqi.stationDistanceKm, 2.8);

      final copy = aqi.copyWith(stationDistanceKm: 1.4);
      expect(copy.stationDistanceKm, 1.4);
      expect(copy.stationName, 'CAAQMS Anand Vihar Central');
    });
  });
}
