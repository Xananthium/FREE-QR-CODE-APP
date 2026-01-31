/// Route path and name constants for the QR Code Generator app.
///
/// This file contains all route definitions used throughout the application.
/// Using constants ensures type-safety and prevents typos in route names.
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  /// Onboarding screen route - First launch experience
  static const String onboarding = '/onboarding';
  static const String onboardingName = 'onboarding';

  /// Home screen route - Main landing page
  static const String home = '/';
  static const String homeName = 'home';

  /// URL Generator screen route - Create QR codes from URLs
  static const String urlGenerator = '/url-generator';
  static const String urlGeneratorName = 'url-generator';

  /// WiFi Generator screen route - Create QR codes for WiFi credentials
  static const String wifiGenerator = '/wifi-generator';
  static const String wifiGeneratorName = 'wifi-generator';

  /// Contact/vCard Generator screen route
  static const String contactGenerator = '/contact-generator';
  static const String contactGeneratorName = 'contact-generator';

  /// Email Generator screen route
  static const String emailGenerator = '/email-generator';
  static const String emailGeneratorName = 'email-generator';

  /// Phone Generator screen route
  static const String phoneGenerator = '/phone-generator';
  static const String phoneGeneratorName = 'phone-generator';

  /// SMS Generator screen route
  static const String smsGenerator = '/sms-generator';
  static const String smsGeneratorName = 'sms-generator';

  /// Location Generator screen route
  static const String locationGenerator = '/location-generator';
  static const String locationGeneratorName = 'location-generator';

  /// Customize screen route - Apply decorative borders to QR codes
  static const String customize = '/customize';
  static const String customizeName = 'customize';

  /// Export screen route - Export and share QR codes
  static const String exportScreen = '/export';
  static const String exportName = 'export';

  /// About screen route - App story, mission, and information
  static const String about = '/about';
  static const String aboutName = 'about';

  /// List of all routes for validation
  static const List<String> allRoutes = [
    onboarding,
    home,
    urlGenerator,
    wifiGenerator,
    contactGenerator,
    emailGenerator,
    phoneGenerator,
    smsGenerator,
    locationGenerator,
    customize,
    exportScreen,
    about,
  ];

  /// Check if a route path is valid
  static bool isValidRoute(String path) {
    return allRoutes.contains(path);
  }
}
