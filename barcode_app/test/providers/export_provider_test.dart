import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/providers/export_provider.dart';
import 'package:barcode_app/models/export_options.dart';
import 'package:barcode_app/core/utils/export_service.dart';

// Mock ExportService for testing
class MockExportService extends ExportService {
  bool shouldFail = false;
  String mockFilePath = '/mock/path/qr_code.png';

  @override
  Future<Uint8List> captureWidget(
    GlobalKey repaintBoundaryKey,
    ExportOptions options,
  ) async {
    if (shouldFail) {
      throw Exception('Mock capture failure');
    }
    // Simulate some processing time
    await Future.delayed(const Duration(milliseconds: 50));
    // Return mock image bytes
    return Uint8List.fromList([1, 2, 3, 4]);
  }

  @override
  Future<String?> saveImage(
    Uint8List imageBytes,
    String filename,
    ExportFormat format,
  ) async {
    if (shouldFail) {
      throw Exception('Mock save failure');
    }
    // Simulate some processing time
    await Future.delayed(const Duration(milliseconds: 50));
    return mockFilePath;
  }
}

void main() {
  group('ExportResult Tests', () {
    test('Success result has correct properties', () {
      const result = ExportResult.success('/path/to/file.png');
      
      expect(result.success, true);
      expect(result.filePath, '/path/to/file.png');
      expect(result.errorMessage, isNull);
      expect(result.toString(), contains('success'));
      expect(result.toString(), contains('/path/to/file.png'));
    });

    test('Error result has correct properties', () {
      const result = ExportResult.error('Something went wrong');
      
      expect(result.success, false);
      expect(result.filePath, isNull);
      expect(result.errorMessage, 'Something went wrong');
      expect(result.toString(), contains('error'));
      expect(result.toString(), contains('Something went wrong'));
    });
  });

  group('ExportProvider Tests', () {
    late ExportProvider provider;
    late MockExportService mockService;

    setUp(() {
      provider = ExportProvider();
      mockService = MockExportService();
    });

    test('Initial state is correct', () {
      expect(provider.options.resolution, ExportResolution.medium);
      expect(provider.options.format, ExportFormat.png);
      expect(provider.options.quality, 85);
      expect(provider.isExporting, false);
      expect(provider.progress, 0.0);
      expect(provider.statusMessage, '');
      expect(provider.exportResult, isNull);
      expect(provider.hasResult, false);
      expect(provider.lastExportSucceeded, false);
      expect(provider.lastExportFailed, false);
    });

    test('Can update resolution', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.updateResolution(ExportResolution.large);
      
      expect(provider.resolution, ExportResolution.large);
      expect(provider.options.resolution, ExportResolution.large);
      expect(notifyCount, 1);
    });

    test('Updating to same resolution does not notify', () {
      provider.updateResolution(ExportResolution.medium);
      
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.updateResolution(ExportResolution.medium);
      
      expect(notifyCount, 0);
    });

    test('Can update format', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.updateFormat(ExportFormat.jpeg);
      
      expect(provider.format, ExportFormat.jpeg);
      expect(provider.options.format, ExportFormat.jpeg);
      expect(notifyCount, 1);
    });

    test('Can update quality', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.updateQuality(95);
      
      expect(provider.quality, 95);
      expect(provider.options.quality, 95);
      expect(notifyCount, 1);
    });

    test('Quality must be between 0 and 100', () {
      expect(
        () => provider.updateQuality(-1),
        throwsAssertionError,
      );
      
      expect(
        () => provider.updateQuality(101),
        throwsAssertionError,
      );

      // Edge cases should work
      provider.updateQuality(0);
      expect(provider.quality, 0);
      
      provider.updateQuality(100);
      expect(provider.quality, 100);
    });

    test('Can update all options at once', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      const newOptions = ExportOptions(
        resolution: ExportResolution.extraLarge,
        format: ExportFormat.jpeg,
        quality: 90,
      );

      provider.updateOptions(newOptions);
      
      expect(provider.options, newOptions);
      expect(provider.resolution, ExportResolution.extraLarge);
      expect(provider.format, ExportFormat.jpeg);
      expect(provider.quality, 90);
      expect(notifyCount, 1);
    });

    test('Successful export updates state correctly', () async {
      // Create a minimal widget tree for the test
      final testKey = GlobalKey();
      
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      final result = await provider.exportQRCode(testKey, mockService);
      
      expect(result.success, true);
      expect(result.filePath, mockService.mockFilePath);
      expect(result.errorMessage, isNull);
      expect(provider.exportResult, isNotNull);
      expect(provider.hasResult, true);
      expect(provider.lastExportSucceeded, true);
      expect(provider.lastExportFailed, false);
      expect(provider.isExporting, false);
      expect(provider.progress, 1.0);
      expect(provider.statusMessage, 'Export complete!');
      expect(notifyCount, greaterThan(0));
    });

    test('Failed export updates state correctly', () async {
      mockService.shouldFail = true;
      final testKey = GlobalKey();
      
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      final result = await provider.exportQRCode(testKey, mockService);
      
      expect(result.success, false);
      expect(result.filePath, isNull);
      expect(result.errorMessage, isNotNull);
      expect(result.errorMessage, contains('Export failed'));
      expect(provider.exportResult, isNotNull);
      expect(provider.hasResult, true);
      expect(provider.lastExportSucceeded, false);
      expect(provider.lastExportFailed, true);
      expect(provider.isExporting, false);
      expect(notifyCount, greaterThan(0));
    });

    test('Export progress updates during operation', () async {
      final testKey = GlobalKey();
      final progressValues = <double>[];
      final statusMessages = <String>[];

      provider.addListener(() {
        progressValues.add(provider.progress);
        statusMessages.add(provider.statusMessage);
      });

      await provider.exportQRCode(testKey, mockService);
      
      // Should have multiple progress updates
      expect(progressValues, isNotEmpty);
      expect(statusMessages, isNotEmpty);
      
      // Should include various status messages
      expect(statusMessages.any((m) => m.contains('Preparing')), true);
      expect(statusMessages.any((m) => m.contains('Capturing')), true);
      expect(statusMessages.any((m) => m.contains('Converting')), true);
      expect(statusMessages.any((m) => m.contains('Saving')), true);
      expect(statusMessages.any((m) => m.contains('complete')), true);
      
      // Final progress should be 1.0 (100%)
      expect(provider.progress, 1.0);
    });

    test('Cannot start export while one is in progress', () async {
      final testKey = GlobalKey();
      
      // Start first export (don't await yet)
      final firstExport = provider.exportQRCode(testKey, mockService);
      
      // Try to start second export while first is running
      final secondResult = await provider.exportQRCode(testKey, mockService);
      
      expect(secondResult.success, false);
      expect(secondResult.errorMessage, contains('already in progress'));
      
      // Wait for first export to complete
      await firstExport;
    });

    test('Can clear export state', () async {
      final testKey = GlobalKey();
      
      // Perform an export to populate state
      await provider.exportQRCode(testKey, mockService);
      
      expect(provider.hasResult, true);
      expect(provider.progress, 1.0);
      expect(provider.statusMessage, isNotEmpty);
      
      // Clear the state
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);
      
      provider.clearExportState();
      
      expect(provider.hasResult, false);
      expect(provider.progress, 0.0);
      expect(provider.statusMessage, '');
      expect(provider.exportResult, isNull);
      // Options should remain unchanged
      expect(provider.options.resolution, ExportResolution.medium);
      expect(notifyCount, 1);
    });

    test('Cannot clear state while export is in progress', () async {
      final testKey = GlobalKey();
      
      // Start export (don't await)
      final exportFuture = provider.exportQRCode(testKey, mockService);
      
      // Try to clear while exporting
      provider.clearExportState();
      
      // State should not be cleared
      expect(provider.isExporting, true);
      
      // Wait for export to complete
      await exportFuture;
    });

    test('Can reset to defaults', () {
      // Change all settings
      provider.updateResolution(ExportResolution.extraLarge);
      provider.updateFormat(ExportFormat.jpeg);
      provider.updateQuality(95);
      
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);
      
      provider.resetToDefaults();
      
      expect(provider.resolution, ExportResolution.medium);
      expect(provider.format, ExportFormat.png);
      expect(provider.quality, 85);
      expect(provider.progress, 0.0);
      expect(provider.statusMessage, '');
      expect(provider.exportResult, isNull);
      expect(notifyCount, 1);
    });

    test('Cannot reset to defaults while export is in progress', () async {
      final testKey = GlobalKey();
      
      // Change settings
      provider.updateResolution(ExportResolution.large);
      
      // Start export (don't await)
      final exportFuture = provider.exportQRCode(testKey, mockService);
      
      // Try to reset while exporting
      provider.resetToDefaults();
      
      // Settings should not be reset
      expect(provider.isExporting, true);
      expect(provider.resolution, ExportResolution.large);
      
      // Wait for export to complete
      await exportFuture;
    });

    test('Convenience getters work correctly', () {
      // Initial state
      expect(provider.resolution, provider.options.resolution);
      expect(provider.format, provider.options.format);
      expect(provider.quality, provider.options.quality);
      
      // After changes
      provider.updateResolution(ExportResolution.small);
      provider.updateFormat(ExportFormat.jpeg);
      provider.updateQuality(70);
      
      expect(provider.resolution, ExportResolution.small);
      expect(provider.format, ExportFormat.jpeg);
      expect(provider.quality, 70);
    });

    test('Export uses current options', () async {
      final testKey = GlobalKey();
      
      // Set specific options
      provider.updateResolution(ExportResolution.large);
      provider.updateFormat(ExportFormat.jpeg);
      provider.updateQuality(90);
      
      await provider.exportQRCode(testKey, mockService);
      
      // Options should remain the same after export
      expect(provider.resolution, ExportResolution.large);
      expect(provider.format, ExportFormat.jpeg);
      expect(provider.quality, 90);
    });
  });
}
