import 'package:flutter/material.dart';

/// App color constants for light and dark themes
/// Follows Material Design 3 color system
class AppColors {
  AppColors._();

  // Primary colors - Museum quality dark minimalism inspired by art galleries
  // Eclipse symbol color extracted from Digital Disconnections logo
  static const Color primaryLight = Color(0xFF556270); // Slate gray-blue from eclipse
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFE8EAED);
  static const Color onPrimaryContainerLight = Color(0xFF1A1D23);

  // Dark theme: Premium gallery aesthetic with golden accents
  static const Color primaryDark = Color(0xFFD4AF37); // Museum gold accent
  static const Color onPrimaryDark = Color(0xFF0A0A0B); // Deep charcoal
  static const Color primaryContainerDark = Color(0xFF1E1E20);
  static const Color onPrimaryContainerDark = Color(0xFFE8E6E3);

  // Secondary colors - used for less prominent components
  static const Color secondaryLight = Color(0xFF625B71);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFE8DEF8);
  static const Color onSecondaryContainerLight = Color(0xFF1D192B);

  static const Color secondaryDark = Color(0xFFCCC2DC);
  static const Color onSecondaryDark = Color(0xFF332D41);
  static const Color secondaryContainerDark = Color(0xFF4A4458);
  static const Color onSecondaryContainerDark = Color(0xFFE8DEF8);

  // Tertiary colors - for contrasting accents
  static const Color tertiaryLight = Color(0xFF7D5260);
  static const Color onTertiaryLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerLight = Color(0xFFFFD8E4);
  static const Color onTertiaryContainerLight = Color(0xFF31111D);

  static const Color tertiaryDark = Color(0xFFEFB8C8);
  static const Color onTertiaryDark = Color(0xFF492532);
  static const Color tertiaryContainerDark = Color(0xFF633B48);
  static const Color onTertiaryContainerDark = Color(0xFFFFD8E4);

  // Error colors
  static const Color errorLight = Color(0xFFB3261E);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color errorContainerLight = Color(0xFFF9DEDC);
  static const Color onErrorContainerLight = Color(0xFF410E0B);

  static const Color errorDark = Color(0xFFF2B8B5);
  static const Color onErrorDark = Color(0xFF601410);
  static const Color errorContainerDark = Color(0xFF8C1D18);
  static const Color onErrorContainerDark = Color(0xFFF9DEDC);

  // Background colors - Gallery white and deep charcoal
  static const Color backgroundLight = Color(0xFFFAFAFA); // Soft gallery white
  static const Color onBackgroundLight = Color(0xFF1A1D23);

  static const Color backgroundDark = Color(0xFF0A0A0B); // Deep charcoal gallery walls
  static const Color onBackgroundDark = Color(0xFFE8E6E3); // Warm off-white text

  // Surface colors - Elevated surfaces with subtle depth
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF1A1D23);
  static const Color surfaceVariantLight = Color(0xFFF5F5F5);
  static const Color onSurfaceVariantLight = Color(0xFF6B6B6B);

  static const Color surfaceDark = Color(0xFF121214); // Slightly elevated from background
  static const Color onSurfaceDark = Color(0xFFE8E6E3);
  static const Color surfaceVariantDark = Color(0xFF1A1A1C); // Cards/elevated elements
  static const Color onSurfaceVariantDark = Color(0xFFB8B6B3); // Muted text

  // Outline colors
  static const Color outlineLight = Color(0xFF79747E);
  static const Color outlineVariantLight = Color(0xFFCAC4D0);

  static const Color outlineDark = Color(0xFF938F99);
  static const Color outlineVariantDark = Color(0xFF49454F);

  // Shadow and scrim
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  // Inverse colors
  static const Color inverseSurfaceLight = Color(0xFF313033);
  static const Color inverseOnSurfaceLight = Color(0xFFF4EFF4);
  static const Color inversePrimaryLight = Color(0xFFD0BCFF);

  static const Color inverseSurfaceDark = Color(0xFFE6E1E5);
  static const Color inverseOnSurfaceDark = Color(0xFF313033);
  static const Color inversePrimaryDark = Color(0xFF6750A4);

  // Barcode scanner specific colors
  static const Color scanOverlay = Color(0x99000000); // Semi-transparent black
  static const Color scanFrameLight = Color(0xFF6750A4); // Same as primary
  static const Color scanFrameDark = Color(0xFFD0BCFF); // Same as primary dark
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
}
