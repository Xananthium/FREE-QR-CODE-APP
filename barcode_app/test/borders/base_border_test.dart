import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/borders/base_border.dart';

// Test implementation of DecorativeBorder
class TestBorder extends DecorativeBorder {
  const TestBorder({
    required super.color,
    super.secondaryColor,
    super.thickness,
    super.padding,
    super.cornerRadius,
    super.hasShadow,
    super.shadowBlur,
    super.shadowOpacity,
    super.patternSpacing,
    super.patternSize,
  });

  @override
  Widget build(Widget child) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: thickness,
        ),
        borderRadius: BorderRadius.circular(cornerRadius),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: color.withOpacity(shadowOpacity),
                  blurRadius: shadowBlur,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  @override
  Widget buildThumbnail(Size size) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: build(
        Container(
          color: Colors.grey[300],
        ),
      ),
    );
  }

  @override
  DecorativeBorder copyWith({
    Color? color,
    Color? secondaryColor,
    double? thickness,
    double? padding,
    double? cornerRadius,
    bool? hasShadow,
    double? shadowBlur,
    double? shadowOpacity,
    double? patternSpacing,
    double? patternSize,
  }) {
    return TestBorder(
      color: color ?? this.color,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      thickness: thickness ?? this.thickness,
      padding: padding ?? this.padding,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      hasShadow: hasShadow ?? this.hasShadow,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      patternSpacing: patternSpacing ?? this.patternSpacing,
      patternSize: patternSize ?? this.patternSize,
    );
  }

  @override
  String get name => 'Test Border';

  @override
  String get description => 'Simple test border for verification';
}

void main() {
  group('DecorativeBorder Base Class', () {
    test('Can create instance with required properties', () {
      const border = TestBorder(color: Colors.blue);
      
      expect(border.color, Colors.blue);
      expect(border.thickness, 4.0); // default
      expect(border.padding, 16.0); // default
      expect(border.cornerRadius, 0.0); // default
      expect(border.hasShadow, false); // default
    });

    test('Can create instance with all properties', () {
      const border = TestBorder(
        color: Colors.red,
        secondaryColor: Colors.orange,
        thickness: 8.0,
        padding: 24.0,
        cornerRadius: 12.0,
        hasShadow: true,
        shadowBlur: 6.0,
        shadowOpacity: 0.5,
        patternSpacing: 10.0,
        patternSize: 5.0,
      );

      expect(border.color, Colors.red);
      expect(border.secondaryColor, Colors.orange);
      expect(border.thickness, 8.0);
      expect(border.padding, 24.0);
      expect(border.cornerRadius, 12.0);
      expect(border.hasShadow, true);
      expect(border.shadowBlur, 6.0);
      expect(border.shadowOpacity, 0.5);
      expect(border.patternSpacing, 10.0);
      expect(border.patternSize, 5.0);
    });

    test('copyWith creates new instance with modified properties', () {
      const border1 = TestBorder(color: Colors.blue);
      final border2 = border1.copyWith(
        color: Colors.green,
        thickness: 6.0,
      );

      expect(border2.color, Colors.green);
      expect(border2.thickness, 6.0);
      expect(border2.padding, border1.padding); // unchanged
    });

    test('Equality works correctly', () {
      const border1 = TestBorder(color: Colors.blue);
      const border2 = TestBorder(color: Colors.blue);
      const border3 = TestBorder(color: Colors.red);

      expect(border1, equals(border2));
      expect(border1, isNot(equals(border3)));
    });

    test('HashCode is consistent', () {
      const border1 = TestBorder(color: Colors.blue);
      const border2 = TestBorder(color: Colors.blue);

      expect(border1.hashCode, equals(border2.hashCode));
    });

    test('toString provides readable output', () {
      const border = TestBorder(color: Colors.blue);
      final str = border.toString();

      expect(str, contains('Test Border'));
      expect(str, contains('color:'));
    });

    test('Abstract methods are implemented', () {
      const border = TestBorder(color: Colors.blue);

      expect(border.name, 'Test Border');
      expect(border.description, isNotEmpty);
    });

    testWidgets('build method returns Widget', (tester) async {
      const border = TestBorder(color: Colors.blue);
      final child = Container(
        width: 100,
        height: 100,
        color: Colors.red,
      );

      final widget = border.build(child);
      
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('buildThumbnail method returns Widget', (tester) async {
      const border = TestBorder(color: Colors.blue);
      const size = Size(50, 50);

      final widget = border.buildThumbnail(size);
      
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
