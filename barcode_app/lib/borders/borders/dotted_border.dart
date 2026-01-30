import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_border.dart';

/// A decorative border that renders as a series of rounded dots.
/// 
/// This border style creates a dotted line effect with:
/// - Configurable dot spacing for density control
/// - Perfectly circular (rounded) dots
/// - Clean corner handling with proper dot placement
/// - Smooth visual flow around corners
/// 
/// The dotted pattern is rendered using CustomPainter for optimal performance
/// and precise control over dot positioning and sizing.
class DottedBorder extends DecorativeBorder {
  /// Creates a dotted border with the given properties.
  /// 
  /// [color] - The color of the dots
  /// [thickness] - The border line thickness (also the base dot diameter)
  /// [padding] - Space between content and border
  /// [cornerRadius] - Corner radius for the border path
  /// [patternSpacing] - Gap between dots (defaults to thickness * 1.5)
  /// [patternSize] - Individual dot diameter (defaults to thickness)
  const DottedBorder({
    required super.color,
    super.secondaryColor,
    super.thickness = 4.0,
    super.padding = 16.0,
    super.cornerRadius = 0.0,
    super.hasShadow = false,
    super.shadowBlur = 4.0,
    super.shadowOpacity = 0.3,
    super.patternSpacing,
    super.patternSize,
  });

  @override
  Widget build(Widget child) {
    return CustomPaint(
      painter: _DottedBorderPainter(this),
      child: Padding(
        padding: EdgeInsets.all(padding + thickness / 2),
        child: child,
      ),
    );
  }

