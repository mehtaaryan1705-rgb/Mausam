/**
 * Coastal Detection Utility for Mausam 2.0
 * Computes minimum distance from coordinates (lat, lon) to India's coastline.
 *
 * SINGLE SOURCE OF TRUTH: Uses backend/data/india_coastline.json (identical to assets/data/india_coastline.json)
 * Algorithm must remain mathematically identical to lib/data/services/coastal_detector.dart
 */

const fs = require('fs');
const path = require('path');

const COASTAL_THRESHOLD_KM = 25.0;
const EARTH_RADIUS_KM = 6371.0088;

let cachedCoastlineSegments = null;

function loadCoastlineData() {
  if (cachedCoastlineSegments) return cachedCoastlineSegments;

  const jsonPath = path.join(__dirname, '..', 'data', 'india_coastline.json');
  const raw = fs.readFileSync(jsonPath, 'utf8');
  const geojson = JSON.parse(raw);

  const segments = [];
  for (const feature of geojson.features) {
    const coords = feature.geometry.coordinates; // [lon, lat]
    for (let i = 0; i < coords.length - 1; i++) {
      segments.push({
        aLon: coords[i][0],
        aLat: coords[i][1],
        bLon: coords[i + 1][0],
        bLat: coords[i + 1][1],
      });
    }
  }

  cachedCoastlineSegments = segments;
  return cachedCoastlineSegments;
}

/**
 * Standard Haversine formula between two coordinate pairs
 */
function haversineDistance(lat1, lon1, lat2, lon2) {
  const toRad = (deg) => (deg * Math.PI) / 180.0;
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  const rLat1 = toRad(lat1);
  const rLat2 = toRad(lat2);

  const a =
    Math.sin(dLat / 2.0) ** 2 +
    Math.cos(rLat1) * Math.cos(rLat2) * Math.sin(dLon / 2.0) ** 2;
  const c = 2.0 * Math.atan2(Math.sqrt(a), Math.sqrt(1.0 - a));
  return EARTH_RADIUS_KM * c;
}

/**
 * Distance from point P(lat, lon) to segment A(aLat, aLon) - B(bLat, bLon)
 */
function distanceToSegment(pLat, pLon, aLat, aLon, bLat, bLon) {
  const midLat = ((aLat + bLat) / 2.0) * (Math.PI / 180.0);
  const cosMidLat = Math.cos(midLat);

  const dx = (bLon - aLon) * cosMidLat;
  const dy = bLat - aLat;
  const segLengthSq = dx * dx + dy * dy;

  if (segLengthSq < 1e-12) {
    return haversineDistance(pLat, pLon, aLat, aLon);
  }

  const px = (pLon - aLon) * cosMidLat;
  const py = pLat - aLat;

  let t = (px * dx + py * dy) / segLengthSq;
  t = Math.max(0.0, Math.min(1.0, t));

  const projLat = aLat + t * (bLat - aLat);
  const projLon = aLon + t * (bLon - aLon);

  return haversineDistance(pLat, pLon, projLat, projLon);
}

/**
 * Calculates whether coordinates are coastal and distance in km
 * @param {number} lat - Latitude
 * @param {number} lon - Longitude
 * @returns {{ isCoastal: boolean, coastDistanceKm: number }}
 */
function checkCoastlineProximity(lat, lon) {
  const segments = loadCoastlineData();
  let minDistanceKm = Infinity;

  for (const seg of segments) {
    const d = distanceToSegment(lat, lon, seg.aLat, seg.aLon, seg.bLat, seg.bLon);
    if (d < minDistanceKm) {
      minDistanceKm = d;
    }
  }

  const roundedDistance = Math.round(minDistanceKm * 10.0) / 10.0;
  return {
    isCoastal: roundedDistance <= COASTAL_THRESHOLD_KM,
    coastDistanceKm: roundedDistance,
  };
}

module.exports = {
  checkCoastlineProximity,
  COASTAL_THRESHOLD_KM,
  haversineDistance,
};
