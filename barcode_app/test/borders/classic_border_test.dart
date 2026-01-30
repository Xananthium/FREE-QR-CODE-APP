import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/borders/borders/classic_border.dart';

void main() {
  group('ClassicBorder', () {
    test('creates border with default values', () {
      const border = ClassicBorder();
      
      expect(border.name, 'Classic Border');
      expect(border.description, 'Elegant double-frame border');
      expect(border.color, Colors.black);
      expect(border.thickness, 3.0);
      expect(border.innerThickness, 1.5);
      expect(border.frameSpacing, 6.0);
      expect(border.padding, 20.0);
      expect(border.cornerRadius, 0.0);
      expect(border.hasShadow, false);
    });

    test('creates border with custom values', () {
      const border = ClassicBorder(
        color: Colors.blue,
        secondaryColor: Colors.red,
        thickness: 4.0,
        innerThickness: 2.0,
        frameSpacing: 8.0,
        padding: 24.0,
        cornerRadius: 8.0,
        hasShadow: true,
        shadowBlur: 6.0,
        shadowOpacity: 0.5,
      );
      
      expect(border.color, Colors.blue);
      expect(border.secondaryColor, Colors.red);
      expect(border.thickness, 4.0);
      expect(border.innerThickness, 2.0);
      expect(border.frameSpacing, 8.0);
      expect(border.padding, 24.0);
      expect(border.cornerRadius, 8.0);
      expect(border.hasShadow, true);
      expect(border.shadowBlur, 6.0);
      expect(border.shadowOpacity, 0.5);
    });

    test('copyWith creates new instance with updated values', () {
      const original = ClassicBorder(
        color: Colors.black,
        thickness: 3.0,
      );
      
      final copied = original.copyWith(
        color: Colors.blue,
        padding: 24.0,
      );
      
      expect(copied.color, Colors.blue);
      expect(copied.padding, 24.0);
      expect(copied.thickness, 3.0); // Unchanged
    });

    testWidgets('build creates widget with proper padding', (tester) async {
      const border = ClassicBorder(
        thickness: 3.0,
        innerThickness: 1.5,
        frameSpacing: 6.0,
        padding: 20.0,
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
      const border = ClassicBorder();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: border.buildThumbnail(const Size(100, 100)),
          ),
        ),
      );
      
      // Verify the thumbnail renders without errors
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    test('equality operator works correctly', () {
      const border1 = ClassicBorder(
        color: Colors.black,
        thickness: 3.0,
      );
      
      const border2 = ClassicBorder(
        color: Colors.black,
        thickness: 3.0,
      );
      
      const border3 = ClassicBorder(
        color: Colors.blue,
        thickness: 3.0,
      );
      
      expect(border1, equals(border2));
      expect(border1, isNot(equals(border3)));
    });

    testWidgets('renders with shadow when enabled', (tester) async {
      const border = ClassicBorder(
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
      const border = ClassicBorder(
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

    testWidgets('renders with dual colors', (tester) async {
      const border = ClassicBorder(
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
  });

  group('ClassicBorderPainter', () {
    test('shouldRepaint returns true when border changes', () {
      const border1 = ClassicBorder(color: Colors.black);
      const border2 = ClassicBorder(color: Colors.blue);
      
      final painter1 = ClassicBorderPainter(border1);
      final painter2 = ClassicBorderPainter(border2);
      
      expect(painter1.shouldRepaint(painter2), true);
    });

    test('shouldRepaint returns false when border is same', () {
      const border = ClassicBorder(color: Colors.black);
      
      final painter1 = ClassicBorderPainter(border);
      final painter2 = ClassicBorderPainter(border);
      
      expect(painter1.shouldRepaint(painter2), false);
    });
  });
}
