import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/data/services/coastal_detector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CoastalDetector Client-Side Offline Twin Tests', () {
    test('Correctly identifies coastal cities under 25km threshold', () async {
      // Mumbai Gateway of India
      final mumbai = await CoastalDetector.instance.checkProximity(18.9220, 72.8347);
      expect(mumbai.isCoastal, isTrue, reason: 'Mumbai should be coastal');
      expect(mumbai.coastDistanceKm, lessThanOrEqualTo(25.0));

      // Kochi Beach
      final kochi = await CoastalDetector.instance.checkProximity(9.9312, 76.2673);
      expect(kochi.isCoastal, isTrue, reason: 'Kochi should be coastal');
      expect(kochi.coastDistanceKm, lessThanOrEqualTo(25.0));

      // Kottayam (~22km inland from Vembanad/Arabian coast, within 25km)
      final kottayam = await CoastalDetector.instance.checkProximity(9.5916, 76.5222);
      expect(kottayam.isCoastal, isTrue, reason: 'Kottayam is within 25km of coast');
      expect(kottayam.coastDistanceKm, lessThanOrEqualTo(25.0));
    });

    test('Correctly identifies inland cities beyond 25km threshold', () async {
      // New Delhi
      final delhi = await CoastalDetector.instance.checkProximity(28.6139, 77.2090);
      expect(delhi.isCoastal, isFalse, reason: 'New Delhi is inland');
      expect(delhi.coastDistanceKm, greaterThan(100.0));

      // Varanasi
      final varanasi = await CoastalDetector.instance.checkProximity(25.3176, 82.9739);
      expect(varanasi.isCoastal, isFalse, reason: 'Varanasi is inland');
      expect(varanasi.coastDistanceKm, greaterThan(100.0));
    });
  });
}
