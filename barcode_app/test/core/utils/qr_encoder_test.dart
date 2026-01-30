import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/core/utils/qr_encoder.dart';

void main() {
  group('QREncoder.encodeUrl', () {
    test('validates URL format - accepts valid domain', () {
      expect(() => QREncoder.encodeUrl('google.com'), returnsNormally);
      expect(() => QREncoder.encodeUrl('example.com'), returnsNormally);
    });

    test('validates URL format - throws on empty string', () {
      expect(
        () => QREncoder.encodeUrl(''),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('cannot be empty'),
        )),
      );
    });

    test('validates URL format - throws on whitespace only', () {
      expect(
        () => QREncoder.encodeUrl('   '),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('cannot be empty'),
        )),
      );
    });

    test('auto-adds https:// if missing protocol', () {
      final result = QREncoder.encodeUrl('google.com');
      expect(result, startsWith('https://'));
      expect(result, equals('https://google.com'));
    });

    test('auto-adds https:// to domain with path', () {
      final result = QREncoder.encodeUrl('example.com/path');
      expect(result, startsWith('https://'));
      expect(result, equals('https://example.com/path'));
    });

    test('preserves existing http:// protocol', () {
      final result = QREncoder.encodeUrl('http://example.com');
      expect(result, startsWith('http://'));
      expect(result, equals('http://example.com'));
    });

    test('preserves existing https:// protocol', () {
      final result = QREncoder.encodeUrl('https://secure.example.com');
      expect(result, startsWith('https://'));
      expect(result, equals('https://secure.example.com'));
    });

    test('handles special characters in path - spaces', () {
      final result = QREncoder.encodeUrl('example.com/path with spaces');
      expect(result, contains('%20'));
      expect(result, equals('https://example.com/path%20with%20spaces'));
    });

    test('handles special characters in query string', () {
      final result = QREncoder.encodeUrl('example.com?name=John Doe');
      expect(result, contains('%20'));
      expect(result, contains('https://example.com'));
    });

    test('handles complex URL with multiple special characters', () {
      final result = QREncoder.encodeUrl('example.com/search?q=hello world&lang=en');
      expect(result, startsWith('https://'));
      expect(result, contains('example.com'));
    });

    test('returns encoded string suitable for QR code', () {
      final result = QREncoder.encodeUrl('google.com');
      expect(result, isA<String>());
      expect(result.isNotEmpty, isTrue);
    });

    test('handles URL with port', () {
      final result = QREncoder.encodeUrl('localhost:8080');
      expect(result, equals('https://localhost:8080'));
    });

    test('handles URL with fragment', () {
      final result = QREncoder.encodeUrl('example.com#section');
      expect(result, equals('https://example.com#section'));
    });

    test('trims whitespace before processing', () {
      final result = QREncoder.encodeUrl('  example.com  ');
      expect(result, equals('https://example.com'));
    });


    test('throws on invalid URL format', () {
      expect(
        () => QREncoder.encodeUrl('http://'),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('valid host'),
        )),
      );
    });
  });

  group('QREncoder.encodeWifi', () {
    test('creates valid WiFi QR code format', () {
      final result = QREncoder.encodeWifi(
        ssid: 'TestNetwork',
        password: 'TestPassword',
      );
      expect(result, startsWith('WIFI:'));
      expect(result, contains('T:WPA'));
      expect(result, contains('S:TestNetwork'));
      expect(result, contains('P:TestPassword'));
      expect(result, endsWith(';;'));
    });

    test('handles WiFi without password', () {
      final result = QREncoder.encodeWifi(ssid: 'OpenNetwork');
      expect(result, contains('S:OpenNetwork'));
      expect(result, isNot(contains('P:')));
    });
  });

  group('QREncoder.encodeText', () {
    test('validates text is not empty', () {
      expect(
        () => QREncoder.encodeText(''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('returns input text for valid input', () {
      final result = QREncoder.encodeText('Hello, World!');
      expect(result, equals('Hello, World!'));
    });
  });

  group('QREncoder.encodeEmail', () {
    test('creates mailto URI', () {
      final result = QREncoder.encodeEmail(email: 'test@example.com');
      expect(result, equals('mailto:test@example.com'));
    });

    test('handles email with subject and body', () {
      final result = QREncoder.encodeEmail(
        email: 'test@example.com',
        subject: 'Hello',
        body: 'Test message',
      );
      expect(result, contains('mailto:test@example.com'));
      expect(result, contains('subject='));
      expect(result, contains('body='));
    });
  });

  group('QREncoder.encodePhone', () {
    test('creates tel URI', () {
      final result = QREncoder.encodePhone('+1-234-567-8900');
      expect(result, equals('tel:+1-234-567-8900'));
    });

    test('throws on empty phone number', () {
      expect(
        () => QREncoder.encodePhone(''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('QREncoder.encodeSms', () {
    test('creates sms URI', () {
      final result = QREncoder.encodeSms(phoneNumber: '+1234567890');
      expect(result, equals('sms:+1234567890'));
    });

    test('handles SMS with message', () {
      final result = QREncoder.encodeSms(
        phoneNumber: '+1234567890',
        message: 'Hello!',
      );
      expect(result, contains('sms:+1234567890'));
      expect(result, contains('body='));
    });
  });
}
