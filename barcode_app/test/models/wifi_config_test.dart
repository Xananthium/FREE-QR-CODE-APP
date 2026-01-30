import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/models/wifi_config.dart';

void main() {
  group('SecurityType', () {
    test('has all required values', () {
      expect(SecurityType.values.length, 5);
      expect(SecurityType.values, contains(SecurityType.wpa));
      expect(SecurityType.values, contains(SecurityType.wpa2));
      expect(SecurityType.values, contains(SecurityType.wpa3));
      expect(SecurityType.values, contains(SecurityType.wep));
      expect(SecurityType.values, contains(SecurityType.none));
    });

    test('toJson and fromJson work correctly', () {
      expect(SecurityType.wpa.toJson(), 'wpa');
      expect(SecurityType.fromJson('wpa2'), SecurityType.wpa2);
    });

    test('requiresPassword works correctly', () {
      expect(SecurityType.wpa.requiresPassword, true);
      expect(SecurityType.wpa2.requiresPassword, true);
      expect(SecurityType.wpa3.requiresPassword, true);
      expect(SecurityType.wep.requiresPassword, true);
      expect(SecurityType.none.requiresPassword, false);
    });
  });

  group('WifiConfig', () {
    test('creates valid WPA2 config', () {
      final config = WifiConfig(
        ssid: 'MyNetwork',
        password: 'password123',
        securityType: SecurityType.wpa2,
      );
      
      expect(config.ssid, 'MyNetwork');
      expect(config.password, 'password123');
      expect(config.securityType, SecurityType.wpa2);
      expect(config.isHidden, false);
      expect(config.isValid(), true);
    });

    test('creates valid open network config', () {
      final config = WifiConfig(
        ssid: 'OpenNetwork',
        securityType: SecurityType.none,
      );
      
      expect(config.password, null);
      expect(config.isValid(), true);
    });

    test('copyWith works correctly', () {
      final config = WifiConfig(
        ssid: 'Network1',
        password: 'pass123',
        securityType: SecurityType.wpa2,
      );
      
      final updated = config.copyWith(ssid: 'Network2');
      expect(updated.ssid, 'Network2');
      expect(updated.password, 'pass123');
    });

    test('validates empty SSID', () {
      final config = WifiConfig(
        ssid: '',
        password: 'password123',
        securityType: SecurityType.wpa2,
      );
      
      expect(config.isValid(), false);
      expect(config.validationError, contains('SSID cannot be empty'));
    });

    test('validates SSID length', () {
      final config = WifiConfig(
        ssid: 'a' * 33,
        password: 'password123',
        securityType: SecurityType.wpa2,
      );
      
      expect(config.isValid(), false);
      expect(config.validationError, contains('cannot exceed 32'));
    });

    test('validates password required for WPA', () {
      final config = WifiConfig(
        ssid: 'Network',
        securityType: SecurityType.wpa2,
      );
      
      expect(config.isValid(), false);
      expect(config.validationError, contains('Password is required'));
    });

    test('validates WPA password length', () {
      final config = WifiConfig(
        ssid: 'Network',
        password: 'short',
        securityType: SecurityType.wpa2,
      );
      
      expect(config.isValid(), false);
      expect(config.validationError, contains('at least 8 characters'));
    });

    test('toJson and fromJson work correctly', () {
      final config = WifiConfig(
        ssid: 'TestNetwork',
        password: 'testpass123',
        securityType: SecurityType.wpa2,
        isHidden: true,
      );
      
      final json = config.toJson();
      final restored = WifiConfig.fromJson(json);
      
      expect(restored, config);
    });

    test('toQRString formats correctly', () {
      final config = WifiConfig(
        ssid: 'MyNetwork',
        password: 'password123',
        securityType: SecurityType.wpa2,
        isHidden: false,
      );
      
      final qrString = config.toQRString();
      expect(qrString, 'WIFI:T:WPA2;S:MyNetwork;P:password123;H:false;;');
    });

    test('fromQRString parses correctly', () {
      const qrString = 'WIFI:T:WPA2;S:MyNetwork;P:password123;H:false;;';
      final config = WifiConfig.fromQRString(qrString);
      
      expect(config, isNotNull);
      expect(config!.ssid, 'MyNetwork');
      expect(config.password, 'password123');
      expect(config.securityType, SecurityType.wpa2);
      expect(config.isHidden, false);
    });

    test('equality works correctly', () {
      final config1 = WifiConfig(
        ssid: 'Network',
        password: 'pass123',
        securityType: SecurityType.wpa2,
      );
      
      final config2 = WifiConfig(
        ssid: 'Network',
        password: 'pass123',
        securityType: SecurityType.wpa2,
      );
      
      expect(config1, config2);
      expect(config1.hashCode, config2.hashCode);
    });
  });
}
