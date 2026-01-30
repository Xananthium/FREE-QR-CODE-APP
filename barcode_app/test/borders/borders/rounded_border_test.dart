import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/borders/borders/rounded_border.dart';

void main() {
  group('RoundedBorder', () {
    test('creates instance with default values', () {
      const border = RoundedBorder(
        color: Colors.black,
      );

      expect(border.color, Colors.black);
      expect(border.thickness, 4.0);
      expect(border.padding, 16.0);
      expect(border.cornerRadius, 16.0);
      expect(border.hasShadow, false);
      expect(border.shadowBlur, 8.0);
      expect(border.shadowOpacity, 0.15);
    });

    test('creates instance with custom values', () {
      const border = RoundedBorder(
        color: Colors.blue,
        secondaryColor: Colors.red,
        thickness: 6.0,
        padding: 20.0,
        cornerRadius: 24.0,
        hasShadow: true,
        shadowBlur: 12.0,
        shadowOpacity: 0.25,
      );

      expect(border.color, Colors.blue);
      expect(border.secondaryColor, Colors.red);
      expect(border.thickness, 6.0);
      expect(border.padding, 20.0);
      expect(border.cornerRadius, 24.0);
      expect(border.hasShadow, true);
      expect(border.shadowBlur, 12.0);
      expect(border.shadowOpacity, 0.25);
    });

    test('has correct name and description', () {
      const border = RoundedBorder(color: Colors.black);

      expect(border.name, 'Rounded Border');
      expect(border.description, 'Soft rounded corners with optional subtle shadow');
    });

    test('copyWith creates new instance with updated values', () {
      const border = RoundedBorder(
        color: Colors.black,
        thickness: 4.0,
        cornerRadius: 16.0,
      );

      final newBorder = border.copyWith(
        color: Colors.blue,
        thickness: 6.0,
      );

      expect(newBorder.color, Colors.blue);
      expect(newBorder.thickness, 6.0);
      expect(newBorder.cornerRadius, 16.0); // Unchanged
    });

    test('copyWith preserves original values when null', () {
      const border = RoundedBorder(
        color: Colors.black,
        thickness: 4.0,
        cornerRadius: 16.0,
        hasShadow: true,
      );

      final newBorder = border.copyWith();

      expect(newBorder.color, border.color);
      expect(newBorder.thickness, border.thickness);
      expect(newBorder.cornerRadius, border.cornerRadius);
      expect(newBorder.hasShadow, border.hasShadow);
    });

    testWidgets('build creates widget with CustomPaint', (tester) async {
      const border = RoundedBorder(color: Colors.black);
      final widget = border.build(
        const SizedBox(width: 100, height: 100),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      // Find CustomPaint widgets and verify our border's CustomPaint exists
      final customPaints = find.byType(CustomPaint);
      expect(customPaints, findsWidgets);
    });

    testWidgets('buildThumbnail creates thumbnail widget', (tester) async {
      const border = RoundedBorder(color: Colors.black);
      final thumbnail = border.buildThumbnail(const Size(50, 50));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: thumbnail,
          ),
        ),
      );

      // Verify CustomPaint widget exists
      expect(find.byType(CustomPaint), findsWidgets);
    });

    test('equality works correctly', () {
      const border1 = RoundedBorder(
        color: Colors.black,
        thickness: 4.0,
        cornerRadius: 16.0,
      );

      const border2 = RoundedBorder(
        color: Colors.black,
        thickness: 4.0,
        cornerRadius: 16.0,
      );

      const border3 = RoundedBorder(
        color: Colors.blue,
        thickness: 4.0,
        cornerRadius: 16.0,
      );

      expect(border1 == border2, true);
      expect(border1 == border3, false);
    });

    test('hashCode is consistent', () {
      const border1 = RoundedBorder(
        color: Colors.black,
        thickness: 4.0,
        cornerRadius: 16.0,
      );

      const border2 = RoundedBorder(
        color: Colors.black,
        thickness: 4.0,
        cornerRadius: 16.0,
      );

      expect(border1.hashCode, border2.hashCode);
    });

    test('different corner radii create different instances', () {
      const border1 = RoundedBorder(color: Colors.black, cornerRadius: 8.0);
      const border2 = RoundedBorder(color: Colors.black, cornerRadius: 16.0);
      const border3 = RoundedBorder(color: Colors.black, cornerRadius: 24.0);

      expect(border1.cornerRadius, 8.0);
      expect(border2.cornerRadius, 16.0);
      expect(border3.cornerRadius, 24.0);
    });

    test('shadow configuration works correctly', () {
      const borderWithoutShadow = RoundedBorder(
        color: Colors.black,
        hasShadow: false,
      );

      const borderWithShadow = RoundedBorder(
        color: Colors.black,
        hasShadow: true,
        shadowBlur: 10.0,
        shadowOpacity: 0.3,
      );

      expect(borderWithoutShadow.hasShadow, false);
      expect(borderWithShadow.hasShadow, true);
      expect(borderWithShadow.shadowBlur, 10.0);
      expect(borderWithShadow.shadowOpacity, 0.3);
    });

    test('accepts configurable corner radius', () {
      const smallRadius = RoundedBorder(color: Colors.black, cornerRadius: 4.0);
      const mediumRadius = RoundedBorder(color: Colors.black, cornerRadius: 16.0);
      const largeRadius = RoundedBorder(color: Colors.black, cornerRadius: 32.0);

      expect(smallRadius.cornerRadius, 4.0);
      expect(mediumRadius.cornerRadius, 16.0);
      expect(largeRadius.cornerRadius, 32.0);
    });
  });
}
