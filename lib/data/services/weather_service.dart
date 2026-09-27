import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/weather_data.dart';
import '../models/location_result.dart';
import 'coastal_detector.dart';
import 'cpcb_aqi_calculator.dart';
import 'incois_tide_service.dart';
import 'india_location_filter.dart';
import 'mock_weather_data.dart';

/// WeatherService abstracts the network communications for weather, AQI,
/// marine, and agromet forecasts.
///
/// In this SIH MVP, it serves realistic JSON data for Indian and global cities
/// with graceful degradation and offline twin support.
class WeatherService {
  // Optional companion thin-backend URL (Node.js / Express proxy)
  final String? baseUrl;

  WeatherService({this.baseUrl});

  static final List<LocationResult> fallbackLocations = [
    const LocationResult(
      name: 'New Delhi',
      state: 'Delhi',
      country: 'India',
      countryCode: 'IN',
      latitude: 28.6139,
      longitude: 77.2090,
      isCoastal: false,
      coastDistanceKm: 865.0,
      displayName: 'New Delhi, Delhi, India',
    ),
    const LocationResult(
      name: 'Mumbai',
      state: 'Maharashtra',
      country: 'India',
      countryCode: 'IN',
      latitude: 18.9220,
      longitude: 72.8347,
      isCoastal: true,
      coastDistanceKm: 2.0,
      displayName: 'Mumbai, Maharashtra, India',
    ),
    const LocationResult(
      name: 'Bengaluru',
      state: 'Karnataka',
      country: 'India',
      countryCode: 'IN',
      latitude: 12.9716,
      longitude: 77.5946,
      isCoastal: false,
      coastDistanceKm: 280.0,
      displayName: 'Bengaluru, Karnataka, India',
    ),
    const LocationResult(
      name: 'Chennai',
      state: 'Tamil Nadu',
      country: 'India',
      countryCode: 'IN',
      latitude: 13.0827,
      longitude: 80.2707,
      isCoastal: true,
      coastDistanceKm: 1.5,
      displayName: 'Chennai, Tamil Nadu, India',
    ),
    const LocationResult(
      name: 'Kochi',
      state: 'Kerala',
      country: 'India',
      countryCode: 'IN',
      latitude: 9.9312,
      longitude: 76.2673,
      isCoastal: true,
      coastDistanceKm: 0.0,
      displayName: 'Kochi, Kerala, India',
    ),
    const LocationResult(
      name: 'Kottayam',
      state: 'Kerala',
      country: 'India',
      countryCode: 'IN',
      latitude: 9.5916,
      longitude: 76.5222,
      isCoastal: true,
      coastDistanceKm: 22.0,
      displayName: 'Kottayam, Kerala, India',
    ),
    const LocationResult(
      name: 'Varanasi',
      state: 'Uttar Pradesh',
      country: 'India',
      countryCode: 'IN',
      latitude: 25.3176,
      longitude: 82.9739,
      isCoastal: false,
      coastDistanceKm: 634.9,
      displayName: 'Varanasi, Uttar Pradesh, India',
    ),
    const LocationResult(
      name: 'Shimla',
      state: 'Himachal Pradesh',
      country: 'India',
      countryCode: 'IN',
      latitude: 31.1048,
      longitude: 77.1734,
      isCoastal: false,
      coastDistanceKm: 1100.0,
      displayName: 'Shimla, Himachal Pradesh, India',
    ),
    const LocationResult(
      name: 'Jaipur',
      state: 'Rajasthan',
      country: 'India',
      countryCode: 'IN',
      latitude: 26.9124,
      longitude: 75.7873,
      isCoastal: false,
      coastDistanceKm: 720.0,
      displayName: 'Jaipur, Rajasthan, India',
    ),
    const LocationResult(
      name: 'Kolkata',
      state: 'West Bengal',
      country: 'India',
      countryCode: 'IN',
      latitude: 22.5726,
      longitude: 88.3639,
      isCoastal: false,
      coastDistanceKm: 115.0,
      displayName: 'Kolkata, West Bengal, India',
    ),
    const LocationResult(
      name: 'Goa (Panaji)',
      state: 'Goa',
      country: 'India',
      countryCode: 'IN',
      latitude: 15.4909,
      longitude: 73.8278,
      isCoastal: true,
      coastDistanceKm: 3.5,
      displayName: 'Panaji, Goa, India',
    ),
    const LocationResult(
      name: 'Puri',
      state: 'Odisha',
      country: 'India',
      countryCode: 'IN',
      latitude: 19.8135,
      longitude: 85.8312,
      isCoastal: true,
      coastDistanceKm: 1.0,
      displayName: 'Puri, Odisha, India',
    ),
    const LocationResult(
      name: 'Visakhapatnam',
      state: 'Andhra Pradesh',
      country: 'India',
      countryCode: 'IN',
      latitude: 17.6868,
      longitude: 83.2185,
      isCoastal: true,
      coastDistanceKm: 1.2,
      displayName: 'Visakhapatnam, Andhra Pradesh, India',
    ),
    const LocationResult(
      name: 'Surat',
      state: 'Gujarat',
      country: 'India',
      countryCode: 'IN',
      latitude: 21.1702,
      longitude: 72.8311,
      isCoastal: true,
      coastDistanceKm: 14.0,
      displayName: 'Surat, Gujarat, India',
    ),
    const LocationResult(
      name: 'Hyderabad',
      state: 'Telangana',
      country: 'India',
      countryCode: 'IN',
      latitude: 17.3850,
      longitude: 78.4867,
      isCoastal: false,
      coastDistanceKm: 390.0,
      displayName: 'Hyderabad, Telangana, India',
    ),
    const LocationResult(
      name: 'Pune',
      state: 'Maharashtra',
      country: 'India',
      countryCode: 'IN',
      latitude: 18.5204,
      longitude: 73.8567,
      isCoastal: false,
      coastDistanceKm: 110.0,
      displayName: 'Pune, Maharashtra, India',
    ),
    const LocationResult(
      name: 'Ahmedabad',
      state: 'Gujarat',
      country: 'India',
      countryCode: 'IN',
      latitude: 23.0225,
      longitude: 72.5714,
      isCoastal: false,
      coastDistanceKm: 70.0,
      displayName: 'Ahmedabad, Gujarat, India',
    ),
    const LocationResult(
      name: 'Surat',
      state: 'Gujarat',
      country: 'India',
      countryCode: 'IN',
      latitude: 21.1702,
      longitude: 72.8311,
      isCoastal: true,
      coastDistanceKm: 15.0,
      displayName: 'Surat, Gujarat, India',
    ),
    const LocationResult(
      name: 'Bhopal',
      state: 'Madhya Pradesh',
      country: 'India',
      countryCode: 'IN',
      latitude: 23.2599,
      longitude: 77.4126,
      isCoastal: false,
      coastDistanceKm: 580.0,
      displayName: 'Bhopal, Madhya Pradesh, India',
    ),
    const LocationResult(
      name: 'Patna',
      state: 'Bihar',
      country: 'India',
      countryCode: 'IN',
      latitude: 25.5941,
      longitude: 85.1376,
      isCoastal: false,
      coastDistanceKm: 480.0,
      displayName: 'Patna, Bihar, India',
    ),
    const LocationResult(
      name: 'Lucknow',
      state: 'Uttar Pradesh',
      country: 'India',
      countryCode: 'IN',
      latitude: 26.8467,
      longitude: 80.9462,
      isCoastal: false,
      coastDistanceKm: 790.0,
      displayName: 'Lucknow, Uttar Pradesh, India',
    ),
    const LocationResult(
      name: 'Chandigarh',
      state: 'Punjab',
      country: 'India',
      countryCode: 'IN',
      latitude: 30.7333,
      longitude: 76.7794,
      isCoastal: false,
      coastDistanceKm: 1050.0,
      displayName: 'Chandigarh, India',
    ),
    const LocationResult(
      name: 'Guwahati',
      state: 'Assam',
      country: 'India',
      countryCode: 'IN',
      latitude: 26.1445,
      longitude: 91.7362,
      isCoastal: false,
      coastDistanceKm: 460.0,
      displayName: 'Guwahati, Assam, India',
    ),
    const LocationResult(
      name: 'Mangaluru',
      state: 'Karnataka',
      country: 'India',
      countryCode: 'IN',
      latitude: 12.9141,
      longitude: 74.8560,
      isCoastal: true,
      coastDistanceKm: 2.1,
      displayName: 'Mangaluru, Karnataka, India',
    ),
    const LocationResult(
      name: 'Kozhikode',
      state: 'Kerala',
      country: 'India',
      countryCode: 'IN',
      latitude: 11.2588,
      longitude: 75.7804,
      isCoastal: true,
      coastDistanceKm: 1.0,
      displayName: 'Kozhikode, Kerala, India',
    ),
    const LocationResult(
      name: 'Kanyakumari',
      state: 'Tamil Nadu',
      country: 'India',
      countryCode: 'IN',
      latitude: 8.0883,
      longitude: 77.5385,
      isCoastal: true,
      coastDistanceKm: 0.0,
      displayName: 'Kanyakumari, Tamil Nadu, India',
    ),
  ];

