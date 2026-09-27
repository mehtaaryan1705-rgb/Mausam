import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;

/// CoastalDetector - Offline Twin of backend/utils/coastal.js
///
/// SINGLE SOURCE OF TRUTH: Uses assets/data/india_coastline.json
/// Algorithm must stay mathematically identical to backend/utils/coastal.js.
///
/// Execution Hierarchy:
/// - Online: Authoritative backend result from /api/geocode is used directly.
/// - Offline / Fallback: This client-side detector runs on-device using the bundled asset.
class CoastalDetector {
  static final CoastalDetector instance = CoastalDetector._internal();
  CoastalDetector._internal();

  static const double coastalThresholdKm = 25.0;
  static const double earthRadiusKm = 6371.0088;

  List<({double aLon, double aLat, double bLon, double bLat})>? _cachedSegments;

  Future<void> initialize() async {
    if (_cachedSegments != null) return;
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/india_coastline.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final features = data['features'] as List<dynamic>;
      final coords =
          features[0]['geometry']['coordinates'] as List<dynamic>;

      final segments = <({double aLon, double aLat, double bLon, double bLat})>[];
      for (int i = 0; i < coords.length - 1; i++) {
        final p1 = coords[i] as List<dynamic>;
        final p2 = coords[i + 1] as List<dynamic>;
        segments.add((
          aLon: (p1[0] as num).toDouble(),
          aLat: (p1[1] as num).toDouble(),
          bLon: (p2[0] as num).toDouble(),
          bLat: (p2[1] as num).toDouble(),
        ));
      }
      _cachedSegments = segments;
    } catch (_) {
      // Graceful fallback if asset loading is delayed
    }
  }

  /// Calculates minimum distance to India's coastline
  Future<({bool isCoastal, double coastDistanceKm})> checkProximity(
      double lat, double lon) async {
    await initialize();
    if (_cachedSegments == null || _cachedSegments!.isEmpty) {
      // Heuristic fallback if asset failed to load
      return (isCoastal: false, coastDistanceKm: 999.0);
    }

    double minDistanceKm = double.infinity;
    for (final seg in _cachedSegments!) {
      final d = _distanceToSegment(lat, lon, seg.aLat, seg.aLon, seg.bLat, seg.bLon);
      if (d < minDistanceKm) {
        minDistanceKm = d;
      }
    }

    final rounded = (minDistanceKm * 10.0).roundToDouble() / 10.0;
    return (
      isCoastal: rounded <= coastalThresholdKm,
      coastDistanceKm: rounded,
    );
  }

  /// Synchronous version if segments are already cached
  ({bool isCoastal, double coastDistanceKm}) checkProximitySync(
      double lat, double lon) {
    if (_cachedSegments == null || _cachedSegments!.isEmpty) {
      return (isCoastal: false, coastDistanceKm: 999.0);
    }

    double minDistanceKm = double.infinity;
    for (final seg in _cachedSegments!) {
      final d = _distanceToSegment(lat, lon, seg.aLat, seg.aLon, seg.bLat, seg.bLon);
      if (d < minDistanceKm) {
        minDistanceKm = d;
      }
    }

    final rounded = (minDistanceKm * 10.0).roundToDouble() / 10.0;
    return (
      isCoastal: rounded <= coastalThresholdKm,
      coastDistanceKm: rounded,
    );
  }

  double _haversineDistance(
      double lat1, double lon1, double lat2, double lon2) {
    double toRad(double deg) => (deg * math.pi) / 180.0;
    final dLat = toRad(lat2 - lat1);
    final dLon = toRad(lon2 - lon1);
    final rLat1 = toRad(lat1);
    final rLat2 = toRad(lat2);

    final a = math.sin(dLat / 2.0) * math.sin(dLat / 2.0) +
        math.cos(rLat1) *
            math.cos(rLat2) *
            math.sin(dLon / 2.0) *
            math.sin(dLon / 2.0);
    final c = 2.0 * math.atan2(math.sqrt(a), math.sqrt(1.0 - a));
    return earthRadiusKm * c;
  }

  double _distanceToSegment(double pLat, double pLon, double aLat, double aLon,
      double bLat, double bLon) {
    final midLat = ((aLat + bLat) / 2.0) * (math.pi / 180.0);
    final cosMidLat = math.cos(midLat);

    final dx = (bLon - aLon) * cosMidLat;
    final dy = bLat - aLat;
    final segLengthSq = dx * dx + dy * dy;

    if (segLengthSq < 1e-12) {
      return _haversineDistance(pLat, pLon, aLat, aLon);
    }

    final px = (pLon - aLon) * cosMidLat;
    final py = pLat - aLat;

    double t = (px * dx + py * dy) / segLengthSq;
    t = math.max(0.0, math.min(1.0, t));

    final projLat = aLat + t * (bLat - aLat);
    final projLon = aLon + t * (bLon - aLon);

    return _haversineDistance(pLat, pLon, projLat, projLon);
  }
}
