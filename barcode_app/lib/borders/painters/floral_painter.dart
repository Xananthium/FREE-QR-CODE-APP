import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painter for rendering nature-inspired floral borders.
///
/// This painter creates elegant botanical decorations including:
/// - Flowing vine patterns along edges
/// - Delicate leaf motifs
/// - Ornate corner flourishes with petals
/// - Organic, hand-drawn aesthetic
///
/// The design is inspired by Art Nouveau botanical illustrations and
/// classical book illuminations, creating a natural, organic feel.
class FloralBorderPainter extends CustomPainter {
  final Color color;
  final Color? secondaryColor;
  final double thickness;
  final double padding;
  final double cornerRadius;
  final bool hasShadow;
  final double shadowBlur;
  final double shadowOpacity;

  const FloralBorderPainter({
    required this.color,
    this.secondaryColor,
    required this.thickness,
    required this.padding,
    required this.cornerRadius,
    required this.hasShadow,
    required this.shadowBlur,
    required this.shadowOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Create paint for the main border
    final mainPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Create paint for fills (leaves, petals)
    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Secondary color for accents (if provided)
    final accentPaint = secondaryColor != null
        ? (Paint()
          ..color = secondaryColor!
          ..style = PaintingStyle.fill)
        : fillPaint;

    // Draw shadow if enabled
    if (hasShadow) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(shadowOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);
      
      _drawMainBorder(canvas, rect, shadowPaint, offset: Offset(2, 2));
    }

    // Draw main border frame
    _drawMainBorder(canvas, rect, mainPaint);

    // Draw decorative elements
    _drawVinePattern(canvas, rect, mainPaint, fillPaint);
    _drawCornerFlourishes(canvas, rect, mainPaint, fillPaint, accentPaint);
    _drawLeafAccents(canvas, rect, mainPaint, fillPaint);
  }

