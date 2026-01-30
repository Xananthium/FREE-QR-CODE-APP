import 'package:flutter/material.dart';
import '../base_border.dart';

/// Direction for gradient flow
enum GradientDirection {
  /// Left to right (horizontal)
  leftToRight,
  
  /// Right to left (horizontal reverse)
  rightToLeft,
  
  /// Top to bottom (vertical)
  topToBottom,
  
  /// Bottom to top (vertical reverse)
  bottomToTop,
  
  /// Top-left to bottom-right (diagonal)
  topLeftToBottomRight,
  
  /// Top-right to bottom-left (diagonal reverse)
  topRightToBottomLeft,
  
  /// Bottom-left to top-right (diagonal reverse)
  bottomLeftToTopRight,
  
  /// Bottom-right to top-left (diagonal)
  bottomRightToTopLeft,
}

/// A decorative border with linear gradient color transitions.
/// 
/// Creates beautiful, modern borders with smooth color gradients.
/// Perfect for adding visual interest and contemporary design aesthetics.
/// 
/// Example usage:
/// ```dart
/// final border = GradientBorder(
///   startColor: Colors.purple,
///   endColor: Colors.blue,
///   direction: GradientDirection.leftToRight,
///   thickness: 6.0,
///   cornerRadius: 12.0,
/// );
/// ```
class GradientBorder extends DecorativeBorder {
  /// Starting color of the gradient
  final Color startColor;
  
  /// Ending color of the gradient
  final Color endColor;
  
  /// Direction of the gradient flow
  final GradientDirection direction;
  
  /// Optional middle color for 3-color gradients
  final Color? middleColor;
  
  /// Creates a gradient border with the specified colors and direction.
  /// 
  /// [startColor] and [endColor] are required.
  /// [direction] defaults to left-to-right.
  /// [middleColor] is optional - if provided, creates a 3-color gradient.
  const GradientBorder({
    required this.startColor,
    required this.endColor,
    this.direction = GradientDirection.leftToRight,
    this.middleColor,
    super.thickness,
    super.padding,
    super.cornerRadius,
    super.hasShadow,
    super.shadowBlur,
    super.shadowOpacity,
  }) : super(
          color: startColor, // Use startColor as primary
          secondaryColor: endColor, // Use endColor as secondary
        );
  
  /// Factory: Creates a horizontal gradient (left to right)
  factory GradientBorder.horizontal({
    required Color startColor,
    required Color endColor,
    Color? middleColor,
    double thickness = 4.0,
    double padding = 16.0,
    double cornerRadius = 0.0,
  }) {
    return GradientBorder(
      startColor: startColor,
      endColor: endColor,
      middleColor: middleColor,
      direction: GradientDirection.leftToRight,
      thickness: thickness,
      padding: padding,
      cornerRadius: cornerRadius,
    );
  }
  
  /// Factory: Creates a vertical gradient (top to bottom)
  factory GradientBorder.vertical({
    required Color startColor,
    required Color endColor,
    Color? middleColor,
    double thickness = 4.0,
    double padding = 16.0,
    double cornerRadius = 0.0,
  }) {
    return GradientBorder(
      startColor: startColor,
      endColor: endColor,
      middleColor: middleColor,
      direction: GradientDirection.topToBottom,
      thickness: thickness,
      padding: padding,
      cornerRadius: cornerRadius,
    );
  }
  
  /// Factory: Creates a diagonal gradient (top-left to bottom-right)
  factory GradientBorder.diagonal({
    required Color startColor,
    required Color endColor,
    Color? middleColor,
    double thickness = 4.0,
    double padding = 16.0,
    double cornerRadius = 0.0,
  }) {
    return GradientBorder(
      startColor: startColor,
      endColor: endColor,
      middleColor: middleColor,
      direction: GradientDirection.topLeftToBottomRight,
      thickness: thickness,
      padding: padding,
      cornerRadius: cornerRadius,
    );
  }
  
  /// Factory: Vibrant sunset gradient (orange to pink)
  factory GradientBorder.sunset({
    double thickness = 4.0,
    double padding = 16.0,
    double cornerRadius = 12.0,
  }) {
    return GradientBorder(
      startColor: const Color(0xFFFF6B6B), // Coral red
      endColor: const Color(0xFFFFE66D), // Warm yellow
      middleColor: const Color(0xFFFF8E53), // Orange
      direction: GradientDirection.topLeftToBottomRight,
      thickness: thickness,
      padding: padding,
      cornerRadius: cornerRadius,
    );
  }
  
  /// Factory: Cool ocean gradient (blue to cyan)
  factory GradientBorder.ocean({
    double thickness = 4.0,
    double padding = 16.0,
    double cornerRadius = 12.0,
  }) {
    return GradientBorder(
      startColor: const Color(0xFF667EEA), // Deep blue
      endColor: const Color(0xFF64B5F6), // Light blue
      direction: GradientDirection.topToBottom,
      thickness: thickness,
      padding: padding,
      cornerRadius: cornerRadius,
    );
  }
  
  /// Factory: Purple aurora gradient
  factory GradientBorder.aurora({
    double thickness = 4.0,
    double padding = 16.0,
    double cornerRadius = 12.0,
  }) {
    return GradientBorder(
      startColor: const Color(0xFF667EEA), // Purple
      endColor: const Color(0xFFEC4899), // Pink
      direction: GradientDirection.leftToRight,
      thickness: thickness,
      padding: padding,
      cornerRadius: cornerRadius,
    );
  }
  
