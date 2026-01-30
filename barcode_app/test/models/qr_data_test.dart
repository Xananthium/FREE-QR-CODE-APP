import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/models/qr_type.dart';
import 'package:barcode_app/models/qr_data.dart';

void main() {
  group('QRType Tests', () {
    test('QRType enum has url and wifi values', () {
      expect(QRType.values.length, 2);
      expect(QRType.values.contains(QRType.url), true);
      expect(QRType.values.contains(QRType.wifi), true);
    });

    test('QRType toJson returns correct string', () {
      expect(QRType.url.toJson(), 'url');
      expect(QRType.wifi.toJson(), 'wifi');
    });

    test('QRType fromJson creates correct enum', () {
      expect(QRType.fromJson('url'), QRType.url);
      expect(QRType.fromJson('wifi'), QRType.wifi);
      // Test fallback for unknown type
      expect(QRType.fromJson('unknown'), QRType.url);
    });

    test('QRType displayName returns correct string', () {
      expect(QRType.url.displayName, 'URL');
      expect(QRType.wifi.displayName, 'WiFi');
    });
  });

  group('QRData Tests', () {
    final testTimestamp = DateTime(2026, 1, 29, 12, 0, 0);
    
    test('QRData can be created with required fields', () {
      final qrData = QRData(
        type: QRType.url,
        content: 'https://example.com',
        timestamp: testTimestamp,
      );

      expect(qrData.type, QRType.url);
      expect(qrData.content, 'https://example.com');
      expect(qrData.timestamp, testTimestamp);
      expect(qrData.label, null);
      expect(qrData.metadata, null);
    });

    test('QRData copyWith creates proper copy with changes', () {
      final original = QRData(
        type: QRType.url,
        content: 'https://example.com',
        label: 'Example',
        timestamp: testTimestamp,
      );

      final copied = original.copyWith(
        content: 'https://newurl.com',
        label: 'New Example',
      );

      expect(copied.type, QRType.url); // unchanged
      expect(copied.content, 'https://newurl.com'); // changed
      expect(copied.label, 'New Example'); // changed
      expect(copied.timestamp, testTimestamp); // unchanged
    });

    test('QRData toJson serializes correctly', () {
      final qrData = QRData(
        type: QRType.wifi,
        content: 'WIFI:S:MyNetwork;T:WPA;P:password123;;',
        label: 'Home WiFi',
        timestamp: testTimestamp,
        metadata: {'ssid': 'MyNetwork', 'password': 'password123'},
      );

      final json = qrData.toJson();

      expect(json['type'], 'wifi');
      expect(json['content'], 'WIFI:S:MyNetwork;T:WPA;P:password123;;');
      expect(json['label'], 'Home WiFi');
      expect(json['timestamp'], testTimestamp.toIso8601String());
      expect(json['metadata'], {'ssid': 'MyNetwork', 'password': 'password123'});
    });

    test('QRData fromJson deserializes correctly', () {
      final json = {
        'type': 'url',
        'content': 'https://example.com',
        'label': 'Example Site',
        'timestamp': testTimestamp.toIso8601String(),
        'metadata': {'domain': 'example.com'},
      };

      final qrData = QRData.fromJson(json);

      expect(qrData.type, QRType.url);
      expect(qrData.content, 'https://example.com');
      expect(qrData.label, 'Example Site');
      expect(qrData.timestamp, testTimestamp);
      expect(qrData.metadata, {'domain': 'example.com'});
    });

    test('QRData roundtrip serialization works', () {
      final original = QRData(
        type: QRType.wifi,
        content: 'WIFI:S:TestNet;T:WPA;P:test123;;',
        label: 'Test WiFi',
        timestamp: testTimestamp,
        metadata: {'ssid': 'TestNet'},
      );

      final json = original.toJson();
      final deserialized = QRData.fromJson(json);

      expect(deserialized.type, original.type);
      expect(deserialized.content, original.content);
      expect(deserialized.label, original.label);
      expect(deserialized.timestamp, original.timestamp);
      expect(deserialized.metadata, original.metadata);
    });

    test('QRData equality works correctly', () {
      final qrData1 = QRData(
        type: QRType.url,
        content: 'https://example.com',
        timestamp: testTimestamp,
      );

      final qrData2 = QRData(
        type: QRType.url,
        content: 'https://example.com',
        timestamp: testTimestamp,
      );

      final qrData3 = QRData(
        type: QRType.url,
        content: 'https://different.com',
        timestamp: testTimestamp,
      );

      expect(qrData1 == qrData2, true);
      expect(qrData1 == qrData3, false);
      expect(qrData1.hashCode == qrData2.hashCode, true);
    });

    test('QRData toString provides useful output', () {
      final qrData = QRData(
        type: QRType.url,
        content: 'https://example.com',
        label: 'Test',
        timestamp: testTimestamp,
      );

      final str = qrData.toString();
      expect(str.contains('QRData'), true);
      expect(str.contains('url'), true);
      expect(str.contains('https://example.com'), true);
    });
  });
}
