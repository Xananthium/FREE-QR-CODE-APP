import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/borders/borders/shadow_border.dart';

void main() {
  group('ShadowBorder', () {
    test('creates with default values', () {
      const border = ShadowBorder();
      
      expect(border.color, const Color(0xFFE0E0E0));
      expect(border.thickness, 2.0);
      expect(border.padding, 20.0);
      expect(border.cornerRadius, 12.0);
      expect(border.hasShadow, true);
      expect(border.shadowBlur, 8.0);
      expect(border.shadowOpacity, 0.25);
      expect(border.shadowOffset, const Offset(0, 4));
      expect(border.hasInnerShadow, false);
      expect(border.innerShadowBlur, 4.0);
    });

    test('creates with custom values', () {
      const border = ShadowBorder(
        color: Colors.blue,
        thickness: 3.0,
        padding: 24.0,
        cornerRadius: 16.0,
        hasShadow: true,
        shadowBlur: 12.0,
        shadowOpacity: 0.3,
        shadowOffset: Offset(2, 6),
        hasInnerShadow: true,
        innerShadowBlur: 6.0,
      );
      
      expect(border.color, Colors.blue);
      expect(border.thickness, 3.0);
      expect(border.padding, 24.0);
      expect(border.cornerRadius, 16.0);
      expect(border.shadowBlur, 12.0);
      expect(border.shadowOpacity, 0.3);
      expect(border.shadowOffset, const Offset(2, 6));
      expect(border.hasInnerShadow, true);
      expect(border.innerShadowBlur, 6.0);
    });

    test('has correct name and description', () {
      const border = ShadowBorder();
      
      expect(border.name, 'Shadow Border');
      expect(border.description, '3D elevated card with configurable shadow depth');
    });

    test('copyWith creates new instance with updated values', () {
      const original = ShadowBorder(
        color: Colors.red,
        thickness: 2.0,
        shadowBlur: 8.0,
      );
      
      final copied = original.copyWith(
        color: Colors.blue,
        shadowBlur: 12.0,
      );
      
      expect(copied.color, Colors.blue);
      expect(copied.shadowBlur, 12.0);
      expect(copied.thickness, 2.0); // unchanged
    });

    test('copyWith with no parameters returns equivalent border', () {
      const original = ShadowBorder(
        color: Colors.green,
        thickness: 3.0,
        shadowOffset: Offset(1, 3),
      );
      
      final copied = original.copyWith();
      
      expect(copied.color, original.color);
      expect(copied.thickness, original.thickness);
      expect(copied.shadowOffset, original.shadowOffset);
    });

    test('equality works correctly', () {
      const border1 = ShadowBorder(
        color: Colors.blue,
        thickness: 2.0,
        shadowBlur: 8.0,
      );
      
      const border2 = ShadowBorder(
        color: Colors.blue,
        thickness: 2.0,
        shadowBlur: 8.0,
      );
      
      const border3 = ShadowBorder(
        color: Colors.red,
        thickness: 2.0,
        shadowBlur: 8.0,
      );
      
      expect(border1, equals(border2));
      expect(border1, isNot(equals(border3)));
    });

    test('hashCode is consistent', () {
      const border1 = ShadowBorder(
        color: Colors.blue,
        thickness: 2.0,
      );
      
      const border2 = ShadowBorder(
        color: Colors.blue,
        thickness: 2.0,
      );
      
      expect(border1.hashCode, equals(border2.hashCode));
    });

    testWidgets('builds widget with child', (tester) async {
      const border = ShadowBorder();
      const testChild = Text('Test QR');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.build(testChild),
          ),
        ),
      );
      
      expect(find.text('Test QR'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('buildThumbnail creates preview widget', (tester) async {
      const border = ShadowBorder();
      const thumbnailSize = Size(100, 100);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.buildThumbnail(thumbnailSize),
          ),
        ),
      );
      
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    test('configurable shadow intensity variations', () {
      // Light shadow
      const lightShadow = ShadowBorder(
        shadowBlur: 4.0,
        shadowOpacity: 0.15,
      );
      
      // Medium shadow (default)
      const mediumShadow = ShadowBorder(
        shadowBlur: 8.0,
        shadowOpacity: 0.25,
      );
      
      // Heavy shadow
      const heavyShadow = ShadowBorder(
        shadowBlur: 16.0,
        shadowOpacity: 0.4,
      );
      
      expect(lightShadow.shadowBlur, 4.0);
      expect(mediumShadow.shadowBlur, 8.0);
      expect(heavyShadow.shadowBlur, 16.0);
      
      expect(lightShadow.shadowOpacity, 0.15);
      expect(mediumShadow.shadowOpacity, 0.25);
      expect(heavyShadow.shadowOpacity, 0.4);
    });

    test('shadow offset creates directional effect', () {
      // Bottom shadow (default)
      const bottomShadow = ShadowBorder(
        shadowOffset: Offset(0, 4),
      );
      
      // Bottom-right shadow
      const bottomRightShadow = ShadowBorder(
        shadowOffset: Offset(3, 3),
      );
      
      // Right shadow
      const rightShadow = ShadowBorder(
        shadowOffset: Offset(4, 0),
      );
      
      expect(bottomShadow.shadowOffset.dx, 0);
      expect(bottomShadow.shadowOffset.dy, 4);
      
      expect(bottomRightShadow.shadowOffset.dx, 3);
      expect(bottomRightShadow.shadowOffset.dy, 3);
      
      expect(rightShadow.shadowOffset.dx, 4);
      expect(rightShadow.shadowOffset.dy, 0);
    });

    test('inner shadow enhances depth perception', () {
      const withInnerShadow = ShadowBorder(
        hasInnerShadow: true,
        innerShadowBlur: 6.0,
      );
      
      const withoutInnerShadow = ShadowBorder(
        hasInnerShadow: false,
      );
      
      expect(withInnerShadow.hasInnerShadow, true);
      expect(withInnerShadow.innerShadowBlur, 6.0);
      expect(withoutInnerShadow.hasInnerShadow, false);
    });

    test('toString provides detailed information', () {
      const border = ShadowBorder(
        color: Colors.grey,
        thickness: 2.0,
        shadowBlur: 8.0,
      );
      
      final string = border.toString();
      
      expect(string, contains('ShadowBorder'));
      expect(string, contains('thickness: 2.0'));
      expect(string, contains('shadowBlur: 8.0'));
    });

    test('elevated card appearance with rounded corners', () {
      const cardBorder = ShadowBorder(
        cornerRadius: 12.0,
        hasShadow: true,
        shadowBlur: 8.0,
        shadowOpacity: 0.25,
      );
      
      expect(cardBorder.cornerRadius, 12.0);
      expect(cardBorder.hasShadow, true);
      expect(cardBorder.shadowBlur, 8.0);
      expect(cardBorder.shadowOpacity, 0.25);
    });

    test('material design elevation levels', () {
      // Elevation 2 (small shadow)
      const elevation2 = ShadowBorder(
        shadowBlur: 4.0,
        shadowOpacity: 0.2,
        shadowOffset: Offset(0, 2),
      );
      
      // Elevation 4 (medium shadow)
      const elevation4 = ShadowBorder(
        shadowBlur: 8.0,
        shadowOpacity: 0.25,
        shadowOffset: Offset(0, 4),
      );
      
      // Elevation 8 (large shadow)
      const elevation8 = ShadowBorder(
        shadowBlur: 16.0,
        shadowOpacity: 0.3,
        shadowOffset: Offset(0, 8),
      );
      
      expect(elevation2.shadowOffset.dy, 2);
      expect(elevation4.shadowOffset.dy, 4);
      expect(elevation8.shadowOffset.dy, 8);
    });
  });
}
