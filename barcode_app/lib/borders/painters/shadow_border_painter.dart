import 'package:flutter/material.dart';
import '../borders/shadow_border.dart';

/// Custom painter for rendering the Shadow Border with 3D elevation effects.
/// 
/// This painter creates depth perception through:
/// - Outer drop shadow with configurable offset and blur
/// - Optional inner shadow for enhanced depth
/// - Smooth rounded rectangle with subtle border
/// - Multiple shadow layers for realistic 3D appearance
/// 
/// The rendering uses Material Design shadow principles to create
/// a floating, elevated card effect.
class ShadowBorderPainter extends CustomPainter {
  final ShadowBorder border;

  const ShadowBorderPainter(this.border);

  @override
  void paint(Canvas canvas, Size size) {
    // Create rounded rectangle for the border
    final borderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(border.cornerRadius),
    );

    // Paint the drop shadow if enabled
    if (border.hasShadow) {
      _paintDropShadow(canvas, borderRect);
    }

    // Paint the main border background (elevated surface)
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRRect(borderRect, backgroundPaint);

    // Paint inner shadow if enabled
    if (border.hasInnerShadow) {
      _paintInnerShadow(canvas, borderRect);
    }

    // Paint the border outline
    final borderPaint = Paint()
      ..color = border.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.thickness;
    canvas.drawRRect(borderRect, borderPaint);
  }

  /// Paints the outer drop shadow for elevation effect
  void _paintDropShadow(Canvas canvas, RRect borderRect) {
    // Create multiple shadow layers for depth
    final shadowLayers = [
      // Primary shadow (largest, softest)
      (
        blur: border.shadowBlur,
        opacity: border.shadowOpacity,
        offset: border.shadowOffset,
      ),
      // Secondary shadow (tighter, slightly darker)
      if (border.shadowBlur > 4.0) (
        blur: border.shadowBlur * 0.5,
        opacity: border.shadowOpacity * 0.7,
        offset: border.shadowOffset * 0.6,
      ),
      // Ambient shadow (very subtle, large spread)
      if (border.shadowBlur > 6.0) (
        blur: border.shadowBlur * 1.5,
        opacity: border.shadowOpacity * 0.3,
        offset: Offset(0, border.shadowOffset.dy * 0.3),
      ),
    ];

    // Paint each shadow layer
    for (final layer in shadowLayers) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(layer.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, layer.blur);

      // Offset the shadow
      final shadowRect = borderRect.shift(layer.offset);
      canvas.drawRRect(shadowRect, shadowPaint);
    }
  }

  /// Paints the inner shadow for enhanced depth perception
  void _paintInnerShadow(Canvas canvas, RRect borderRect) {
    // Save canvas state
    canvas.saveLayer(borderRect.outerRect, Paint());

    // Fill with white to create clipping mask
    final clipPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRRect(borderRect, clipPaint);

    // Create inner shadow by drawing inverted shadow
    final innerShadowPaint = Paint()
      ..color = Colors.black.withOpacity(border.shadowOpacity * 0.4)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, border.innerShadowBlur)
      ..blendMode = BlendMode.multiply;

    // Inset the shadow rectangle
    final insetRect = RRect.fromRectAndRadius(
      borderRect.outerRect.deflate(border.thickness),
      Radius.circular(border.cornerRadius - border.thickness),
    );

    // Draw shadow inset
    final innerShadowOffset = Offset(0, -2);
    final shadowRect = insetRect.shift(innerShadowOffset);
    canvas.drawRRect(shadowRect, innerShadowPaint);

    // Restore canvas
    canvas.restore();
  }

  @override
  bool shouldRepaint(ShadowBorderPainter oldDelegate) {
    return oldDelegate.border != border;
  }
}
