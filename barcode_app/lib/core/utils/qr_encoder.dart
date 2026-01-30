/// QR Code encoding utilities
///
/// Provides static methods for encoding various data types into QR-compatible formats.
/// Currently supports URL encoding with automatic protocol addition and special character handling.
class QREncoder {
  /// Private constructor to prevent instantiation
  QREncoder._();

  /// Encodes a URL string for QR code generation
  ///
  /// This method:
  /// - Validates the input URL format
  /// - Automatically adds 'https://' if no protocol is present
  /// - Properly encodes special characters in the path and query components
  /// - Preserves the URL structure without double-encoding
  ///
  /// Example:
  /// ```dart
  /// // Basic domain
  /// QREncoder.encodeUrl('google.com'); // Returns: 'https://google.com'
  ///
  /// // URL with spaces
  /// QREncoder.encodeUrl('example.com/path with spaces');
  /// // Returns: 'https://example.com/path%20with%20spaces'
  ///
  /// // Already has protocol
  /// QREncoder.encodeUrl('http://test.com'); // Returns: 'http://test.com'
  /// ```
  ///
  /// Throws [ArgumentError] if:
  /// - The input is empty or only whitespace
  /// - The URL format is invalid
  ///
  /// Parameters:
  /// - [url]: The URL string to encode (required)
  ///
  /// Returns: A properly formatted and encoded URL string
  static String encodeUrl(String url) {
    // Trim whitespace
    final trimmedUrl = url.trim();

    // Validate non-empty
    if (trimmedUrl.isEmpty) {
      throw ArgumentError('URL cannot be empty');
    }

    // Add protocol if missing
    String urlWithProtocol = trimmedUrl;
    if (!trimmedUrl.startsWith('http://') &&
        !trimmedUrl.startsWith('https://')) {
      urlWithProtocol = 'https://$trimmedUrl';
    }

    // Parse and validate URL
    final Uri uri;
    try {
      uri = Uri.parse(urlWithProtocol);
    } catch (e) {
      throw ArgumentError('Invalid URL format: $e');
    }

    // Validate that we have a host
    if (uri.host.isEmpty) {
      throw ArgumentError('URL must contain a valid host/domain');
    }

    // Reconstruct the URL with proper encoding
    // Uri.parse already handles encoding, but we'll ensure it's properly formatted
    final encodedUri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
      path: uri.path,
      query: uri.query.isNotEmpty ? uri.query : null,
      fragment: uri.fragment.isNotEmpty ? uri.fragment : null,
    );

