import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/models/export_options.dart';

void main() {
  group('ExportResolution', () {
    test('should have all required enum values', () {
      expect(ExportResolution.values.length, 4);
      expect(ExportResolution.values, contains(ExportResolution.small));
      expect(ExportResolution.values, contains(ExportResolution.medium));
      expect(ExportResolution.values, contains(ExportResolution.large));
      expect(ExportResolution.values, contains(ExportResolution.extraLarge));
    });

    test('displayName should return correct human-readable names', () {
      expect(ExportResolution.small.displayName, 'Small (512×512)');
      expect(ExportResolution.medium.displayName, 'Medium (1024×1024)');
      expect(ExportResolution.large.displayName, 'Large (2048×2048)');
      expect(ExportResolution.extraLarge.displayName, 'Extra Large (4096×4096)');
    });

    test('pixelSize should return correct dimensions', () {
      expect(ExportResolution.small.pixelSize, 512);
      expect(ExportResolution.medium.pixelSize, 1024);
      expect(ExportResolution.large.pixelSize, 2048);
      expect(ExportResolution.extraLarge.pixelSize, 4096);
    });

    test('toJson should return enum name', () {
      expect(ExportResolution.small.toJson(), 'small');
      expect(ExportResolution.medium.toJson(), 'medium');
      expect(ExportResolution.large.toJson(), 'large');
      expect(ExportResolution.extraLarge.toJson(), 'extraLarge');
    });

    test('fromJson should deserialize valid values', () {
      expect(ExportResolution.fromJson('small'), ExportResolution.small);
      expect(ExportResolution.fromJson('medium'), ExportResolution.medium);
      expect(ExportResolution.fromJson('large'), ExportResolution.large);
      expect(ExportResolution.fromJson('extraLarge'), ExportResolution.extraLarge);
    });

    test('fromJson should default to medium for invalid values', () {
      expect(ExportResolution.fromJson('invalid'), ExportResolution.medium);
      expect(ExportResolution.fromJson(''), ExportResolution.medium);
    });
  });

  group('ExportFormat', () {
    test('should have all required enum values', () {
      expect(ExportFormat.values.length, 2);
      expect(ExportFormat.values, contains(ExportFormat.png));
      expect(ExportFormat.values, contains(ExportFormat.jpeg));
    });

    test('displayName should return correct names', () {
      expect(ExportFormat.png.displayName, 'PNG');
      expect(ExportFormat.jpeg.displayName, 'JPEG');
    });

    test('fileExtension should return correct extensions', () {
      expect(ExportFormat.png.fileExtension, 'png');
      expect(ExportFormat.jpeg.fileExtension, 'jpg');
    });

    test('mimeType should return correct MIME types', () {
      expect(ExportFormat.png.mimeType, 'image/png');
      expect(ExportFormat.jpeg.mimeType, 'image/jpeg');
    });

    test('toJson should return enum name', () {
      expect(ExportFormat.png.toJson(), 'png');
      expect(ExportFormat.jpeg.toJson(), 'jpeg');
    });

    test('fromJson should deserialize valid values', () {
      expect(ExportFormat.fromJson('png'), ExportFormat.png);
      expect(ExportFormat.fromJson('jpeg'), ExportFormat.jpeg);
    });

    test('fromJson should default to png for invalid values', () {
      expect(ExportFormat.fromJson('invalid'), ExportFormat.png);
      expect(ExportFormat.fromJson(''), ExportFormat.png);
    });
  });

  group('ExportOptions', () {
    test('should create with default values', () {
      const options = ExportOptions();
      expect(options.resolution, ExportResolution.medium);
      expect(options.format, ExportFormat.png);
      expect(options.quality, 85);
    });

    test('should create with custom values', () {
      const options = ExportOptions(
        resolution: ExportResolution.large,
        format: ExportFormat.jpeg,
        quality: 90,
      );
      expect(options.resolution, ExportResolution.large);
      expect(options.format, ExportFormat.jpeg);
      expect(options.quality, 90);
    });

    test('should throw assertion error for quality < 0', () {
      expect(
        () => ExportOptions(quality: -1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw assertion error for quality > 100', () {
      expect(
        () => ExportOptions(quality: 101),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should accept quality values 0-100', () {
      expect(() => const ExportOptions(quality: 0), returnsNormally);
      expect(() => const ExportOptions(quality: 50), returnsNormally);
      expect(() => const ExportOptions(quality: 100), returnsNormally);
    });

    test('copyWith should update individual properties', () {
      const original = ExportOptions();
      
      final withResolution = original.copyWith(resolution: ExportResolution.large);
      expect(withResolution.resolution, ExportResolution.large);
      expect(withResolution.format, ExportFormat.png);
      expect(withResolution.quality, 85);

      final withFormat = original.copyWith(format: ExportFormat.jpeg);
      expect(withFormat.resolution, ExportResolution.medium);
      expect(withFormat.format, ExportFormat.jpeg);
      expect(withFormat.quality, 85);

      final withQuality = original.copyWith(quality: 95);
      expect(withQuality.resolution, ExportResolution.medium);
      expect(withQuality.format, ExportFormat.png);
      expect(withQuality.quality, 95);
    });

    test('copyWith should update multiple properties', () {
      const original = ExportOptions();
      final updated = original.copyWith(
        resolution: ExportResolution.extraLarge,
        format: ExportFormat.jpeg,
        quality: 100,
      );
      
      expect(updated.resolution, ExportResolution.extraLarge);
      expect(updated.format, ExportFormat.jpeg);
      expect(updated.quality, 100);
    });

    test('copyWith should return new instance', () {
      const original = ExportOptions();
      final copied = original.copyWith();
      
      expect(identical(original, copied), isFalse);
      expect(original == copied, isTrue);
    });

    test('toJson should serialize correctly', () {
      const options = ExportOptions(
        resolution: ExportResolution.large,
        format: ExportFormat.jpeg,
        quality: 90,
      );
      
      final json = options.toJson();
      expect(json['resolution'], 'large');
      expect(json['format'], 'jpeg');
      expect(json['quality'], 90);
    });

    test('fromJson should deserialize correctly', () {
      final json = {
        'resolution': 'large',
        'format': 'jpeg',
        'quality': 90,
      };
      
      final options = ExportOptions.fromJson(json);
      expect(options.resolution, ExportResolution.large);
      expect(options.format, ExportFormat.jpeg);
      expect(options.quality, 90);
    });

    test('fromJson should handle missing quality field', () {
      final json = {
        'resolution': 'small',
        'format': 'png',
      };
      
      final options = ExportOptions.fromJson(json);
      expect(options.resolution, ExportResolution.small);
      expect(options.format, ExportFormat.png);
      expect(options.quality, 85); // Should default to 85
    });

    test('toString should include all properties', () {
      const options = ExportOptions(
        resolution: ExportResolution.large,
        format: ExportFormat.jpeg,
        quality: 90,
      );
      
      final str = options.toString();
      expect(str, contains('Large (2048×2048)')); // resolution displayName
      expect(str, contains('JPEG')); // format displayName
      expect(str, contains('90')); // quality value
    });

    test('equality operator should work correctly', () {
      const options1 = ExportOptions(
        resolution: ExportResolution.large,
        format: ExportFormat.jpeg,
        quality: 90,
      );
      const options2 = ExportOptions(
        resolution: ExportResolution.large,
        format: ExportFormat.jpeg,
        quality: 90,
      );
      const options3 = ExportOptions(
        resolution: ExportResolution.small,
        format: ExportFormat.png,
        quality: 85,
      );
      
      expect(options1 == options2, isTrue);
      expect(options1 == options3, isFalse);
      expect(options1 == options1, isTrue); // identical
    });

    test('hashCode should be consistent', () {
      const options1 = ExportOptions(
        resolution: ExportResolution.large,
        format: ExportFormat.jpeg,
        quality: 90,
      );
      const options2 = ExportOptions(
        resolution: ExportResolution.large,
        format: ExportFormat.jpeg,
        quality: 90,
      );
      
      expect(options1.hashCode, options2.hashCode);
      expect(options1.hashCode, options1.hashCode); // consistent
    });

    test('round-trip serialization should preserve data', () {
      const original = ExportOptions(
        resolution: ExportResolution.extraLarge,
        format: ExportFormat.jpeg,
        quality: 75,
      );
      
      final json = original.toJson();
      final deserialized = ExportOptions.fromJson(json);
      
      expect(deserialized, original);
    });
  });
}
