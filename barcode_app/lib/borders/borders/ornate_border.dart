import 'package:flutter/material.dart';
import '../base_border.dart';
import '../painters/ornate_painter.dart';

/// Victorian-style decorative border with elegant scrollwork and flourishes.
///
/// This border features:
/// - Double-line frame for depth
/// - Repeating C-scroll patterns along edges
/// - Elaborate corner flourishes with three-pronged ornaments
/// - Support for dual-color layering (primary and secondary)
/// - Smooth organic curves using cubic Bezier paths
///
/// Perfect for creating elegant, vintage-inspired QR code presentations
/// with a touch of Victorian ornamentation.
///
/// Example:
/// ```dart
/// final border = OrnateBorder(
///   color: Colors.deepPurple,
///   secondaryColor: Colors.purple.shade200,
///   thickness: 5.0,
///   patternSpacing: 45.0,
///   patternSize: 20.0,
/// );
/// ```
class OrnateBorder extends DecorativeBorder {
  /// Creates an ornate border with Victorian scrollwork.
  ///
  /// The [color] is used for the main border lines and scroll outlines.
  /// The optional [secondaryColor] is used for inner details and accent flourishes.
  ///
  /// [patternSpacing] controls the distance between scroll elements (default: 40.0)
  /// [patternSize] controls the size of scrolls and flourishes (default: 16.0)
  const OrnateBorder({
    required super.color,
    super.secondaryColor,
    super.thickness = 5.0,
    super.padding = 20.0,
    super.cornerRadius = 8.0,
    super.hasShadow = true,
    super.shadowBlur = 6.0,
    super.shadowOpacity = 0.25,
    super.patternSpacing = 40.0,
    super.patternSize = 16.0,
  });

  @override
  Widget build(Widget child) {
    return CustomPaint(
      painter: OrnatePainter(this),
      child: Padding(
        padding: EdgeInsets.all(padding + thickness * 3),
        child: child,
      ),
    );
  }

  @override
  Widget buildThumbnail(Size size) {
    return SizedBox.fromSize(
      size: size,
      child: CustomPaint(
        painter: OrnatePainter(
          copyWith(
            padding: size.width * 0.08,
            thickness: size.width * 0.02,
            patternSpacing: size.width * 0.15,
            patternSize: size.width * 0.06,
          ),
        ),
        child: Center(
          child: Container(
            width: size.width * 0.4,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  @override
  OrnateBorder copyWith({
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
    return OrnateBorder(
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
  String get name => 'Ornate Border';

  @override
  String get description =>
      'Victorian-style decorative border with elegant scrollwork and corner flourishes';
}
