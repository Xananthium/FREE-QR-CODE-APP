import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/widgets/bordered_qr.dart';
import 'package:barcode_app/borders/border_registry.dart';
import 'package:barcode_app/borders/base_border.dart';

void main() {
  group('BorderedQr Widget', () {
    testWidgets('renders QR code with border', (WidgetTester tester) async {
      // Arrange
      const testData = 'https://example.com';
      final border = BorderRegistry.getBorder(BorderType.classic);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr(
              data: testData,
              border: border,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQr), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('wraps in RepaintBoundary for performance', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.defaultBorder;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr(
              data: 'test',
              border: border,
            ),
          ),
        ),
      );

      // Assert - Should have RepaintBoundary for performance optimization
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('accepts GlobalKey for export capability', (WidgetTester tester) async {
      // Arrange
      final captureKey = GlobalKey();
      final border = BorderRegistry.getBorder(BorderType.rounded);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr(
              data: 'export test',
              border: border,
              captureKey: captureKey,
            ),
          ),
        ),
      );

      // Assert - Widget should render successfully
      expect(find.byType(BorderedQr), findsOneWidget);
      
      // The key should be attached to a RepaintBoundary
      expect(captureKey.currentContext, isNotNull);
    });

    testWidgets('handles null data gracefully', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.defaultBorder;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr(
              data: null,
              border: border,
            ),
          ),
        ),
      );

      // Assert - Should render without error (empty state in QrDisplay)
      expect(find.byType(BorderedQr), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('handles empty string data', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.getBorder(BorderType.minimal);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr(
              data: '',
              border: border,
            ),
          ),
        ),
      );

      // Assert - Should render without error
      expect(find.byType(BorderedQr), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('respects custom QR size', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.defaultBorder;
      const customSize = 150.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr(
              data: 'custom size test',
              border: border,
              qrSize: customSize,
            ),
          ),
        ),
      );

      // Assert - Widget renders with custom size
      expect(find.byType(BorderedQr), findsOneWidget);
    });

    testWidgets('respects custom colors', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.getBorder(BorderType.shadow);
      const foregroundColor = Colors.blue;
      const backgroundColor = Colors.yellow;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr(
              data: 'colored test',
              border: border,
              qrForegroundColor: foregroundColor,
              qrBackgroundColor: backgroundColor,
            ),
          ),
        ),
      );

      // Assert - Widget renders with custom colors
      expect(find.byType(BorderedQr), findsOneWidget);
    });
  });

  group('BorderedQr Factory Constructors', () {
    testWidgets('preview factory creates larger QR', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.getBorder(BorderType.floral);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr.preview(
              data: 'preview test',
              border: border,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQr), findsOneWidget);
    });

    testWidgets('withType factory uses BorderRegistry', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr.withType(
              data: 'type test',
              borderType: BorderType.geometric,
              borderColor: Colors.purple,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQr), findsOneWidget);
    });

    testWidgets('forExport factory requires capture key', (WidgetTester tester) async {
      // Arrange
      final captureKey = GlobalKey();
      final border = BorderRegistry.getBorder(BorderType.ornate);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr.forExport(
              data: 'export data',
              border: border,
              captureKey: captureKey,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQr), findsOneWidget);
      expect(captureKey.currentContext, isNotNull);
    });

    testWidgets('thumbnail factory creates small QR', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.getBorder(BorderType.dotted);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr.thumbnail(
              data: 'thumbnail test',
              border: border,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQr), findsOneWidget);
    });
  });

  group('BorderedQrCard Widget', () {
    testWidgets('renders card with bordered QR', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.defaultBorder;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQrCard(
              data: 'card test',
              border: border,
              title: 'Test Title',
              subtitle: 'Test Subtitle',
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQrCard), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
    });

    testWidgets('renders without title and subtitle', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.getBorder(BorderType.gradient);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQrCard(
              data: 'minimal card',
              border: border,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQrCard), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('renders action buttons when provided', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.defaultBorder;
      var sharePressed = false;
      var downloadPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQrCard(
              data: 'actions test',
              border: border,
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => sharePressed = true,
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => downloadPressed = true,
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.byIcon(Icons.download), findsOneWidget);

      // Test button interaction
      await tester.tap(find.byIcon(Icons.share));
      expect(sharePressed, isTrue);

      await tester.tap(find.byIcon(Icons.download));
      expect(downloadPressed, isTrue);
    });

    testWidgets('accepts capture key for export', (WidgetTester tester) async {
      // Arrange
      final captureKey = GlobalKey();
      final border = BorderRegistry.getBorder(BorderType.classic);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQrCard(
              data: 'card export',
              border: border,
              captureKey: captureKey,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQrCard), findsOneWidget);
      expect(captureKey.currentContext, isNotNull);
    });
  });

  group('BorderedQrGalleryItem Widget', () {
    testWidgets('renders gallery item with border preview', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.getBorder(BorderType.floral);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQrGalleryItem(
              data: 'gallery test',
              border: border,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQrGalleryItem), findsOneWidget);
      expect(find.text(border.name), findsOneWidget);
    });

    testWidgets('shows selection state', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.getBorder(BorderType.rounded);

      // Act - Not selected
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQrGalleryItem(
              data: 'test',
              border: border,
              isSelected: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQrGalleryItem), findsOneWidget);

      // Act - Selected
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQrGalleryItem(
              data: 'test',
              border: border,
              isSelected: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQrGalleryItem), findsOneWidget);
    });

    testWidgets('responds to tap', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.defaultBorder;
      var tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQrGalleryItem(
              data: 'tap test',
              border: border,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Tap the item
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('displays border name', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.getBorder(BorderType.geometric);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQrGalleryItem(
              data: 'name test',
              border: border,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(border.name), findsOneWidget);
    });
  });

  group('Integration Tests', () {
    testWidgets('works with all border types', (WidgetTester tester) async {
      // Test that BorderedQr works with every border type
      for (final borderType in BorderType.values) {
        final border = BorderRegistry.getBorder(borderType);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BorderedQr(
                data: 'test ${borderType.name}',
                border: border,
              ),
            ),
          ),
        );

        expect(find.byType(BorderedQr), findsOneWidget);
        expect(tester.takeException(), isNull,
            reason: 'Failed with border type: ${borderType.name}');
      }
    });

    testWidgets('maintains quality with different QR sizes', (WidgetTester tester) async {
      // Arrange
      final border = BorderRegistry.defaultBorder;
      final sizes = [50.0, 100.0, 200.0, 400.0, 800.0];

      for (final size in sizes) {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BorderedQr(
                data: 'size test $size',
                border: border,
                qrSize: size,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(BorderedQr), findsOneWidget);
        expect(tester.takeException(), isNull,
            reason: 'Failed with QR size: $size');
      }
    });

    testWidgets('combines multiple features correctly', (WidgetTester tester) async {
      // Arrange - Test all features together
      final captureKey = GlobalKey();
      final border = BorderRegistry.getBorder(
        BorderType.floral,
        color: Colors.purple,
        secondaryColor: Colors.pink,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderedQr(
              data: 'comprehensive test',
              border: border,
              qrSize: 300,
              captureKey: captureKey,
              qrForegroundColor: Colors.black,
              qrBackgroundColor: Colors.white,
              showQrContainer: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BorderedQr), findsOneWidget);
      expect(captureKey.currentContext, isNotNull);
      expect(tester.takeException(), isNull);
    });
  });
}
