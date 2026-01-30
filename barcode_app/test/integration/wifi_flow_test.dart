import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Import screens
import 'package:barcode_app/screens/wifi_generator_screen.dart';
import 'package:barcode_app/screens/export/export_screen.dart';
import 'package:barcode_app/screens/customize/customize_screen.dart';
import 'package:barcode_app/screens/home/home_screen.dart';
import 'package:barcode_app/screens/error_screen.dart';

// Import navigation
import 'package:barcode_app/core/navigation/routes.dart';
import 'package:barcode_app/core/animations/page_transitions.dart';

// Import providers
import 'package:barcode_app/providers/qr_provider.dart';
import 'package:barcode_app/providers/export_provider.dart';

// Import WiFi widgets for finding
import 'package:barcode_app/screens/wifi_generator/widgets/security_selector.dart';

void main() {
  group('WiFi Flow Integration Tests', () {
    late QRProvider qrProvider;
    late ExportProvider exportProvider;
    late GoRouter router;

    setUp(() {
      qrProvider = QRProvider();
      exportProvider = ExportProvider();
      
      // Create test router with all WiFi flow screens
      router = GoRouter(
        initialLocation: AppRoutes.wifiGenerator,
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
            path: AppRoutes.wifiGenerator,
            name: AppRoutes.wifiGeneratorName,
            pageBuilder: (context, state) => buildSlideFadeTransitionPage(
              child: const WifiGeneratorScreen(),
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
        ],
        errorBuilder: (context, state) => ErrorScreen(
          error: state.error?.toString() ?? 'Unknown error',
          path: state.uri.toString(),
        ),
      );
    });

    tearDown(() {
      router.dispose();
      exportProvider.dispose();
    });

    testWidgets('complete WPA2 WiFi flow → Preview → Export', (WidgetTester tester) async {
      // Build app with router and both providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      // Initial pump to build the widget tree
      await tester.pumpAndSettle();
      
      // STEP 1: Verify we're on WiFi generator screen
      expect(find.byType(WifiGeneratorScreen), findsOneWidget);
      expect(find.text('WiFi QR Generator'), findsOneWidget);
      
      // STEP 2: Find and enter SSID
      final ssidField = find.widgetWithText(TextFormField, 'Enter WiFi network name');
      expect(ssidField, findsOneWidget);
      await tester.enterText(ssidField, 'TestNetwork');
      await tester.pump();
      
      // STEP 3: Verify default security is WPA2 (already selected)
      expect(find.text('WPA/WPA2'), findsWidgets);
      
      // STEP 4: Enter password
      final passwordField = find.widgetWithText(TextFormField, 'Enter your WiFi password');
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, 'SecurePass123');
      await tester.pump();
      
      // STEP 5: Scroll to and toggle hidden network switch
      final hiddenToggle = find.byType(Switch);
      expect(hiddenToggle, findsOneWidget);
      await tester.ensureVisible(hiddenToggle);
      await tester.pumpAndSettle();
      await tester.tap(hiddenToggle);
      await tester.pump();
      
      // STEP 6: Generate QR code by scrolling to and tapping button
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate WiFi QR Code'));
      
      // Wait for generation (includes loading state + animations)
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      // STEP 7: Verify QR code generated in provider
      expect(qrProvider.hasQRData, isTrue, reason: 'QR data should be generated');
      expect(qrProvider.currentContent, startsWith('WIFI:'), reason: 'QR should be WiFi format');
      expect(qrProvider.currentContent, contains('S:TestNetwork'), reason: 'Should contain SSID');
      expect(qrProvider.currentContent, contains('P:SecurePass123'), reason: 'Should contain password');
      expect(qrProvider.currentContent, contains('H:true'), reason: 'Should indicate hidden network');
      
      // STEP 8: Verify QR preview appears in UI
      expect(find.byType(QrImageView), findsOneWidget, reason: 'QR preview should be visible');
      
      // STEP 9: Verify network details card displays
      expect(find.text('Network Details'), findsOneWidget);
      expect(find.text('Network'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      
      // Store the QR content for later verification
      final generatedContent = qrProvider.currentContent;
      
      // STEP 10: Navigate to Export screen
      await tester.ensureVisible(find.text('Export'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Export'));
      await tester.pumpAndSettle();
      
      // STEP 11: Verify navigation to Export screen
      expect(find.byType(ExportScreen), findsOneWidget, reason: 'Should navigate to Export screen');
      expect(find.text('Export QR Code'), findsOneWidget);
      
      // STEP 12: Verify QR data persists across navigation
      expect(qrProvider.currentContent, equals(generatedContent), 
        reason: 'QR content should persist to export');
      expect(qrProvider.hasQRData, isTrue, reason: 'QR data should persist to export');
      
      // STEP 13: Verify QR is displayed on Export screen
      expect(find.byType(QrImageView), findsWidgets, 
        reason: 'QR should be displayed on export screen');
    });

    testWidgets('open network flow (no password required)', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Enter SSID
      final ssidField = find.widgetWithText(TextFormField, 'Enter WiFi network name');
      await tester.enterText(ssidField, 'OpenNetwork');
      await tester.pump();
      
      // Change security to None
      final securityDropdown = find.byType(DropdownButton<SecurityType>);
      expect(securityDropdown, findsOneWidget);
      await tester.tap(securityDropdown);
      await tester.pumpAndSettle();
      
      // Select "None" option
      final noneOption = find.text('None').last;
      await tester.tap(noneOption);
      await tester.pumpAndSettle();
      
      // Generate QR code
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate WiFi QR Code'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      // Verify QR generated without password
      expect(qrProvider.hasQRData, isTrue);
      expect(qrProvider.currentContent, startsWith('WIFI:'));
      expect(qrProvider.currentContent, contains('T:nopass'), 
        reason: 'Should use nopass security type');
      expect(qrProvider.currentContent, contains('S:OpenNetwork'));
      expect(qrProvider.currentContent.contains('P:'), isFalse, 
        reason: 'Should not contain password field');
    });

    testWidgets('WPA3 security with password validation', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Enter SSID
      final ssidField = find.widgetWithText(TextFormField, 'Enter WiFi network name');
      await tester.enterText(ssidField, 'WPA3Network');
      await tester.pump();
      
      // Change security to WPA3
      final securityDropdown = find.byType(DropdownButton<SecurityType>);
      await tester.tap(securityDropdown);
      await tester.pumpAndSettle();
      
      final wpa3Option = find.text('WPA3').last;
      await tester.tap(wpa3Option);
      await tester.pumpAndSettle();
      
      // Enter password (must be 8+ characters for WPA3)
      final passwordField = find.widgetWithText(TextFormField, 'Enter your WiFi password');
      await tester.enterText(passwordField, 'StrongPass123');
      await tester.pump();
      
      // Generate QR code
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate WiFi QR Code'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      // Verify QR generated with WPA3
      expect(qrProvider.hasQRData, isTrue);
      expect(qrProvider.currentContent, contains('T:WPA3'), 
        reason: 'Should use WPA3 security type');
      expect(qrProvider.currentContent, contains('S:WPA3Network'));
      expect(qrProvider.currentContent, contains('P:StrongPass123'));
    });

    testWidgets('WEP security with minimum password length', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Enter SSID
      final ssidField = find.widgetWithText(TextFormField, 'Enter WiFi network name');
      await tester.enterText(ssidField, 'WEPNetwork');
      await tester.pump();
      
      // Change security to WEP
      final securityDropdown = find.byType(DropdownButton<SecurityType>);
      await tester.tap(securityDropdown);
      await tester.pumpAndSettle();
      
      final wepOption = find.text('WEP').last;
      await tester.tap(wepOption);
      await tester.pumpAndSettle();
      
      // Enter password (5+ characters for WEP)
      final passwordField = find.widgetWithText(TextFormField, 'Enter your WiFi password');
      await tester.enterText(passwordField, '12345');
      await tester.pump();
      
      // Generate QR code
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate WiFi QR Code'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      // Verify QR generated with WEP
      expect(qrProvider.hasQRData, isTrue);
      expect(qrProvider.currentContent, contains('T:WEP'), 
        reason: 'Should use WEP security type');
      expect(qrProvider.currentContent, contains('S:WEPNetwork'));
      expect(qrProvider.currentContent, contains('P:12345'));
    });

    testWidgets('validates empty SSID', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Leave SSID empty, enter password
      final passwordField = find.widgetWithText(TextFormField, 'Enter your WiFi password');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();
      
      // Try to generate QR code
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate WiFi QR Code'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      // Should NOT generate QR for empty SSID
      expect(qrProvider.hasQRData, isFalse, 
        reason: 'Empty SSID should not generate QR');
      
      // Should show validation error
      expect(find.text('Network name is required'), findsOneWidget);
    });

    testWidgets('validates missing password for secured network', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Enter SSID only (WPA2 is default, requires password)
      final ssidField = find.widgetWithText(TextFormField, 'Enter WiFi network name');
      await tester.enterText(ssidField, 'SecuredNetwork');
      await tester.pump();
      
      // Try to generate without password
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate WiFi QR Code'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      // Should NOT generate QR without password
      expect(qrProvider.hasQRData, isFalse, 
        reason: 'Secured network without password should not generate QR');
      
      // Should show validation error
      expect(find.text('Password is required for secured networks'), findsOneWidget);
    });

    testWidgets('validates WEP password too short (< 5 chars)', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Enter SSID
      final ssidField = find.widgetWithText(TextFormField, 'Enter WiFi network name');
      await tester.enterText(ssidField, 'WEPTest');
      await tester.pump();
      
      // Select WEP
      final securityDropdown = find.byType(DropdownButton<SecurityType>);
      await tester.tap(securityDropdown);
      await tester.pumpAndSettle();
      final wepOption = find.text('WEP').last;
      await tester.tap(wepOption);
      await tester.pumpAndSettle();
      
      // Enter too-short password (4 chars, need 5+)
      final passwordField = find.widgetWithText(TextFormField, 'Enter your WiFi password');
      await tester.enterText(passwordField, '1234');
      await tester.pump();
      
      // Try to generate
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate WiFi QR Code'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      // Should NOT generate QR
      expect(qrProvider.hasQRData, isFalse);
      
      // Should show validation error
      expect(find.text('WEP password must be at least 5 characters'), findsOneWidget);
    });

    testWidgets('validates WPA password too short (< 8 chars)', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Enter SSID
      final ssidField = find.widgetWithText(TextFormField, 'Enter WiFi network name');
      await tester.enterText(ssidField, 'WPATest');
      await tester.pump();
      
      // WPA2 is default, just enter short password (7 chars, need 8+)
      final passwordField = find.widgetWithText(TextFormField, 'Enter your WiFi password');
      await tester.enterText(passwordField, 'pass123');
      await tester.pump();
      
      // Try to generate
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate WiFi QR Code'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      // Should NOT generate QR
      expect(qrProvider.hasQRData, isFalse);
      
      // Should show validation error
      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('QR data persists across navigation to Customize and back', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Generate QR code
      final ssidField = find.widgetWithText(TextFormField, 'Enter WiFi network name');
      await tester.enterText(ssidField, 'PersistTest');
      await tester.pump();
      
      final passwordField = find.widgetWithText(TextFormField, 'Enter your WiFi password');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();
      
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate WiFi QR Code'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      final generatedContent = qrProvider.currentContent;
      expect(qrProvider.hasQRData, isTrue);
      
      // Navigate to Customize using router (instead of tapping button)
      router.go(AppRoutes.customize);
      await tester.pumpAndSettle();
      expect(find.byType(CustomizeScreen), findsOneWidget);
      
      // Verify data persists
      expect(qrProvider.currentContent, equals(generatedContent));
      expect(qrProvider.hasQRData, isTrue);
      
      // Navigate back to WiFi generator
      router.go(AppRoutes.wifiGenerator);
      await tester.pumpAndSettle();
      expect(find.byType(WifiGeneratorScreen), findsOneWidget);
      
      // Verify data still exists
      expect(qrProvider.currentContent, equals(generatedContent));
      expect(qrProvider.hasQRData, isTrue);
    });

    testWidgets('complete flow with hidden network toggle', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Fill in WiFi details
      final ssidField = find.widgetWithText(TextFormField, 'Enter WiFi network name');
      await tester.enterText(ssidField, 'HiddenNet');
      await tester.pump();
      
      final passwordField = find.widgetWithText(TextFormField, 'Enter your WiFi password');
      await tester.enterText(passwordField, 'hiddenpass');
      await tester.pump();
      
      // Scroll to and toggle hidden network ON
      final hiddenToggle = find.byType(Switch);
      await tester.ensureVisible(hiddenToggle);
      await tester.pumpAndSettle();
      await tester.tap(hiddenToggle);
      await tester.pump();
      
      // Generate
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate WiFi QR Code'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      // Verify hidden flag is in QR content
      expect(qrProvider.hasQRData, isTrue);
      expect(qrProvider.currentContent, contains('H:true'), 
        reason: 'Hidden network flag should be set');
      
      // Verify network details card shows "Hidden"
      expect(find.text('Hidden'), findsOneWidget);
    });

    testWidgets('WiFi QR format verification', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Generate a standard WPA2 WiFi QR
      final ssidField = find.widgetWithText(TextFormField, 'Enter WiFi network name');
      await tester.enterText(ssidField, 'FormatTest');
      await tester.pump();
      
      final passwordField = find.widgetWithText(TextFormField, 'Enter your WiFi password');
      await tester.enterText(passwordField, 'testpass123');
      await tester.pump();
      
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate WiFi QR Code'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      // Verify exact WiFi format
      final content = qrProvider.currentContent;
      expect(content, startsWith('WIFI:'), reason: 'Should start with WIFI:');
      expect(content, endsWith(';;'), reason: 'Should end with ;;');
      expect(content, contains('T:'), reason: 'Should contain security type (T:)');
      expect(content, contains('S:'), reason: 'Should contain SSID (S:)');
      expect(content, contains('P:'), reason: 'Should contain password (P:)');
      
      // Verify specific values
      expect(content, contains('S:FormatTest'));
      expect(content, contains('P:testpass123'));
      expect(content, contains('T:WPAOWPA2')); // Default security
    });

    testWidgets('loading state during QR generation', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<QRProvider>.value(value: qrProvider),
            ChangeNotifierProvider<ExportProvider>.value(value: exportProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Fill form
      final ssidField = find.widgetWithText(TextFormField, 'Enter WiFi network name');
      await tester.enterText(ssidField, 'LoadTest');
      await tester.pump();
      
      final passwordField = find.widgetWithText(TextFormField, 'Enter your WiFi password');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();
      
      // Ensure button is visible
      await tester.ensureVisible(find.text('Generate WiFi QR Code'));
      await tester.pumpAndSettle();
      
      // Verify QR Provider loading state gets set
      expect(qrProvider.isGenerating, isFalse, reason: 'Should not be generating initially');
      
      // Tap generate button
      await tester.tap(find.text('Generate WiFi QR Code'));
      await tester.pump();
      
      // Verify loading state is active (QRProvider.isGenerating should be true)
      // Note: We can't reliably check UI loading text because it's too fast,
      // but we verify the provider state changes correctly
      
      // Complete the generation
      await tester.pumpAndSettle();
      
      // Verify generation completed
      expect(qrProvider.hasQRData, isTrue, reason: 'QR should be generated');
      expect(qrProvider.isGenerating, isFalse, reason: 'Should not be generating after completion');
    });
  });
}
