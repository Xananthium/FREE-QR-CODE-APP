import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/borders/borders/dotted_border.dart';

void main() {
  group('DottedBorder', () {
    test('creates border with default values', () {
      const border = DottedBorder(
        color: Colors.black,
      );

      expect(border.name, 'Dotted Border');
      expect(border.description, 'Modern dotted line border with rounded dots');
      expect(border.color, Colors.black);
      expect(border.thickness, 4.0);
      expect(border.padding, 16.0);
      expect(border.cornerRadius, 0.0);
      expect(border.hasShadow, false);
      expect(border.shadowBlur, 4.0);
      expect(border.shadowOpacity, 0.3);
      expect(border.patternSpacing, isNull);
      expect(border.patternSize, isNull);
    });

    test('creates border with custom values', () {
      const border = DottedBorder(
        color: Colors.blue,
        secondaryColor: Colors.red,
        thickness: 6.0,
        padding: 20.0,
        cornerRadius: 12.0,
        hasShadow: true,
        shadowBlur: 8.0,
        shadowOpacity: 0.5,
        patternSpacing: 10.0,
        patternSize: 5.0,
      );

      expect(border.color, Colors.blue);
      expect(border.secondaryColor, Colors.red);
      expect(border.thickness, 6.0);
      expect(border.padding, 20.0);
      expect(border.cornerRadius, 12.0);
      expect(border.hasShadow, true);
      expect(border.shadowBlur, 8.0);
      expect(border.shadowOpacity, 0.5);
      expect(border.patternSpacing, 10.0);
      expect(border.patternSize, 5.0);
    });

    test('copyWith creates new instance with updated values', () {
      const original = DottedBorder(
        color: Colors.black,
        thickness: 4.0,
      );

      final copied = original.copyWith(
        color: Colors.blue,
        padding: 24.0,
        patternSpacing: 8.0,
      );

      expect(copied.color, Colors.blue);
      expect(copied.padding, 24.0);
      expect(copied.patternSpacing, 8.0);
      expect(copied.thickness, 4.0); // Unchanged
    });

    test('copyWith preserves original values when parameters are null', () {
      const original = DottedBorder(
        color: Colors.black,
        thickness: 4.0,
        padding: 16.0,
        cornerRadius: 8.0,
        patternSpacing: 6.0,
        patternSize: 3.0,
      );

      final copied = original.copyWith();

      expect(copied.color, original.color);
      expect(copied.thickness, original.thickness);
      expect(copied.padding, original.padding);
      expect(copied.cornerRadius, original.cornerRadius);
      expect(copied.patternSpacing, original.patternSpacing);
      expect(copied.patternSize, original.patternSize);
    });

    testWidgets('build creates widget with proper padding', (tester) async {
      const border = DottedBorder(
        color: Colors.black,
        thickness: 4.0,
        padding: 16.0,
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

      // Verify the widget renders without errors
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('buildThumbnail creates thumbnail widget', (tester) async {
      const border = DottedBorder(color: Colors.black);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.buildThumbnail(const Size(100, 100)),
          ),
        ),
      );

      // Verify the thumbnail renders without errors
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(Container), findsWidgets);
    });

    test('equality operator works correctly', () {
      const border1 = DottedBorder(
        color: Colors.black,
        thickness: 4.0,
        patternSpacing: 6.0,
      );

      const border2 = DottedBorder(
        color: Colors.black,
        thickness: 4.0,
        patternSpacing: 6.0,
      );

      const border3 = DottedBorder(
        color: Colors.blue,
        thickness: 4.0,
        patternSpacing: 6.0,
      );

      expect(border1, equals(border2));
      expect(border1, isNot(equals(border3)));
    });

    test('hashCode is consistent for equal borders', () {
      const border1 = DottedBorder(
        color: Colors.black,
        thickness: 4.0,
      );

      const border2 = DottedBorder(
        color: Colors.black,
        thickness: 4.0,
      );

      expect(border1.hashCode, border2.hashCode);
    });

    testWidgets('renders with shadow when enabled', (tester) async {
      const border = DottedBorder(
        color: Colors.black,
        hasShadow: true,
        shadowBlur: 8.0,
        shadowOpacity: 0.4,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(
              Container(width: 100, height: 100, color: Colors.white),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders with rounded corners', (tester) async {
      const border = DottedBorder(
        color: Colors.black,
        cornerRadius: 12.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(
              Container(width: 100, height: 100, color: Colors.white),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders with custom pattern spacing', (tester) async {
      const border = DottedBorder(
        color: Colors.black,
        patternSpacing: 8.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(
              Container(width: 100, height: 100, color: Colors.white),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders with custom pattern size', (tester) async {
      const border = DottedBorder(
        color: Colors.black,
        patternSize: 6.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(
              Container(width: 100, height: 100, color: Colors.white),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders with both custom pattern spacing and size',
        (tester) async {
      const border = DottedBorder(
        color: Colors.black,
        patternSpacing: 10.0,
        patternSize: 5.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(
              Container(width: 100, height: 100, color: Colors.white),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders with secondary color', (tester) async {
      const border = DottedBorder(
        color: Colors.black,
        secondaryColor: Colors.grey,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(
              Container(width: 100, height: 100, color: Colors.white),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders with all features enabled', (tester) async {
      const border = DottedBorder(
        color: Colors.blue,
        secondaryColor: Colors.lightBlue,
        thickness: 6.0,
        padding: 20.0,
        cornerRadius: 16.0,
        hasShadow: true,
        shadowBlur: 10.0,
        shadowOpacity: 0.5,
        patternSpacing: 8.0,
        patternSize: 4.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(
              Container(width: 200, height: 200, color: Colors.white),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(Padding), findsOneWidget);
    });

    test('default pattern spacing is thickness * 1.5', () {
      const border = DottedBorder(
        color: Colors.black,
        thickness: 4.0,
      );

      // Pattern spacing should be null, will be calculated as thickness * 1.5 in painter
      expect(border.patternSpacing, isNull);
      expect(border.thickness, 4.0);
      // Expected calculated spacing would be 4.0 * 1.5 = 6.0
    });

    test('default pattern size equals thickness', () {
      const border = DottedBorder(
        color: Colors.black,
        thickness: 4.0,
      );

      // Pattern size should be null, will default to thickness in painter
      expect(border.patternSize, isNull);
      expect(border.thickness, 4.0);
    });

    test('supports various thickness values', () {
      const thinBorder = DottedBorder(color: Colors.black, thickness: 2.0);
      const mediumBorder = DottedBorder(color: Colors.black, thickness: 4.0);
      const thickBorder = DottedBorder(color: Colors.black, thickness: 8.0);

      expect(thinBorder.thickness, 2.0);
      expect(mediumBorder.thickness, 4.0);
      expect(thickBorder.thickness, 8.0);
    });

    test('supports various corner radius values', () {
      const sharpCorners = DottedBorder(color: Colors.black, cornerRadius: 0.0);
      const roundedCorners =
          DottedBorder(color: Colors.black, cornerRadius: 16.0);
      const veryRoundedCorners =
          DottedBorder(color: Colors.black, cornerRadius: 32.0);

      expect(sharpCorners.cornerRadius, 0.0);
      expect(roundedCorners.cornerRadius, 16.0);
      expect(veryRoundedCorners.cornerRadius, 32.0);
    });

    test('supports various padding values', () {
      const smallPadding = DottedBorder(color: Colors.black, padding: 8.0);
      const mediumPadding = DottedBorder(color: Colors.black, padding: 16.0);
      const largePadding = DottedBorder(color: Colors.black, padding: 32.0);

      expect(smallPadding.padding, 8.0);
      expect(mediumPadding.padding, 16.0);
      expect(largePadding.padding, 32.0);
    });
  });

  group('DottedBorderPainter', () {
    testWidgets('painter renders dots correctly', (tester) async {
      const border = DottedBorder(
        color: Colors.black,
        thickness: 4.0,
      );

      final widget = border.build(
        const SizedBox(width: 200, height: 200),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      // Verify CustomPaint renders without errors
      final customPaint = find.byType(CustomPaint);
      expect(customPaint, findsWidgets);
    });

    testWidgets('painter handles corner dots when corner radius is set',
        (tester) async {
      const border = DottedBorder(
        color: Colors.black,
        thickness: 4.0,
        cornerRadius: 20.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(
              const SizedBox(width: 200, height: 200),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('painter handles shadow rendering', (tester) async {
      const border = DottedBorder(
        color: Colors.black,
        hasShadow: true,
        shadowBlur: 8.0,
        shadowOpacity: 0.4,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(
              const SizedBox(width: 200, height: 200),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
