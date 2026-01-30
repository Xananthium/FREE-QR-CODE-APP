import '../../models/wifi_config.dart';

/// Utility class for formatting WiFi configurations into QR code strings.
///
/// This class provides static methods to convert [WifiConfig] objects into
/// the standard WiFi QR code format (MECARD format).
///
/// Format: `WIFI:T:type;S:ssid;P:password;H:hidden;;`
///
/// Example:
/// ```dart
/// final config = WifiConfig(
///   ssid: 'MyNetwork',
///   password: 'password123',
///   securityType: SecurityType.wpa2,
///   isHidden: false,
/// );
/// final qrString = WifiFormatter.formatToQRString(config);
/// // Result: WIFI:T:WPA2;S:MyNetwork;P:password123;H:false;;
/// ```
class WifiFormatter {
  // Private constructor to prevent instantiation
  WifiFormatter._();

  /// Formats a [WifiConfig] object into a WiFi QR code string.
  ///
  /// The output follows the WiFi QR code standard format:
  /// `WIFI:T:type;S:ssid;P:password;H:hidden;;`
  ///
  /// Special characters in SSID and password are automatically escaped
  /// according to the QR code specification.
  ///
  /// Parameters:
  ///   - [config]: The WiFi configuration to format
  ///
  /// Returns:
  ///   A properly formatted WiFi QR code string
  ///
  /// Example:
  /// ```dart
  /// final config = WifiConfig(
  ///   ssid: 'Coffee:Shop',
  ///   password: 'pass;word',
  ///   securityType: SecurityType.wpa2,
  ///   isHidden: true,
  /// );
  /// final qrString = WifiFormatter.formatToQRString(config);
  /// // Result: WIFI:T:WPA2;S:Coffee\:Shop;P:pass\;word;H:true;;
  /// ```
  static String formatToQRString(WifiConfig config) {
    final type = _formatSecurityType(config.securityType);
    final ssid = escapeSpecialChars(config.ssid);
    final password = config.password != null 
        ? escapeSpecialChars(config.password!) 
        : '';
    final hidden = config.isHidden.toString();

    return 'WIFI:T:$type;S:$ssid;P:$password;H:$hidden;;';
  }

  /// Escapes special characters in a string for WiFi QR code format.
  ///
  /// The following characters are escaped:
  /// - Backslash (\) → \\
  /// - Semicolon (;) → \;
  /// - Comma (,) → \,
  /// - Colon (:) → \:
  /// - Double quote (") → \"
  ///
  /// Parameters:
  ///   - [input]: The string to escape
  ///
  /// Returns:
  ///   The escaped string safe for use in WiFi QR codes
  ///
  /// Example:
  /// ```dart
  /// final escaped = WifiFormatter.escapeSpecialChars('test;pass:word');
  /// // Result: 'test\;pass\:word'
  /// ```
  static String escapeSpecialChars(String input) {
    return input
        .replaceAll('\\', '\\\\')  // Must be first to avoid double-escaping
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll(':', '\\:')
        .replaceAll('"', '\\"');
  }

  /// Unescapes special characters from a WiFi QR code format string.
  ///
  /// This is the reverse operation of [escapeSpecialChars].
  ///
  /// Parameters:
  ///   - [input]: The escaped string
  ///
  /// Returns:
  ///   The unescaped original string
  ///
  /// Example:
  /// ```dart
  /// final unescaped = WifiFormatter.unescapeSpecialChars('test\;pass\\:word');
  /// // Result: 'test;pass:word'
  /// ```
  static String unescapeSpecialChars(String input) {
    return input
        .replaceAll('\\:', ':')
        .replaceAll('\\,', ',')
        .replaceAll(r'\;', ';')
        .replaceAll('\\"', '"')
        .replaceAll('\\\\', '\\');  // Must be last to avoid double-unescaping
  }

