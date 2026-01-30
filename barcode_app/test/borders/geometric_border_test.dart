import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/borders/borders/geometric_border.dart';
import 'package:barcode_app/borders/base_border.dart';

void main() {
  group('GeometricBorder', () {
    test('creates border with default values', () {
      const border = GeometricBorder(color: Colors.blue);

      expect(border.color, Colors.blue);
      expect(border.secondaryColor, isNull);
      expect(border.patternType, GeometricPattern.triangles);
      expect(border.thickness, 3.0);
      expect(border.padding, 20.0);
      expect(border.cornerRadius, 8.0);
      expect(border.patternSize, 12.0);
      expect(border.patternSpacing, 4.0);
      expect(border.hasShadow, false);
    });

    test('creates border with custom values', () {
      const border = GeometricBorder(
        color: Colors.red,
        secondaryColor: Colors.orange,
        patternType: GeometricPattern.hexagons,
        thickness: 5.0,
        padding: 24.0,
        cornerRadius: 12.0,
        patternSize: 16.0,
        patternSpacing: 6.0,
        hasShadow: true,
        shadowBlur: 8.0,
        shadowOpacity: 0.5,
      );

      expect(border.color, Colors.red);
      expect(border.secondaryColor, Colors.orange);
      expect(border.patternType, GeometricPattern.hexagons);
      expect(border.thickness, 5.0);
      expect(border.padding, 24.0);
      expect(border.cornerRadius, 12.0);
      expect(border.patternSize, 16.0);
      expect(border.patternSpacing, 6.0);
      expect(border.hasShadow, true);
      expect(border.shadowBlur, 8.0);
      expect(border.shadowOpacity, 0.5);
    });

    test('has correct name and description', () {
      const border = GeometricBorder(
        color: Colors.blue,
        patternType: GeometricPattern.triangles,
      );

      expect(border.name, 'Geometric Border');
      expect(border.description, contains('triangles'));
    });

    test('description changes based on pattern type', () {
      const triangleBorder = GeometricBorder(
        color: Colors.blue,
        patternType: GeometricPattern.triangles,
      );
      const hexagonBorder = GeometricBorder(
        color: Colors.blue,
        patternType: GeometricPattern.hexagons,
      );
      const diamondBorder = GeometricBorder(
        color: Colors.blue,
        patternType: GeometricPattern.diamonds,
      );

      expect(triangleBorder.description, contains('triangles'));
      expect(hexagonBorder.description, contains('hexagons'));
      expect(diamondBorder.description, contains('diamonds'));
    });

    test('copyWith creates new instance with updated values', () {
      const original = GeometricBorder(
        color: Colors.blue,
        patternType: GeometricPattern.triangles,
        thickness: 3.0,
      );

      final updated = original.copyWith(
        color: Colors.red,
        patternType: GeometricPattern.hexagons,
      );

      expect(updated.color, Colors.red);
      expect(updated.patternType, GeometricPattern.hexagons);
      expect(updated.thickness, 3.0); // Unchanged
    });

    test('copyWith preserves original when no values provided', () {
      const original = GeometricBorder(
        color: Colors.blue,
        secondaryColor: Colors.lightBlue,
        patternType: GeometricPattern.diamonds,
      );

      final copy = original.copyWith();

      expect(copy.color, original.color);
      expect(copy.secondaryColor, original.secondaryColor);
      expect(copy.patternType, original.patternType);
    });

    test('equality works correctly', () {
      const border1 = GeometricBorder(
        color: Colors.blue,
        patternType: GeometricPattern.triangles,
      );
      const border2 = GeometricBorder(
        color: Colors.blue,
        patternType: GeometricPattern.triangles,
      );
      const border3 = GeometricBorder(
        color: Colors.red,
        patternType: GeometricPattern.triangles,
      );

      expect(border1, equals(border2));
      expect(border1, isNot(equals(border3)));
    });

    test('hashCode works correctly', () {
      const border1 = GeometricBorder(
        color: Colors.blue,
        patternType: GeometricPattern.hexagons,
      );
      const border2 = GeometricBorder(
        color: Colors.blue,
        patternType: GeometricPattern.hexagons,
      );

      expect(border1.hashCode, equals(border2.hashCode));
    });

    test('is a DecorativeBorder', () {
      const border = GeometricBorder(color: Colors.blue);
      expect(border, isA<DecorativeBorder>());
    });

    testWidgets('build returns CustomPaint widget', (tester) async {
      const border = GeometricBorder(color: Colors.blue);
      final child = Container(
        width: 100,
        height: 100,
        color: Colors.white,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(child),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('buildThumbnail creates thumbnail widget', (tester) async {
      const border = GeometricBorder(color: Colors.blue);
      const size = Size(100, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.buildThumbnail(size),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
    });

    group('GeometricPattern enum', () {
      test('has correct display names', () {
        expect(GeometricPattern.triangles.displayName, 'triangles');
        expect(GeometricPattern.hexagons.displayName, 'hexagons');
        expect(GeometricPattern.diamonds.displayName, 'diamonds');
        expect(GeometricPattern.circles.displayName, 'circles');
      });

      test('has all expected values', () {
        expect(GeometricPattern.values.length, 4);
        expect(GeometricPattern.values, contains(GeometricPattern.triangles));
        expect(GeometricPattern.values, contains(GeometricPattern.hexagons));
        expect(GeometricPattern.values, contains(GeometricPattern.diamonds));
        expect(GeometricPattern.values, contains(GeometricPattern.circles));
      });
    });

    testWidgets('renders with different pattern types', (tester) async {
      final patterns = [
        GeometricPattern.triangles,
        GeometricPattern.hexagons,
        GeometricPattern.diamonds,
        GeometricPattern.circles,
      ];

      for (final pattern in patterns) {
        final border = GeometricBorder(
          color: Colors.blue,
          patternType: pattern,
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

        expect(find.byType(CustomPaint), findsWidgets,
            reason: 'Pattern $pattern should render');
      }
    });

    testWidgets('applies padding correctly', (tester) async {
      const customPadding = 30.0;
      const customThickness = 5.0;
      const border = GeometricBorder(
        color: Colors.blue,
        padding: customPadding,
        thickness: customThickness,
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

      final paddingWidget = tester.widget<Padding>(find.byType(Padding));
      expect(
        paddingWidget.padding,
        equals(const EdgeInsets.all(customPadding + customThickness)),
      );
    });

    test('supports alternating colors with secondary color', () {
      const border = GeometricBorder(
        color: Colors.blue,
        secondaryColor: Colors.lightBlue,
        patternType: GeometricPattern.triangles,
      );

      expect(border.secondaryColor, Colors.lightBlue);
    });

    test('works without secondary color', () {
      const border = GeometricBorder(
        color: Colors.blue,
        patternType: GeometricPattern.hexagons,
      );

      expect(border.secondaryColor, isNull);
    });

    testWidgets('renders with shadow when enabled', (tester) async {
      const border = GeometricBorder(
        color: Colors.blue,
        hasShadow: true,
        shadowBlur: 10.0,
        shadowOpacity: 0.4,
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

      expect(find.byType(CustomPaint), findsWidgets);
    });

    test('maintains immutability', () {
      const border = GeometricBorder(color: Colors.blue);
      
      // Verify all fields are final (compile-time check)
      expect(border.color, Colors.blue);
      
      // copyWith should return new instance
      final modified = border.copyWith(color: Colors.red);
      expect(modified, isNot(same(border)));
      expect(border.color, Colors.blue); // Original unchanged
      expect(modified.color, Colors.red); // New instance changed
    });

    test('all pattern types are accounted for', () {
      // Ensure we have a border for each pattern type
      for (final pattern in GeometricPattern.values) {
        final border = GeometricBorder(
          color: Colors.blue,
          patternType: pattern,
        );
        expect(border.patternType, pattern);
        expect(border.description, contains(pattern.displayName));
      }
    });

    test('pattern size and spacing can be customized', () {
      const border = GeometricBorder(
        color: Colors.blue,
        patternSize: 20.0,
        patternSpacing: 8.0,
      );

      expect(border.patternSize, 20.0);
      expect(border.patternSpacing, 8.0);
    });

    test('corner radius can be customized', () {
      const border = GeometricBorder(
        color: Colors.blue,
        cornerRadius: 16.0,
      );

      expect(border.cornerRadius, 16.0);
    });

    test('shadow properties can be customized', () {
      const border = GeometricBorder(
        color: Colors.blue,
        hasShadow: true,
        shadowBlur: 12.0,
        shadowOpacity: 0.6,
      );

      expect(border.hasShadow, true);
      expect(border.shadowBlur, 12.0);
      expect(border.shadowOpacity, 0.6);
    });
  });
}
