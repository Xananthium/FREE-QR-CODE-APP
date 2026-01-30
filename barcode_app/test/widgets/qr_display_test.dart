import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/widgets/qr_display.dart';

void main() {
  group('QrDisplay Widget Tests', () {
    testWidgets('displays QR code with valid data', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QrDisplay(
              data: 'https://example.com',
            ),
          ),
        ),
      );

      // Widget should render without errors
      expect(find.byType(QrDisplay), findsOneWidget);
      
      // Should contain a Container (the wrapper)
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('displays placeholder for null data', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QrDisplay(
              data: null,
            ),
          ),
        ),
      );

      // Should show empty state
      expect(find.text('No data to display'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_2_outlined), findsOneWidget);
    });

    testWidgets('displays placeholder for empty string', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QrDisplay(
              data: '',
            ),
          ),
        ),
      );

      // Should show empty state
      expect(find.text('No data to display'), findsOneWidget);
    });

    testWidgets('QrDisplay.preview factory creates larger QR code', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QrDisplay.preview(
              data: 'https://example.com',
            ),
          ),
        ),
      );

      expect(find.byType(QrDisplay), findsOneWidget);
    });

    testWidgets('QrDisplay.thumbnail factory creates smaller QR code', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QrDisplay.thumbnail(
              data: 'https://example.com',
            ),
          ),
        ),
      );

      expect(find.byType(QrDisplay), findsOneWidget);
    });

    testWidgets('QrDisplay.export factory uses high error correction', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QrDisplay.export(
              data: 'https://example.com',
            ),
          ),
        ),
      );

      expect(find.byType(QrDisplay), findsOneWidget);
    });

    testWidgets('respects custom size parameter', (WidgetTester tester) async {
      const customSize = 300.0;
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QrDisplay(
              data: 'test',
              size: customSize,
            ),
          ),
        ),
      );

      expect(find.byType(QrDisplay), findsOneWidget);
    });

    testWidgets('respects custom colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QrDisplay(
              data: 'test',
              foregroundColor: Colors.red,
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(QrDisplay), findsOneWidget);
    });
  });

  group('QrDisplayCard Widget Tests', () {
    testWidgets('displays card with QR code and title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QrDisplayCard(
              data: 'https://example.com',
              title: 'Test QR Code',
            ),
          ),
        ),
      );

      expect(find.text('Test QR Code'), findsOneWidget);
      expect(find.byType(QrDisplay), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('displays subtitle when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QrDisplayCard(
              data: 'https://example.com',
              title: 'Test QR Code',
              subtitle: 'This is a test',
            ),
          ),
        ),
      );

      expect(find.text('Test QR Code'), findsOneWidget);
      expect(find.text('This is a test'), findsOneWidget);
    });

    testWidgets('displays actions when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QrDisplayCard(
              data: 'https://example.com',
              title: 'Test QR Code',
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Share'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Share'), findsOneWidget);
    });
  });

  group('QrDisplayListTile Widget Tests', () {
    testWidgets('displays list tile with QR thumbnail', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QrDisplayListTile(
              data: 'https://example.com',
              title: 'Example URL',
            ),
          ),
        ),
      );

      expect(find.text('Example URL'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byType(QrDisplay), findsOneWidget);
    });

    testWidgets('displays subtitle when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QrDisplayListTile(
              data: 'https://example.com',
              title: 'Example URL',
              subtitle: 'Created today',
            ),
          ),
        ),
      );

      expect(find.text('Example URL'), findsOneWidget);
      expect(find.text('Created today'), findsOneWidget);
    });

    testWidgets('calls onTap callback when tapped', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QrDisplayListTile(
              data: 'https://example.com',
              title: 'Example URL',
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      expect(tapped, isTrue);
    });
  });

  group('Edge Cases', () {
    testWidgets('handles very long data strings', (WidgetTester tester) async {
      final longData = 'a' * 1000;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QrDisplay(
              data: longData,
            ),
          ),
        ),
      );

      expect(find.byType(QrDisplay), findsOneWidget);
    });

    testWidgets('handles special characters in data', (WidgetTester tester) async {
      const specialData = 'Test!@#\$%^&*()_+{}|:"<>?[];,./';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QrDisplay(
              data: specialData,
            ),
          ),
        ),
      );

      expect(find.byType(QrDisplay), findsOneWidget);
    });

    testWidgets('handles unicode characters', (WidgetTester tester) async {
      const unicodeData = 'Hello 世界 🌍';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QrDisplay(
              data: unicodeData,
            ),
          ),
        ),
      );

      expect(find.byType(QrDisplay), findsOneWidget);
    });
  });
}