  /// Factory: Forest green gradient
  factory GradientBorder.forest({
    double thickness = 4.0,
    double padding = 16.0,
    double cornerRadius = 12.0,
  }) {
    return GradientBorder(
      startColor: const Color(0xFF11998E), // Teal
      endColor: const Color(0xFF38EF7D), // Mint green
      direction: GradientDirection.topLeftToBottomRight,
      thickness: thickness,
      padding: padding,
      cornerRadius: cornerRadius,
    );
  }
  
  /// Factory: Fire gradient (red to yellow)
  factory GradientBorder.fire({
    double thickness = 4.0,
    double padding = 16.0,
    double cornerRadius = 12.0,
  }) {
    return GradientBorder(
      startColor: const Color(0xFFF85032), // Red
      endColor: const Color(0xFFFBB034), // Yellow
      middleColor: const Color(0xFFFA6C2C), // Orange
      direction: GradientDirection.bottomToTop,
      thickness: thickness,
      padding: padding,
      cornerRadius: cornerRadius,
    );
  }

  @override
  Widget build(Widget child) {
    return CustomPaint(
      painter: _GradientBorderPainter(this),
      child: Padding(
        padding: EdgeInsets.all(padding + thickness),
        child: child,
      ),
    );
  }

  @override
  Widget buildThumbnail(Size size) {
    return SizedBox.fromSize(
      size: size,
      child: CustomPaint(
        painter: _GradientBorderPainter(this),
        child: Center(
          child: Container(
            width: size.width * 0.4,
            height: size.height * 0.4,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  GradientBorder copyWith({
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
    Color? startColor,
    Color? endColor,
    Color? middleColor,
    GradientDirection? direction,
  }) {
    return GradientBorder(
      startColor: startColor ?? this.startColor,
      endColor: endColor ?? this.endColor,
      middleColor: middleColor ?? this.middleColor,
      direction: direction ?? this.direction,
      thickness: thickness ?? this.thickness,
      padding: padding ?? this.padding,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      hasShadow: hasShadow ?? this.hasShadow,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
    );
  }

  @override
  String get name => 'Gradient Border';

  @override
  String get description => 'Modern border with smooth color transitions';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is GradientBorder &&
        other.startColor == startColor &&
        other.endColor == endColor &&
        other.middleColor == middleColor &&
        other.direction == direction &&
        super == other;
  }

  @override
  int get hashCode {
    return Object.hash(
      super.hashCode,
      startColor,
      endColor,
      middleColor,
      direction,
    );
  }
}

/// Custom painter for gradient borders
class _GradientBorderPainter extends CustomPainter {
  final GradientBorder border;
  
  _GradientBorderPainter(this.border);
  
  @override
  void paint(Canvas canvas, Size size) {
    // Determine gradient alignment based on direction
    final alignment = _getGradientAlignment(border.direction);
    
    // Create gradient colors list
    final colors = border.middleColor != null
        ? [border.startColor, border.middleColor!, border.endColor]
        : [border.startColor, border.endColor];
    
    // Create the gradient
    final gradient = LinearGradient(
      begin: alignment.$1,
      end: alignment.$2,
      colors: colors,
    );
    
    // Create rect for the border
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Create paint with gradient shader
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.thickness;
    
    // Add shadow if enabled
    if (border.hasShadow) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(border.shadowOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, border.shadowBlur)
        ..style = PaintingStyle.stroke
        ..strokeWidth = border.thickness;
      
      if (border.cornerRadius > 0) {
        final shadowRect = RRect.fromRectAndRadius(
          rect.deflate(border.thickness / 2),
          Radius.circular(border.cornerRadius),
        );
        canvas.drawRRect(shadowRect, shadowPaint);
      } else {
        canvas.drawRect(rect.deflate(border.thickness / 2), shadowPaint);
      }
    }
    
    // Draw the gradient border
    if (border.cornerRadius > 0) {
      final borderRect = RRect.fromRectAndRadius(
        rect.deflate(border.thickness / 2),
        Radius.circular(border.cornerRadius),
      );
      canvas.drawRRect(borderRect, paint);
    } else {
      canvas.drawRect(rect.deflate(border.thickness / 2), paint);
    }
  }
  
  /// Returns the begin and end alignment for the gradient direction
  (Alignment, Alignment) _getGradientAlignment(GradientDirection direction) {
    switch (direction) {
      case GradientDirection.leftToRight:
        return (Alignment.centerLeft, Alignment.centerRight);
      case GradientDirection.rightToLeft:
        return (Alignment.centerRight, Alignment.centerLeft);
      case GradientDirection.topToBottom:
        return (Alignment.topCenter, Alignment.bottomCenter);
      case GradientDirection.bottomToTop:
        return (Alignment.bottomCenter, Alignment.topCenter);
      case GradientDirection.topLeftToBottomRight:
        return (Alignment.topLeft, Alignment.bottomRight);
      case GradientDirection.topRightToBottomLeft:
        return (Alignment.topRight, Alignment.bottomLeft);
      case GradientDirection.bottomLeftToTopRight:
        return (Alignment.bottomLeft, Alignment.topRight);
      case GradientDirection.bottomRightToTopLeft:
        return (Alignment.bottomRight, Alignment.topLeft);
    }
  }
  
  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) {
    return oldDelegate.border != border;
  }
}
