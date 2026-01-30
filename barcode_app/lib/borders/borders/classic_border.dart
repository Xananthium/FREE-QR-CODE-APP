import 'package:flutter/material.dart';
import '../base_border.dart';

/// Classic Border - Elegant double-frame border
/// 
/// Features:
/// - Refined double-line frame with perfect spacing
/// - Clean, sharp corners with subtle sophistication
/// - Customizable dual-tone color scheme
/// - Timeless aesthetic suitable for professional use
/// - Balanced proportions for visual harmony
class ClassicBorder extends DecorativeBorder {
  /// Inner frame thickness (typically thinner than outer)
  final double innerThickness;
  
  /// Spacing between inner and outer frames
  final double frameSpacing;

  const ClassicBorder({
    super.color = Colors.black,
    super.secondaryColor,
    super.thickness = 3.0,
    this.innerThickness = 1.5,
    this.frameSpacing = 6.0,
    super.padding = 20.0,
    super.cornerRadius = 0.0,
    super.hasShadow = false,
    super.shadowBlur = 4.0,
    super.shadowOpacity = 0.3,
  });

  @override
  String get name => 'Classic Border';

  @override
  String get description => 'Elegant double-frame border';

  @override
  Widget build(Widget child) {
    return CustomPaint(
      painter: ClassicBorderPainter(this),
      child: Padding(
        padding: EdgeInsets.all(padding + thickness + frameSpacing + innerThickness + 4),
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
        painter: ClassicBorderPainter(this),
        child: Center(
          child: Container(
            width: size.width * 0.4,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(cornerRadius * 0.5),
            ),
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
    return ClassicBorder(
      color: color ?? this.color,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      thickness: thickness ?? this.thickness,
      padding: padding ?? this.padding,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      hasShadow: hasShadow ?? this.hasShadow,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
    );
  }
}

/// Custom painter for the Classic Border
class ClassicBorderPainter extends CustomPainter {
  final ClassicBorder border;

  ClassicBorderPainter(this.border);

  @override
  void paint(Canvas canvas, Size size) {
    final outerColor = border.color;
    final innerColor = border.secondaryColor ?? border.color;
    
    // Calculate dimensions
    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final innerFrameInset = border.thickness + border.frameSpacing;
    
    // Apply shadow if enabled
    if (border.hasShadow) {
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: border.shadowOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, border.shadowBlur);
      
      final shadowPath = _createFramePath(
        outerRect,
        border.cornerRadius,
      );
      
      canvas.drawPath(shadowPath, shadowPaint);
    }
    
    // Draw outer frame
    final outerPaint = Paint()
      ..color = outerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.thickness
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;
    
    final outerPath = _createFramePath(
      outerRect.deflate(border.thickness / 2),
      border.cornerRadius,
    );
    
    canvas.drawPath(outerPath, outerPaint);
    
    // Draw inner frame
    final innerPaint = Paint()
      ..color = innerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.innerThickness
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;
    
    final innerRect = outerRect.deflate(innerFrameInset + border.innerThickness / 2);
    final innerPath = _createFramePath(
      innerRect,
      border.cornerRadius > 0 ? (border.cornerRadius - innerFrameInset).clamp(0.0, double.infinity) : 0.0,
    );
    
    canvas.drawPath(innerPath, innerPaint);
    
    // Add corner accents for enhanced elegance
    if (border.cornerRadius == 0.0) {
      _drawCornerAccents(canvas, outerRect, innerFrameInset, outerColor);
    }
  }

  /// Creates a rectangular or rounded rectangular path
  Path _createFramePath(Rect rect, double radius) {
    if (radius <= 0.0) {
      return Path()..addRect(rect);
    } else {
      return Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    }
  }

  /// Draws subtle corner accents for sharp-cornered classic borders
  void _drawCornerAccents(Canvas canvas, Rect rect, double inset, Color color) {
    final accentPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.square;
    
    final accentLength = 8.0;
    final accentInset = inset + border.innerThickness + 2.0;
    
    // Top-left corner
    canvas.drawLine(
      Offset(rect.left + accentInset, rect.top + accentInset),
      Offset(rect.left + accentInset + accentLength, rect.top + accentInset),
      accentPaint,
    );
    canvas.drawLine(
      Offset(rect.left + accentInset, rect.top + accentInset),
      Offset(rect.left + accentInset, rect.top + accentInset + accentLength),
      accentPaint,
    );
    
    // Top-right corner
    canvas.drawLine(
      Offset(rect.right - accentInset, rect.top + accentInset),
      Offset(rect.right - accentInset - accentLength, rect.top + accentInset),
      accentPaint,
    );
    canvas.drawLine(
      Offset(rect.right - accentInset, rect.top + accentInset),
      Offset(rect.right - accentInset, rect.top + accentInset + accentLength),
      accentPaint,
    );
    
    // Bottom-left corner
    canvas.drawLine(
      Offset(rect.left + accentInset, rect.bottom - accentInset),
      Offset(rect.left + accentInset + accentLength, rect.bottom - accentInset),
      accentPaint,
    );
    canvas.drawLine(
      Offset(rect.left + accentInset, rect.bottom - accentInset),
      Offset(rect.left + accentInset, rect.bottom - accentInset - accentLength),
      accentPaint,
    );
    
    // Bottom-right corner
    canvas.drawLine(
      Offset(rect.right - accentInset, rect.bottom - accentInset),
      Offset(rect.right - accentInset - accentLength, rect.bottom - accentInset),
      accentPaint,
    );
    canvas.drawLine(
      Offset(rect.right - accentInset, rect.bottom - accentInset),
      Offset(rect.right - accentInset, rect.bottom - accentInset - accentLength),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(ClassicBorderPainter oldDelegate) {
    return oldDelegate.border != border;
  }
}
