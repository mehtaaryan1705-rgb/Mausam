import 'package:flutter/material.dart';

class WeatherData {
  final String cityName;
  final String stateName;
  final String country;
  final double latitude;
  final double longitude;
  final bool isCoastal;
  final double? coastDistanceKm;
  final DateTime lastUpdated;
  final CurrentWeather current;
  final AqiData aqi;
  final PollenData pollen;
  final TideSeaData? tideSea;
  final OutdoorFitnessData outdoorFitness;
  final TravelerData traveler;
  final ParentsFamiliesData parentsFamilies;
  final AgricultureData agriculture;
  final CommuterData commuter;
  final EventPlannerData eventPlanner;

  const WeatherData({
    required this.cityName,
    required this.stateName,
    this.country = 'India',
    required this.latitude,
    required this.longitude,
    required this.isCoastal,
    this.coastDistanceKm,
    required this.lastUpdated,
    required this.current,
    required this.aqi,
    required this.pollen,
    this.tideSea,
    required this.outdoorFitness,
    required this.traveler,
    required this.parentsFamilies,
    required this.agriculture,
    required this.commuter,
    required this.eventPlanner,
  });

  bool get isIndia =>
      country.toLowerCase() == 'india' || country.toUpperCase() == 'IN';

  WeatherData copyWith({
    String? cityName,
    String? stateName,
    String? country,
    double? latitude,
    double? longitude,
    bool? isCoastal,
    double? coastDistanceKm,
    DateTime? lastUpdated,
    CurrentWeather? current,
    AqiData? aqi,
    PollenData? pollen,
    TideSeaData? tideSea,
    OutdoorFitnessData? outdoorFitness,
    TravelerData? traveler,
    ParentsFamiliesData? parentsFamilies,
    AgricultureData? agriculture,
    CommuterData? commuter,
    EventPlannerData? eventPlanner,
  }) {
    return WeatherData(
      cityName: cityName ?? this.cityName,
      stateName: stateName ?? this.stateName,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isCoastal: isCoastal ?? this.isCoastal,
      coastDistanceKm: coastDistanceKm ?? this.coastDistanceKm,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      current: current ?? this.current,
      aqi: aqi ?? this.aqi,
      pollen: pollen ?? this.pollen,
      tideSea: tideSea ?? this.tideSea,
      outdoorFitness: outdoorFitness ?? this.outdoorFitness,
      traveler: traveler ?? this.traveler,
      parentsFamilies: parentsFamilies ?? this.parentsFamilies,
      agriculture: agriculture ?? this.agriculture,
      commuter: commuter ?? this.commuter,
      eventPlanner: eventPlanner ?? this.eventPlanner,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'stateName': stateName,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'isCoastal': isCoastal,
      'coastDistanceKm': coastDistanceKm,
      'lastUpdated': lastUpdated.toIso8601String(),
      'current': current.toJson(),
      'aqi': aqi.toJson(),
      'pollen': pollen.toJson(),
      'tideSea': tideSea?.toJson(),
      'outdoorFitness': outdoorFitness.toJson(),
      'traveler': traveler.toJson(),
      'parentsFamilies': parentsFamilies.toJson(),
      'agriculture': agriculture.toJson(),
      'commuter': commuter.toJson(),
      'eventPlanner': eventPlanner.toJson(),
    };
  }

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['cityName'] as String? ?? 'New Delhi',
      stateName: json['stateName'] as String? ?? 'Delhi',
      country: json['country'] as String? ?? 'India',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 28.6139,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 77.2090,
      isCoastal: json['isCoastal'] as bool? ?? false,
      coastDistanceKm: (json['coastDistanceKm'] as num?)?.toDouble(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
      current: CurrentWeather.fromJson(json['current'] as Map<String, dynamic>? ?? {}),
      aqi: AqiData.fromJson(json['aqi'] as Map<String, dynamic>? ?? {}),
      pollen: PollenData.fromJson(json['pollen'] as Map<String, dynamic>? ?? {}),
      tideSea: json['tideSea'] != null
          ? TideSeaData.fromJson(json['tideSea'] as Map<String, dynamic>)
          : null,
      outdoorFitness: OutdoorFitnessData.fromJson(json['outdoorFitness'] as Map<String, dynamic>? ?? {}),
      traveler: TravelerData.fromJson(json['traveler'] as Map<String, dynamic>? ?? {}),
      parentsFamilies: ParentsFamiliesData.fromJson(json['parentsFamilies'] as Map<String, dynamic>? ?? {}),
      agriculture: AgricultureData.fromJson(json['agriculture'] as Map<String, dynamic>? ?? {}),
      commuter: CommuterData.fromJson(json['commuter'] as Map<String, dynamic>? ?? {}),
      eventPlanner: EventPlannerData.fromJson(json['eventPlanner'] as Map<String, dynamic>? ?? {}),
    );
  }
}

