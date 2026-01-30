import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/borders/borders/floral_border.dart';

void main() {
  group('FloralBorder', () {
    test('creates with default values', () {
      const border = FloralBorder(color: Colors.green);
      
      expect(border.color, Colors.green);
      expect(border.thickness, 3.0);
      expect(border.padding, 20.0);
      expect(border.cornerRadius, 4.0);
      expect(border.hasShadow, false);
      expect(border.name, 'Floral Border');
      expect(border.description, contains('Nature-inspired'));
    });

    test('creates with custom values', () {
      const border = FloralBorder(
        color: Colors.blue,
        secondaryColor: Colors.amber,
        thickness: 5.0,
        padding: 25.0,
        cornerRadius: 8.0,
        hasShadow: true,
        shadowBlur: 6.0,
        shadowOpacity: 0.4,
      );
      
      expect(border.color, Colors.blue);
      expect(border.secondaryColor, Colors.amber);
      expect(border.thickness, 5.0);
      expect(border.padding, 25.0);
      expect(border.cornerRadius, 8.0);
      expect(border.hasShadow, true);
      expect(border.shadowBlur, 6.0);
      expect(border.shadowOpacity, 0.4);
    });

    test('botanical factory creates correct theme', () {
      final border = FloralBorder.botanical();
      
      expect(border.color, const Color(0xFF2E7D32)); // Forest green
      expect(border.secondaryColor, const Color(0xFFFFD54F)); // Golden yellow
      expect(border.thickness, 3.0);
      expect(border.padding, 20.0);
      expect(border.cornerRadius, 4.0);
    });

    test('pastel factory creates correct theme', () {
      final border = FloralBorder.pastel();
      
      expect(border.color, const Color(0xFF81C784)); // Light green
      expect(border.secondaryColor, const Color(0xFFF48FB1)); // Pink
      expect(border.thickness, 2.5);
      expect(border.padding, 20.0);
      expect(border.cornerRadius, 6.0);
    });

    test('autumn factory creates correct theme', () {
      final border = FloralBorder.autumn();
      
      expect(border.color, const Color(0xFF8D6E63)); // Brown
      expect(border.secondaryColor, const Color(0xFFFF8A65)); // Orange
      expect(border.thickness, 3.5);
      expect(border.padding, 22.0);
      expect(border.cornerRadius, 4.0);
    });

    test('elegant factory creates correct theme with shadow', () {
      final border = FloralBorder.elegant();
      
      expect(border.color, const Color(0xFF212121)); // Dark gray
      expect(border.secondaryColor, const Color(0xFF757575)); // Medium gray
      expect(border.thickness, 2.5);
      expect(border.hasShadow, true);
      expect(border.shadowBlur, 6.0);
      expect(border.shadowOpacity, 0.15);
    });

    test('tropical factory creates correct theme', () {
      final border = FloralBorder.tropical();
      
      expect(border.color, const Color(0xFF00695C)); // Teal
      expect(border.secondaryColor, const Color(0xFFE91E63)); // Magenta
      expect(border.thickness, 3.5);
      expect(border.padding, 22.0);
      expect(border.cornerRadius, 6.0);
    });

    test('copyWith creates new instance with updated values', () {
      const original = FloralBorder(
        color: Colors.green,
        thickness: 3.0,
        padding: 20.0,
      );
      
      final copied = original.copyWith(
        color: Colors.blue,
        thickness: 5.0,
      );
      
      expect(copied.color, Colors.blue);
      expect(copied.thickness, 5.0);
      expect(copied.padding, 20.0); // Unchanged
      expect(original.color, Colors.green); // Original unchanged
      expect(original.thickness, 3.0);
    });

    test('copyWith with no changes returns equivalent instance', () {
      const original = FloralBorder(color: Colors.green);
      final copied = original.copyWith();
      
      expect(copied.color, original.color);
      expect(copied.thickness, original.thickness);
      expect(copied.padding, original.padding);
    });

    test('equality works correctly', () {
      const border1 = FloralBorder(
        color: Colors.green,
        thickness: 3.0,
      );
      const border2 = FloralBorder(
        color: Colors.green,
        thickness: 3.0,
      );
      const border3 = FloralBorder(
        color: Colors.blue,
        thickness: 3.0,
      );
      
      expect(border1, equals(border2));
      expect(border1, isNot(equals(border3)));
    });

    test('hashCode works correctly', () {
      const border1 = FloralBorder(
        color: Colors.green,
        thickness: 3.0,
      );
      const border2 = FloralBorder(
        color: Colors.green,
        thickness: 3.0,
      );
      
      expect(border1.hashCode, equals(border2.hashCode));
    });

    testWidgets('build returns CustomPaint widget', (tester) async {
      const border = FloralBorder(color: Colors.green);
      final child = Container(
        width: 100,
        height: 100,
        color: Colors.white,
      );
      
      final widget = border.build(child);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );
      
      // Should find at least one CustomPaint widget (may find more due to complex painting)
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('buildThumbnail creates preview widget', (tester) async {
      const border = FloralBorder(color: Colors.green);
      final thumbnail = border.buildThumbnail(const Size(80, 80));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: thumbnail,
          ),
        ),
      );
      
      // Should find at least one CustomPaint widget
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byIcon(Icons.eco_outlined), findsOneWidget);
    });

    test('toString returns readable representation', () {
      const border = FloralBorder(
        color: Colors.green,
        thickness: 3.0,
      );
      
      final string = border.toString();
      expect(string, contains('FloralBorder'));
      expect(string, contains('Floral Border'));
    });

    test('factory constructors allow custom colors', () {
      final border = FloralBorder.botanical(
        primaryColor: Colors.teal,
        accentColor: Colors.orange,
      );
      
      expect(border.color, Colors.teal);
      expect(border.secondaryColor, Colors.orange);
    });

    test('factory constructors allow custom dimensions', () {
      final border = FloralBorder.pastel(
        thickness: 5.0,
        padding: 30.0,
      );
      
      expect(border.thickness, 5.0);
      expect(border.padding, 30.0);
    });
  });
}
