import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/widgets/empty_state.dart';

void main() {
  group('EmptyState Widget Tests', () {
    testWidgets('EmptyState displays title and message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.qr_code_2_outlined,
              title: 'Test Title',
              message: 'Test Message',
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_2_outlined), findsOneWidget);
    });

    testWidgets('EmptyState.noQrCode shows correct content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noQrCode(),
          ),
        ),
      );

      expect(find.text('No QR Code Yet'), findsOneWidget);
      expect(find.text('Select a type from the home screen to create your first QR code'), findsOneWidget);
    });

    testWidgets('EmptyState with action button calls callback', (WidgetTester tester) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.qr_code_2_outlined,
              title: 'Test',
              message: 'Test Message',
              actionLabel: 'Action',
              onActionPressed: () {
                callbackCalled = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Action'), findsOneWidget);
      
      await tester.tap(find.text('Action'));
      await tester.pump();

      expect(callbackCalled, isTrue);
    });

    testWidgets('EmptyState without action button does not show button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.qr_code_2_outlined,
              title: 'Test',
              message: 'Test Message',
            ),
          ),
        ),
      );

      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('EmptyState animation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.qr_code_2_outlined,
              title: 'Test',
              message: 'Test Message',
              animate: true,
            ),
          ),
        ),
      );

      // Initial state
      await tester.pump();
      
      // Animation in progress
      await tester.pump(const Duration(milliseconds: 400));
      
      // Animation complete
      await tester.pump(const Duration(milliseconds: 400));
      
      expect(find.byIcon(Icons.qr_code_2_outlined), findsOneWidget);
    });

    testWidgets('CompactEmptyState displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactEmptyState(
              icon: Icons.search_off_outlined,
              message: 'No results',
            ),
          ),
        ),
      );

      expect(find.text('No results'), findsOneWidget);
      expect(find.byIcon(Icons.search_off_outlined), findsOneWidget);
    });

    testWidgets('EmptyState.noHistory factory works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noHistory(),
          ),
        ),
      );

      expect(find.text('No History'), findsOneWidget);
      expect(find.byIcon(Icons.history_outlined), findsOneWidget);
    });

    testWidgets('EmptyState.noScans factory works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noScans(),
          ),
        ),
      );

      expect(find.text('No Scans Yet'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_outlined), findsOneWidget);
    });

    testWidgets('EmptyState.noFavorites factory works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noFavorites(),
          ),
        ),
      );

      expect(find.text('No Favorites'), findsOneWidget);
      expect(find.byIcon(Icons.star_border_outlined), findsOneWidget);
    });

    testWidgets('EmptyState.noResults factory works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noResults(searchQuery: 'test'),
          ),
        ),
      );

      expect(find.text('No Results Found'), findsOneWidget);
      expect(find.textContaining('test'), findsOneWidget);
    });

    testWidgets('EmptyState.networkError factory works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.networkError(),
          ),
        ),
      );

      expect(find.text('Connection Error'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_outlined), findsOneWidget);
    });

    testWidgets('EmptyState.error factory works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.error(errorMessage: 'Custom error'),
          ),
        ),
      );

      expect(find.text('Something Went Wrong'), findsOneWidget);
      expect(find.text('Custom error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
