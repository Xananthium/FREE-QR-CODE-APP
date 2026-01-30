import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../borders/geometric_border.dart';

/// CustomPainter that renders geometric pattern borders.
/// 
/// This painter creates repeating geometric patterns (triangles, hexagons,
/// diamonds, or circles) around the border frame. The patterns are
/// mathematically precise and evenly spaced.
class GeometricPainter extends CustomPainter {
  final Color color;
  final Color? secondaryColor;
  final double thickness;
  final double cornerRadius;
  final GeometricPattern patternType;
  final double patternSize;
  final double patternSpacing;
  final bool hasShadow;
  final double shadowBlur;
  final double shadowOpacity;

  GeometricPainter({
    required this.color,
    this.secondaryColor,
    required this.thickness,
    required this.cornerRadius,
    required this.patternType,
    required this.patternSize,
    required this.patternSpacing,
    required this.hasShadow,
    required this.shadowBlur,
    required this.shadowOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw shadow if enabled
    if (hasShadow) {
      _drawShadow(canvas, size);
    }

    // Draw main border frame
    _drawBorderFrame(canvas, size);

    // Draw geometric pattern
    _drawGeometricPattern(canvas, size);
  }

  void _drawShadow(Canvas canvas, Size size) {
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: shadowOpacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

    final shadowRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, 2, size.width - 4, size.height - 4),
      Radius.circular(cornerRadius),
    );

