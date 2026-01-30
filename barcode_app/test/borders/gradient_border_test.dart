import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/borders/borders/gradient_border.dart';

void main() {
  group('GradientBorder', () {
    test('creates border with required parameters', () {
      final border = GradientBorder(
        startColor: Colors.purple,
        endColor: Colors.blue,
      );

      expect(border.startColor, Colors.purple);
      expect(border.endColor, Colors.blue);
      expect(border.direction, GradientDirection.leftToRight);
      expect(border.middleColor, isNull);
    });

    test('creates border with all parameters', () {
      final border = GradientBorder(
        startColor: Colors.red,
        endColor: Colors.yellow,
        middleColor: Colors.orange,
        direction: GradientDirection.topToBottom,
        thickness: 6.0,
        padding: 20.0,
        cornerRadius: 12.0,
        hasShadow: true,
        shadowBlur: 8.0,
        shadowOpacity: 0.5,
      );

      expect(border.startColor, Colors.red);
      expect(border.endColor, Colors.yellow);
      expect(border.middleColor, Colors.orange);
      expect(border.direction, GradientDirection.topToBottom);
      expect(border.thickness, 6.0);
      expect(border.padding, 20.0);
      expect(border.cornerRadius, 12.0);
      expect(border.hasShadow, true);
      expect(border.shadowBlur, 8.0);
      expect(border.shadowOpacity, 0.5);
    });

    test('horizontal factory creates left-to-right gradient', () {
      final border = GradientBorder.horizontal(
        startColor: Colors.blue,
        endColor: Colors.green,
      );

      expect(border.direction, GradientDirection.leftToRight);
      expect(border.startColor, Colors.blue);
      expect(border.endColor, Colors.green);
    });

    test('vertical factory creates top-to-bottom gradient', () {
      final border = GradientBorder.vertical(
        startColor: Colors.blue,
        endColor: Colors.green,
      );

      expect(border.direction, GradientDirection.topToBottom);
      expect(border.startColor, Colors.blue);
      expect(border.endColor, Colors.green);
    });

    test('diagonal factory creates top-left to bottom-right gradient', () {
      final border = GradientBorder.diagonal(
        startColor: Colors.blue,
        endColor: Colors.green,
      );

      expect(border.direction, GradientDirection.topLeftToBottomRight);
      expect(border.startColor, Colors.blue);
      expect(border.endColor, Colors.green);
    });

    test('sunset preset has correct colors and direction', () {
      final border = GradientBorder.sunset();

      expect(border.startColor, const Color(0xFFFF6B6B));
      expect(border.endColor, const Color(0xFFFFE66D));
      expect(border.middleColor, const Color(0xFFFF8E53));
      expect(border.direction, GradientDirection.topLeftToBottomRight);
      expect(border.cornerRadius, 12.0);
    });

    test('ocean preset has correct colors and direction', () {
      final border = GradientBorder.ocean();

      expect(border.startColor, const Color(0xFF667EEA));
      expect(border.endColor, const Color(0xFF64B5F6));
      expect(border.direction, GradientDirection.topToBottom);
      expect(border.cornerRadius, 12.0);
    });

    test('aurora preset has correct colors', () {
      final border = GradientBorder.aurora();

      expect(border.startColor, const Color(0xFF667EEA));
      expect(border.endColor, const Color(0xFFEC4899));
      expect(border.direction, GradientDirection.leftToRight);
    });

    test('forest preset has correct colors', () {
      final border = GradientBorder.forest();

      expect(border.startColor, const Color(0xFF11998E));
      expect(border.endColor, const Color(0xFF38EF7D));
      expect(border.direction, GradientDirection.topLeftToBottomRight);
    });

    test('fire preset has correct colors and direction', () {
      final border = GradientBorder.fire();

      expect(border.startColor, const Color(0xFFF85032));
      expect(border.endColor, const Color(0xFFFBB034));
      expect(border.middleColor, const Color(0xFFFA6C2C));
      expect(border.direction, GradientDirection.bottomToTop);
    });

    test('name returns correct value', () {
      final border = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
      );

      expect(border.name, 'Gradient Border');
    });

    test('description returns correct value', () {
      final border = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
      );

      expect(border.description, 'Modern border with smooth color transitions');
    });

    test('copyWith creates new instance with updated values', () {
      final original = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
        thickness: 4.0,
      );

      final copied = original.copyWith(
        startColor: Colors.red,
        thickness: 8.0,
      );

      expect(copied.startColor, Colors.red);
      expect(copied.endColor, Colors.green); // Unchanged
      expect(copied.thickness, 8.0);
    });

    test('copyWith updates middle color', () {
      final original = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
      );

      final copied = original.copyWith(
        middleColor: Colors.yellow,
      );

      expect(copied.middleColor, Colors.yellow);
    });

    test('copyWith updates direction', () {
      final original = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
        direction: GradientDirection.leftToRight,
      );

      final copied = original.copyWith(
        direction: GradientDirection.topToBottom,
      );

      expect(copied.direction, GradientDirection.topToBottom);
    });

    test('equality works correctly', () {
      final border1 = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
        direction: GradientDirection.leftToRight,
      );

      final border2 = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
        direction: GradientDirection.leftToRight,
      );

      final border3 = GradientBorder(
        startColor: Colors.red,
        endColor: Colors.green,
        direction: GradientDirection.leftToRight,
      );

      expect(border1, equals(border2));
      expect(border1, isNot(equals(border3)));
    });

    test('hashCode works correctly', () {
      final border1 = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
      );

      final border2 = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
      );

      expect(border1.hashCode, border2.hashCode);
    });

    testWidgets('build returns CustomPaint with child', (tester) async {
      final border = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(
              const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('buildThumbnail returns widget with correct size',
        (tester) async {
      final border = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
      );

      const thumbnailSize = Size(100, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.buildThumbnail(thumbnailSize),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    test('supports all gradient directions', () {
      final directions = [
        GradientDirection.leftToRight,
        GradientDirection.rightToLeft,
        GradientDirection.topToBottom,
        GradientDirection.bottomToTop,
        GradientDirection.topLeftToBottomRight,
        GradientDirection.topRightToBottomLeft,
        GradientDirection.bottomLeftToTopRight,
        GradientDirection.bottomRightToTopLeft,
      ];

      for (final direction in directions) {
        final border = GradientBorder(
          startColor: Colors.blue,
          endColor: Colors.green,
          direction: direction,
        );

        expect(border.direction, direction);
      }
    });

    test('uses startColor as primary color', () {
      final border = GradientBorder(
        startColor: Colors.purple,
        endColor: Colors.blue,
      );

      expect(border.color, Colors.purple);
    });

    test('uses endColor as secondary color', () {
      final border = GradientBorder(
        startColor: Colors.purple,
        endColor: Colors.blue,
      );

      expect(border.secondaryColor, Colors.blue);
    });

    test('supports shadow configuration', () {
      final border = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
        hasShadow: true,
        shadowBlur: 10.0,
        shadowOpacity: 0.6,
      );

      expect(border.hasShadow, true);
      expect(border.shadowBlur, 10.0);
      expect(border.shadowOpacity, 0.6);
    });

    test('supports corner radius', () {
      final border = GradientBorder(
        startColor: Colors.blue,
        endColor: Colors.green,
        cornerRadius: 16.0,
      );

      expect(border.cornerRadius, 16.0);
    });

    test('all preset gradients have rounded corners by default', () {
      final presets = [
        GradientBorder.sunset(),
        GradientBorder.ocean(),
        GradientBorder.aurora(),
        GradientBorder.forest(),
        GradientBorder.fire(),
      ];

      for (final preset in presets) {
        expect(preset.cornerRadius, 12.0);
      }
    });

    test('preset gradients can override corner radius', () {
      final border = GradientBorder.sunset(cornerRadius: 20.0);
      expect(border.cornerRadius, 20.0);
    });

    test('preset gradients can override thickness', () {
      final border = GradientBorder.ocean(thickness: 8.0);
      expect(border.thickness, 8.0);
    });

    test('preset gradients can override padding', () {
      final border = GradientBorder.aurora(padding: 24.0);
      expect(border.padding, 24.0);
    });
  });

  group('GradientDirection', () {
    test('all directions are available', () {
      expect(GradientDirection.values.length, 8);
      expect(GradientDirection.values, contains(GradientDirection.leftToRight));
      expect(GradientDirection.values, contains(GradientDirection.rightToLeft));
      expect(GradientDirection.values, contains(GradientDirection.topToBottom));
      expect(GradientDirection.values, contains(GradientDirection.bottomToTop));
      expect(GradientDirection.values,
          contains(GradientDirection.topLeftToBottomRight));
      expect(GradientDirection.values,
          contains(GradientDirection.topRightToBottomLeft));
      expect(GradientDirection.values,
          contains(GradientDirection.bottomLeftToTopRight));
      expect(GradientDirection.values,
          contains(GradientDirection.bottomRightToTopLeft));
    });
  });
}
