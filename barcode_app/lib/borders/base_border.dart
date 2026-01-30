import 'package:flutter/material.dart';

/// Abstract base class for all decorative borders in the QR code app.
/// 
/// This class defines the interface that all border implementations must follow.
/// Each border type (Classic, Minimal, Ornate, Floral, etc.) extends this class
/// and provides concrete implementations of the rendering methods.
/// 
/// The border system is designed to be:
/// - Immutable: All properties are final
/// - Extensible: Easy to add new border types
/// - Flexible: Supports simple to complex decorative borders
/// - Performant: Efficient rendering via CustomPainter
@immutable
abstract class DecorativeBorder {
  /// Primary color of the border
  final Color color;
  
  /// Secondary color for gradients, dual-tone effects, or accents
  /// Null if the border uses only a single color
  final Color? secondaryColor;
  
  /// Border line thickness in logical pixels
  final double thickness;
  
  /// Padding between the content (QR code) and the border in logical pixels
  final double padding;
  
  /// Corner radius for rounded borders (0.0 = sharp corners)
  final double cornerRadius;
  
  /// Whether this border should render with a shadow effect
  final bool hasShadow;
  
  /// Shadow blur radius in logical pixels (only applies if hasShadow is true)
  final double shadowBlur;
  
  /// Shadow opacity from 0.0 (transparent) to 1.0 (opaque)
  final double shadowOpacity;
  
  /// Spacing between pattern elements (e.g., dash spacing, dot spacing)
  /// Null if the border has no pattern
  final double? patternSpacing;
  
  /// Size of pattern elements (e.g., dot diameter, decoration size)
  /// Null if the border has no pattern
  final double? patternSize;

  /// Creates a new DecorativeBorder with the given properties.
  /// 
  /// All concrete border implementations should call this constructor
  /// from their own constructors.
  const DecorativeBorder({
    required this.color,
    this.secondaryColor,
    this.thickness = 4.0,
    this.padding = 16.0,
    this.cornerRadius = 0.0,
    this.hasShadow = false,
    this.shadowBlur = 4.0,
    this.shadowOpacity = 0.3,
    this.patternSpacing,
    this.patternSize,
  });

  /// Builds the complete widget with the border wrapped around the child.
  /// 
  /// This is the main rendering method that concrete implementations must provide.
  /// It should return a widget that:
  /// - Applies padding around the child
  /// - Renders the decorative border using CustomPaint
  /// - Handles shadows if hasShadow is true
  /// - Properly sizes itself based on child size + padding + border thickness
  /// 
  /// Example implementation:
  /// ```dart
  /// @override
  /// Widget build(Widget child) {
  ///   return CustomPaint(
  ///     painter: MyBorderPainter(this),
  ///     child: Padding(
  ///       padding: EdgeInsets.all(padding),
  ///       child: child,
  ///     ),
  ///   );
  /// }
  /// ```
  Widget build(Widget child);

  /// Builds a small thumbnail preview of this border for UI selection.
  /// 
  /// Used in the border gallery/picker to show users what each border looks like.
  /// Should render a simplified version of the border that:
  /// - Fits within the given size
  /// - Shows the distinctive characteristics of the border style
  /// - Is lightweight and fast to render (may simplify complex patterns)
  /// - Centers a small placeholder or sample content
  /// 
  /// The thumbnail should be representative but doesn't need to show every detail.
  /// 
  /// [size] - The dimensions of the thumbnail widget
  Widget buildThumbnail(Size size);

  /// Creates a copy of this border with the specified properties replaced.
  /// 
  /// All concrete implementations must override this to return their specific type.
  /// This enables immutable modification of border properties.
  /// 
  /// Example:
  /// ```dart
  /// final newBorder = existingBorder.copyWith(
  ///   color: Colors.blue,
  ///   thickness: 6.0,
  /// );
  /// ```
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
  });

  /// Returns a human-readable name for this border style.
  /// 
  /// Used in UI to display the border type to users.
  /// Examples: "Classic Border", "Floral Border", "Minimal Border"
  String get name;

  /// Returns a brief description of this border style.
  /// 
  /// Used in UI to help users understand what makes this border unique.
  /// Examples: 
  /// - "Elegant double-frame border"
  /// - "Nature-inspired floral decorations"
  /// - "Clean, thin modern border"
  String get description;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is DecorativeBorder &&
        other.color == color &&
        other.secondaryColor == secondaryColor &&
        other.thickness == thickness &&
        other.padding == padding &&
        other.cornerRadius == cornerRadius &&
        other.hasShadow == hasShadow &&
        other.shadowBlur == shadowBlur &&
        other.shadowOpacity == shadowOpacity &&
        other.patternSpacing == patternSpacing &&
        other.patternSize == patternSize;
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      secondaryColor,
      thickness,
      padding,
      cornerRadius,
      hasShadow,
      shadowBlur,
      shadowOpacity,
      Object.hash(
        patternSpacing,
        patternSize,
      ),
    );
  }

  @override
  String toString() {
    return '$name(color: $color, secondaryColor: $secondaryColor, '
        'thickness: $thickness, padding: $padding, cornerRadius: $cornerRadius, '
        'hasShadow: $hasShadow, shadowBlur: $shadowBlur, '
        'shadowOpacity: $shadowOpacity, patternSpacing: $patternSpacing, '
        'patternSize: $patternSize)';
  }
}
