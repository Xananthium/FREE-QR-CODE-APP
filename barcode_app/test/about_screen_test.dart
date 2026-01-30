import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:barcode_app/screens/about_screen.dart';
import 'package:barcode_app/providers/theme_provider.dart';

void main() {
  group('About Screen Tests', () {
    testWidgets('About screen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => ThemeProvider(),
            child: const AboutScreen(),
          ),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Verify app bar
      expect(find.text('About'), findsOneWidget);

      // Verify story section exists
      expect(find.textContaining('daughter'), findsOneWidget);
      expect(find.textContaining('sixth birthday'), findsOneWidget);

      // Verify mission exists
      expect(find.textContaining('rent your own phone'), findsOneWidget);

      // Verify features
      expect(find.textContaining('Free forever'), findsOneWidget);
      expect(find.textContaining('No subscriptions'), findsOneWidget);
      expect(find.textContaining('No data collection'), findsOneWidget);
      expect(find.textContaining('No ads'), findsOneWidget);
      expect(find.textContaining('Works offline'), findsOneWidget);
      expect(find.textContaining('never expire'), findsOneWidget);

      // Verify links
      expect(find.textContaining('Visit Our Website'), findsOneWidget);
      expect(find.textContaining('View on GitHub'), findsOneWidget);
      expect(find.textContaining('Privacy Policy'), findsOneWidget);
    });

    testWidgets('About screen has proper icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => ThemeProvider(),
            child: const AboutScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify QR code icon exists
      expect(find.byIcon(Icons.qr_code_2_rounded), findsAtLeastNWidgets(1));
    });
  });
}
