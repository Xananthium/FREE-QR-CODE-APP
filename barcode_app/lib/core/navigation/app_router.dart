import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../animations/page_transitions.dart';
import 'routes.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/url_generator_screen.dart';
import '../../screens/wifi_generator_screen.dart';
import '../../screens/contact_generator_screen.dart';
import '../../screens/email_generator_screen.dart';
import '../../screens/phone_generator_screen.dart';
import '../../screens/sms_generator_screen.dart';
import '../../screens/location_generator_screen.dart';
import '../../screens/customize/customize_screen.dart';
import '../../screens/export/export_screen.dart';
import '../../screens/about/about_screen.dart';
import '../../screens/error_screen.dart';

/// Global router configuration for the application with custom page transitions.
///
/// This uses GoRouter for declarative routing with support for:
/// - Type-safe navigation
/// - Custom page transitions (slide, fade, scale)
/// - Deep linking
/// - Browser URL updates (web)
/// - Error handling
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.homeName,
      pageBuilder: (context, state) => buildFadeTransitionPage(
        child: const HomeScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: AppRoutes.urlGenerator,
      name: AppRoutes.urlGeneratorName,
      pageBuilder: (context, state) => buildSlideFadeTransitionPage(
        child: const UrlGeneratorScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: AppRoutes.wifiGenerator,
      name: AppRoutes.wifiGeneratorName,
      pageBuilder: (context, state) => buildSlideFadeTransitionPage(
        child: const WifiGeneratorScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: AppRoutes.contactGenerator,
      name: AppRoutes.contactGeneratorName,
      pageBuilder: (context, state) => buildSlideFadeTransitionPage(
        child: const ContactGeneratorScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: AppRoutes.emailGenerator,
      name: AppRoutes.emailGeneratorName,
      pageBuilder: (context, state) => buildSlideFadeTransitionPage(
        child: const EmailGeneratorScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: AppRoutes.phoneGenerator,
      name: AppRoutes.phoneGeneratorName,
      pageBuilder: (context, state) => buildSlideFadeTransitionPage(
        child: const PhoneGeneratorScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: AppRoutes.smsGenerator,
      name: AppRoutes.smsGeneratorName,
      pageBuilder: (context, state) => buildSlideFadeTransitionPage(
        child: const SmsGeneratorScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: AppRoutes.locationGenerator,
      name: AppRoutes.locationGeneratorName,
      pageBuilder: (context, state) => buildSlideFadeTransitionPage(
        child: const LocationGeneratorScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: AppRoutes.customize,
      name: AppRoutes.customizeName,
      pageBuilder: (context, state) => buildSlideFadeTransitionPage(
        child: const CustomizeScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: AppRoutes.exportScreen,
      name: AppRoutes.exportName,
      pageBuilder: (context, state) => buildSlideFadeTransitionPage(
        child: const ExportScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: AppRoutes.about,
      name: AppRoutes.aboutName,
      pageBuilder: (context, state) => buildSlideFadeTransitionPage(
        child: const AboutScreen(),
        state: state,
      ),
    ),
  ],
  errorBuilder: (context, state) => ErrorScreen(
    error: state.error?.toString() ?? 'Unknown error',
    path: state.uri.toString(),
  ),
);

/// Extension methods on BuildContext for type-safe navigation.
///
/// These helper methods make navigation cleaner and prevent typos in route names.
/// Usage: context.goToUrlGenerator() instead of context.go('/url-generator')
extension NavigationExtension on BuildContext {
  /// Navigate to home screen
  void goToHome() => go(AppRoutes.home);

  /// Navigate to URL generator screen
  void goToUrlGenerator() => go(AppRoutes.urlGenerator);

  /// Navigate to WiFi generator screen
  void goToWifiGenerator() => go(AppRoutes.wifiGenerator);

  /// Navigate to Contact generator screen
  void goToContactGenerator() => go(AppRoutes.contactGenerator);

  /// Navigate to Email generator screen
  void goToEmailGenerator() => go(AppRoutes.emailGenerator);

  /// Navigate to Phone generator screen
  void goToPhoneGenerator() => go(AppRoutes.phoneGenerator);

  /// Navigate to SMS generator screen
  void goToSmsGenerator() => go(AppRoutes.smsGenerator);

  /// Navigate to Location generator screen
  void goToLocationGenerator() => go(AppRoutes.locationGenerator);

  /// Navigate to customize screen
  void goToCustomize() => go(AppRoutes.customize);

  /// Navigate to export screen
  void goToExport() => go(AppRoutes.exportScreen);

  /// Navigate to about screen
  void goToAbout() => go(AppRoutes.about);

  /// Navigate back if possible, otherwise go to home
  void goBackOrHome() {
    if (canPop()) {
      pop();
    } else {
      go(AppRoutes.home);
    }
  }

  /// Check if the current location matches a route
  bool isCurrentRoute(String route) {
    final routerState = GoRouter.of(this).routerDelegate.currentConfiguration;
    return routerState.uri.path == route;
  }

  /// Get the current route path
  String get currentRoute {
    final routerState = GoRouter.of(this).routerDelegate.currentConfiguration;
    return routerState.uri.path;
  }
}

/// Extension methods on GoRouter for additional navigation utilities
extension GoRouterExtension on GoRouter {
  /// Navigate to home screen
  void goToHome() => go(AppRoutes.home);

  /// Navigate to URL generator screen
  void goToUrlGenerator() => go(AppRoutes.urlGenerator);

  /// Navigate to WiFi generator screen
  void goToWifiGenerator() => go(AppRoutes.wifiGenerator);

  /// Navigate to Contact generator screen
  void goToContactGenerator() => go(AppRoutes.contactGenerator);

  /// Navigate to Email generator screen
  void goToEmailGenerator() => go(AppRoutes.emailGenerator);

  /// Navigate to Phone generator screen
  void goToPhoneGenerator() => go(AppRoutes.phoneGenerator);

  /// Navigate to SMS generator screen
  void goToSmsGenerator() => go(AppRoutes.smsGenerator);

  /// Navigate to Location generator screen
  void goToLocationGenerator() => go(AppRoutes.locationGenerator);

  /// Navigate to customize screen
  void goToCustomize() => go(AppRoutes.customize);

  /// Navigate to export screen
  void goToExport() => go(AppRoutes.exportScreen);

  /// Navigate to about screen
  void goToAbout() => go(AppRoutes.about);
}