// -------------------------------------------------------------
// 1. Current Weather
// -------------------------------------------------------------
class CurrentWeather {
  final double temperature;
  final double feelsLike;
  final String condition;
  final int humidity;
  final double uvIndex;
  final double windSpeedKmh;
  final String windDirection;
  final double visibilityKm;
  final int pressureHpa;
  final String sunrise;
  final String sunset;
  final double tempMax;
  final double tempMin;

  const CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.humidity,
    required this.uvIndex,
    required this.windSpeedKmh,
    required this.windDirection,
    required this.visibilityKm,
    required this.pressureHpa,
    required this.sunrise,
    required this.sunset,
    required this.tempMax,
    required this.tempMin,
  });

  Map<String, dynamic> toJson() => {
    'temperature': temperature,
    'feelsLike': feelsLike,
    'condition': condition,
    'humidity': humidity,
    'uvIndex': uvIndex,
    'windSpeedKmh': windSpeedKmh,
    'windDirection': windDirection,
    'visibilityKm': visibilityKm,
    'pressureHpa': pressureHpa,
    'sunrise': sunrise,
    'sunset': sunset,
    'tempMax': tempMax,
    'tempMin': tempMin,
  };

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
    temperature: (json['temperature'] as num?)?.toDouble() ?? 29.0,
    feelsLike: (json['feelsLike'] as num?)?.toDouble() ?? 31.0,
    condition: json['condition'] as String? ?? 'Partly Cloudy',
    humidity: (json['humidity'] as num?)?.toInt() ?? 62,
    uvIndex: (json['uvIndex'] as num?)?.toDouble() ?? 6.5,
    windSpeedKmh: (json['windSpeedKmh'] as num?)?.toDouble() ?? 14.0,
    windDirection: json['windDirection'] as String? ?? 'ENE',
    visibilityKm: (json['visibilityKm'] as num?)?.toDouble() ?? 4.5,
    pressureHpa: (json['pressureHpa'] as num?)?.toInt() ?? 1012,
    sunrise: json['sunrise'] as String? ?? '06:05 AM',
    sunset: json['sunset'] as String? ?? '06:34 PM',
    tempMax: (json['tempMax'] as num?)?.toDouble() ?? 33.0,
    tempMin: (json['tempMin'] as num?)?.toDouble() ?? 24.0,
  );
}

// -------------------------------------------------------------
// 2. AQI (CPCB Integration)
// -------------------------------------------------------------
class AqiData {
  final int aqi;
  final double pm25;
  final double pm10;
  final double no2;
  final double so2;
  final double co;
  final double o3;
  final String category;
  final String healthAdvisory;
  final String stationName;
  final double stationDistanceKm;

  const AqiData({
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.no2,
    required this.so2,
    required this.co,
    required this.o3,
    required this.category,
    required this.healthAdvisory,
    this.stationName = 'CAAQMS Central Station',
    this.stationDistanceKm = 3.2,
  });

  bool get isUnhealthy => aqi > 200;

  Color get categoryColor {
    if (aqi <= 50) return const Color(0xFF2E7D32); // Good (Green)
    if (aqi <= 100) return const Color(0xFF689F38); // Satisfactory (Light Green)
    if (aqi <= 200) return const Color(0xFFFBC02D); // Moderate (Yellow)
    if (aqi <= 300) return const Color(0xFFFB8C00); // Poor (Orange)
    if (aqi <= 400) return const Color(0xFFD32F2F); // Very Poor (Red)
    return const Color(0xFF880E4F); // Severe (Maroon)
  }

