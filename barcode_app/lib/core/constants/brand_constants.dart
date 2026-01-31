import 'package:flutter/material.dart';

/// Digital Disconnections brand constants
/// 
/// Contains all branding-related constants including:
/// - Company information
/// - Brand colors extracted from logo
/// - Asset paths
/// - URLs
class BrandConstants {
  BrandConstants._(); // Private constructor to prevent instantiation

  // Company Information
  static const String companyName = 'Digital Disconnections';
  static const String companyNameFull = 'Digital Disconnections Inc.';
  static const String websiteUrl = 'https://digitaldisconnections.com';
  
  // App Branding
  static const String appName = 'QR Code Generator';
  static const String appNameWithBranding = 'QR Code Generator by Digital Disconnections';
  static const String appTagline = 'Create custom QR codes instantly';
  
  // Brand Colors (extracted from logo)
  /// Primary brand color - Blue-grey from logo
  static const Color brandPrimary = Color(0xFF556270);
  
  /// Secondary brand color - Warm brown from logo
  static const Color brandSecondary = Color(0xFF8B6F47);
  
  /// Lighter variant of brand primary for backgrounds
  static const Color brandPrimaryLight = Color(0xFF7B8794);
  
  /// Darker variant of brand secondary for accents
  static const Color brandSecondaryDark = Color(0xFF6B5537);
  
  // Asset Paths
  static const String logoPath = 'assets/images/digital_disconnections_logo.png';
  
  // Footer Text
  static const String footerText = 'Made by Digital Disconnections Inc.';
  static const String footerWithLink = 'Made with ♥ by Digital Disconnections Inc.';
  
  // About Text
  static const String aboutDescription =
      'Digital Eclipse is a beautiful, easy-to-use QR code generator. '
      'Create QR codes for URLs, WiFi networks, contacts, and more with stunning decorative borders. '
      'Free forever. No subscriptions. No tricks.';

  static const String ourStory =
      'There\'s a special time in May when my wife, my daughter, and my sister all share a birthday. '
      'We decided to do an extra special party, and I made invitations with a Google Maps QR code to the venue. '
      'I searched for a "Free QR Code Generator" and clicked the first result.\n\n'
      'Three days later, I got an email saying my QR code was no longer active. '
      'To reactivate it, I needed a yearly membership for \$30+. '
      'I got a lot of calls about the broken QR code, but I didn\'t pay the membership.\n\n'
      'My processing power made that QR code, and then they charged me for it. '
      'You shouldn\'t have to pay rent to use the things that you own.\n\n'
      'So I made this app. Forever free.';

  static const String freeForever =
      'We also have a self-contained HTML file that generates QR codes, '
      'is free forever, and will run offline on any device. '
      'Check it out on our GitHub at digitaldisconnections.com.';

  static const String aboutCompany =
      'Digital Disconnections creates thoughtful software that helps people '
      'disconnect from unnecessary digital noise and focus on what matters.';
}