  /// Draws the main rectangular border frame
  void _drawMainBorder(Canvas canvas, Rect rect, Paint paint, {Offset offset = Offset.zero}) {
    final inset = padding + thickness / 2;
    final borderRect = Rect.fromLTRB(
      inset + offset.dx,
      inset + offset.dy,
      rect.width - inset + offset.dx,
      rect.height - inset + offset.dy,
    );

    if (cornerRadius > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(borderRect, Radius.circular(cornerRadius)),
        paint,
      );
    } else {
      canvas.drawRect(borderRect, paint);
    }
  }

  /// Draws flowing vine patterns along the edges
  void _drawVinePattern(Canvas canvas, Rect rect, Paint strokePaint, Paint fillPaint) {
    final inset = padding + thickness / 2;
    final vineThickness = thickness * 0.5;
    
    final vinePaint = Paint()
      ..color = strokePaint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = vineThickness
      ..strokeCap = StrokeCap.round;

    // Top vine with gentle curves
    _drawTopVine(canvas, rect, inset, vinePaint, fillPaint);
    
    // Bottom vine (mirrored)
    _drawBottomVine(canvas, rect, inset, vinePaint, fillPaint);
    
    // Side vines
    _drawLeftVine(canvas, rect, inset, vinePaint, fillPaint);
    _drawRightVine(canvas, rect, inset, vinePaint, fillPaint);
  }

  /// Draws a flowing vine along the top edge
  void _drawTopVine(Canvas canvas, Rect rect, double inset, Paint vinePaint, Paint fillPaint) {
    final path = Path();
    final startX = inset + 40;
    final endX = rect.width - inset - 40;
    final y = inset - thickness * 0.5;
    
    path.moveTo(startX, y);
    
    // Create flowing S-curves along the top
    final segments = 3;
    final segmentWidth = (endX - startX) / segments;
    
    for (int i = 0; i < segments; i++) {
      final x1 = startX + segmentWidth * i;
      final x2 = startX + segmentWidth * (i + 0.5);
      final x3 = startX + segmentWidth * (i + 1);
      
      final amplitude = 6.0;
      final yOffset = i.isEven ? amplitude : -amplitude;
      
      path.cubicTo(
        x1 + segmentWidth * 0.25, y + yOffset,
        x2 - segmentWidth * 0.25, y - yOffset,
        x2, y,
      );
      path.cubicTo(
        x2 + segmentWidth * 0.25, y,
        x3 - segmentWidth * 0.25, y,
        x3, y,
      );
    }
    
    canvas.drawPath(path, vinePaint);
    
    // Add small leaves along the vine
    for (int i = 0; i < segments + 1; i++) {
      final x = startX + segmentWidth * i;
      _drawSmallLeaf(canvas, Offset(x, y), fillPaint, math.pi / 4);
    }
  }

  /// Draws a flowing vine along the bottom edge
  void _drawBottomVine(Canvas canvas, Rect rect, double inset, Paint vinePaint, Paint fillPaint) {
    final path = Path();
    final startX = inset + 40;
    final endX = rect.width - inset - 40;
    final y = rect.height - inset + thickness * 0.5;
    
    path.moveTo(startX, y);
    
    final segments = 3;
    final segmentWidth = (endX - startX) / segments;
    
    for (int i = 0; i < segments; i++) {
      final x1 = startX + segmentWidth * i;
      final x2 = startX + segmentWidth * (i + 0.5);
      final x3 = startX + segmentWidth * (i + 1);
      
      final amplitude = 6.0;
      final yOffset = i.isEven ? -amplitude : amplitude;
      
      path.cubicTo(
        x1 + segmentWidth * 0.25, y + yOffset,
        x2 - segmentWidth * 0.25, y - yOffset,
        x2, y,
      );
      path.cubicTo(
        x2 + segmentWidth * 0.25, y,
        x3 - segmentWidth * 0.25, y,
        x3, y,
      );
    }
    
    canvas.drawPath(path, vinePaint);
    
    // Add small leaves
    for (int i = 0; i < segments + 1; i++) {
      final x = startX + segmentWidth * i;
      _drawSmallLeaf(canvas, Offset(x, y), fillPaint, -math.pi / 4);
    }
  }

  /// Draws a flowing vine along the left edge
  void _drawLeftVine(Canvas canvas, Rect rect, double inset, Paint vinePaint, Paint fillPaint) {
    final path = Path();
    final x = inset - thickness * 0.5;
    final startY = inset + 40;
    final endY = rect.height - inset - 40;
    
    path.moveTo(x, startY);
    
    final segments = 3;
    final segmentHeight = (endY - startY) / segments;
    
    for (int i = 0; i < segments; i++) {
      final y1 = startY + segmentHeight * i;
      final y2 = startY + segmentHeight * (i + 0.5);
      final y3 = startY + segmentHeight * (i + 1);
      
      final amplitude = 6.0;
      final xOffset = i.isEven ? amplitude : -amplitude;
      
      path.cubicTo(
        x + xOffset, y1 + segmentHeight * 0.25,
        x - xOffset, y2 - segmentHeight * 0.25,
        x, y2,
      );
      path.cubicTo(
        x, y2 + segmentHeight * 0.25,
        x, y3 - segmentHeight * 0.25,
        x, y3,
      );
    }
    
    canvas.drawPath(path, vinePaint);
    
    // Add small leaves
    for (int i = 0; i < segments + 1; i++) {
      final y = startY + segmentHeight * i;
      _drawSmallLeaf(canvas, Offset(x, y), fillPaint, math.pi * 0.6);
    }
  }

  /// Draws a flowing vine along the right edge
  void _drawRightVine(Canvas canvas, Rect rect, double inset, Paint vinePaint, Paint fillPaint) {
    final path = Path();
    final x = rect.width - inset + thickness * 0.5;
    final startY = inset + 40;
    final endY = rect.height - inset - 40;
    
    path.moveTo(x, startY);
    
    final segments = 3;
    final segmentHeight = (endY - startY) / segments;
    
    for (int i = 0; i < segments; i++) {
      final y1 = startY + segmentHeight * i;
      final y2 = startY + segmentHeight * (i + 0.5);
      final y3 = startY + segmentHeight * (i + 1);
      
      final amplitude = 6.0;
      final xOffset = i.isEven ? -amplitude : amplitude;
      
      path.cubicTo(
        x + xOffset, y1 + segmentHeight * 0.25,
        x - xOffset, y2 - segmentHeight * 0.25,
        x, y2,
      );
      path.cubicTo(
        x, y2 + segmentHeight * 0.25,
        x, y3 - segmentHeight * 0.25,
        x, y3,
      );
    }
    
    canvas.drawPath(path, vinePaint);
    
    // Add small leaves
    for (int i = 0; i < segments + 1; i++) {
      final y = startY + segmentHeight * i;
      _drawSmallLeaf(canvas, Offset(x, y), fillPaint, math.pi * 0.4);
    }
  }

  /// Draws ornate corner flourishes with petal designs
  void _drawCornerFlourishes(Canvas canvas, Rect rect, Paint strokePaint, 
                            Paint fillPaint, Paint accentPaint) {
    final inset = padding;
    
    // Top-left corner
    _drawCornerFlower(canvas, Offset(inset, inset), strokePaint, fillPaint, accentPaint);
    
    // Top-right corner
    canvas.save();
    canvas.translate(rect.width - inset, inset);
    canvas.rotate(math.pi / 2);
    canvas.translate(-inset, -inset);
    _drawCornerFlower(canvas, Offset(inset, inset), strokePaint, fillPaint, accentPaint);
    canvas.restore();
    
    // Bottom-right corner
    canvas.save();
    canvas.translate(rect.width - inset, rect.height - inset);
    canvas.rotate(math.pi);
    canvas.translate(-inset, -inset);
    _drawCornerFlower(canvas, Offset(inset, inset), strokePaint, fillPaint, accentPaint);
    canvas.restore();
    
    // Bottom-left corner
    canvas.save();
    canvas.translate(inset, rect.height - inset);
    canvas.rotate(-math.pi / 2);
    canvas.translate(-inset, -inset);
    _drawCornerFlower(canvas, Offset(inset, inset), strokePaint, fillPaint, accentPaint);
    canvas.restore();
  }

  /// Draws a decorative flower flourish for corners
  void _drawCornerFlower(Canvas canvas, Offset center, Paint strokePaint, 
                        Paint fillPaint, Paint accentPaint) {
    final size = 20.0;
    final petalCount = 5;
    
    // Draw petals in a radial pattern
    for (int i = 0; i < petalCount; i++) {
      final angle = (math.pi * 2 / petalCount) * i - math.pi / 2;
      _drawPetal(canvas, center, size, angle, fillPaint, strokePaint);
    }
    
    // Draw center circle
    canvas.drawCircle(center, size * 0.25, accentPaint);
    canvas.drawCircle(center, size * 0.25, strokePaint..style = PaintingStyle.stroke);
    strokePaint.style = PaintingStyle.stroke; // Reset
    
    // Draw decorative leaves extending from corner
    _drawCornerLeaves(canvas, center, strokePaint, fillPaint);
  }

  /// Draws a single petal shape
  void _drawPetal(Canvas canvas, Offset center, double size, double angle, 
                 Paint fillPaint, Paint strokePaint) {
    final path = Path();
    
    final tipX = center.dx + math.cos(angle) * size;
    final tipY = center.dy + math.sin(angle) * size;
    
    final control1X = center.dx + math.cos(angle - 0.3) * size * 0.6;
    final control1Y = center.dy + math.sin(angle - 0.3) * size * 0.6;
    
    final control2X = center.dx + math.cos(angle + 0.3) * size * 0.6;
    final control2Y = center.dy + math.sin(angle + 0.3) * size * 0.6;
    
    path.moveTo(center.dx, center.dy);
    path.quadraticBezierTo(control1X, control1Y, tipX, tipY);
    path.quadraticBezierTo(control2X, control2Y, center.dx, center.dy);
    path.close();
    
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint..strokeWidth = thickness * 0.5);
    strokePaint.strokeWidth = thickness; // Reset
  }

  /// Draws decorative leaves extending from corner
  void _drawCornerLeaves(Canvas canvas, Offset center, Paint strokePaint, Paint fillPaint) {
    // Two leaves extending at angles from the corner flower
    _drawLeaf(canvas, center, 25.0, 0.3, fillPaint, strokePaint);
    _drawLeaf(canvas, center, 22.0, -0.6, fillPaint, strokePaint);
  }

  /// Draws a leaf shape at specified angle
  void _drawLeaf(Canvas canvas, Offset start, double length, double angle, 
                Paint fillPaint, Paint strokePaint) {
    final path = Path();
    
    final endX = start.dx + math.cos(angle) * length;
    final endY = start.dy + math.sin(angle) * length;
    
    final width = length * 0.4;
    
    final perpAngle = angle + math.pi / 2;
    final control1X = start.dx + math.cos(angle) * length * 0.3 + math.cos(perpAngle) * width * 0.5;
    final control1Y = start.dy + math.sin(angle) * length * 0.3 + math.sin(perpAngle) * width * 0.5;
    
    final control2X = start.dx + math.cos(angle) * length * 0.7 + math.cos(perpAngle) * width * 0.3;
    final control2Y = start.dy + math.sin(angle) * length * 0.7 + math.sin(perpAngle) * width * 0.3;
    
    final control3X = start.dx + math.cos(angle) * length * 0.7 - math.cos(perpAngle) * width * 0.3;
    final control3Y = start.dy + math.sin(angle) * length * 0.7 - math.sin(perpAngle) * width * 0.3;
    
    final control4X = start.dx + math.cos(angle) * length * 0.3 - math.cos(perpAngle) * width * 0.5;
    final control4Y = start.dy + math.sin(angle) * length * 0.3 - math.sin(perpAngle) * width * 0.5;
    
    path.moveTo(start.dx, start.dy);
    path.cubicTo(control1X, control1Y, control2X, control2Y, endX, endY);
    path.cubicTo(control3X, control3Y, control4X, control4Y, start.dx, start.dy);
    path.close();
    
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint..strokeWidth = thickness * 0.3);
    
    // Draw center vein
    canvas.drawLine(start, Offset(endX, endY), strokePaint..strokeWidth = thickness * 0.2);
    
    strokePaint.strokeWidth = thickness; // Reset
  }

  /// Draws small leaf accents between corners
  void _drawLeafAccents(Canvas canvas, Rect rect, Paint strokePaint, Paint fillPaint) {
    final inset = padding;
    final midX = rect.width / 2;
    final midY = rect.height / 2;
    
    // Top center
    _drawSmallLeaf(canvas, Offset(midX, inset), fillPaint, math.pi / 2);
    
    // Bottom center
    _drawSmallLeaf(canvas, Offset(midX, rect.height - inset), fillPaint, -math.pi / 2);
    
    // Left center
    _drawSmallLeaf(canvas, Offset(inset, midY), fillPaint, 0);
    
    // Right center
    _drawSmallLeaf(canvas, Offset(rect.width - inset, midY), fillPaint, math.pi);
  }

  /// Draws a small decorative leaf
  void _drawSmallLeaf(Canvas canvas, Offset position, Paint fillPaint, double angle) {
    final size = 8.0;
    final path = Path();
    
    final tipX = position.dx + math.cos(angle) * size;
    final tipY = position.dy + math.sin(angle) * size;
    
    final perpAngle = angle + math.pi / 2;
    final width = size * 0.5;
    
    path.moveTo(position.dx, position.dy);
    path.quadraticBezierTo(
      position.dx + math.cos(angle) * size * 0.5 + math.cos(perpAngle) * width,
      position.dy + math.sin(angle) * size * 0.5 + math.sin(perpAngle) * width,
      tipX,
      tipY,
    );
    path.quadraticBezierTo(
      position.dx + math.cos(angle) * size * 0.5 - math.cos(perpAngle) * width,
      position.dy + math.sin(angle) * size * 0.5 - math.sin(perpAngle) * width,
      position.dx,
      position.dy,
    );
    path.close();
    
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(FloralBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.thickness != thickness ||
        oldDelegate.padding != padding ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.hasShadow != hasShadow ||
        oldDelegate.shadowBlur != shadowBlur ||
        oldDelegate.shadowOpacity != shadowOpacity;
  }
}
