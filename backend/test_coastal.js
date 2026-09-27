/**
 * Test script for coastal detection algorithm in Node.js
 */

const { checkCoastlineProximity, COASTAL_THRESHOLD_KM } = require('./utils/coastal');

const testCases = [
  { name: 'Mumbai', lat: 18.9220, lon: 72.8347, expectedCoastal: true, maxExpectedDistKm: 3 },
  { name: 'Kochi', lat: 9.9312, lon: 76.2673, expectedCoastal: true, maxExpectedDistKm: 5 },
  { name: 'Varanasi', lat: 25.3176, lon: 82.9739, expectedCoastal: false, minExpectedDistKm: 500 },
  { name: 'New Delhi', lat: 28.6139, lon: 77.2090, expectedCoastal: false, minExpectedDistKm: 500 },
  { name: 'Kottayam (Borderline-Inside)', lat: 9.5916, lon: 76.5222, expectedCoastal: true, maxExpectedDistKm: 25 },
  { name: 'Pala (Borderline-Outside)', lat: 9.7117, lon: 76.6833, expectedCoastal: false, minExpectedDistKm: 25 },
];

console.log('=== VERIFYING COASTAL DISTANCE ALGORITHM ===');
let allPassed = true;

for (const tc of testCases) {
  const result = checkCoastlineProximity(tc.lat, tc.lon);
  console.log(
    `[RESULT] ${tc.name.padEnd(22)}: dist = ${result.coastDistanceKm} km, isCoastal = ${result.isCoastal} (Threshold = ${COASTAL_THRESHOLD_KM}km)`
  );

  if (tc.expectedCoastal !== undefined) {
    if (result.isCoastal !== tc.expectedCoastal) {
      console.error(`  FAIL: Expected isCoastal = ${tc.expectedCoastal}, got ${result.isCoastal}`);
      allPassed = false;
    }
  }

  if (tc.maxExpectedDistKm && result.coastDistanceKm > tc.maxExpectedDistKm) {
    console.error(`  FAIL: Expected dist <= ${tc.maxExpectedDistKm}, got ${result.coastDistanceKm}`);
    allPassed = false;
  }

  if (tc.minExpectedDistKm && result.coastDistanceKm < tc.minExpectedDistKm) {
    console.error(`  FAIL: Expected dist >= ${tc.minExpectedDistKm}, got ${result.coastDistanceKm}`);
    allPassed = false;
  }
}

if (allPassed) {
  console.log('\n[PASS] All coastal detection test cases passed successfully!');
  process.exit(0);
} else {
  console.error('\n[FAIL] Some test cases failed.');
  process.exit(1);
}