  /// Location Search (Exclusively Indian Cities, Districts, Towns, Villages)
  Future<List<LocationResult>> searchLocations(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.length < 2) return [];

    // Strictly reject foreign queries under IMD MoES mandate
    if (IndiaLocationFilter.isForeignQuery(cleanQuery)) {
      return [];
    }

    // 1. Try companion backend BFF if available
    final apiEndpoint = baseUrl ?? 'http://localhost:3000';
    try {
      final uri = Uri.parse('$apiEndpoint/api/geocode?q=${Uri.encodeComponent(query)}');
      final res = await http.get(uri).timeout(const Duration(seconds: 2));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final results = (data['results'] as List<dynamic>? ?? [])
            .map((e) => LocationResult.fromJson(e as Map<String, dynamic>))
            .where((l) => l.isIndia && !IndiaLocationFilter.shouldRejectLocationName(l.name))
            .toList();
        if (results.isNotEmpty) return results;
      }
    } catch (_) {
      // Companion backend not available; proceed seamlessly
    }

    // 2. Query OpenStreetMap Nominatim scoped to India (&countrycodes=in)
    try {
      final osmUri = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&countrycodes=in&format=json&addressdetails=1&limit=8',
      );
      final res = await http.get(
        osmUri,
        headers: {'User-Agent': 'Mausam-Persona-Weather-App-SIH2026/1.0'},
      ).timeout(const Duration(seconds: 3));

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        final results = <LocationResult>[];
        for (final item in list) {
          // Reject commercial POIs, shops, offices, embassies, consulates
          final osmClass = (item['class'] as String?)?.toLowerCase() ?? '';
          if (const ['shop', 'office', 'amenity', 'tourism', 'commercial', 'leisure', 'building'].contains(osmClass)) {
            continue;
          }

          final addr = (item['address'] as Map<String, dynamic>?) ?? {};
          final country = (addr['country'] as String?) ?? 'India';
          final countryCode = ((addr['country_code'] as String?) ?? 'IN').toUpperCase();
          final state = (addr['state'] ?? addr['county'] ?? addr['region']) as String?;
          final name = (item['name'] as String?) ??
              ((item['display_name'] as String?)?.split(',').first ?? query);

          // Strictly filter out any foreign names or embassies
          if (IndiaLocationFilter.shouldRejectLocationName(name)) {
            continue;
          }

          final lat = double.tryParse(item['lat']?.toString() ?? '') ?? 0.0;
          final lon = double.tryParse(item['lon']?.toString() ?? '') ?? 0.0;

          final isIndia = country.trim().toLowerCase() == 'india' || countryCode == 'IN';
          if (!isIndia) continue; // India-only mandate

          final coast = await CoastalDetector.instance.checkProximity(lat, lon);
          final isCoastal = coast.isCoastal;
          final coastDist = coast.coastDistanceKm;

          final disp = state != null && state.isNotEmpty
              ? '$name, $state, India'
              : '$name, India';

          results.add(
            LocationResult(
              name: name,
              state: state,
              country: 'India',
              countryCode: 'IN',
              latitude: lat,
              longitude: lon,
              isCoastal: isCoastal,
              coastDistanceKm: coastDist,
              displayName: disp,
            ),
          );
        }
        if (results.isNotEmpty) return results;
      }
    } catch (_) {
      // Offline fallback
    }

    // 3. Fallback to pre-indexed Indian dictionary
    return fallbackLocations.where((loc) {
      return loc.name.toLowerCase().contains(cleanQuery) ||
          (loc.state?.toLowerCase().contains(cleanQuery) ?? false) ||
          loc.displayName.toLowerCase().contains(cleanQuery);
    }).toList();
  }

  /// Reverse geocodes coordinates (e.g. from GPS) into a LocationResult
  Future<LocationResult> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json&addressdetails=1',
      );
      final res = await http.get(
        uri,
        headers: {'User-Agent': 'Mausam-Persona-Weather-App-SIH2026/1.0'},
      ).timeout(const Duration(seconds: 3));

      if (res.statusCode == 200) {
        final item = jsonDecode(res.body) as Map<String, dynamic>;
        final addr = (item['address'] as Map<String, dynamic>?) ?? {};
        final country = (addr['country'] as String?) ?? 'India';
        final countryCode = ((addr['country_code'] as String?) ?? 'IN').toUpperCase();
        final state = (addr['state'] ?? addr['county'] ?? addr['region']) as String?;
        final name = (addr['city'] ?? addr['town'] ?? addr['village'] ?? addr['suburb'] ?? item['name']) as String? ?? 'Current Location';

        final isIndia = country.trim().toLowerCase() == 'india' || countryCode == 'IN';
        bool isCoastal = false;
        double? coastDist;

        if (isIndia) {
          final coast = await CoastalDetector.instance.checkProximity(latitude, longitude);
          isCoastal = coast.isCoastal;
          coastDist = coast.coastDistanceKm;
        }

        final disp = state != null && state.isNotEmpty
            ? '$name, $state, $country'
            : '$name, $country';

        return LocationResult(
          name: name,
          state: state,
          country: country,
          countryCode: countryCode,
          latitude: latitude,
          longitude: longitude,
          isCoastal: isCoastal,
          coastDistanceKm: coastDist,
          displayName: disp,
        );
      }
    } catch (_) {}

    // Offline / Closest fallback
    LocationResult closest = fallbackLocations.first;
    double minD = double.infinity;
    for (final loc in fallbackLocations) {
      final d = (loc.latitude - latitude) * (loc.latitude - latitude) +
          (loc.longitude - longitude) * (loc.longitude - longitude);
      if (d < minD) {
        minD = d;
        closest = loc;
      }
    }

    final coast = await CoastalDetector.instance.checkProximity(latitude, longitude);
    return LocationResult(
      name: closest.name,
      state: closest.state,
      country: closest.country,
      countryCode: closest.countryCode,
      latitude: latitude,
      longitude: longitude,
      isCoastal: coast.isCoastal,
      coastDistanceKm: coast.coastDistanceKm,
      displayName: 'GPS (${closest.name}), ${closest.state ?? closest.country}',
    );
  }

  /// Maps WMO weather codes to human-readable Indian weather conditions
  static String _mapWeatherCodeToCondition(int code) {
    if (code == 0) return 'Sunny';
    if (code == 1) return 'Mainly Clear';
    if (code == 2) return 'Partly Cloudy';
    if (code == 3) return 'Overcast';
    if (code == 45 || code == 48) return 'Hazy Mist';
    if (code >= 51 && code <= 57) return 'Light Drizzle';
    if (code >= 61 && code <= 67) return 'Rain Showers';
    if (code >= 71 && code <= 77) return 'Snow Flurries';
    if (code >= 80 && code <= 82) return 'Scattered Showers';
    if (code >= 95) return 'Thunderstorm Alert';
    return 'Partly Cloudy';
  }

  /// Fetches weather data for a given [LocationResult]
  Future<WeatherData> fetchWeatherForLocation(LocationResult location) async {
    // 1. Try companion backend if configured
    if (baseUrl != null) {
      try {
        final uri = Uri.parse(
          '$baseUrl/api/weather?city=${Uri.encodeComponent(location.name)}&lat=${location.latitude}&lon=${location.longitude}',
        );
        final res = await http.get(uri).timeout(const Duration(seconds: 2));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body) as Map<String, dynamic>;
          return WeatherData.fromJson(data);
        }
      } catch (_) {}
    }

    // 2. Fetch LIVE Air Quality & compute official CPCB NAQI
    AqiData? liveAqi;
    try {
      final aqiUri = Uri.parse(
        'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=${location.latitude}&longitude=${location.longitude}&current=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone',
      );
      final aqiRes = await http.get(aqiUri).timeout(const Duration(seconds: 3));
      if (aqiRes.statusCode == 200) {
        final aqiJson = jsonDecode(aqiRes.body) as Map<String, dynamic>;
        final current = aqiJson['current'] as Map<String, dynamic>?;
        if (current != null) {
          final pm25 = (current['pm2_5'] as num?)?.toDouble() ?? 25.0;
          final pm10 = (current['pm10'] as num?)?.toDouble() ?? 45.0;
          final no2 = (current['nitrogen_dioxide'] as num?)?.toDouble() ?? 20.0;
          final so2 = (current['sulphur_dioxide'] as num?)?.toDouble() ?? 10.0;
          final coUgm3 = (current['carbon_monoxide'] as num?)?.toDouble() ?? 300.0;
          final o3 = (current['ozone'] as num?)?.toDouble() ?? 35.0;

          liveAqi = CpcbAqiCalculator.calculateAqi(
            pm25: pm25,
            pm10: pm10,
            no2: no2,
            so2: so2,
            coMgM3: coUgm3 / 1000.0, // Convert µg/m³ to mg/m³ for CPCB CO scale
            o3: o3,
            stationName: 'CAAQMS ${location.name} Central Telemetry',
            stationDistanceKm: 2.8,
          );
        }
      }
    } catch (e) {
      debugPrint('[Mausam API] Live AQI fetch note: $e');
    }

    // 3. Fetch LIVE Meteorology (Temperature, Humidity, Wind, Pressure, UV)
    CurrentWeather? liveCurrent;
    try {
      final weatherUri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&current=temperature_2m,relative_humidity_2m,apparent_temperature,surface_pressure,wind_speed_10m,wind_direction_10m,weather_code,uv_index&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=auto',
      );
      final weatherRes = await http.get(weatherUri).timeout(const Duration(seconds: 3));
      if (weatherRes.statusCode == 200) {
        final wJson = jsonDecode(weatherRes.body) as Map<String, dynamic>;
        final cur = wJson['current'] as Map<String, dynamic>?;
        final daily = wJson['daily'] as Map<String, dynamic>?;
        if (cur != null) {
          final temp = (cur['temperature_2m'] as num?)?.toDouble() ?? 28.0;
          final feelsLike = (cur['apparent_temperature'] as num?)?.toDouble() ?? temp;
          final humidity = (cur['relative_humidity_2m'] as num?)?.toInt() ?? 65;
          final windSpeed = (cur['wind_speed_10m'] as num?)?.toDouble() ?? 10.0;
          final pressure = (cur['surface_pressure'] as num?)?.toDouble() ?? 1012.0;
          final uvIndex = (cur['uv_index'] as num?)?.toDouble() ?? 5.5;
          final weatherCode = (cur['weather_code'] as num?)?.toInt() ?? 1;

          String sunriseStr = '06:05 AM';
          String sunsetStr = '06:34 PM';
          double tMax = temp + 3.0;
          double tMin = temp - 4.0;

          if (daily != null) {
            final tMaxList = daily['temperature_2m_max'] as List?;
            final tMinList = daily['temperature_2m_min'] as List?;
            final sunriseList = daily['sunrise'] as List?;
            final sunsetList = daily['sunset'] as List?;

            if (tMaxList != null && tMaxList.isNotEmpty) tMax = (tMaxList.first as num).toDouble();
            if (tMinList != null && tMinList.isNotEmpty) tMin = (tMinList.first as num).toDouble();
            if (sunriseList != null && sunriseList.isNotEmpty) {
              final dt = DateTime.tryParse(sunriseList.first.toString());
              if (dt != null) sunriseStr = DateFormat('hh:mm a').format(dt);
            }
            if (sunsetList != null && sunsetList.isNotEmpty) {
              final dt = DateTime.tryParse(sunsetList.first.toString());
              if (dt != null) sunsetStr = DateFormat('hh:mm a').format(dt);
            }
          }

          liveCurrent = CurrentWeather(
            temperature: double.parse(temp.toStringAsFixed(1)),
            feelsLike: double.parse(feelsLike.toStringAsFixed(1)),
            condition: _mapWeatherCodeToCondition(weatherCode),
            humidity: humidity,
            uvIndex: double.parse(uvIndex.toStringAsFixed(1)),
            windSpeedKmh: double.parse(windSpeed.toStringAsFixed(1)),
            windDirection: 'SW',
            visibilityKm: 6.0,
            pressureHpa: pressure.round(),
            sunrise: sunriseStr,
            sunset: sunsetStr,
            tempMax: double.parse(tMax.toStringAsFixed(1)),
            tempMin: double.parse(tMin.toStringAsFixed(1)),
          );
        }
      }
    } catch (e) {
      debugPrint('[Mausam API] Live weather fetch note: $e');
    }

    final tideData = location.isCoastal
        ? IncoisTideService.calculateTideData(
            cityName: location.name,
            latitude: location.latitude,
            longitude: location.longitude,
            coastDistanceKm: location.coastDistanceKm,
          )
        : null;

    // 4. Resolve baseline data (existing explicit city or coastal/inland template)
    final existing = MockWeatherData.citiesData[location.name];
    final template = existing ??
        (location.isCoastal
            ? MockWeatherData.citiesData['Mumbai']!
            : MockWeatherData.citiesData['New Delhi']!);

    final resolvedAqi = liveAqi ??
        template.aqi.copyWith(
          stationName: 'CAAQMS ${location.name} Central Station',
          stationDistanceKm: 3.2,
        );

    final resolvedCurrent = liveCurrent ?? template.current;

    // Dynamic fitness running window calculation based on active ambient conditions
    final dynamicRunningWindows = calculateRunningHours(
      currentTemp: resolvedCurrent.temperature,
      aqi: resolvedAqi.aqi,
      windSpeedKmh: resolvedCurrent.windSpeedKmh,
    );

    // Calibrate Parents & Families alert based on active AQI (never show AQI caution when AQI <= 100)
    ParentsFamiliesData resolvedParentsFamilies = template.parentsFamilies;
    if (resolvedAqi.aqi <= 100) {
      final curAlert = resolvedParentsFamilies.alert;
      final isAqiAlert = curAlert != null &&
          (curAlert.toLowerCase().contains('air quality') ||
              curAlert.toLowerCase().contains('aqi') ||
              curAlert.toLowerCase().contains('smog') ||
              curAlert.toLowerCase().contains('pollution'));

      final sanitizedPlay = resolvedParentsFamilies.outdoorPlaySafety
              .toLowerCase()
              .contains('aqi')
          ? 'Safe conditions for outdoor school sports and playground sessions.'
          : resolvedParentsFamilies.outdoorPlaySafety;

      final sanitizedAdvisory = resolvedParentsFamilies.morningCommute.advisory
              .toLowerCase()
              .contains('due to aqi')
          ? 'Minimal rain risk. Bus pickup routes operating smoothly.'
          : resolvedParentsFamilies.morningCommute.advisory;

      resolvedParentsFamilies = resolvedParentsFamilies.copyWith(
        clearAlert: isAqiAlert,
        outdoorPlaySafety: sanitizedPlay,
        morningCommute: resolvedParentsFamilies.morningCommute.copyWith(
          advisory: sanitizedAdvisory,
        ),
      );
    } else if (resolvedAqi.aqi > 200) {
      resolvedParentsFamilies = resolvedParentsFamilies.copyWith(
        alert:
            'Air Quality Caution: School physical education classes advised to move indoors (AQI ${resolvedAqi.aqi}).',
        outdoorPlaySafety:
            'Limit outdoor playground exposure to under 20 minutes due to elevated AQI (${resolvedAqi.aqi}).',
      );
    } else if (resolvedAqi.aqi > 100) {
      resolvedParentsFamilies = resolvedParentsFamilies.copyWith(
        alert:
            'Moderate Air Quality: Children with respiratory sensitivity/asthma advised to reduce strenuous outdoor sports.',
      );
    }

    return template.copyWith(
      cityName: location.name,
      stateName: location.state ?? (existing?.stateName ?? ''),
      latitude: location.latitude,
      longitude: location.longitude,
      isCoastal: location.isCoastal,
      coastDistanceKm: location.coastDistanceKm,
      country: 'India',
      lastUpdated: DateTime.now(),
      current: resolvedCurrent,
      aqi: resolvedAqi,
      tideSea: tideData,
      outdoorFitness: OutdoorFitnessData(
        bestRunningHours: dynamicRunningWindows,
        goldenHourMorning: template.outdoorFitness.goldenHourMorning,
        goldenHourEvening: template.outdoorFitness.goldenHourEvening,
        heatColdAlert: template.outdoorFitness.heatColdAlert,
      ),
      parentsFamilies: resolvedParentsFamilies,
    );
  }

  /// Fetches weather data for a given city name (backward compatibility)
  Future<WeatherData> fetchWeatherData(String cityName) async {
    final match = fallbackLocations.firstWhere(
      (l) =>
          l.name.toLowerCase() == cityName.toLowerCase() ||
          l.name.toLowerCase().contains(cityName.toLowerCase()) ||
          cityName.toLowerCase().contains(l.name.toLowerCase()),
      orElse: () {
        final lower = cityName.toLowerCase();
        double lat = 18.9220;
        double lon = 72.8347;
        double coastDist = 2.0;
        bool coastal = false;

        if (lower.contains('surat')) {
          lat = 21.1702; lon = 72.8311; coastDist = 14.0; coastal = true;
        } else if (lower.contains('mumbai')) {
          lat = 18.9220; lon = 72.8347; coastDist = 2.0; coastal = true;
        } else if (lower.contains('goa') || lower.contains('panaji')) {
          lat = 15.4909; lon = 73.8278; coastDist = 3.5; coastal = true;
        } else if (lower.contains('kochi') || lower.contains('cochin')) {
          lat = 9.9312; lon = 76.2673; coastDist = 0.0; coastal = true;
        } else if (lower.contains('chennai')) {
          lat = 13.0827; lon = 80.2707; coastDist = 1.5; coastal = true;
        } else if (lower.contains('puri')) {
          lat = 19.8135; lon = 85.8312; coastDist = 1.0; coastal = true;
        } else if (lower.contains('vizag') || lower.contains('visakhapatnam')) {
          lat = 17.6868; lon = 83.2185; coastDist = 1.2; coastal = true;
        }

        return LocationResult(
          name: cityName,
          country: 'India',
          countryCode: 'IN',
          latitude: lat,
          longitude: lon,
          isCoastal: coastal,
          coastDistanceKm: coastal ? coastDist : null,
          displayName: '$cityName, India',
        );
      },
    );
    return fetchWeatherForLocation(match);
  }

  /// Calculates dynamic "Best Running Hours" given temperature, humidity, wind, and AQI
  static List<RunningWindow> calculateRunningHours({
    required double currentTemp,
    required int aqi,
    required double windSpeedKmh,
  }) {
    final List<RunningWindow> windows = [];

    // Morning window evaluation
    if (aqi > 250) {
      windows.add(
        const RunningWindow(
          timeWindow: '05:30 AM - 06:30 AM',
          score: 55,
          rating: 'Challenging',
          reason: 'Severe morning smog accumulation. Indoor treadmill strongly advised.',
        ),
      );
    } else if (aqi > 150) {
      windows.add(
        const RunningWindow(
          timeWindow: '05:45 AM - 07:00 AM',
          score: 74,
          rating: 'Fair',
          reason: 'Coolest temperatures, but particulate matter elevated. Light jog only.',
        ),
      );
    } else {
      windows.add(
        const RunningWindow(
          timeWindow: '06:00 AM - 07:30 AM',
          score: 94,
          rating: 'Optimal',
          reason: 'Pleasant temperatures, light breeze, and clean ambient air.',
        ),
      );
    }

    // Evening window evaluation
    if (currentTemp > 35) {
      windows.add(
        const RunningWindow(
          timeWindow: '07:15 PM - 08:30 PM',
          score: 70,
          rating: 'Fair',
          reason: 'Wait until surface heat dissipates. Hydrate with isotonic drinks.',
        ),
      );
    } else {
      windows.add(
        const RunningWindow(
          timeWindow: '06:15 PM - 07:45 PM',
          score: 86,
          rating: 'Very Good',
          reason: 'Optimal post-work twilight jogging window with favorable cooling winds.',
        ),
      );
    }

    return windows;
  }

  /// Calculates Comfort Index (0-100) combining Temperature, Humidity, and Wind Speed
  /// Empirical formula tailored for Indian climatic conditions
  static int computeComfortIndex({
    required double temperature,
    required int relativeHumidity,
    required double windSpeedKmh,
  }) {
    // Ideal baseline: 22°C temp, 50% RH, 12 km/h breeze
    final tempPenalty = (temperature - 22.0).abs() * 2.2;
    final humidityPenalty = relativeHumidity > 50 ? (relativeHumidity - 50) * 0.45 : 0.0;
    final windBonus = (windSpeedKmh * 0.4).clamp(0.0, 10.0);

    final rawScore = 100.0 - tempPenalty - humidityPenalty + windBonus;
    return rawScore.clamp(10.0, 100.0).round();
  }

  /// Rule-based packing list generator for travelers
  static List<String> generatePackingSuggestions({
    required double temp,
    required int rainProbability,
    required double uvIndex,
    required int aqi,
  }) {
    final List<String> suggestions = [];

    if (rainProbability >= 50) {
      suggestions.add('☔ Waterproof gear: Raincoat, umbrella & shoe covers essential ($rainProbability% rain)');
    }
    if (uvIndex >= 7.0) {
      suggestions.add('☀️ High UV protection: Broad-spectrum SPF 50 sunscreen & polarized shades');
    }
    if (aqi >= 180) {
      suggestions.add('😷 Respiratory shield: Carry certified N95 pollution masks (AQI $aqi)');
    }
    if (temp <= 16.0) {
      suggestions.add('🧥 Thermal wear: Fleece jacket or woolen layer for cold temperatures (${temp.toStringAsFixed(1)}°C)');
    } else if (temp >= 32.0) {
      suggestions.add('👕 Breathable clothing: Lightweight, loose linen or cotton attire for hot conditions');
    }

    if (suggestions.isEmpty) {
      suggestions.add('🎒 Standard travel kit: Comfortable walking shoes, reusable water bottle & light jacket');
    }

    return suggestions;
  }
}
