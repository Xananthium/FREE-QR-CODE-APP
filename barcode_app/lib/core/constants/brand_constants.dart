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
      'I was planning my daughter\'s 6th birthday party and printing invitations with a Google Maps QR code. '
      'I clicked on the first website that said "free QR codes." I was very busy planning the party, '
      'put it on the cards, and sent them out.\n\n'
      'Three days later I got an email that said I would need to buy a membership if I wanted this QR code to stay active. '
      'Needless to say, I didn\'t pay their \$30/year membership so this QR code could stay active for a few days, '
      'and I got several calls about it.\n\n'
      'So I wrote this app. It\'s free forever.';

  static const String freeForever =
      'We also have a self-contained HTML file that generates QR codes, '
      'is free forever, and will run offline on any device. '
      'Check it out on our GitHub at digitaldisconnections.com.';

  static const String aboutCompany =
      'Digital Disconnections creates thoughtful software that helps people '
      'disconnect from unnecessary digital noise and focus on what matters.';
}
