import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:barcode_app/screens/customize/customize_screen.dart';
import 'package:barcode_app/providers/qr_provider.dart';

void main() {
  group('CustomizeScreen Tests', () {
    late QRProvider provider;

    setUp(() {
      provider = QRProvider();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<QRProvider>.value(
          value: provider,
          child: const CustomizeScreen(),
        ),
      );
    }

    testWidgets('renders all main sections', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for main sections
      expect(find.text('Live Preview'), findsOneWidget);
      expect(find.text('Select Border'), findsOneWidget);
      expect(find.text('Customize Colors'), findsOneWidget);
      expect(find.text('Export'), findsOneWidget);
    });

    testWidgets('color chips are present', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('QR Color'), findsOneWidget);
      expect(find.text('Border Color'), findsOneWidget);
    });

    testWidgets('section headers have correct icons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for section icons
      expect(find.byIcon(Icons.border_style_rounded), findsOneWidget);
      expect(find.byIcon(Icons.palette_rounded), findsOneWidget);
      expect(find.byIcon(Icons.download_rounded), findsWidgets);
    });

    testWidgets('screen is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the ScrollView
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays help text when no QR data', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Generate a QR code first'), findsOneWidget);
    });

    testWidgets('section subtitles are present', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Choose a decorative frame'), findsOneWidget);
      expect(find.text('Personalize your QR code appearance'), findsOneWidget);
      expect(find.text('Save or share your customized QR code'), findsOneWidget);
    });

    testWidgets('export button exists', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Export QR Code'), findsOneWidget);
    });
  });
}