  AqiData copyWith({
    int? aqi,
    double? pm25,
    double? pm10,
    double? no2,
    double? so2,
    double? co,
    double? o3,
    String? category,
    String? healthAdvisory,
    String? stationName,
    double? stationDistanceKm,
  }) {
    return AqiData(
      aqi: aqi ?? this.aqi,
      pm25: pm25 ?? this.pm25,
      pm10: pm10 ?? this.pm10,
      no2: no2 ?? this.no2,
      so2: so2 ?? this.so2,
      co: co ?? this.co,
      o3: o3 ?? this.o3,
      category: category ?? this.category,
      healthAdvisory: healthAdvisory ?? this.healthAdvisory,
      stationName: stationName ?? this.stationName,
      stationDistanceKm: stationDistanceKm ?? this.stationDistanceKm,
    );
  }

  Map<String, dynamic> toJson() => {
    'aqi': aqi,
    'pm25': pm25,
    'pm10': pm10,
    'no2': no2,
    'so2': so2,
    'co': co,
    'o3': o3,
    'category': category,
    'healthAdvisory': healthAdvisory,
    'stationName': stationName,
    'stationDistanceKm': stationDistanceKm,
  };

  factory AqiData.fromJson(Map<String, dynamic> json) => AqiData(
    aqi: (json['aqi'] as num?)?.toInt() ?? 142,
    pm25: (json['pm25'] as num?)?.toDouble() ?? 58.0,
    pm10: (json['pm10'] as num?)?.toDouble() ?? 115.0,
    no2: (json['no2'] as num?)?.toDouble() ?? 32.0,
    so2: (json['so2'] as num?)?.toDouble() ?? 12.0,
    co: (json['co'] as num?)?.toDouble() ?? 1.1,
    o3: (json['o3'] as num?)?.toDouble() ?? 28.0,
    category: json['category'] as String? ?? 'Moderate',
    healthAdvisory: json['healthAdvisory'] as String? ??
        'Sensitive individuals should limit prolonged outdoor exertion.',
    stationName: json['stationName'] as String? ?? 'CAAQMS Central Station',
    stationDistanceKm: (json['stationDistanceKm'] as num?)?.toDouble() ?? 3.2,
  );
}

// -------------------------------------------------------------
// 3. Pollen Data
// -------------------------------------------------------------
class PollenData {
  final int count;
  final String level;
  final String treePollen;
  final String grassPollen;
  final String weedPollen;

  const PollenData({
    required this.count,
    required this.level,
    required this.treePollen,
    required this.grassPollen,
    required this.weedPollen,
  });

  Map<String, dynamic> toJson() => {
    'count': count,
    'level': level,
    'treePollen': treePollen,
    'grassPollen': grassPollen,
    'weedPollen': weedPollen,
  };

  factory PollenData.fromJson(Map<String, dynamic> json) => PollenData(
    count: (json['count'] as num?)?.toInt() ?? 38,
    level: json['level'] as String? ?? 'Moderate',
    treePollen: json['treePollen'] as String? ?? 'Low',
    grassPollen: json['grassPollen'] as String? ?? 'Moderate',
    weedPollen: json['weedPollen'] as String? ?? 'Low',
  );
}

// -------------------------------------------------------------
// 4. Tide & Sea State (INCOIS Integration)
// -------------------------------------------------------------
class TideSeaData {
  final String seaCondition;
  final double waveHeightM;
  final double waterTempC;
  final String highTideTime;
  final String lowTideTime;
  final String nextTideType;
  final String nextTideCountdown;

  const TideSeaData({
    required this.seaCondition,
    required this.waveHeightM,
    required this.waterTempC,
    required this.highTideTime,
    required this.lowTideTime,
    required this.nextTideType,
    required this.nextTideCountdown,
  });

  Map<String, dynamic> toJson() => {
    'seaCondition': seaCondition,
    'waveHeightM': waveHeightM,
    'waterTempC': waterTempC,
    'highTideTime': highTideTime,
    'lowTideTime': lowTideTime,
    'nextTideType': nextTideType,
    'nextTideCountdown': nextTideCountdown,
  };

  factory TideSeaData.fromJson(Map<String, dynamic> json) => TideSeaData(
    seaCondition: json['seaCondition'] as String? ?? 'Moderate',
    waveHeightM: (json['waveHeightM'] as num?)?.toDouble() ?? 1.6,
    waterTempC: (json['waterTempC'] as num?)?.toDouble() ?? 28.5,
    highTideTime: json['highTideTime'] as String? ?? '01:45 PM (3.8m)',
    lowTideTime: json['lowTideTime'] as String? ?? '07:20 PM (1.1m)',
    nextTideType: json['nextTideType'] as String? ?? 'High Tide',
    nextTideCountdown: json['nextTideCountdown'] as String? ?? 'in 2 hrs 15 mins',
  );
}

