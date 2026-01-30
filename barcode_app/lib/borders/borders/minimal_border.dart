import 'package:flutter/material.dart';
import '../base_border.dart';

/// A minimal, modern border featuring a single thin line with generous padding.
/// 
/// The Minimal Border embodies contemporary design principles:
/// - Clean single-line perimeter
/// - Generous whitespace (large padding)
/// - Subtle corner radius for modern feel
/// - No shadows or ornaments
/// - Perfect dark mode compatibility
/// 
/// Design Philosophy:
/// Less is more. The minimal border draws attention through restraint,
/// allowing the QR code content to be the hero while providing just enough
/// visual framing to separate it from the background.
/// 
/// Best Used For:
/// - Professional presentations
/// - Modern, clean aesthetics
/// - Digital displays
/// - Contexts where subtlety is preferred
/// 
/// Example:
/// ```dart
/// final border = MinimalBorder(
///   color: Colors.black87,
///   thickness: 1.5,
///   padding: 32.0,
///   cornerRadius: 8.0,
/// );
/// ```
class MinimalBorder extends DecorativeBorder {
  /// Creates a minimal border with the specified properties.
  /// 
  /// Defaults are carefully chosen for optimal minimal aesthetic:
  /// - [thickness]: 1.5px - Thin but clearly visible
  /// - [padding]: 32.0px - Generous breathing room
  /// - [cornerRadius]: 8.0px - Subtle modern softness
  /// 
  /// The minimal border never uses shadows (hasShadow is always false)
  /// to maintain its clean, flat appearance.
  const MinimalBorder({
    required super.color,
    super.thickness = 1.5,
    super.padding = 32.0,
    super.cornerRadius = 8.0,
  }) : super(
          hasShadow: false, // Minimal borders never have shadows
          secondaryColor: null, // Single color only
          patternSpacing: null, // No patterns
          patternSize: null, // No patterns
        );

  @override
  String get name => 'Minimal Border';

  @override
  String get description => 'Clean, thin modern border with generous padding';

  @override
  Widget build(Widget child) {
    return CustomPaint(
      painter: _MinimalBorderPainter(this),
      child: Padding(
        padding: EdgeInsets.all(padding + thickness),
        child: child,
      ),
    );
  }

  @override
  Widget buildThumbnail(Size size) {
    return CustomPaint(
      painter: _MinimalBorderPainter(this),
      size: size,
      child: Center(
        child: Container(
          width: size.width * 0.4,
          height: size.height * 0.4,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  @override
  MinimalBorder copyWith({
    Color? color,
    Color? secondaryColor, // Ignored for minimal border
    double? thickness,
    double? padding,
    double? cornerRadius,
    bool? hasShadow, // Ignored - always false for minimal
    double? shadowBlur,
    double? shadowOpacity,
    double? patternSpacing,
    double? patternSize,
  }) {
    return MinimalBorder(
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      padding: padding ?? this.padding,
      cornerRadius: cornerRadius ?? this.cornerRadius,
    );
  }
}

/// Custom painter that renders the minimal border with pixel-perfect precision.
/// 
/// Implementation Details:
/// - Uses PaintingStyle.stroke for outline-only rendering
/// - Deflates rect by half thickness to center stroke on border
/// - Uses StrokeCap.square for crisp corners (even with borderRadius)
/// - Supports corner radius for modern softness
/// - Optimized for thin lines (1-2px)
class _MinimalBorderPainter extends CustomPainter {
  final MinimalBorder border;

  const _MinimalBorderPainter(this.border);

  @override
  void paint(Canvas canvas, Size size) {
    // Create paint with stroke style for outline
    final paint = Paint()
      ..color = border.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = border.thickness
      ..strokeCap = StrokeCap.square // Crisp, clean corners
      ..isAntiAlias = true; // Smooth rendering

    // Calculate the border rectangle
    // Deflate by half thickness to center the stroke on the edge
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final strokeRect = rect.deflate(border.thickness / 2);

    if (border.cornerRadius > 0) {
      // Rounded rectangle for modern feel
      final rrect = RRect.fromRectAndRadius(
        strokeRect,
        Radius.circular(border.cornerRadius),
      );
      canvas.drawRRect(rrect, paint);
    } else {
      // Sharp rectangle for technical precision
      canvas.drawRect(strokeRect, paint);
    }
  }

  @override
  bool shouldRepaint(_MinimalBorderPainter oldDelegate) {
    // Only repaint if border properties changed
    return oldDelegate.border != border;
  }

  @override
  bool hitTest(Offset position) => true;
}
