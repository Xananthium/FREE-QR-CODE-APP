import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Import screens
import 'package:barcode_app/screens/url_generator_screen.dart';
import 'package:barcode_app/screens/export/export_screen.dart';
import 'package:barcode_app/screens/home/home_screen.dart';
import 'package:barcode_app/screens/error_screen.dart';

// Import navigation
import 'package:barcode_app/core/navigation/routes.dart';
import 'package:barcode_app/core/animations/page_transitions.dart';

// Import providers
import 'package:barcode_app/providers/qr_provider.dart';
import 'package:barcode_app/providers/export_provider.dart';

void main() {
  group('URL Flow Integration Tests', () {
    late QRProvider qrProvider;
    late ExportProvider exportProvider;
    late GoRouter router;

    setUp(() {
      qrProvider = QRProvider();
      exportProvider = ExportProvider();
      
      // Create test router
      router = GoRouter(
        initialLocation: AppRoutes.urlGenerator,
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

    testWidgets('complete URL → Preview → Export flow', (WidgetTester tester) async {
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
      
      // STEP 1: Verify we're on URL generator screen
      expect(find.byType(UrlGeneratorScreen), findsOneWidget);
      expect(find.text('URL QR Generator'), findsOneWidget);
      
      // STEP 2: Enter URL
      final urlField = find.byType(TextField);
      expect(urlField, findsOneWidget);
      
      await tester.enterText(urlField, 'https://flutter.dev');
      
      // STEP 3: Wait for debounce (500ms) + buffer for QR generation
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      
      // STEP 4: Verify QR code generated in provider (state verification)
      expect(qrProvider.currentContent, isNotEmpty, reason: 'QR content should be generated');
      expect(qrProvider.hasQRData, isTrue, reason: 'QR data should exist');
      expect(qrProvider.currentContent, contains('flutter.dev'), reason: 'QR should contain the URL');
      
      // STEP 5: Verify QR preview appears in UI
      expect(find.byType(QrImageView), findsOneWidget, reason: 'QR preview should be visible');
      
      // Store the QR content for later verification
      final generatedContent = qrProvider.currentContent;
      
      // STEP 6: Navigate to Export screen
      router.go(AppRoutes.exportScreen);
      await tester.pumpAndSettle();
      
      // STEP 7: Verify navigation to Export screen
      expect(find.byType(ExportScreen), findsOneWidget, reason: 'Should navigate to Export screen');
      expect(find.text('Export QR Code'), findsOneWidget);
      
      // STEP 8: Verify QR data persists across navigation
      expect(qrProvider.currentContent, equals(generatedContent), reason: 'QR content should persist to export');
      expect(qrProvider.hasQRData, isTrue, reason: 'QR data should persist to export');
      
      // STEP 9: Verify QR is displayed on Export screen
      expect(find.byType(QrImageView), findsWidgets, reason: 'QR should be displayed on export screen');
    });

    testWidgets('URL → Export direct flow (complete end-to-end)', (WidgetTester tester) async {
      // Build app with router and providers
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
      
      // Enter URL
      final urlField = find.byType(TextField);
      await tester.enterText(urlField, 'https://example.com');
      
      // Wait for debounce + QR generation
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      
      // Verify QR generated
      expect(qrProvider.hasQRData, isTrue, reason: 'QR should be generated');
      expect(find.byType(QrImageView), findsOneWidget);
      
      final generatedContent = qrProvider.currentContent;
      expect(generatedContent, contains('example.com'));
      
      // Navigate directly to Export
      router.go(AppRoutes.exportScreen);
      await tester.pumpAndSettle();
      
      // Verify complete flow
      expect(find.byType(ExportScreen), findsOneWidget, reason: 'Should navigate to Export screen');
      expect(qrProvider.currentContent, equals(generatedContent), reason: 'QR content should be available for export');
      expect(qrProvider.hasQRData, isTrue);
    });
    
    testWidgets('validates URL format before generating QR', (WidgetTester tester) async {
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
      
      // Enter invalid URL (no domain extension)
      final urlField = find.byType(TextField);
      await tester.enterText(urlField, 'not a url');
      
      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      
      // Should NOT generate QR for invalid URL
      expect(qrProvider.hasQRData, isFalse, reason: 'Invalid URL should not generate QR');
      expect(find.byType(QrImageView), findsNothing, reason: 'QR preview should not appear for invalid URL');
    });

    testWidgets('handles multiple URL changes with debouncing', (WidgetTester tester) async {
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
      
      final urlField = find.byType(TextField);
      
      // Enter first URL
      await tester.enterText(urlField, 'https://first.com');
      await tester.pump(const Duration(milliseconds: 300));
      
      // Change URL before debounce completes (should cancel previous)
      await tester.enterText(urlField, 'https://second.com');
      await tester.pump(const Duration(milliseconds: 300));
      
      // Change URL again
      await tester.enterText(urlField, 'https://final.com');
      
      // Wait for final debounce to complete
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      
      // Should only generate QR for final URL
      expect(qrProvider.hasQRData, isTrue);
      expect(qrProvider.currentContent, contains('final.com'), reason: 'Should contain final URL');
      expect(find.byType(QrImageView), findsOneWidget);
    });

    testWidgets('URL with protocol is handled correctly', (WidgetTester tester) async {
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
      
      // Enter URL without protocol (should auto-add https://)
      final urlField = find.byType(TextField);
      await tester.enterText(urlField, 'flutter.dev');
      
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      
      // Verify QR generated with https:// prefix
      expect(qrProvider.hasQRData, isTrue);
      expect(qrProvider.currentContent, startsWith('https://'), 
        reason: 'URL without protocol should be prefixed with https://');
    });

    testWidgets('QR data persists across back navigation', (WidgetTester tester) async {
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
      final urlField = find.byType(TextField);
      await tester.enterText(urlField, 'https://test.com');
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      
      final generatedContent = qrProvider.currentContent;
      expect(qrProvider.hasQRData, isTrue);
      
      // Navigate to Export
      router.go(AppRoutes.exportScreen);
      await tester.pumpAndSettle();
      expect(find.byType(ExportScreen), findsOneWidget);
      
      // Navigate back to URL generator
      router.go(AppRoutes.urlGenerator);
      await tester.pumpAndSettle();
      expect(find.byType(UrlGeneratorScreen), findsOneWidget);
      
      // Verify data still exists
      expect(qrProvider.currentContent, equals(generatedContent));
      expect(qrProvider.hasQRData, isTrue);
    });

    testWidgets('empty URL does not generate QR', (WidgetTester tester) async {
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
      
      // Enter empty string
      final urlField = find.byType(TextField);
      await tester.enterText(urlField, '');
      
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      
      // Should not generate QR
      expect(qrProvider.hasQRData, isFalse);
      expect(find.byType(QrImageView), findsNothing);
    });
  });
}