  /// Converts a [SecurityType] enum to its QR code string representation.
  ///
  /// Mapping:
  /// - [SecurityType.wpa] → "WPA"
  /// - [SecurityType.wpa2] → "WPA2"
  /// - [SecurityType.wpa3] → "WPA3"
  /// - [SecurityType.wep] → "WEP"
  /// - [SecurityType.none] → "nopass"
  ///
  /// Parameters:
  ///   - [type]: The security type to format
  ///
  /// Returns:
  ///   The QR code string representation of the security type
  static String _formatSecurityType(SecurityType type) {
    switch (type) {
      case SecurityType.wpa:
        return 'WPA';
      case SecurityType.wpa2:
        return 'WPA2';
      case SecurityType.wpa3:
        return 'WPA3';
      case SecurityType.wep:
        return 'WEP';
      case SecurityType.none:
        return 'nopass';
    }
  }

  /// Parses a WiFi QR code string and returns a [WifiConfig] object.
  ///
  /// Expected format: `WIFI:T:type;S:ssid;P:password;H:hidden;;`
  ///
  /// Parameters:
  ///   - [qrString]: The WiFi QR code string to parse
  ///
  /// Returns:
  ///   A [WifiConfig] object if parsing succeeds, null otherwise
  ///
  /// Example:
  /// ```dart
  /// final config = WifiFormatter.parseFromQRString(
  ///   'WIFI:T:WPA2;S:MyNetwork;P:password123;H:false;;'
  /// );
  /// ```
  static WifiConfig? parseFromQRString(String qrString) {
    if (!qrString.startsWith('WIFI:')) {
      return null;
    }

    final params = <String, String>{};
    
    // Remove WIFI: prefix and split by unescaped semicolons
    final content = qrString.substring(5);
    final parts = _splitByUnescapedSemicolon(content);
    
    for (final part in parts) {
      if (part.isEmpty) continue;
      final colonIndex = part.indexOf(':');
      if (colonIndex == -1) continue;
      
      final key = part.substring(0, colonIndex);
      final value = part.substring(colonIndex + 1);
      params[key] = unescapeSpecialChars(value);
    }

    final ssid = params['S'];
    if (ssid == null || ssid.isEmpty) {
      return null;
    }

    return WifiConfig(
      ssid: ssid,
      password: params['P']?.isEmpty == true ? null : params['P'],
      securityType: _parseSecurityType(params['T'] ?? 'nopass'),
      isHidden: params['H']?.toLowerCase() == 'true',
    );
  }

  /// Splits a string by semicolons, but only on unescaped semicolons.
  ///
  /// Escaped semicolons (\;) are preserved in the parts.
  static List<String> _splitByUnescapedSemicolon(String input) {
    final parts = <String>[];
    final buffer = StringBuffer();
    var i = 0;
    
    while (i < input.length) {
      if (input[i] == '\\' && i + 1 < input.length) {
        // Escaped character - add both the backslash and next char
        buffer.write(input[i]);
        buffer.write(input[i + 1]);
        i += 2;
      } else if (input[i] == ';') {
        // Unescaped semicolon - this is a separator
        parts.add(buffer.toString());
        buffer.clear();
        i++;
      } else {
        // Regular character
        buffer.write(input[i]);
        i++;
      }
    }
    
    // Add remaining buffer content
    if (buffer.isNotEmpty) {
      parts.add(buffer.toString());
    }
    
    return parts;
  }

  /// Parses a security type string from a QR code.
  ///
  /// Parameters:
  ///   - [qrString]: The security type string from the QR code
  ///
  /// Returns:
  ///   The corresponding [SecurityType] enum value, defaults to WPA2 if unknown
  static SecurityType _parseSecurityType(String qrString) {
    final normalized = qrString.toUpperCase();
    switch (normalized) {
      case 'WPA':
        return SecurityType.wpa;
      case 'WPA2':
        return SecurityType.wpa2;
      case 'WPA3':
        return SecurityType.wpa3;
      case 'WEP':
        return SecurityType.wep;
      case 'NOPASS':
      case '':
        return SecurityType.none;
      default:
        return SecurityType.wpa2; // Default to most common
    }
  }
}
