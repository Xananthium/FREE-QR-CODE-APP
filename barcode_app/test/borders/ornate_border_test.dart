import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/borders/borders/ornate_border.dart';

void main() {
  group('OrnateBorder', () {
    test('creates border with default values', () {
      const border = OrnateBorder(
        color: Colors.blue,
      );

      expect(border.color, Colors.blue);
      expect(border.thickness, 5.0);
      expect(border.padding, 20.0);
      expect(border.cornerRadius, 8.0);
      expect(border.hasShadow, true);
      expect(border.patternSpacing, 40.0);
      expect(border.patternSize, 16.0);
    });

    test('creates border with custom values', () {
      const border = OrnateBorder(
        color: Colors.purple,
        secondaryColor: Colors.purpleAccent,
        thickness: 6.0,
        padding: 24.0,
        patternSpacing: 50.0,
        patternSize: 20.0,
      );

      expect(border.color, Colors.purple);
      expect(border.secondaryColor, Colors.purpleAccent);
      expect(border.thickness, 6.0);
      expect(border.padding, 24.0);
      expect(border.patternSpacing, 50.0);
      expect(border.patternSize, 20.0);
    });

    test('has correct name and description', () {
      const border = OrnateBorder(color: Colors.red);

      expect(border.name, 'Ornate Border');
      expect(
        border.description,
        'Victorian-style decorative border with elegant scrollwork and corner flourishes',
      );
    });

    test('copyWith creates new instance with updated values', () {
      const original = OrnateBorder(
        color: Colors.blue,
        thickness: 4.0,
      );

      final copied = original.copyWith(
        color: Colors.red,
        thickness: 6.0,
      );

      expect(copied.color, Colors.red);
      expect(copied.thickness, 6.0);
      expect(copied.padding, original.padding); // unchanged
    });

    test('equality works correctly', () {
      const border1 = OrnateBorder(
        color: Colors.blue,
        thickness: 5.0,
      );

      const border2 = OrnateBorder(
        color: Colors.blue,
        thickness: 5.0,
      );

      const border3 = OrnateBorder(
        color: Colors.red,
        thickness: 5.0,
      );

      expect(border1, equals(border2));
      expect(border1, isNot(equals(border3)));
    });

    testWidgets('build() wraps child with CustomPaint', (tester) async {
      const border = OrnateBorder(color: Colors.blue);
      final child = Container(width: 100, height: 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(child),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('buildThumbnail() creates preview widget', (tester) async {
      const border = OrnateBorder(color: Colors.blue);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.buildThumbnail(const Size(100, 100)),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
      expect(find.byType(SizedBox), findsOneWidget);
    });

    test('supports dual-color layering', () {
      const border = OrnateBorder(
        color: Colors.deepPurple,
        secondaryColor: Colors.purple,
      );

      expect(border.color, Colors.deepPurple);
      expect(border.secondaryColor, Colors.purple);
    });

    test('pattern parameters control scroll appearance', () {
      const border = OrnateBorder(
        color: Colors.blue,
        patternSpacing: 45.0,
        patternSize: 18.0,
      );

      expect(border.patternSpacing, 45.0);
      expect(border.patternSize, 18.0);
    });
  });
}
