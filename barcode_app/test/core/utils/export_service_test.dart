import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/core/utils/export_service.dart';
import 'package:barcode_app/models/export_options.dart';

void main() {
  group('ExportService.generateFilename', () {
    late ExportService exportService;

    setUp(() {
      exportService = ExportService();
    });

    test('generates filename with correct PNG extension', () {
      final filename = exportService.generateFilename(ExportFormat.png);
      expect(filename, endsWith('.png'));
      expect(filename, startsWith('qr_code_'));
    });

    test('generates filename with correct JPEG extension', () {
      final filename = exportService.generateFilename(ExportFormat.jpeg);
      expect(filename, endsWith('.jpg'));
      expect(filename, startsWith('qr_code_'));
    });

    test('includes timestamp in filename - PNG format', () {
      final filename = exportService.generateFilename(ExportFormat.png);
      // Format: qr_code_YYYYMMDD_HHMMSS.png
      final pattern = RegExp(r'^qr_code_\d{8}_\d{6}\.png$');
      expect(filename, matches(pattern));
    });

    test('includes timestamp in filename - JPEG format', () {
      final filename = exportService.generateFilename(ExportFormat.jpeg);
      // Format: qr_code_YYYYMMDD_HHMMSS.jpg
      final pattern = RegExp(r'^qr_code_\d{8}_\d{6}\.jpg$');
      expect(filename, matches(pattern));
    });

    test('generates unique filenames when called multiple times', () async {
      final filename1 = exportService.generateFilename(ExportFormat.png);
      
      // Wait a small amount to ensure timestamp differs
      await Future.delayed(const Duration(milliseconds: 1100));
      
      final filename2 = exportService.generateFilename(ExportFormat.png);
      
      expect(filename1, isNot(equals(filename2)));
    });

    test('timestamp format is parseable - PNG', () {
      final filename = exportService.generateFilename(ExportFormat.png);
      // Extract timestamp: qr_code_YYYYMMDD_HHMMSS.png -> YYYYMMDD_HHMMSS
      final timestampPart = filename
          .replaceFirst('qr_code_', '')
          .replaceFirst('.png', '');
      
      final parts = timestampPart.split('_');
      expect(parts.length, equals(2));
      
      final datePart = parts[0]; // YYYYMMDD
      final timePart = parts[1]; // HHMMSS
      
      expect(datePart.length, equals(8));
      expect(timePart.length, equals(6));
      expect(int.tryParse(datePart), isNotNull);
      expect(int.tryParse(timePart), isNotNull);
    });

    test('timestamp format is parseable - JPEG', () {
      final filename = exportService.generateFilename(ExportFormat.jpeg);
      // Extract timestamp: qr_code_YYYYMMDD_HHMMSS.jpg -> YYYYMMDD_HHMMSS
      final timestampPart = filename
          .replaceFirst('qr_code_', '')
          .replaceFirst('.jpg', '');
      
      final parts = timestampPart.split('_');
      expect(parts.length, equals(2));
      
      final datePart = parts[0]; // YYYYMMDD
      final timePart = parts[1]; // HHMMSS
      
      expect(datePart.length, equals(8));
      expect(timePart.length, equals(6));
      expect(int.tryParse(datePart), isNotNull);
      expect(int.tryParse(timePart), isNotNull);
    });

    test('current timestamp is reflected in filename', () {
      final now = DateTime.now();
      final filename = exportService.generateFilename(ExportFormat.png);
      
      // Extract year from filename
      final timestampPart = filename
          .replaceFirst('qr_code_', '')
          .replaceFirst('.png', '');
      final datePart = timestampPart.split('_')[0];
      final year = datePart.substring(0, 4);
      
      expect(year, equals(now.year.toString()));
    });
  });

  group('ExportOptions Integration', () {
    test('ExportOptions has correct default values', () {
      const options = ExportOptions();
      expect(options.resolution, equals(ExportResolution.medium));
      expect(options.format, equals(ExportFormat.png));
      expect(options.quality, equals(85));
    });

    test('ExportOptions resolution returns correct pixel sizes', () {
      expect(ExportResolution.small.pixelSize, equals(512));
      expect(ExportResolution.medium.pixelSize, equals(1024));
      expect(ExportResolution.large.pixelSize, equals(2048));
      expect(ExportResolution.extraLarge.pixelSize, equals(4096));
    });

    test('ExportFormat returns correct file extensions', () {
      expect(ExportFormat.png.fileExtension, equals('png'));
      expect(ExportFormat.jpeg.fileExtension, equals('jpg'));
    });

    test('ExportOptions quality must be between 0 and 100', () {
      expect(
        () => ExportOptions(quality: 101),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => ExportOptions(quality: -1),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => ExportOptions(quality: 0),
        returnsNormally,
      );
      expect(
        () => ExportOptions(quality: 100),
        returnsNormally,
      );
    });

    test('ExportOptions can be created with all resolutions', () {
      expect(
        () => ExportOptions(resolution: ExportResolution.small),
        returnsNormally,
      );
      expect(
        () => ExportOptions(resolution: ExportResolution.medium),
        returnsNormally,
      );
      expect(
        () => ExportOptions(resolution: ExportResolution.large),
        returnsNormally,
      );
      expect(
        () => ExportOptions(resolution: ExportResolution.extraLarge),
        returnsNormally,
      );
    });

    test('ExportOptions can be created with both formats', () {
      const pngOptions = ExportOptions(format: ExportFormat.png);
      const jpegOptions = ExportOptions(format: ExportFormat.jpeg);
      
      expect(pngOptions.format, equals(ExportFormat.png));
      expect(jpegOptions.format, equals(ExportFormat.jpeg));
    });
  });

  // NOTE: The following tests require widget testing environment and are
  // documented here for future integration/widget test implementation:
  //
  // group('ExportService.captureWidget - REQUIRES WIDGET TEST', () {
  //   // These tests need testWidgets() instead of test()
  //   // Requires RepaintBoundary, BuildContext, and render tree
  //   
  //   // TODO: Implement in integration tests:
  //   // - Test successful widget capture with valid RepaintBoundary
  //   // - Test error when key is not attached to widget (null context)
  //   // - Test error when key is not attached to RepaintBoundary
  //   // - Test PNG output format
  //   // - Test JPEG conversion with various quality settings
  //   // - Test different resolutions produce different sized outputs
  //   // - Test pixel ratio calculations for various widget sizes
  // });
  //
  // group('ExportService.saveImage - REQUIRES PLATFORM TESTING', () {
  //   // These tests need platform-specific mocking (mobile vs web)
  //   // 
  //   // TODO: Implement in integration tests:
  //   // - Test file saving on mobile platforms
  //   // - Test download trigger on web platform
  //   // - Test error handling for file system failures
  // });
}
