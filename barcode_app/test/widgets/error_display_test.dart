import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/widgets/error_display.dart';

/// Comprehensive tests for error handling UI components
/// 
/// Verifies FLUTTER 9.4 acceptance criteria:
/// 1. Error snackbars work correctly
/// 2. Inline validation errors display properly  
/// 3. Retry options are available and functional
void main() {
  group('ACCEPTANCE CRITERIA 1: Error Snackbars', () {
    testWidgets('showError displays error snackbar with correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ErrorDisplay.showError(
                  context,
                  'Test error message',
                ),
                child: const Text('Show Error'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pumpAndSettle();

      expect(find.text('Test error message'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('showWarning displays warning snackbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ErrorDisplay.showWarning(
                  context,
                  'Low storage space',
                ),
                child: const Text('Show Warning'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Warning'));
      await tester.pumpAndSettle();

      expect(find.text('Low storage space'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
    });

    testWidgets('showSuccess displays success snackbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ErrorDisplay.showSuccess(
                  context,
                  'Operation successful!',
                ),
                child: const Text('Show Success'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pumpAndSettle();

      expect(find.text('Operation successful!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('showInfo displays info snackbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ErrorDisplay.showInfo(
                  context,
                  'Tap to view details',
                ),
                child: const Text('Show Info'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Info'));
      await tester.pumpAndSettle();

      expect(find.text('Tap to view details'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('snackbars clear previous ones when showing new ones', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () => ErrorDisplay.showError(context, 'First error'),
                    child: const Text('Error 1'),
                  ),
                  ElevatedButton(
                    onPressed: () => ErrorDisplay.showError(context, 'Second error'),
                    child: const Text('Error 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Error 1'));
      await tester.pumpAndSettle();
      expect(find.text('First error'), findsOneWidget);

      await tester.tap(find.text('Error 2'));
      await tester.pumpAndSettle();
      
      expect(find.text('Second error'), findsOneWidget);
      expect(find.text('First error'), findsNothing);
    });
  });

  group('ACCEPTANCE CRITERIA 2: Inline Validation Errors', () {
    testWidgets('ErrorCard displays inline error message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorCard(
              message: 'Failed to load data',
            ),
          ),
        ),
      );

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Failed to load data'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('ErrorBanner displays persistent inline error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorBanner(
              message: 'Connection lost',
            ),
          ),
        ),
      );

      expect(find.text('Connection lost'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('ErrorBanner and ErrorCard can coexist', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const ErrorBanner(message: 'Banner error'),
                const ErrorCard(message: 'Card error'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Banner error'), findsOneWidget);
      expect(find.text('Card error'), findsOneWidget);
    });
  });

  group('ACCEPTANCE CRITERIA 3: Retry Options', () {
    testWidgets('ErrorDisplay.showError supports retry action', (tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ErrorDisplay.showError(
                  context,
                  'Network error',
                  action: ErrorAction(
                    label: 'Retry',
                    onPressed: () => retryPressed = true,
                  ),
                ),
                child: const Text('Show Error'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      expect(retryPressed, isTrue);
    });

    testWidgets('ErrorCard supports retry button', (tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorCard(
              message: 'Failed to load data',
              onRetry: () => retryPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      await tester.tap(find.text('Retry'));
      expect(retryPressed, isTrue);
    });

    testWidgets('ErrorCard supports dismiss button', (tester) async {
      bool dismissPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorCard(
              message: 'Failed to load data',
              onRetry: () {},
              onDismiss: () => dismissPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Dismiss'), findsOneWidget);

      await tester.tap(find.text('Dismiss'));
      expect(dismissPressed, isTrue);
    });

    testWidgets('ErrorBanner supports retry button', (tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorBanner(
              message: 'Connection lost',
              onRetry: () => retryPressed = true,
            ),
          ),
        ),
      );

      final retryButton = find.widgetWithIcon(IconButton, Icons.refresh);
      expect(retryButton, findsOneWidget);

      await tester.tap(retryButton);
      expect(retryPressed, isTrue);
    });

    testWidgets('ErrorBanner supports dismiss button', (tester) async {
      bool dismissPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorBanner(
              message: 'Connection lost',
              onDismiss: () => dismissPressed = true,
            ),
          ),
        ),
      );

      final dismissButton = find.widgetWithIcon(IconButton, Icons.close);
      expect(dismissButton, findsOneWidget);

      await tester.tap(dismissButton);
      expect(dismissPressed, isTrue);
    });

    testWidgets('ErrorStateWidget supports retry button', (tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              title: 'Failed to Load',
              message: 'Please try again',
              onRetry: () => retryPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      expect(retryPressed, isTrue);
    });

    testWidgets('NetworkErrorWidget supports retry', (tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkErrorWidget(
              onRetry: () => retryPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Try Again'));
      expect(retryPressed, isTrue);
    });

    testWidgets('LoadingErrorWidget supports retry', (tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingErrorWidget(
              onRetry: () => retryPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Try Again'));
      expect(retryPressed, isTrue);
    });

    testWidgets('RetryButton shows loading state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryButton(
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.text('Retrying...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Full-Screen Error States', () {
    testWidgets('ErrorStateWidget displays correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              title: 'Failed to Load',
              message: 'Please try again later',
            ),
          ),
        ),
      );

      expect(find.text('Failed to Load'), findsOneWidget);
      expect(find.text('Please try again later'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('NetworkErrorWidget displays correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NetworkErrorWidget(),
          ),
        ),
      );

      expect(find.text('No Internet Connection'), findsOneWidget);
      expect(find.text('Please check your connection and try again.'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_outlined), findsOneWidget);
    });

    testWidgets('LoadingErrorWidget displays correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingErrorWidget(),
          ),
        ),
      );

      expect(find.text('Failed to Load'), findsOneWidget);
      expect(find.text('Something went wrong. Please try again.'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    });

    testWidgets('LoadingErrorWidget supports custom message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingErrorWidget(
              message: 'Failed to load QR codes',
            ),
          ),
        ),
      );

      expect(find.text('Failed to load QR codes'), findsOneWidget);
    });
  });

  group('Theme Adaptation', () {
    testWidgets('Components adapt to light theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: ErrorCard(message: 'Test error'),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, isNotNull);
    });

    testWidgets('Components adapt to dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: ErrorCard(message: 'Test error'),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, isNotNull);
    });
  });

  group('Customization', () {
    testWidgets('ErrorStateWidget supports custom retry label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              title: 'Failed',
              message: 'Error occurred',
              onRetry: () {},
              retryLabel: 'Reload',
            ),
          ),
        ),
      );

      expect(find.text('Reload'), findsOneWidget);
    });

    testWidgets('ErrorStateWidget supports custom icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              title: 'Not Found',
              message: 'Page does not exist',
              icon: Icons.search_off,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('RetryButton supports custom label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryButton(
              onPressed: () {},
              label: 'Reload',
            ),
          ),
        ),
      );

      expect(find.text('Reload'), findsOneWidget);
    });
  });
}
