import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/providers/qr_provider.dart';
import 'package:barcode_app/models/qr_type.dart';
import 'package:barcode_app/models/qr_data.dart';
import 'package:barcode_app/models/border_style.dart' as qr_models;

void main() {
  group('QRProvider Tests', () {
    late QRProvider provider;

    setUp(() {
      provider = QRProvider();
    });

    test('Initial state is correct', () {
      expect(provider.currentType, QRType.url);
      expect(provider.currentQRData, isNull);
      expect(provider.borderStyle.type, qr_models.BorderType.none);
      expect(provider.qrColor, Colors.black);
      expect(provider.backgroundColor, Colors.white);
      expect(provider.qrSize, 280.0);
      expect(provider.hasQRData, false);
      expect(provider.hasBorder, false);
    });

    test('Can update QR type', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.updateQRType(QRType.wifi);
      
      expect(provider.currentType, QRType.wifi);
      expect(provider.currentQRData, isNull); // Should clear data
      expect(notifyCount, 1);
    });

    test('Can generate QR from simple string', () async {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      await provider.generateQRCode('https://example.com', label: 'Test QR');
      
      expect(provider.hasQRData, true);
      expect(provider.currentContent, 'https://example.com');
      expect(provider.currentQRData?.label, 'Test QR');
      expect(provider.currentQRData?.type, QRType.url);
      expect(notifyCount, greaterThan(0));
    });

    test('Can generate QR from QRData object', () async {
      final data = QRData(
        type: QRType.wifi,
        content: 'WIFI:T:WPA;S:MyNetwork;P:password123;;',
        label: 'Home WiFi',
        timestamp: DateTime.now(),
        metadata: {'ssid': 'MyNetwork', 'password': 'password123'},
      );

      await provider.generateQRFromData(data);
      
      expect(provider.hasQRData, true);
      expect(provider.currentType, QRType.wifi);
      expect(provider.currentQRData?.metadata?['ssid'], 'MyNetwork');
    });

    test('Can update QR content', () async {
      await provider.generateQRCode('initial content');
      
      provider.updateQRContent('updated content');
      
      expect(provider.currentContent, 'updated content');
    });

    test('Can select border type', () async {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      await provider.selectBorderType(qr_models.BorderType.circle);
      
      expect(provider.hasBorder, true);
      expect(provider.borderStyle.type, qr_models.BorderType.circle);
      expect(notifyCount, greaterThan(0));
    });

    test('Can remove border', () async {
      await provider.selectBorderType(qr_models.BorderType.solid);
      expect(provider.hasBorder, true);

      await provider.removeBorder();
      
      expect(provider.hasBorder, false);
      expect(provider.borderStyle.type, qr_models.BorderType.none);
    });

    test('Can update colors', () async {
      await provider.updateQRColor(Colors.blue);
      expect(provider.qrColor, Colors.blue);

      await provider.updateBackgroundColor(Colors.yellow);
      expect(provider.backgroundColor, Colors.yellow);
    });

    test('Can update size', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.updateQRSize(350.0);
      
      expect(provider.qrSize, 350.0);
      expect(notifyCount, 1);
    });

    test('Can reset to defaults', () async {
      // Set some non-default values
      provider.updateQRType(QRType.wifi);
      await provider.generateQRCode('test content');
      await provider.selectBorderType(qr_models.BorderType.circle);
      await provider.updateQRColor(Colors.red);
      provider.updateQRSize(500.0);

      // Reset
      provider.resetToDefaults();
      
      expect(provider.currentType, QRType.url);
      expect(provider.currentQRData, isNull);
      expect(provider.borderStyle.type, qr_models.BorderType.none);
      expect(provider.qrColor, Colors.black);
      expect(provider.backgroundColor, Colors.white);
      expect(provider.qrSize, 280.0);
    });

    test('Can create and restore snapshot', () async {
      // Set up some state with a simple color
      const testColor = Color(0xFF00FF00); // Green
      await provider.generateQRCode('snapshot test');
      await provider.selectBorderType(qr_models.BorderType.mediumRounded);
      await provider.updateQRColor(testColor);

      // Create snapshot
      final snapshot = provider.createSnapshot();

      // Change state
      provider.resetToDefaults();
      expect(provider.currentContent, '');

      // Restore snapshot
      provider.restoreFromSnapshot(snapshot);
      
      expect(provider.currentContent, 'snapshot test');
      expect(provider.borderStyle.type, qr_models.BorderType.mediumRounded);
      expect(provider.qrColor.value, testColor.value);
    });

    test('Loading states work correctly', () async {
      expect(provider.isGenerating, false);
      expect(provider.isAnyLoading, false);

      final future = provider.generateQRCode('test');
      expect(provider.isGenerating, true);
      expect(provider.isAnyLoading, true);

      await future;
      expect(provider.isGenerating, false);
      expect(provider.isAnyLoading, false);
    });

    test('Prevents duplicate generation calls', () async {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      // Start first generation
      final future1 = provider.generateQRCode('first');
      // Try to start second (should be ignored)
      final future2 = provider.generateQRCode('second');

      await Future.wait([future1, future2]);
      
      // Should have generated only the first one
      expect(provider.currentContent, 'first');
    });
  });
}