    return encodedUri.toString();
  }

  /// Encodes WiFi credentials for QR code generation
  ///
  /// Uses the standard WiFi QR code format: WIFI:T:<type>;S:<ssid>;P:<password>;;
  ///
  /// Example:
  /// ```dart
  /// QREncoder.encodeWifi(
  ///   ssid: 'MyNetwork',
  ///   password: 'MyPassword123',
  ///   security: 'WPA',
  /// );
  /// // Returns: 'WIFI:T:WPA;S:MyNetwork;P:MyPassword123;;'
  /// ```
  ///
  /// Parameters:
  /// - [ssid]: The WiFi network name (required)
  /// - [password]: The WiFi password (optional for open networks)
  /// - [security]: The security type: 'WPA', 'WEP', or 'nopass' (defaults to 'WPA')
  /// - [hidden]: Whether the network is hidden (defaults to false)
  ///
  /// Returns: A WiFi QR code formatted string
  static String encodeWifi({
    required String ssid,
    String? password,
    String security = 'WPA',
    bool hidden = false,
  }) {
    if (ssid.trim().isEmpty) {
      throw ArgumentError('SSID cannot be empty');
    }

    // Escape special characters in SSID and password
    final escapedSsid = _escapeWifiString(ssid);
    final escapedPassword = password != null ? _escapeWifiString(password) : '';

    // Build WiFi string according to standard format
    final buffer = StringBuffer('WIFI:');
    buffer.write('T:$security;');
    buffer.write('S:$escapedSsid;');

    if (password != null && password.isNotEmpty) {
      buffer.write('P:$escapedPassword;');
    }

    if (hidden) {
      buffer.write('H:true;');
    }

    buffer.write(';');

    return buffer.toString();
  }

  /// Escapes special characters in WiFi strings
  ///
  /// According to WiFi QR code spec, these characters need to be escaped:
  /// \\ " ; , :
  static String _escapeWifiString(String input) {
    return input
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll(';', '\;')
        .replaceAll(',', '\\,')
        .replaceAll(':', '\\:');
  }

  /// Encodes plain text for QR code generation
  ///
  /// For simple text QR codes, no special encoding is needed.
  /// This method mainly validates the input.
  ///
  /// Example:
  /// ```dart
  /// QREncoder.encodeText('Hello, World!'); // Returns: 'Hello, World!'
  /// ```
  ///
  /// Parameters:
  /// - [text]: The text to encode (required)
  ///
  /// Returns: The input text (validated)
  static String encodeText(String text) {
    if (text.trim().isEmpty) {
      throw ArgumentError('Text cannot be empty');
    }
    return text;
  }

  /// Encodes a vCard string for contact QR codes
  ///
  /// Validates that the vCard string is not empty.
  static String encodeVCard(String vCard) {
    if (vCard.trim().isEmpty) {
      throw ArgumentError('vCard data cannot be empty');
    }
    return vCard.trim();
  }

  /// Encodes an email address for QR code generation
  ///
  /// Creates a mailto: URI for email QR codes
  ///
  /// Example:
  /// ```dart
  /// QREncoder.encodeEmail(
  ///   email: 'user@example.com',
  ///   subject: 'Hello',
  ///   body: 'Test message',
  /// );
  /// // Returns: 'mailto:user@example.com?subject=Hello&body=Test%20message'
  /// ```
  ///
  /// Parameters:
  /// - [email]: The email address (required)
  /// - [subject]: Optional email subject
  /// - [body]: Optional email body
  ///
  /// Returns: A mailto: URI string
  static String encodeEmail({
    required String email,
    String? subject,
    String? body,
  }) {
    if (email.trim().isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }

    // Basic email validation
    if (!email.contains('@') || !email.contains('.')) {
      throw ArgumentError('Invalid email format');
    }

    final buffer = StringBuffer('mailto:${email.trim()}');
    final params = <String>[];

    if (subject != null && subject.isNotEmpty) {
      params.add('subject=${Uri.encodeComponent(subject)}');
    }

    if (body != null && body.isNotEmpty) {
      params.add('body=${Uri.encodeComponent(body)}');
    }

    if (params.isNotEmpty) {
      buffer.write('?${params.join('&')}');
    }

    return buffer.toString();
  }

  /// Encodes a phone number for QR code generation
  ///
  /// Creates a tel: URI for phone number QR codes
  ///
  /// Example:
  /// ```dart
  /// QREncoder.encodePhone('+1-234-567-8900'); // Returns: 'tel:+1-234-567-8900'
  /// ```
  ///
  /// Parameters:
  /// - [phoneNumber]: The phone number (required)
  ///
  /// Returns: A tel: URI string
  static String encodePhone(String phoneNumber) {
    final trimmedNumber = phoneNumber.trim();

    if (trimmedNumber.isEmpty) {
      throw ArgumentError('Phone number cannot be empty');
    }

    // Remove spaces and common separators for validation
    final digitsOnly = trimmedNumber.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');

    if (digitsOnly.isEmpty) {
      throw ArgumentError('Phone number must contain digits');
    }

    return 'tel:$trimmedNumber';
  }

  /// Encodes an SMS message for QR code generation
  ///
  /// Creates an SMS URI for SMS QR codes
  ///
  /// Example:
  /// ```dart
  /// QREncoder.encodeSms(
  ///   phoneNumber: '+1234567890',
  ///   message: 'Hello!',
  /// );
  /// // Returns: 'sms:+1234567890?body=Hello!'
  /// ```
  ///
  /// Parameters:
  /// - [phoneNumber]: The recipient phone number (required)
  /// - [message]: Optional SMS message body
  ///
  /// Returns: An SMS URI string
  static String encodeSms({
    required String phoneNumber,
    String? message,
  }) {
    final trimmedNumber = phoneNumber.trim();

    if (trimmedNumber.isEmpty) {
      throw ArgumentError('Phone number cannot be empty');
    }

    final buffer = StringBuffer('sms:$trimmedNumber');

    if (message != null && message.isNotEmpty) {
      buffer.write('?body=${Uri.encodeComponent(message)}');
    }

    return buffer.toString();
  }

  /// Encodes a location for QR code generation
  ///
  /// Supports coordinates (geo:) and address (Google Maps) formats.
  ///
  /// Examples:
  /// ```dart
  /// QREncoder.encodeLocation(latitude: 37.7749, longitude: -122.4194);
  /// // Returns: 'geo:37.7749,-122.4194'
  ///
  /// QREncoder.encodeLocation(address: '1600 Amphitheatre Pkwy, Mountain View, CA');
  /// // Returns: 'https://maps.google.com/?q=1600%20Amphitheatre%20Pkwy%2C%20Mountain%20View%2C%20CA'
  /// ```
  static String encodeLocation({
    String? address,
    double? latitude,
    double? longitude,
    String? label,
  }) {
    final hasCoords = latitude != null && longitude != null;
    final hasAddress = address != null && address.trim().isNotEmpty;

    if (!hasCoords && !hasAddress) {
      throw ArgumentError('Provide an address or coordinates');
    }

    if (hasCoords) {
      final lat = latitude!;
      final lon = longitude!;
      final buffer = StringBuffer('geo:$lat,$lon');
      final query = label != null && label.trim().isNotEmpty
          ? label.trim()
          : (hasAddress ? address!.trim() : null);
      if (query != null && query.isNotEmpty) {
        buffer.write('?q=${Uri.encodeComponent(query)}');
      }
      return buffer.toString();
    }

    return 'https://maps.google.com/?q=${Uri.encodeComponent(address!.trim())}';
  }
}
