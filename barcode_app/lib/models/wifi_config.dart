import 'package:flutter/foundation.dart';

/// Enum representing WiFi security types
enum SecurityType {
  /// WPA security
  wpa,
  
  /// WPA2 security
  wpa2,
  
  /// WPA3 security (latest standard)
  wpa3,
  
  /// WEP security (legacy, not recommended)
  wep,
  
  /// No security (open network)
  none;

  /// Returns a human-readable display name for the security type
  String get displayName {
    switch (this) {
      case SecurityType.wpa:
        return 'WPA';
      case SecurityType.wpa2:
        return 'WPA2';
      case SecurityType.wpa3:
        return 'WPA3';
      case SecurityType.wep:
        return 'WEP';
      case SecurityType.none:
        return 'Open';
    }
  }

  /// Returns the QR code format string for this security type
  String toQRString() {
    switch (this) {
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

  /// Creates a SecurityType from a QR code format string
  static SecurityType fromQRString(String qrString) {
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

  /// Converts the enum to a string for JSON serialization
  String toJson() => name;

  /// Creates a SecurityType from a JSON string
  static SecurityType fromJson(String json) {
    return SecurityType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => SecurityType.wpa2,
    );
  }

  /// Returns true if this security type requires a password
  bool get requiresPassword {
    return this != SecurityType.none;
  }
}

/// Immutable data model representing WiFi network configuration
@immutable
class WifiConfig {
  /// Network name (SSID)
  final String ssid;
  
  /// Network password (null for open networks)
  final String? password;
  
  /// Security type of the network
  final SecurityType securityType;
  
  /// Whether the network is hidden
  final bool isHidden;

  /// Maximum SSID length in bytes (WiFi standard)
  static const int maxSsidLength = 32;

  const WifiConfig({
    required this.ssid,
    this.password,
    required this.securityType,
    this.isHidden = false,
  });

  /// Creates a copy of this WifiConfig with the given fields replaced
  WifiConfig copyWith({
    String? ssid,
    String? password,
    SecurityType? securityType,
    bool? isHidden,
  }) {
    return WifiConfig(
      ssid: ssid ?? this.ssid,
      password: password ?? this.password,
      securityType: securityType ?? this.securityType,
      isHidden: isHidden ?? this.isHidden,
    );
  }

  /// Validates the WiFi configuration
  /// Returns true if the configuration is valid
  bool isValid() {
    // SSID must not be empty
    if (ssid.trim().isEmpty) {
      return false;
    }

    // SSID must not exceed maximum length
    if (ssid.length > maxSsidLength) {
      return false;
    }

    // Password must be provided for secured networks
    if (securityType.requiresPassword && (password == null || password!.isEmpty)) {
      return false;
    }

    // WPA/WPA2/WPA3 password must be at least 8 characters
    if ((securityType == SecurityType.wpa ||
         securityType == SecurityType.wpa2 ||
         securityType == SecurityType.wpa3) &&
        password != null &&
        password!.length < 8) {
      return false;
    }

    // WEP password must be exactly 5, 13, 16, or 29 characters (or 10, 26, 32, 58 hex)
    if (securityType == SecurityType.wep && password != null) {
      final len = password!.length;
      if (![5, 10, 13, 16, 26, 29, 32, 58].contains(len)) {
        return false;
      }
    }

    return true;
  }

  /// Returns validation error message, or null if valid
  String? get validationError {
    if (ssid.trim().isEmpty) {
      return 'SSID cannot be empty';
    }

    if (ssid.length > maxSsidLength) {
      return 'SSID cannot exceed $maxSsidLength characters';
    }

    if (securityType.requiresPassword && (password == null || password!.isEmpty)) {
      return 'Password is required for ${securityType.displayName}';
    }

    if ((securityType == SecurityType.wpa ||
         securityType == SecurityType.wpa2 ||
         securityType == SecurityType.wpa3) &&
        password != null &&
        password!.length < 8) {
      return 'WPA password must be at least 8 characters';
    }

    if (securityType == SecurityType.wep && password != null) {
      final len = password!.length;
      if (![5, 10, 13, 16, 26, 29, 32, 58].contains(len)) {
        return 'WEP password must be 5, 13, 16, or 29 characters (ASCII) or 10, 26, 32, 58 characters (HEX)';
      }
    }

    return null;
  }

  /// Converts this WifiConfig to WiFi QR code format
  /// Format: WIFI:T:WPA;S:MyNetwork;P:password;H:false;;
  String toQRString() {
    final escapedSsid = _escapeQRString(ssid);
    final escapedPassword = password != null ? _escapeQRString(password!) : '';
    return 'WIFI:T:${securityType.toQRString()};S:$escapedSsid;P:$escapedPassword;H:$isHidden;;';
  }

  /// Creates a WifiConfig from WiFi QR code format string
  /// Format: WIFI:T:WPA;S:MyNetwork;P:password;H:false;;
  static WifiConfig? fromQRString(String qrString) {
    if (!qrString.startsWith('WIFI:')) {
      return null;
    }

    final params = <String, String>{};
    final parts = qrString.substring(5).split(r';');
    
    for (final part in parts) {
      if (part.isEmpty) continue;
      final colonIndex = part.indexOf(':');
      if (colonIndex == -1) continue;
      
      final key = part.substring(0, colonIndex);
      final value = part.substring(colonIndex + 1);
      params[key] = _unescapeQRString(value);
    }

    final ssid = params['S'];
    if (ssid == null || ssid.isEmpty) {
      return null;
    }

    return WifiConfig(
      ssid: ssid,
      password: params['P']?.isEmpty == true ? null : params['P'],
      securityType: SecurityType.fromQRString(params['T'] ?? 'nopass'),
      isHidden: params['H']?.toLowerCase() == 'true',
    );
  }

  /// Escapes special characters for WiFi QR code format
  static String _escapeQRString(String input) {
    return input
        .replaceAll('\\', '\\\\')
        .replaceAll(';', r'\;')
        .replaceAll(',', '\\,')
        .replaceAll(':', '\\:')
        .replaceAll('"', '\\"');
  }

  /// Unescapes special characters from WiFi QR code format
  static String _unescapeQRString(String input) {
    return input
        .replaceAll('\\:', ':')
        .replaceAll('\\,', ',')
        .replaceAll(r'\;', ';')
        .replaceAll('\\"', '"')
        .replaceAll('\\\\', '\\');
  }

  /// Converts this WifiConfig to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'ssid': ssid,
      'password': password,
      'securityType': securityType.toJson(),
      'isHidden': isHidden,
    };
  }

  /// Creates a WifiConfig from a JSON map
  factory WifiConfig.fromJson(Map<String, dynamic> json) {
    return WifiConfig(
      ssid: json['ssid'] as String,
      password: json['password'] as String?,
      securityType: SecurityType.fromJson(json['securityType'] as String),
      isHidden: json['isHidden'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is WifiConfig &&
        other.ssid == ssid &&
        other.password == password &&
        other.securityType == securityType &&
        other.isHidden == isHidden;
  }

  @override
  int get hashCode {
    return Object.hash(
      ssid,
      password,
      securityType,
      isHidden,
    );
  }

  @override
  String toString() {
    return 'WifiConfig(ssid: $ssid, securityType: ${securityType.displayName}, isHidden: $isHidden)';
  }
}
