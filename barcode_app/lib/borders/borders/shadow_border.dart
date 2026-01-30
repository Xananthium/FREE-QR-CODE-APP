import 'package:flutter/material.dart';
import '../base_border.dart';
import '../painters/shadow_border_painter.dart';

/// A modern border with 3D shadow effects creating an elevated card appearance.
/// 
/// The Shadow Border creates depth perception through configurable drop shadows,
/// giving the QR code a floating, elevated look similar to Material Design cards.
/// 
/// Features:
/// - Soft drop shadow for depth
/// - Configurable shadow intensity
/// - Optional inner shadow for depth effect
/// - Smooth rounded corners
/// - Multiple shadow layers for enhanced 3D effect
/// 
/// This border is perfect for:
/// - Modern, clean designs
/// - Material Design aesthetic
/// - Professional documents
/// - Digital displays
/// - Presentations
class ShadowBorder extends DecorativeBorder {
  /// Offset distance of the shadow from the border
  final Offset shadowOffset;
  
  /// Whether to include an inner shadow for enhanced depth
  final bool hasInnerShadow;
  
  /// Blur radius for the inner shadow
  final double innerShadowBlur;
  
  /// Creates a Shadow Border with 3D elevation effects.
  /// 
  /// The border creates depth through layered shadows that can be configured
  /// for different levels of elevation and visual impact.
  /// 
  /// Parameters:
  /// - [color]: Main border color (typically subtle or matches background)
  /// - [thickness]: Border line thickness (default: 2.0 for subtle frame)
  /// - [padding]: Space between content and border (default: 20.0)
  /// - [cornerRadius]: Corner rounding (default: 12.0 for modern look)
  /// - [hasShadow]: Whether to show drop shadow (default: true)
  /// - [shadowBlur]: Drop shadow blur radius (default: 8.0)
  /// - [shadowOpacity]: Shadow darkness 0.0-1.0 (default: 0.25)
  /// - [shadowOffset]: Shadow displacement (default: (0, 4) for downward)
  /// - [hasInnerShadow]: Show inner shadow for depth (default: false)
  /// - [innerShadowBlur]: Inner shadow blur (default: 4.0)
  const ShadowBorder({
    super.color = const Color(0xFFE0E0E0),
    super.thickness = 2.0,
    super.padding = 20.0,
    super.cornerRadius = 12.0,
    super.hasShadow = true,
    super.shadowBlur = 8.0,
    super.shadowOpacity = 0.25,
    this.shadowOffset = const Offset(0, 4),
    this.hasInnerShadow = false,
    this.innerShadowBlur = 4.0,
  }) : super(
    secondaryColor: null,
    patternSpacing: null,
    patternSize: null,
  );

  @override
  Widget build(Widget child) {
    return CustomPaint(
      painter: ShadowBorderPainter(this),
      child: Padding(
        padding: EdgeInsets.all(padding),
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
        painter: ShadowBorderPainter(this),
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
  ShadowBorder copyWith({
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
    Offset? shadowOffset,
    bool? hasInnerShadow,
    double? innerShadowBlur,
  }) {
    return ShadowBorder(
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      padding: padding ?? this.padding,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      hasShadow: hasShadow ?? this.hasShadow,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      hasInnerShadow: hasInnerShadow ?? this.hasInnerShadow,
      innerShadowBlur: innerShadowBlur ?? this.innerShadowBlur,
    );
  }

  @override
  String get name => 'Shadow Border';

  @override
  String get description => '3D elevated card with configurable shadow depth';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ShadowBorder &&
        other.color == color &&
        other.thickness == thickness &&
        other.padding == padding &&
        other.cornerRadius == cornerRadius &&
        other.hasShadow == hasShadow &&
        other.shadowBlur == shadowBlur &&
        other.shadowOpacity == shadowOpacity &&
        other.shadowOffset == shadowOffset &&
        other.hasInnerShadow == hasInnerShadow &&
        other.innerShadowBlur == innerShadowBlur;
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      thickness,
      padding,
      cornerRadius,
      hasShadow,
      shadowBlur,
      shadowOpacity,
      shadowOffset,
      hasInnerShadow,
      innerShadowBlur,
    );
  }

  @override
  String toString() {
    return 'ShadowBorder(color: $color, thickness: $thickness, '
        'padding: $padding, cornerRadius: $cornerRadius, '
        'hasShadow: $hasShadow, shadowBlur: $shadowBlur, '
        'shadowOpacity: $shadowOpacity, shadowOffset: $shadowOffset, '
        'hasInnerShadow: $hasInnerShadow, innerShadowBlur: $innerShadowBlur)';
  }
}