// -------------------------------------------------------------
// 5. Outdoor Fitness Data
// -------------------------------------------------------------
class RunningWindow {
  final String timeWindow;
  final int score;
  final String rating;
  final String reason;

  const RunningWindow({
    required this.timeWindow,
    required this.score,
    required this.rating,
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
    'timeWindow': timeWindow,
    'score': score,
    'rating': rating,
    'reason': reason,
  };

  factory RunningWindow.fromJson(Map<String, dynamic> json) => RunningWindow(
    timeWindow: json['timeWindow'] as String? ?? '05:30 AM - 07:00 AM',
    score: (json['score'] as num?)?.toInt() ?? 88,
    rating: json['rating'] as String? ?? 'Optimal',
    reason: json['reason'] as String? ?? 'Cool breeze, low UV & acceptable AQI',
  );
}

class OutdoorFitnessData {
  final List<RunningWindow> bestRunningHours;
  final String goldenHourMorning;
  final String goldenHourEvening;
  final String? heatColdAlert;

  const OutdoorFitnessData({
    required this.bestRunningHours,
    required this.goldenHourMorning,
    required this.goldenHourEvening,
    this.heatColdAlert,
  });

  Map<String, dynamic> toJson() => {
    'bestRunningHours': bestRunningHours.map((w) => w.toJson()).toList(),
    'goldenHourMorning': goldenHourMorning,
    'goldenHourEvening': goldenHourEvening,
    'heatColdAlert': heatColdAlert,
  };

  factory OutdoorFitnessData.fromJson(Map<String, dynamic> json) {
    final rawList = json['bestRunningHours'] as List<dynamic>? ?? [];
    return OutdoorFitnessData(
      bestRunningHours: rawList
          .map((item) => RunningWindow.fromJson(item as Map<String, dynamic>))
          .toList(),
      goldenHourMorning: json['goldenHourMorning'] as String? ?? '06:05 AM - 06:50 AM',
      goldenHourEvening: json['goldenHourEvening'] as String? ?? '05:45 PM - 06:34 PM',
      heatColdAlert: json['heatColdAlert'] as String?,
    );
  }
}

// -------------------------------------------------------------
// 6. Traveler Data
// -------------------------------------------------------------
class TravelDestination {
  final String city;
  final double temp;
  final String condition;
  final int rainProbability;
  final String? alert;

  const TravelDestination({
    required this.city,
    required this.temp,
    required this.condition,
    required this.rainProbability,
    this.alert,
  });

  Map<String, dynamic> toJson() => {
    'city': city,
    'temp': temp,
    'condition': condition,
    'rainProbability': rainProbability,
    'alert': alert,
  };

  factory TravelDestination.fromJson(Map<String, dynamic> json) => TravelDestination(
    city: json['city'] as String? ?? 'Goa',
    temp: (json['temp'] as num?)?.toDouble() ?? 29.5,
    condition: json['condition'] as String? ?? 'Scattered Showers',
    rainProbability: (json['rainProbability'] as num?)?.toInt() ?? 65,
    alert: json['alert'] as String?,
  );
}

class TravelerData {
  final List<TravelDestination> savedDestinations;
  final List<String> packingSuggestions;

  const TravelerData({
    required this.savedDestinations,
    required this.packingSuggestions,
  });

  Map<String, dynamic> toJson() => {
    'savedDestinations': savedDestinations.map((d) => d.toJson()).toList(),
    'packingSuggestions': packingSuggestions,
  };

  factory TravelerData.fromJson(Map<String, dynamic> json) {
    final rawList = json['savedDestinations'] as List<dynamic>? ?? [];
    final rawPacking = json['packingSuggestions'] as List<dynamic>? ?? [];
    return TravelerData(
      savedDestinations: rawList
          .map((item) => TravelDestination.fromJson(item as Map<String, dynamic>))
          .toList(),
      packingSuggestions: rawPacking.map((e) => e.toString()).toList(),
    );
  }
}

// -------------------------------------------------------------
// 7. Parents & Families Data
// -------------------------------------------------------------
class SchoolCommuteWindow {
  final String title;
  final String timeRange;
  final double temp;
  final int rainProbability;
  final String condition;
  final String advisory;

