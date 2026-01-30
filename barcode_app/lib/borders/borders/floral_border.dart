import 'package:flutter/material.dart';
import '../base_border.dart';
import '../painters/floral_painter.dart';

/// Nature-inspired floral border with botanical decorations.
///
/// This border features:
/// - Flowing vine patterns along all edges
/// - Delicate leaf motifs scattered throughout
/// - Ornate corner flourishes with petal designs
/// - Organic, hand-drawn aesthetic inspired by Art Nouveau
///
/// Perfect for:
/// - Elegant, natural-themed QR codes
/// - Garden or nature-related content
/// - Botanical or eco-friendly branding
/// - Vintage botanical illustration style
///
/// The design balances decorative beauty with functionality,
/// ensuring the QR code remains easily scannable while adding
/// sophisticated botanical ornamentation.
class FloralBorder extends DecorativeBorder {
  /// Creates a floral border with botanical decorations.
  ///
  /// Example:
  /// ```dart
  /// final border = FloralBorder(
  ///   color: Colors.green.shade700,
  ///   secondaryColor: Colors.amber.shade200,
  ///   thickness: 3.0,
  ///   padding: 20.0,
  /// );
  /// ```
  const FloralBorder({
    required super.color,
    super.secondaryColor,
    super.thickness = 3.0,
    super.padding = 20.0,
    super.cornerRadius = 4.0,
    super.hasShadow = false,
    super.shadowBlur = 4.0,
    super.shadowOpacity = 0.2,
    super.patternSpacing,
    super.patternSize,
  });

  /// Creates a floral border with green and gold botanical theme
  factory FloralBorder.botanical({
    Color? primaryColor,
    Color? accentColor,
    double thickness = 3.0,
    double padding = 20.0,
  }) {
    return FloralBorder(
      color: primaryColor ?? const Color(0xFF2E7D32), // Forest green
      secondaryColor: accentColor ?? const Color(0xFFFFD54F), // Golden yellow
      thickness: thickness,
      padding: padding,
      cornerRadius: 4.0,
    );
  }

  /// Creates a floral border with soft pastel botanical theme
  factory FloralBorder.pastel({
    Color? primaryColor,
    Color? accentColor,
    double thickness = 2.5,
    double padding = 20.0,
  }) {
    return FloralBorder(
      color: primaryColor ?? const Color(0xFF81C784), // Light green
      secondaryColor: accentColor ?? const Color(0xFFF48FB1), // Pink
      thickness: thickness,
      padding: padding,
      cornerRadius: 6.0,
    );
  }

  /// Creates a floral border with autumn botanical theme
  factory FloralBorder.autumn({
    Color? primaryColor,
    Color? accentColor,
    double thickness = 3.5,
    double padding = 22.0,
  }) {
    return FloralBorder(
      color: primaryColor ?? const Color(0xFF8D6E63), // Brown
      secondaryColor: accentColor ?? const Color(0xFFFF8A65), // Orange
      thickness: thickness,
      padding: padding,
      cornerRadius: 4.0,
    );
  }

  /// Creates a floral border with elegant black and white botanical theme
  factory FloralBorder.elegant({
    double thickness = 2.5,
    double padding = 20.0,
  }) {
    return FloralBorder(
      color: const Color(0xFF212121), // Dark gray/black
      secondaryColor: const Color(0xFF757575), // Medium gray
      thickness: thickness,
      padding: padding,
      cornerRadius: 4.0,
      hasShadow: true,
      shadowBlur: 6.0,
      shadowOpacity: 0.15,
    );
  }

  /// Creates a floral border with vibrant tropical botanical theme
  factory FloralBorder.tropical({
    Color? primaryColor,
    Color? accentColor,
    double thickness = 3.5,
    double padding = 22.0,
  }) {
    return FloralBorder(
      color: primaryColor ?? const Color(0xFF00695C), // Teal
      secondaryColor: accentColor ?? const Color(0xFFE91E63), // Magenta
      thickness: thickness,
      padding: padding,
      cornerRadius: 6.0,
    );
  }

  @override
  Widget build(Widget child) {
    return CustomPaint(
      painter: FloralBorderPainter(
        color: color,
        secondaryColor: secondaryColor,
        thickness: thickness,
        padding: padding,
        cornerRadius: cornerRadius,
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
        painter: FloralBorderPainter(
          color: color,
          secondaryColor: secondaryColor,
          thickness: thickness * 0.7, // Slightly thinner for thumbnail
          padding: size.width * 0.15, // Proportional padding
          cornerRadius: cornerRadius,
          hasShadow: false, // Disable shadow for thumbnail performance
          shadowBlur: shadowBlur,
          shadowOpacity: shadowOpacity,
        ),
        child: Center(
          child: Container(
            width: size.width * 0.4,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.eco_outlined,
              color: color,
              size: size.width * 0.25,
            ),
          ),
        ),
      ),
    );
  }

  @override
  FloralBorder copyWith({
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
    return FloralBorder(
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
  String get name => 'Floral Border';

  @override
  String get description => 'Nature-inspired border with leaves, vines, and corner flower decorations';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FloralBorder && super == other;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return 'FloralBorder(${super.toString()})';
  }
}
