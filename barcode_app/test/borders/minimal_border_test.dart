import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/borders/borders/minimal_border.dart';

void main() {
  group('MinimalBorder', () {
    test('creates with default values', () {
      const border = MinimalBorder(color: Colors.black);

      expect(border.color, Colors.black);
      expect(border.thickness, 1.5);
      expect(border.padding, 32.0);
      expect(border.cornerRadius, 8.0);
      expect(border.hasShadow, false);
      expect(border.secondaryColor, isNull);
      expect(border.patternSpacing, isNull);
      expect(border.patternSize, isNull);
    });

    test('creates with custom values', () {
      const border = MinimalBorder(
        color: Colors.blue,
        thickness: 2.0,
        padding: 24.0,
        cornerRadius: 12.0,
      );

      expect(border.color, Colors.blue);
      expect(border.thickness, 2.0);
      expect(border.padding, 24.0);
      expect(border.cornerRadius, 12.0);
    });

    test('always has hasShadow false', () {
      const border = MinimalBorder(color: Colors.red);
      expect(border.hasShadow, false);
    });

    test('name is correct', () {
      const border = MinimalBorder(color: Colors.black);
      expect(border.name, 'Minimal Border');
    });

    test('description is correct', () {
      const border = MinimalBorder(color: Colors.black);
      expect(border.description, 'Clean, thin modern border with generous padding');
    });

    test('copyWith creates new instance with updated values', () {
      const original = MinimalBorder(
        color: Colors.black,
        thickness: 1.5,
        padding: 32.0,
        cornerRadius: 8.0,
      );

      final copied = original.copyWith(
        color: Colors.blue,
        thickness: 2.0,
      );

      expect(copied.color, Colors.blue);
      expect(copied.thickness, 2.0);
      expect(copied.padding, 32.0); // Unchanged
      expect(copied.cornerRadius, 8.0); // Unchanged
    });

    test('copyWith with no parameters returns equivalent border', () {
      const original = MinimalBorder(color: Colors.black);
      final copied = original.copyWith();

      expect(copied.color, original.color);
      expect(copied.thickness, original.thickness);
      expect(copied.padding, original.padding);
      expect(copied.cornerRadius, original.cornerRadius);
    });

    test('equality works correctly', () {
      const border1 = MinimalBorder(
        color: Colors.black,
        thickness: 1.5,
        padding: 32.0,
        cornerRadius: 8.0,
      );
      const border2 = MinimalBorder(
        color: Colors.black,
        thickness: 1.5,
        padding: 32.0,
        cornerRadius: 8.0,
      );
      const border3 = MinimalBorder(
        color: Colors.blue,
        thickness: 1.5,
        padding: 32.0,
        cornerRadius: 8.0,
      );

      expect(border1, equals(border2));
      expect(border1, isNot(equals(border3)));
    });

    test('hashCode is consistent', () {
      const border1 = MinimalBorder(color: Colors.black);
      const border2 = MinimalBorder(color: Colors.black);

      expect(border1.hashCode, equals(border2.hashCode));
    });

    test('toString contains relevant information', () {
      const border = MinimalBorder(
        color: Colors.black,
        thickness: 1.5,
        padding: 32.0,
      );

      final str = border.toString();
      expect(str, contains('Minimal Border'));
      expect(str, contains('1.5'));
      expect(str, contains('32.0'));
    });

    testWidgets('build creates widget with padding', (tester) async {
      const border = MinimalBorder(
        color: Colors.black,
        thickness: 1.5,
        padding: 32.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(
              Container(
                width: 100,
                height: 100,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      // Verify CustomPaint is present (may be multiple in tree)
      expect(find.byType(CustomPaint), findsWidgets);

      // Verify Padding is present with correct values
      final paddingFinder = find.byType(Padding);
      expect(paddingFinder, findsWidgets);
      
      // Find the padding widget with our specific value
      bool foundCorrectPadding = false;
      for (final element in paddingFinder.evaluate()) {
        final widget = element.widget as Padding;
        if (widget.padding == const EdgeInsets.all(33.5)) { // 32 + 1.5
          foundCorrectPadding = true;
          break;
        }
      }
      expect(foundCorrectPadding, isTrue, reason: 'Should find padding with value 33.5');
    });

    testWidgets('buildThumbnail creates preview widget', (tester) async {
      const border = MinimalBorder(color: Colors.black);
      const size = Size(100, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.buildThumbnail(size),
          ),
        ),
      );

      // Verify CustomPaint and Container are present
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(Container), findsWidgets);
    });

    test('minimal thickness is visible but thin', () {
      const border = MinimalBorder(color: Colors.black);
      expect(border.thickness, lessThan(3.0));
      expect(border.thickness, greaterThan(1.0));
    });

    test('padding is generous (large)', () {
      const border = MinimalBorder(color: Colors.black);
      expect(border.padding, greaterThanOrEqualTo(24.0));
    });

    test('corner radius is subtle', () {
      const border = MinimalBorder(color: Colors.black);
      expect(border.cornerRadius, greaterThan(0));
      expect(border.cornerRadius, lessThan(16.0));
    });

    test('works with dark mode colors', () {
      const lightBorder = MinimalBorder(color: Colors.black87);
      const darkBorder = MinimalBorder(color: Colors.white70);

      expect(lightBorder.color.opacity, greaterThan(0.8));
      expect(darkBorder.color.opacity, greaterThan(0.6));
    });

    test('sharp corners when cornerRadius is 0', () {
      const border = MinimalBorder(
        color: Colors.black,
        cornerRadius: 0.0,
      );

      expect(border.cornerRadius, 0.0);
    });

    test('accepts various thicknesses', () {
      const ultraThin = MinimalBorder(color: Colors.black, thickness: 0.5);
      const thin = MinimalBorder(color: Colors.black, thickness: 1.0);
      const standard = MinimalBorder(color: Colors.black, thickness: 1.5);
      const thick = MinimalBorder(color: Colors.black, thickness: 2.0);

      expect(ultraThin.thickness, 0.5);
      expect(thin.thickness, 1.0);
      expect(standard.thickness, 1.5);
      expect(thick.thickness, 2.0);
    });

    test('accepts various padding values', () {
      const compact = MinimalBorder(color: Colors.black, padding: 16.0);
      const standard = MinimalBorder(color: Colors.black, padding: 32.0);
      const generous = MinimalBorder(color: Colors.black, padding: 48.0);

      expect(compact.padding, 16.0);
      expect(standard.padding, 32.0);
      expect(generous.padding, 48.0);
    });

    test('accepts various corner radius values', () {
      const sharp = MinimalBorder(color: Colors.black, cornerRadius: 0.0);
      const subtle = MinimalBorder(color: Colors.black, cornerRadius: 8.0);
      const rounded = MinimalBorder(color: Colors.black, cornerRadius: 16.0);

      expect(sharp.cornerRadius, 0.0);
      expect(subtle.cornerRadius, 8.0);
      expect(rounded.cornerRadius, 16.0);
    });
  });

  group('MinimalBorder Design Principles', () {
    test('embodies minimal aesthetic', () {
      const border = MinimalBorder(color: Colors.black);

      // Minimal = thin line
      expect(border.thickness, lessThanOrEqualTo(2.0));

      // Minimal = large padding (breathing room)
      expect(border.padding, greaterThanOrEqualTo(24.0));

      // Minimal = no shadow
      expect(border.hasShadow, false);

      // Minimal = no secondary color
      expect(border.secondaryColor, isNull);

      // Minimal = no patterns
      expect(border.patternSpacing, isNull);
      expect(border.patternSize, isNull);
    });

    test('modern aesthetic with subtle radius', () {
      const border = MinimalBorder(color: Colors.black);

      // Modern = subtle corner radius (not sharp, not too round)
      expect(border.cornerRadius, greaterThan(0));
      expect(border.cornerRadius, lessThanOrEqualTo(12.0));
    });

    test('professional and clean', () {
      const border = MinimalBorder(color: Colors.black87);

      // Professional = visible but not bold
      expect(border.thickness, lessThan(2.5));

      // Clean = single color, no effects
      expect(border.secondaryColor, isNull);
      expect(border.hasShadow, false);
    });
  });
}