  const SchoolCommuteWindow({
    required this.title,
    required this.timeRange,
    required this.temp,
    required this.rainProbability,
    required this.condition,
    required this.advisory,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'timeRange': timeRange,
    'temp': temp,
    'rainProbability': rainProbability,
    'condition': condition,
    'advisory': advisory,
  };

  factory SchoolCommuteWindow.fromJson(Map<String, dynamic> json) => SchoolCommuteWindow(
    title: json['title'] as String? ?? 'Morning Commute',
    timeRange: json['timeRange'] as String? ?? '07:00 AM - 09:00 AM',
    temp: (json['temp'] as num?)?.toDouble() ?? 26.0,
    rainProbability: (json['rainProbability'] as num?)?.toInt() ?? 15,
    condition: json['condition'] as String? ?? 'Clear & Pleasant',
    advisory: json['advisory'] as String? ?? 'Good conditions for walking/bus commute.',
  );

  SchoolCommuteWindow copyWith({
    String? title,
    String? timeRange,
    double? temp,
    int? rainProbability,
    String? condition,
    String? advisory,
  }) {
    return SchoolCommuteWindow(
      title: title ?? this.title,
      timeRange: timeRange ?? this.timeRange,
      temp: temp ?? this.temp,
      rainProbability: rainProbability ?? this.rainProbability,
      condition: condition ?? this.condition,
      advisory: advisory ?? this.advisory,
    );
  }
}

class ParentsFamiliesData {
  final SchoolCommuteWindow morningCommute;
  final SchoolCommuteWindow afternoonCommute;
  final String outdoorPlaySafety;
  final String? alert;

  const ParentsFamiliesData({
    required this.morningCommute,
    required this.afternoonCommute,
    required this.outdoorPlaySafety,
    this.alert,
  });

  ParentsFamiliesData copyWith({
    SchoolCommuteWindow? morningCommute,
    SchoolCommuteWindow? afternoonCommute,
    String? outdoorPlaySafety,
    String? alert,
    bool clearAlert = false,
  }) {
    return ParentsFamiliesData(
      morningCommute: morningCommute ?? this.morningCommute,
      afternoonCommute: afternoonCommute ?? this.afternoonCommute,
      outdoorPlaySafety: outdoorPlaySafety ?? this.outdoorPlaySafety,
      alert: clearAlert ? null : (alert ?? this.alert),
    );
  }

  Map<String, dynamic> toJson() => {
    'morningCommute': morningCommute.toJson(),
    'afternoonCommute': afternoonCommute.toJson(),
    'outdoorPlaySafety': outdoorPlaySafety,
    'alert': alert,
  };

  factory ParentsFamiliesData.fromJson(Map<String, dynamic> json) => ParentsFamiliesData(
    morningCommute: SchoolCommuteWindow.fromJson(
        json['morningCommute'] as Map<String, dynamic>? ?? {}),
    afternoonCommute: SchoolCommuteWindow.fromJson(
        json['afternoonCommute'] as Map<String, dynamic>? ?? {}),
    outdoorPlaySafety: json['outdoorPlaySafety'] as String? ??
        'Safe until 11:30 AM; moderate heat index in the afternoon.',
    alert: json['alert'] as String?,
  );
}

// -------------------------------------------------------------
// 8. Agriculture & Gardeners (Agromet GKMS)
// -------------------------------------------------------------
class AgricultureData {
  final int soilMoisturePercent;
  final double rainfallPrediction48hMm;
  final bool frostAlert;
  final bool heatwaveAlert;
  final String seasonalCropTip;
  final String recommendedAction;

  const AgricultureData({
    required this.soilMoisturePercent,
    required this.rainfallPrediction48hMm,
    required this.frostAlert,
    required this.heatwaveAlert,
    required this.seasonalCropTip,
    required this.recommendedAction,
  });

  Map<String, dynamic> toJson() => {
    'soilMoisturePercent': soilMoisturePercent,
    'rainfallPrediction48hMm': rainfallPrediction48hMm,
    'frostAlert': frostAlert,
    'heatwaveAlert': heatwaveAlert,
    'seasonalCropTip': seasonalCropTip,
    'recommendedAction': recommendedAction,
  };

