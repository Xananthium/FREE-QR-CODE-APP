import 'package:flutter/material.dart';
import '../base_border.dart';

/// Rounded border with soft, friendly rounded corners.
/// 
/// This border creates a modern, approachable frame with customizable
/// corner radius and optional subtle shadow for depth. Perfect for
/// contemporary designs that need a softer, less rigid appearance.
/// 
/// Features:
/// - Configurable corner radius (default: 16.0)
/// - Optional subtle shadow for depth
/// - Clean, minimal aesthetic
/// - Works well with both light and dark themes
class RoundedBorder extends DecorativeBorder {
  const RoundedBorder({
    required super.color,
    super.secondaryColor,
    super.thickness = 4.0,
    super.padding = 16.0,
    super.cornerRadius = 16.0,
    super.hasShadow = false,
    super.shadowBlur = 8.0,
    super.shadowOpacity = 0.15,
    super.patternSpacing,
    super.patternSize,
  });

  @override
  String get name => 'Rounded Border';

  @override
  String get description => 'Soft rounded corners with optional subtle shadow';

  @override
  Widget build(Widget child) {
    return CustomPaint(
      painter: _RoundedBorderPainter(this),
      child: Padding(
        padding: EdgeInsets.all(padding + thickness / 2),
        child: child,
      ),
    );
  }

  @override
  Widget buildThumbnail(Size size) {
    return CustomPaint(
      painter: _RoundedBorderPainter(this),
      size: size,
      child: Center(
        child: Container(
          width: size.width * 0.4,
          height: size.height * 0.4,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
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
    return RoundedBorder(
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
}

/// Custom painter for the rounded border.
class _RoundedBorderPainter extends CustomPainter {
  final RoundedBorder border;

  _RoundedBorderPainter(this.border);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(border.cornerRadius),
    );

    // Draw shadow if enabled
    if (border.hasShadow) {
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: border.shadowOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, border.shadowBlur);
      
      canvas.drawRRect(rrect, shadowPaint);
    }

    // Draw the rounded border
    final borderPaint = Paint()
      ..color = border.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.thickness
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawRRect(rrect, borderPaint);

    // If secondary color is provided, draw an inner stroke
    if (border.secondaryColor != null) {
      final innerRect = rect.deflate(border.thickness);
      final innerRRect = RRect.fromRectAndRadius(
        innerRect,
        Radius.circular(border.cornerRadius - border.thickness),
      );
      
      final secondaryPaint = Paint()
        ..color = border.secondaryColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = border.thickness / 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawRRect(innerRRect, secondaryPaint);
    }
  }

  @override
  bool shouldRepaint(_RoundedBorderPainter oldDelegate) {
    return oldDelegate.border != border;
  }
}
