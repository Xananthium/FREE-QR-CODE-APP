import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/core/utils/qr_validator.dart';

void main() {
  group('QRValidator', () {
    test('validates adequate quiet zone (10%)', () {
      final result = QRValidator.validateQuietZone(
        qrSize: 1024,
        padding: 102.4,
      );
      expect(result.isValid, true);
      expect(result.status, QuietZoneStatus.adequate);
    });

    test('validates excellent quiet zone (15%)', () {
      final result = QRValidator.validateQuietZone(
        qrSize: 1024,
        padding: 153.6,
      );
      expect(result.isValid, true);
      expect(result.status, QuietZoneStatus.excellent);
    });

    test('rejects insufficient quiet zone (5%)', () {
      final result = QRValidator.validateQuietZone(
        qrSize: 1024,
        padding: 51.2,
      );
      expect(result.isValid, false);
      expect(result.status, QuietZoneStatus.insufficient);
    });

    test('calculates minimum padding correctly', () {
      expect(QRValidator.calculateMinimumPadding(1024), 102.4);
      expect(QRValidator.calculateMinimumPadding(512), 51.2);
    });

    test('calculates recommended padding correctly', () {
      expect(QRValidator.calculateRecommendedPadding(1024), 153.6);
      expect(QRValidator.calculateRecommendedPadding(512), 76.8);
    });

    test('validates multiple sizes', () {
      final results = QRValidator.validateMultiple({
        512: 51.2,
        1024: 102.4,
        2048: 204.8,
      });
      
      expect(results[512]!.status, QuietZoneStatus.adequate);
      expect(results[1024]!.status, QuietZoneStatus.adequate);
      expect(results[2048]!.status, QuietZoneStatus.adequate);
    });
  });
}
