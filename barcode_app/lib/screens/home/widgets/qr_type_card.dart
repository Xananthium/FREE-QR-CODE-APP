import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Museum-quality QR type card inspired by art gallery exhibits
///
/// Design Philosophy:
/// - Illuminated art piece on gallery walls
/// - Subtle eclipse symbol watermark
/// - Dramatic spotlighting effect
/// - Premium hover/tap interactions
/// - Generous spacing and breathing room
class QRTypeCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color primaryColor;
  final Color secondaryColor;

  const QRTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  State<QRTypeCard> createState() => _QRTypeCardState();
}

class _QRTypeCardState extends State<QRTypeCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Animation values for subtle interactions
    final scale = _isPressed ? 0.96 : (_isHovered ? 1.02 : 1.0);
    final elevation = _isPressed ? 2.0 : (_isHovered ? 12.0 : 6.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.diagonal3Values(scale, scale, 1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                // Dramatic spotlight shadow effect
                BoxShadow(
                  color: widget.primaryColor.withValues(alpha: _isHovered ? 0.3 : 0.15),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation / 2),
                  spreadRadius: _isHovered ? 2 : 0,
                ),
                // Subtle depth shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                  blurRadius: elevation,
                  offset: Offset(0, elevation / 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Base card with gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                colorScheme.surfaceVariant,
                                colorScheme.surfaceVariant.withValues(alpha: 0.8),
                              ]
                            : [
                                Colors.white,
                                colorScheme.surfaceVariant.withValues(alpha: 0.3),
                              ],
                      ),
                    ),
                  ),

                  // Eclipse watermark - subtle infinity symbol in background
                  Positioned.fill(
                    child: Opacity(
                      opacity: isDark ? 0.03 : 0.02,
                      child: CustomPaint(
                        painter: _EclipseWatermarkPainter(
                          color: widget.primaryColor,
                        ),
                      ),
                    ),
                  ),

                  // Shimmer effect on hover (dark mode only)
                  if (isDark && _isHovered)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: _ShimmerPainter(
                              animation: _shimmerController,
                              gradientColor: widget.primaryColor.withValues(alpha: 0.1),
                            ),
                          );
                        },
                      ),
                    ),

                  // Border accent
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isHovered
                            ? widget.primaryColor.withValues(alpha: 0.4)
                            : colorScheme.outline.withValues(alpha: 0.1),
                        width: _isHovered ? 2 : 1,
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with spotlight gradient background
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                widget.primaryColor.withValues(alpha: isDark ? 0.9 : 1.0),
                                widget.secondaryColor.withValues(alpha: isDark ? 0.8 : 0.9),
                              ],
                            ),
                            boxShadow: [
                              // Glow effect
                              BoxShadow(
                                color: widget.primaryColor.withValues(alpha: _isHovered ? 0.5 : 0.3),
                                blurRadius: _isHovered ? 16 : 12,
                                spreadRadius: _isHovered ? 2 : 0,
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Title with premium typography
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                            letterSpacing: 0.2,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for eclipse/infinity symbol watermark
class _EclipseWatermarkPainter extends CustomPainter {
  final Color color;

  _EclipseWatermarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);
    final radiusX = size.width * 0.2;
    final radiusY = size.width * 0.12;

    // Draw tilted ellipses (Digital Disconnections logo)

    // Left ellipse - tilted -25 degrees
    canvas.save();
    canvas.translate(center.dx - radiusX * 0.5, center.dy);
    canvas.rotate(-0.436); // -25 degrees in radians
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: radiusX * 2, height: radiusY * 2),
      paint,
    );
    canvas.restore();

    // Right ellipse - tilted +25 degrees
    canvas.save();
    canvas.translate(center.dx + radiusX * 0.5, center.dy);
    canvas.rotate(0.436); // 25 degrees in radians
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: radiusX * 2, height: radiusY * 2),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_EclipseWatermarkPainter oldDelegate) => false;
}

/// Shimmer effect painter for hover state
class _ShimmerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color gradientColor;

  _ShimmerPainter({required this.animation, required this.gradientColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          gradientColor.withValues(alpha: 0.0),
          gradientColor,
          gradientColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(animation.value * 2 * math.pi),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) => true;
}
