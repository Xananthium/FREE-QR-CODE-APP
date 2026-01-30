/// Enum representing different types of QR codes supported by the app
enum QRType {
  /// URL/Link QR code
  url,

  /// WiFi network configuration QR code
  wifi,

  /// Contact / vCard QR code
  contact,

  /// Email QR code
  email,

  /// Phone number QR code
  phone,

  /// SMS QR code
  sms,

  /// Location QR code
  location;

  /// Returns a human-readable display name for the QR type
  String get displayName {
    switch (this) {
      case QRType.url:
        return 'URL';
      case QRType.wifi:
        return 'WiFi';
      case QRType.contact:
        return 'Contact';
      case QRType.email:
        return 'Email';
      case QRType.phone:
        return 'Phone';
      case QRType.sms:
        return 'SMS';
      case QRType.location:
        return 'Location';
    }
  }

  /// Converts the enum to a string for JSON serialization
  String toJson() => name;

  /// Creates a QRType from a JSON string
  static QRType fromJson(String json) {
    return QRType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => QRType.url,
    );
  }
}