  factory AgricultureData.fromJson(Map<String, dynamic> json) => AgricultureData(
    soilMoisturePercent: (json['soilMoisturePercent'] as num?)?.toInt() ?? 58,
    rainfallPrediction48hMm: (json['rainfallPrediction48hMm'] as num?)?.toDouble() ?? 12.4,
    frostAlert: json['frostAlert'] as bool? ?? false,
    heatwaveAlert: json['heatwaveAlert'] as bool? ?? false,
    seasonalCropTip: json['seasonalCropTip'] as String? ??
        'Pre-Rabi land preparation: Ideal soil moisture for wheat and mustard nursery beds.',
    recommendedAction: json['recommendedAction'] as String? ??
        'Postpone chemical pesticide spraying due to moderate wind and expected light showers.',
  );
}

// -------------------------------------------------------------
// 9. Commuter Data
// -------------------------------------------------------------
class CommuterData {
  final int trafficDelayMins;
  final String trafficStatus;
  final int visibilityMeters;
  final String? fogStormAlert;
  final String routeSafety;

  const CommuterData({
    required this.trafficDelayMins,
    required this.trafficStatus,
    required this.visibilityMeters,
    this.fogStormAlert,
    required this.routeSafety,
  });

  Map<String, dynamic> toJson() => {
    'trafficDelayMins': trafficDelayMins,
    'trafficStatus': trafficStatus,
    'visibilityMeters': visibilityMeters,
    'fogStormAlert': fogStormAlert,
    'routeSafety': routeSafety,
  };

  factory CommuterData.fromJson(Map<String, dynamic> json) => CommuterData(
    trafficDelayMins: (json['trafficDelayMins'] as num?)?.toInt() ?? 18,
    trafficStatus: json['trafficStatus'] as String? ?? 'Moderate Delays (+18 min)',
    visibilityMeters: (json['visibilityMeters'] as num?)?.toInt() ?? 3200,
    fogStormAlert: json['fogStormAlert'] as String?,
    routeSafety: json['routeSafety'] as String? ?? 'Normal Caution',
  );
}

// -------------------------------------------------------------
// 10. Event Planner Data (Extended Forecast & Comfort Index)
// -------------------------------------------------------------
class DailyForecast {
  final String day;
  final String date;
  final double tempMax;
  final double tempMin;
  final String condition;
  final int rainProbability;
  final int comfortScore;

  const DailyForecast({
    required this.day,
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
    required this.rainProbability,
    required this.comfortScore,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'date': date,
    'tempMax': tempMax,
    'tempMin': tempMin,
    'condition': condition,
    'rainProbability': rainProbability,
    'comfortScore': comfortScore,
  };

  factory DailyForecast.fromJson(Map<String, dynamic> json) => DailyForecast(
    day: json['day'] as String? ?? 'Mon',
    date: json['date'] as String? ?? 'Sep 15',
    tempMax: (json['tempMax'] as num?)?.toDouble() ?? 32.0,
    tempMin: (json['tempMin'] as num?)?.toDouble() ?? 23.0,
    condition: json['condition'] as String? ?? 'Sunny',
    rainProbability: (json['rainProbability'] as num?)?.toInt() ?? 10,
    comfortScore: (json['comfortScore'] as num?)?.toInt() ?? 82,
  );
}

class EventPlannerData {
  final List<DailyForecast> extendedForecast;
  final int comfortIndexScore; // 0 - 100
  final String comfortCategory;
  final String comfortFormulaBreakdown;

  const EventPlannerData({
    required this.extendedForecast,
    required this.comfortIndexScore,
    required this.comfortCategory,
    required this.comfortFormulaBreakdown,
  });

  Map<String, dynamic> toJson() => {
    'extendedForecast': extendedForecast.map((d) => d.toJson()).toList(),
    'comfortIndexScore': comfortIndexScore,
    'comfortCategory': comfortCategory,
    'comfortFormulaBreakdown': comfortFormulaBreakdown,
  };

  factory EventPlannerData.fromJson(Map<String, dynamic> json) {
    final rawList = json['extendedForecast'] as List<dynamic>? ?? [];
    return EventPlannerData(
      extendedForecast: rawList
          .map((item) => DailyForecast.fromJson(item as Map<String, dynamic>))
          .toList(),
      comfortIndexScore: (json['comfortIndexScore'] as num?)?.toInt() ?? 78,
      comfortCategory: json['comfortCategory'] as String? ?? 'Ideal for Outdoor Events',
      comfortFormulaBreakdown: json['comfortFormulaBreakdown'] as String? ??
          'Combined: Temp (29°C), Humidity (62%), Wind (14 km/h)',
    );
  }
}
