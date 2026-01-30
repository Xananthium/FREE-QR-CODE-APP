import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_border.dart';

/// CustomPainter for rendering Victorian-style ornate borders with scrollwork.
///
/// This painter creates elaborate decorative borders featuring:
/// - Double-line frames
/// - Curved scroll patterns along edges
/// - Ornate corner flourishes
/// - Layered colors for depth and elegance
///
/// The design uses cubic Bezier curves to create smooth, organic
/// flowing lines characteristic of Victorian ornamentation.
class OrnatePainter extends CustomPainter {
  final DecorativeBorder border;

  const OrnatePainter(this.border);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final innerRect = rect.deflate(border.padding);

    // Apply shadow if enabled
    if (border.hasShadow) {
      _drawShadow(canvas, innerRect);
    }

    // Draw the ornate border components
    _drawDoubleFrame(canvas, innerRect);
    _drawCornerFlourishes(canvas, innerRect);
    _drawEdgeScrollwork(canvas, innerRect);
  }

  /// Draws a subtle shadow around the border
  void _drawShadow(Canvas canvas, Rect rect) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(border.shadowOpacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, border.shadowBlur);

    final shadowRect = RRect.fromRectAndRadius(
      rect.inflate(2),
      Radius.circular(border.cornerRadius),
    );

    canvas.drawRRect(shadowRect, shadowPaint);
  }

  /// Draws the main double-line frame
  void _drawDoubleFrame(Canvas canvas, Rect rect) {
    final outerPaint = Paint()
      ..color = border.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.thickness;

    final innerPaint = Paint()
      ..color = border.secondaryColor ?? border.color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.thickness * 0.5;

    final outerRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(border.cornerRadius),
    );

    // Outer frame
    canvas.drawRRect(outerRect, outerPaint);

    // Inner frame (inset)
    final insetAmount = border.thickness * 2.5;
    final innerRect = RRect.fromRectAndRadius(
      rect.deflate(insetAmount),
      Radius.circular(math.max(0, border.cornerRadius - insetAmount)),
    );
    canvas.drawRRect(innerRect, innerPaint);
  }

  /// Draws ornate flourishes at each corner
  void _drawCornerFlourishes(Canvas canvas, Rect rect) {
    final size = (border.patternSize ?? 24.0) * (border.thickness / 4.0);
    final offset = border.thickness * 2.5;

    // Top-left corner
    _drawSingleCornerFlourish(
      canvas,
      Offset(rect.left + offset, rect.top + offset),
      size,
      0, // rotation angle
    );

    // Top-right corner
    _drawSingleCornerFlourish(
      canvas,
      Offset(rect.right - offset, rect.top + offset),
      size,
      math.pi / 2, // 90 degrees
    );

    // Bottom-right corner
    _drawSingleCornerFlourish(
      canvas,
      Offset(rect.right - offset, rect.bottom - offset),
      size,
      math.pi, // 180 degrees
    );

    // Bottom-left corner
    _drawSingleCornerFlourish(
      canvas,
      Offset(rect.left + offset, rect.bottom - offset),
      size,
      3 * math.pi / 2, // 270 degrees
    );
  }

  /// Draws a single corner flourish with rotation
  void _drawSingleCornerFlourish(
    Canvas canvas,
    Offset center,
    double size,
    double rotation,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final primaryPaint = Paint()
      ..color = border.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.thickness * 0.8
      ..strokeCap = StrokeCap.round;

    final accentPaint = Paint()
      ..color = border.secondaryColor ?? border.color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.thickness * 0.5
      ..strokeCap = StrokeCap.round;

    // Main flourish - three-pronged ornament
    _drawFlourishProng(canvas, size, 0, primaryPaint);
    _drawFlourishProng(canvas, size * 0.8, -math.pi / 6, accentPaint);
    _drawFlourishProng(canvas, size * 0.8, math.pi / 6, accentPaint);

    // Central decorative element
    final centerCircle = Paint()
      ..color = border.color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, size * 0.12, centerCircle);

    canvas.restore();
  }

  /// Draws a single prong of the corner flourish
  void _drawFlourishProng(
    Canvas canvas,
    double size,
    double angle,
    Paint paint,
  ) {
    final path = Path();

    // Rotate the prong
    final cos = math.cos(angle);
    final sin = math.sin(angle);

    // Create elegant S-curve
    path.moveTo(0, 0);

    // First curve - outward sweep
    final cp1 = Offset(size * 0.3 * cos, size * 0.3 * sin);
    final cp2 = Offset(size * 0.5 * cos, size * 0.4 * sin);
    final end1 = Offset(size * 0.6 * cos, size * 0.6 * sin);
    path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end1.dx, end1.dy);

    // Second curve - spiral finish
    final cp3 = Offset(size * 0.7 * cos, size * 0.8 * sin);
    final cp4 = Offset(size * 0.65 * cos, size * 0.95 * sin);
    final end2 = Offset(size * 0.55 * cos, size * 1.0 * sin);
    path.cubicTo(cp3.dx, cp3.dy, cp4.dx, cp4.dy, end2.dx, end2.dy);

    // Add a small curl at the end
    final curlSize = size * 0.15;
    path.cubicTo(
      end2.dx - curlSize * 0.3,
      end2.dy + curlSize * 0.2,
      end2.dx - curlSize * 0.5,
      end2.dy + curlSize * 0.1,
      end2.dx - curlSize * 0.4,
      end2.dy,
    );

    canvas.drawPath(path, paint);
  }

  /// Draws scrollwork patterns along each edge
  void _drawEdgeScrollwork(Canvas canvas, Rect rect) {
    final spacing = border.patternSpacing ?? 40.0;
    final size = (border.patternSize ?? 16.0) * (border.thickness / 4.0);
    final offset = border.thickness * 2.5;

    // Top edge
    _drawEdgeScrolls(
      canvas,
      rect.topLeft + Offset(offset + size, offset),
      rect.topRight + Offset(-offset - size, offset),
      spacing,
      size,
      true, // horizontal
      false, // not flipped
    );

    // Bottom edge
    _drawEdgeScrolls(
      canvas,
      rect.bottomLeft + Offset(offset + size, -offset),
      rect.bottomRight + Offset(-offset - size, -offset),
      spacing,
      size,
      true, // horizontal
      true, // flipped
    );

    // Left edge
    _drawEdgeScrolls(
      canvas,
      rect.topLeft + Offset(offset, offset + size),
      rect.bottomLeft + Offset(offset, -offset - size),
      spacing,
      size,
      false, // vertical
      false, // not flipped
    );

    // Right edge
    _drawEdgeScrolls(
      canvas,
      rect.topRight + Offset(-offset, offset + size),
      rect.bottomRight + Offset(-offset, -offset - size),
      spacing,
      size,
      false, // vertical
      true, // flipped
    );
  }

  /// Draws a series of scrolls along an edge
  void _drawEdgeScrolls(
    Canvas canvas,
    Offset start,
    Offset end,
    double spacing,
    double size,
    bool horizontal,
    bool flipped,
  ) {
    final length = horizontal
        ? (end.dx - start.dx).abs()
        : (end.dy - start.dy).abs();

    final count = (length / spacing).floor();
    if (count <= 0) return;

    for (int i = 0; i < count; i++) {
      final t = i / count;
      final position = horizontal
          ? Offset(start.dx + length * t, start.dy)
          : Offset(start.dx, start.dy + length * t);

      _drawCScroll(canvas, position, size, horizontal, flipped);
    }
  }

  /// Draws a single C-shaped scroll
  void _drawCScroll(
    Canvas canvas,
    Offset position,
    double size,
    bool horizontal,
    bool flipped,
  ) {
    final path = Path();
    final primaryPaint = Paint()
      ..color = border.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.thickness * 0.6
      ..strokeCap = StrokeCap.round;

    final accentPaint = Paint()
      ..color = border.secondaryColor ?? border.color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.thickness * 0.3
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.translate(position.dx, position.dy);

    if (horizontal) {
      if (flipped) canvas.scale(1, -1);
    } else {
      canvas.rotate(math.pi / 2);
      if (flipped) canvas.scale(-1, 1);
    }

    // Main C-curve
    path.moveTo(0, -size * 0.5);
    path.cubicTo(
      size * 0.6,
      -size * 0.4,
      size * 0.6,
      size * 0.4,
      0,
      size * 0.5,
    );

    canvas.drawPath(path, primaryPaint);

    // Inner accent curve
    final accentPath = Path();
    accentPath.moveTo(-size * 0.15, -size * 0.3);
    accentPath.cubicTo(
      size * 0.35,
      -size * 0.25,
      size * 0.35,
      size * 0.25,
      -size * 0.15,
      size * 0.3,
    );

    canvas.drawPath(accentPath, accentPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(OrnatePainter oldDelegate) {
    return oldDelegate.border != border;
  }
}
