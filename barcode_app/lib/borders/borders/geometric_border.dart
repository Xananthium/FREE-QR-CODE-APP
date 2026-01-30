import 'package:flutter/material.dart';
import '../base_border.dart';
import '../painters/geometric_painter.dart';

/// A decorative border featuring repeating geometric patterns.
/// 
/// This border creates a clean, mathematical design using geometric shapes
/// like triangles and hexagons arranged in a repeating pattern around the
/// QR code. The geometric style is modern and precise, perfect for
/// technical or minimalist aesthetics.
/// 
/// Features:
/// - Repeating geometric pattern (triangles or hexagons)
/// - Clean mathematical design
/// - Customizable pattern size and spacing
/// - Optional secondary color for dual-tone effects
/// 
/// Example usage:
/// ```dart
/// final border = GeometricBorder(
///   color: Colors.blue,
///   secondaryColor: Colors.lightBlue,
///   patternType: GeometricPattern.triangles,
///   patternSize: 12.0,
///   patternSpacing: 4.0,
/// );
/// ```
class GeometricBorder extends DecorativeBorder {
  /// The type of geometric pattern to use
  final GeometricPattern patternType;

  /// Creates a new GeometricBorder with the specified properties.
  /// 
  /// [color] is the primary color for the pattern elements
  /// [secondaryColor] is used for alternating pattern colors (optional)
  /// [patternType] determines which geometric shape to use
  /// [patternSize] controls the size of each geometric element
  /// [patternSpacing] controls the gap between elements
  /// [thickness] determines the border frame thickness
  /// [padding] sets the space between QR code and border
  const GeometricBorder({
    required super.color,
    super.secondaryColor,
    this.patternType = GeometricPattern.triangles,
    super.thickness = 3.0,
    super.padding = 20.0,
    super.cornerRadius = 8.0,
    super.hasShadow = false,
    super.shadowBlur = 4.0,
    super.shadowOpacity = 0.3,
    double? patternSize,
    double? patternSpacing,
  }) : super(
          patternSize: patternSize ?? 12.0,
          patternSpacing: patternSpacing ?? 4.0,
        );

  @override
  Widget build(Widget child) {
    return CustomPaint(
      painter: GeometricPainter(
        color: color,
        secondaryColor: secondaryColor,
        thickness: thickness,
        cornerRadius: cornerRadius,
        patternType: patternType,
        patternSize: patternSize ?? 12.0,
        patternSpacing: patternSpacing ?? 4.0,
        hasShadow: hasShadow,
        shadowBlur: shadowBlur,
        shadowOpacity: shadowOpacity,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding + thickness),
        child: child,
      ),
    );
  }

  @override
  Widget buildThumbnail(Size size) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: GeometricPainter(
          color: color,
          secondaryColor: secondaryColor,
          thickness: thickness * 0.6, // Slightly thinner for thumbnail
          cornerRadius: cornerRadius,
          patternType: patternType,
          patternSize: (patternSize ?? 12.0) * 0.8, // Slightly smaller for thumbnail
          patternSpacing: (patternSpacing ?? 4.0) * 0.8,
          hasShadow: false, // Disable shadow in thumbnail for performance
          shadowBlur: shadowBlur,
          shadowOpacity: shadowOpacity,
        ),
        child: Center(
          child: Container(
            width: size.width * 0.4,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  @override
  GeometricBorder copyWith({
    Color? color,
    Color? secondaryColor,
    GeometricPattern? patternType,
    double? thickness,
    double? padding,
    double? cornerRadius,
    bool? hasShadow,
    double? shadowBlur,
    double? shadowOpacity,
    double? patternSpacing,
    double? patternSize,
  }) {
    return GeometricBorder(
      color: color ?? this.color,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      patternType: patternType ?? this.patternType,
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
  String get name => 'Geometric Border';

  @override
  String get description =>
      'Clean mathematical pattern with ${patternType.displayName}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeometricBorder &&
        other.patternType == patternType &&
        super == other;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, patternType);
}

/// Enum defining available geometric pattern types
enum GeometricPattern {
  /// Repeating triangular pattern
  triangles,

  /// Repeating hexagonal pattern
  hexagons,

  /// Repeating diamond/rhombus pattern
  diamonds,

  /// Repeating circular pattern
  circles;

  /// Human-readable name for the pattern
  String get displayName {
    switch (this) {
      case GeometricPattern.triangles:
        return 'triangles';
      case GeometricPattern.hexagons:
        return 'hexagons';
      case GeometricPattern.diamonds:
        return 'diamonds';
      case GeometricPattern.circles:
        return 'circles';
    }
  }
}
