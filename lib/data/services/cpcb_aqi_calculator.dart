import '../models/weather_data.dart';

/// Central Pollution Control Board (CPCB) NAQI (National Air Quality Index) Engine
/// Implements the official Indian CPCB piecewise linear interpolation methodology
/// and breakpoint standards (MoEFCC, Government of India).
class CpcbAqiCalculator {
  const CpcbAqiCalculator._();

  static const List<_Breakpoint> _pm25Breakpoints = [
    _Breakpoint(0, 30, 0, 50),
    _Breakpoint(30, 60, 50, 100),
    _Breakpoint(60, 90, 100, 200),
    _Breakpoint(90, 120, 200, 300),
    _Breakpoint(120, 250, 300, 400),
    _Breakpoint(250, 500, 400, 500),
  ];

  static const List<_Breakpoint> _pm10Breakpoints = [
    _Breakpoint(0, 50, 0, 50),
    _Breakpoint(50, 100, 50, 100),
    _Breakpoint(100, 250, 100, 200),
    _Breakpoint(250, 350, 200, 300),
    _Breakpoint(350, 430, 300, 400),
    _Breakpoint(430, 600, 400, 500),
  ];

  static const List<_Breakpoint> _no2Breakpoints = [
    _Breakpoint(0, 40, 0, 50),
    _Breakpoint(40, 80, 50, 100),
    _Breakpoint(80, 180, 100, 200),
    _Breakpoint(180, 280, 200, 300),
    _Breakpoint(280, 400, 300, 400),
    _Breakpoint(400, 600, 400, 500),
  ];

  static const List<_Breakpoint> _so2Breakpoints = [
    _Breakpoint(0, 40, 0, 50),
    _Breakpoint(40, 80, 50, 100),
    _Breakpoint(80, 380, 100, 200),
    _Breakpoint(380, 800, 200, 300),
    _Breakpoint(800, 1600, 300, 400),
    _Breakpoint(1600, 2000, 400, 500),
  ];

  static const List<_Breakpoint> _coBreakpoints = [
    _Breakpoint(0.0, 1.0, 0, 50),
    _Breakpoint(1.0, 2.0, 50, 100),
    _Breakpoint(2.0, 10.0, 100, 200),
    _Breakpoint(10.0, 17.0, 200, 300),
    _Breakpoint(17.0, 34.0, 300, 400),
    _Breakpoint(34.0, 50.0, 400, 500),
  ];

  static const List<_Breakpoint> _o3Breakpoints = [
    _Breakpoint(0, 50, 0, 50),
    _Breakpoint(50, 100, 50, 100),
    _Breakpoint(100, 168, 100, 200),
    _Breakpoint(168, 208, 200, 300),
    _Breakpoint(208, 748, 300, 400),
    _Breakpoint(748, 1000, 400, 500),
  ];

  /// Calculates the official Indian CPCB AQI from monitored pollutant concentrations.
  ///
  /// [pm25] concentration in µg/m³
  /// [pm10] concentration in µg/m³
  /// [no2] concentration in µg/m³
  /// [so2] concentration in µg/m³
  /// [coMgM3] concentration in mg/m³ (if input is in µg/m³, divide by 1000)
  /// [o3] concentration in µg/m³
  static AqiData calculateAqi({
    required double pm25,
    required double pm10,
    double no2 = 0.0,
    double so2 = 0.0,
    double coMgM3 = 0.0,
    double o3 = 0.0,
    String? stationName,
    double stationDistanceKm = 2.8,
  }) {
    final subIndices = <String, double>{
      'PM2.5': _subIndex(pm25, _pm25Breakpoints),
      'PM10': _subIndex(pm10, _pm10Breakpoints),
      if (no2 > 0) 'NO2': _subIndex(no2, _no2Breakpoints),
      if (so2 > 0) 'SO2': _subIndex(so2, _so2Breakpoints),
      if (coMgM3 > 0) 'CO': _subIndex(coMgM3, _coBreakpoints),
      if (o3 > 0) 'O3': _subIndex(o3, _o3Breakpoints),
    };

    // Overall AQI is the MAXIMUM sub-index among all active pollutants
    double maxIndex = 0.0;
    String dominantPollutant = 'PM2.5';

    subIndices.forEach((pollutant, score) {
      if (score > maxIndex) {
        maxIndex = score;
        dominantPollutant = pollutant;
      }
    });

    final int finalAqi = maxIndex.round().clamp(1, 500);
    final category = _getCategory(finalAqi);
    final advisory = _getHealthAdvisory(finalAqi, dominantPollutant);

    return AqiData(
      aqi: finalAqi,
      pm25: double.parse(pm25.toStringAsFixed(1)),
      pm10: double.parse(pm10.toStringAsFixed(1)),
      no2: double.parse(no2.toStringAsFixed(1)),
      so2: double.parse(so2.toStringAsFixed(1)),
      co: double.parse(coMgM3.toStringAsFixed(2)),
      o3: double.parse(o3.toStringAsFixed(1)),
      category: category,
      healthAdvisory: advisory,
      stationName: stationName ?? 'CAAQMS Real-Time Telemetry',
      stationDistanceKm: stationDistanceKm,
    );
  }

  static double _subIndex(double cp, List<_Breakpoint> breakpoints) {
    if (cp <= 0) return 0.0;

    for (final bp in breakpoints) {
      if (cp <= bp.bHi) {
        final bLo = bp.bLo;
        final bHi = bp.bHi;
        final iLo = bp.iLo;
        final iHi = bp.iHi;
        return ((iHi - iLo) / (bHi - bLo)) * (cp - bLo) + iLo;
      }
    }

    // Value exceeds highest breakpoint
    return breakpoints.last.iHi.toDouble();
  }

  static String _getCategory(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Satisfactory';
    if (aqi <= 200) return 'Moderate';
    if (aqi <= 300) return 'Poor';
    if (aqi <= 400) return 'Very Poor';
    return 'Severe';
  }

  static String _getHealthAdvisory(int aqi, String dominantPollutant) {
    if (aqi <= 50) {
      return 'Air quality is satisfactory. Clean ambient air poses minimal or no health risk.';
    }
    if (aqi <= 100) {
      return 'Air quality is acceptable. Sensitive individuals may experience minor respiratory discomfort.';
    }
    if (aqi <= 200) {
      return 'May cause breathing discomfort to people with asthma, lung diseases, or heart ailments (Dominant: $dominantPollutant).';
    }
    if (aqi <= 300) {
      return 'May cause breathing discomfort to most people on prolonged exposure. Sensitive groups should wear masks.';
    }
    if (aqi <= 400) {
      return 'HEALTH ALERT: Respiratory illness risk on prolonged exposure. Avoid strenuous outdoor activities.';
    }
    return 'EMERGENCY: Severe atmospheric pollution. Healthy people affected; serious impacts on vulnerable groups. Wear N95 masks.';
  }
}

class _Breakpoint {
  final double bLo;
  final double bHi;
  final int iLo;
  final int iHi;

  const _Breakpoint(this.bLo, this.bHi, this.iLo, this.iHi);
}