    canvas.drawRRect(shadowRect, shadowPaint);
  }

  void _drawBorderFrame(Canvas canvas, Size size) {
    final framePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final frameRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        thickness / 2,
        thickness / 2,
        size.width - thickness,
        size.height - thickness,
      ),
      Radius.circular(cornerRadius),
    );

    canvas.drawRRect(frameRect, framePaint);
  }

  void _drawGeometricPattern(Canvas canvas, Size size) {
    switch (patternType) {
      case GeometricPattern.triangles:
        _drawTrianglePattern(canvas, size);
        break;
      case GeometricPattern.hexagons:
        _drawHexagonPattern(canvas, size);
        break;
      case GeometricPattern.diamonds:
        _drawDiamondPattern(canvas, size);
        break;
      case GeometricPattern.circles:
        _drawCirclePattern(canvas, size);
        break;
    }
  }

  void _drawTrianglePattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    final step = patternSize + patternSpacing;
    final inset = thickness + patternSize;

    // Top edge
    for (double x = inset; x < size.width - inset; x += step) {
      paint.color = _getAlternatingColor(x ~/ step);
      _drawTriangle(
        canvas,
        Offset(x, inset - patternSize / 2),
        patternSize,
        TriangleDirection.down,
        paint,
      );
    }

    // Bottom edge
    for (double x = inset; x < size.width - inset; x += step) {
      paint.color = _getAlternatingColor(x ~/ step);
      _drawTriangle(
        canvas,
        Offset(x, size.height - inset + patternSize / 2),
        patternSize,
        TriangleDirection.up,
        paint,
      );
    }

    // Left edge
    for (double y = inset; y < size.height - inset; y += step) {
      paint.color = _getAlternatingColor(y ~/ step);
      _drawTriangle(
        canvas,
        Offset(inset - patternSize / 2, y),
        patternSize,
        TriangleDirection.right,
        paint,
      );
    }

    // Right edge
    for (double y = inset; y < size.height - inset; y += step) {
      paint.color = _getAlternatingColor(y ~/ step);
      _drawTriangle(
        canvas,
        Offset(size.width - inset + patternSize / 2, y),
        patternSize,
        TriangleDirection.left,
        paint,
      );
    }
  }

  void _drawTriangle(
    Canvas canvas,
    Offset center,
    double size,
    TriangleDirection direction,
    Paint paint,
  ) {
    final path = Path();
    final halfSize = size / 2;

    switch (direction) {
      case TriangleDirection.up:
        path.moveTo(center.dx, center.dy - halfSize);
        path.lineTo(center.dx - halfSize, center.dy + halfSize);
        path.lineTo(center.dx + halfSize, center.dy + halfSize);
        break;
      case TriangleDirection.down:
        path.moveTo(center.dx, center.dy + halfSize);
        path.lineTo(center.dx - halfSize, center.dy - halfSize);
        path.lineTo(center.dx + halfSize, center.dy - halfSize);
        break;
      case TriangleDirection.left:
        path.moveTo(center.dx - halfSize, center.dy);
        path.lineTo(center.dx + halfSize, center.dy - halfSize);
        path.lineTo(center.dx + halfSize, center.dy + halfSize);
        break;
      case TriangleDirection.right:
        path.moveTo(center.dx + halfSize, center.dy);
        path.lineTo(center.dx - halfSize, center.dy - halfSize);
        path.lineTo(center.dx - halfSize, center.dy + halfSize);
        break;
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHexagonPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.5;

    final step = patternSize + patternSpacing;
    final inset = thickness + patternSize;

    // Top edge
    for (double x = inset; x < size.width - inset; x += step) {
      paint.color = _getAlternatingColor(x ~/ step);
      _drawHexagon(canvas, Offset(x, inset), patternSize * 0.6, paint);
    }

    // Bottom edge
    for (double x = inset; x < size.width - inset; x += step) {
      paint.color = _getAlternatingColor(x ~/ step);
      _drawHexagon(canvas, Offset(x, size.height - inset), patternSize * 0.6, paint);
    }

    // Left edge
    for (double y = inset; y < size.height - inset; y += step) {
      paint.color = _getAlternatingColor(y ~/ step);
      _drawHexagon(canvas, Offset(inset, y), patternSize * 0.6, paint);
    }

    // Right edge
    for (double y = inset; y < size.height - inset; y += step) {
      paint.color = _getAlternatingColor(y ~/ step);
      _drawHexagon(canvas, Offset(size.width - inset, y), patternSize * 0.6, paint);
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawDiamondPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final step = patternSize + patternSpacing;
    final inset = thickness + patternSize;

    // Top edge
    for (double x = inset; x < size.width - inset; x += step) {
      paint.color = _getAlternatingColor(x ~/ step);
      _drawDiamond(canvas, Offset(x, inset), patternSize * 0.7, paint);
    }

    // Bottom edge
    for (double x = inset; x < size.width - inset; x += step) {
      paint.color = _getAlternatingColor(x ~/ step);
      _drawDiamond(canvas, Offset(x, size.height - inset), patternSize * 0.7, paint);
    }

    // Left edge
    for (double y = inset; y < size.height - inset; y += step) {
      paint.color = _getAlternatingColor(y ~/ step);
      _drawDiamond(canvas, Offset(inset, y), patternSize * 0.7, paint);
    }

    // Right edge
    for (double y = inset; y < size.height - inset; y += step) {
      paint.color = _getAlternatingColor(y ~/ step);
      _drawDiamond(canvas, Offset(size.width - inset, y), patternSize * 0.7, paint);
    }
  }

  void _drawDiamond(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - size / 2) // Top
      ..lineTo(center.dx + size / 2, center.dy) // Right
      ..lineTo(center.dx, center.dy + size / 2) // Bottom
      ..lineTo(center.dx - size / 2, center.dy) // Left
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawCirclePattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final step = patternSize + patternSpacing;
    final inset = thickness + patternSize;
    final radius = patternSize * 0.4;

    // Top edge
    for (double x = inset; x < size.width - inset; x += step) {
      paint.color = _getAlternatingColor(x ~/ step);
      canvas.drawCircle(Offset(x, inset), radius, paint);
    }

    // Bottom edge
    for (double x = inset; x < size.width - inset; x += step) {
      paint.color = _getAlternatingColor(x ~/ step);
      canvas.drawCircle(Offset(x, size.height - inset), radius, paint);
    }

    // Left edge
    for (double y = inset; y < size.height - inset; y += step) {
      paint.color = _getAlternatingColor(y ~/ step);
      canvas.drawCircle(Offset(inset, y), radius, paint);
    }

    // Right edge
    for (double y = inset; y < size.height - inset; y += step) {
      paint.color = _getAlternatingColor(y ~/ step);
      canvas.drawCircle(Offset(size.width - inset, y), radius, paint);
    }
  }

  Color _getAlternatingColor(int index) {
    if (secondaryColor == null) {
      return color;
    }
    return index % 2 == 0 ? color : secondaryColor!;
  }

  @override
  bool shouldRepaint(GeometricPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.thickness != thickness ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.patternType != patternType ||
        oldDelegate.patternSize != patternSize ||
        oldDelegate.patternSpacing != patternSpacing ||
        oldDelegate.hasShadow != hasShadow ||
        oldDelegate.shadowBlur != shadowBlur ||
        oldDelegate.shadowOpacity != shadowOpacity;
  }
}

/// Direction for triangle orientation
enum TriangleDirection {
  up,
  down,
  left,
  right,
}