  @override
  Widget buildThumbnail(Size size) {
    return CustomPaint(
      painter: _DottedBorderPainter(this),
      size: size,
      child: Container(),
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
    return DottedBorder(
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
  String get name => 'Dotted Border';

  @override
  String get description => 'Modern dotted line border with rounded dots';
}

/// CustomPainter that renders the dotted border pattern.
/// 
/// This painter:
/// - Calculates optimal dot placement along the border path
/// - Ensures dots are evenly distributed
/// - Handles corners cleanly without overlapping dots
/// - Renders perfectly circular dots using drawCircle
class _DottedBorderPainter extends CustomPainter {
  final DottedBorder border;

  _DottedBorderPainter(this.border);

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate dot size and spacing
    final dotDiameter = border.patternSize ?? border.thickness;
    final dotRadius = dotDiameter / 2;
    final spacing = border.patternSpacing ?? (border.thickness * 1.5);
    
    // Total spacing between dot centers
    final dotPitch = dotDiameter + spacing;

    // Create paint for dots
    final paint = Paint()
      ..color = border.color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Add shadow if enabled
    if (border.hasShadow) {
      canvas.saveLayer(
        Offset.zero & size,
        Paint()..color = Colors.white,
      );
      
      final shadowPaint = Paint()
        ..color = border.color.withValues(alpha: border.shadowOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, border.shadowBlur)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      
      _drawDots(canvas, size, dotRadius, dotPitch, spacing, shadowPaint, offsetShadow: true);
      canvas.restore();
    }

    // Draw the actual dots
    _drawDots(canvas, size, dotRadius, dotPitch, spacing, paint);
  }

  /// Draws dots along all four sides of the border.
  /// 
  /// This method calculates dot positions along each side and handles
  /// corners properly to avoid overlap and maintain visual consistency.
  void _drawDots(
    Canvas canvas,
    Size size,
    double dotRadius,
    double dotPitch,
    double spacing,
    Paint paint, {
    bool offsetShadow = false,
  }) {
    final inset = border.thickness / 2;
    final cornerRad = border.cornerRadius;

    // Offset for shadow
    final shadowOffset = offsetShadow ? Offset(0, border.shadowBlur / 2) : Offset.zero;

    // Define the four sides
    final sides = [
      // Top side
      _Side(
        start: Offset(inset + cornerRad, inset),
        end: Offset(size.width - inset - cornerRad, inset),
      ),
      // Right side
      _Side(
        start: Offset(size.width - inset, inset + cornerRad),
        end: Offset(size.width - inset, size.height - inset - cornerRad),
      ),
      // Bottom side
      _Side(
        start: Offset(size.width - inset - cornerRad, size.height - inset),
        end: Offset(inset + cornerRad, size.height - inset),
      ),
      // Left side
      _Side(
        start: Offset(inset, size.height - inset - cornerRad),
        end: Offset(inset, inset + cornerRad),
      ),
    ];

    // Draw dots along each side
    for (final side in sides) {
      final sideLength = (side.end - side.start).distance;
      final direction = (side.end - side.start) / sideLength;
      
      // Calculate number of dots that fit on this side
      final numDots = (sideLength / dotPitch).floor();
      
      if (numDots <= 0) continue;
      
      // Center the dots on the side by calculating offset
      final totalDotsLength = numDots * dotPitch - spacing;
      final startOffset = (sideLength - totalDotsLength) / 2;

      // Draw each dot
      for (int i = 0; i < numDots; i++) {
        final distance = startOffset + i * dotPitch;
        final dotCenter = side.start + (direction * distance) + shadowOffset;
        
        canvas.drawCircle(dotCenter, dotRadius, paint);
      }
    }

    // Draw corner dots if there's corner radius
    if (cornerRad > 0) {
      _drawCornerDots(canvas, size, dotRadius, dotPitch, spacing, paint, shadowOffset);
    }
  }

  /// Draws dots along rounded corners.
  /// 
  /// This ensures clean visual flow around corners by placing dots
  /// along the arc of the corner radius.
  void _drawCornerDots(
    Canvas canvas,
    Size size,
    double dotRadius,
    double dotPitch,
    double spacing,
    Paint paint,
    Offset shadowOffset,
  ) {
    final inset = border.thickness / 2;
    final cornerRad = border.cornerRadius;

    // Define the four corner arcs
    final corners = [
      // Top-left
      _Corner(
        center: Offset(inset + cornerRad, inset + cornerRad),
        startAngle: -math.pi, // π (180°)
        sweepAngle: math.pi / 2, // π/2 (90°)
      ),
      // Top-right
      _Corner(
        center: Offset(size.width - inset - cornerRad, inset + cornerRad),
        startAngle: -math.pi / 2, // -π/2 (-90°)
        sweepAngle: math.pi / 2,
      ),
      // Bottom-right
      _Corner(
        center: Offset(size.width - inset - cornerRad, size.height - inset - cornerRad),
        startAngle: 0,
        sweepAngle: math.pi / 2,
      ),
      // Bottom-left
      _Corner(
        center: Offset(inset + cornerRad, size.height - inset - cornerRad),
        startAngle: math.pi / 2, // π/2 (90°)
        sweepAngle: math.pi / 2,
      ),
    ];

    // Draw dots along each corner arc
    for (final corner in corners) {
      final arcLength = cornerRad * corner.sweepAngle;
      final numDots = (arcLength / dotPitch).floor();
      
      if (numDots <= 0) continue;

      final totalDotsLength = numDots * dotPitch - spacing;
      final startAngleOffset = (arcLength - totalDotsLength) / (2 * cornerRad);

      for (int i = 0; i < numDots; i++) {
        final angleDistance = startAngleOffset + (i * dotPitch) / cornerRad;
        final angle = corner.startAngle + angleDistance;
        
        final dotCenter = corner.center + Offset(
          cornerRad * math.cos(angle),
          cornerRad * math.sin(angle),
        ) + shadowOffset;
        
        canvas.drawCircle(dotCenter, dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DottedBorderPainter oldDelegate) {
    return oldDelegate.border != border;
  }
}

/// Helper class to represent a straight side of the border.
class _Side {
  final Offset start;
  final Offset end;

  _Side({required this.start, required this.end});
}

/// Helper class to represent a corner arc of the border.
class _Corner {
  final Offset center;
  final double startAngle;
  final double sweepAngle;

  _Corner({
    required this.center,
    required this.startAngle,
    required this.sweepAngle,
  });
}
