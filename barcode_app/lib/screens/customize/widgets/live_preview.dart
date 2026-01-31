import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../providers/qr_provider.dart';
import '../../../borders/border_registry.dart' as registry;
import '../../../borders/base_border.dart';
import '../../../models/border_style.dart' as qr_models;

/// Live Preview Widget - Real-time QR code customization preview
class LivePreview extends StatelessWidget {
  final double? qrSize;

  const LivePreview({
    super.key,
    this.qrSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<QRProvider>();
    final displaySize = qrSize ?? 280.0;

    if (!provider.hasQRData) {
      return _buildEmptyState(theme, colorScheme);
    }

    if (provider.isProcessing) {
      return _buildLoadingState(theme, colorScheme, displaySize);
    }

    return _buildPreview(theme, colorScheme, provider, displaySize);
  }

  Widget _buildPreview(
    ThemeData theme,
    ColorScheme colorScheme,
    QRProvider provider,
    double displaySize,
  ) {
    return Semantics(
      label: 'QR Code Preview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(theme, colorScheme, provider),
          const SizedBox(height: 16),
          _buildQRDisplay(provider, displaySize, colorScheme),
          const SizedBox(height: 12),
          _buildInfoBadges(colorScheme, provider, displaySize),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme, QRProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.visibility_rounded, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          'Live Preview',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildQRDisplay(QRProvider provider, double size, ColorScheme colorScheme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(provider.borderStyle.type.name + provider.qrColor.toARGB32().toString()),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _buildQRContent(provider, size),
        ),
      ),
    );
  }

  Widget _buildQRContent(QRProvider provider, double size) {
    final qrWidget = QrImageView(
      data: provider.currentContent,
      version: QrVersions.auto,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: provider.qrColor,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: provider.qrColor,
      ),
      backgroundColor: provider.backgroundColor,
    );

    // If border frame is selected, show QR with PNG frame overlay
    if (provider.borderFrame != null) {
      return Container(
        width: size,
        height: size,
        color: provider.backgroundColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // QR code (centered, smaller to fit in frame)
            Container(
              width: size * 0.6, // QR is 60% of frame size
              height: size * 0.6,
              child: qrWidget,
            ),
            // Border frame overlay
            Image.asset(
              provider.borderFrame!.assetPath,
              width: size,
              height: size,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: size,
                  height: size,
                  color: Colors.red.withValues(alpha: 0.1),
                  child: const Icon(Icons.broken_image),
                );
              },
            ),
          ],
        ),
      );
    }

    if (provider.borderStyle.type == qr_models.BorderType.none) {
      return Container(
        width: size,
        height: size,
        color: provider.backgroundColor,
        padding: const EdgeInsets.all(24),
        child: qrWidget,
      );
    }

    final border = _getBorder(provider.borderStyle);
    if (border != null) {
      final totalSize = size + (provider.borderStyle.padding * 2);
      return SizedBox(
        width: totalSize,
        height: totalSize,
        child: border.build(
          Container(
            color: provider.backgroundColor,
            padding: const EdgeInsets.all(16),
            child: qrWidget,
          ),
        ),
      );
    }

    return Container(
      width: size + (provider.borderStyle.padding * 2),
      height: size + (provider.borderStyle.padding * 2),
      decoration: BoxDecoration(
        color: provider.backgroundColor,
        border: Border.all(
          color: provider.borderStyle.color,
          width: provider.borderStyle.thickness,
        ),
        borderRadius: BorderRadius.circular(provider.borderStyle.cornerRadius),
      ),
      padding: EdgeInsets.all(provider.borderStyle.padding),
      child: qrWidget,
    );
  }

  DecorativeBorder? _getBorder(qr_models.BorderStyle borderStyle) {
    final type = _mapType(borderStyle.type);
    if (type == null) return null;
    
    try {
      return registry.BorderRegistry.getBorder(
        type,
        color: borderStyle.color,
        secondaryColor: borderStyle.secondaryColor,
      );
    } catch (e) {
      return null;
    }
  }

  registry.BorderType? _mapType(qr_models.BorderType type) {
    switch (type) {
      case qr_models.BorderType.classic:
      case qr_models.BorderType.solid:
        return registry.BorderType.classic;
      case qr_models.BorderType.minimal:
      case qr_models.BorderType.modern:
        return registry.BorderType.minimal;
      case qr_models.BorderType.mediumRounded:
      case qr_models.BorderType.roundedSquare:
        return registry.BorderType.rounded;
      case qr_models.BorderType.ornateCorners:
      case qr_models.BorderType.vintage:
        return registry.BorderType.ornate;
      case qr_models.BorderType.geometric:
      case qr_models.BorderType.hexagon:
        return registry.BorderType.geometric;
      case qr_models.BorderType.gradient:
      case qr_models.BorderType.neon:
        return registry.BorderType.gradient;
      case qr_models.BorderType.shadow:
      case qr_models.BorderType.threeD:
        return registry.BorderType.shadow;
      case qr_models.BorderType.dotted:
        return registry.BorderType.dotted;
      case qr_models.BorderType.floral:
        return registry.BorderType.floral;
      default:
        return null;
    }
  }

  Widget _buildInfoBadges(ColorScheme colorScheme, QRProvider provider, double size) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: [
        _InfoBadge(
          icon: Icons.straighten,
          label: '${size.round()}px',
          colorScheme: colorScheme,
        ),
        if (provider.hasBorder)
          _InfoBadge(
            icon: Icons.border_style,
            label: '${provider.borderStyle.thickness.round()}px',
            colorScheme: colorScheme,
          ),
      ],
    );
  }

  Widget _buildLoadingState(ThemeData theme, ColorScheme colorScheme, double size) {
    return Column(
      children: [
        Text(
          'Updating Preview...',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        _SkeletonPreview(size: size, colorScheme: colorScheme),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_2_rounded,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No Preview Available',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonPreview extends StatefulWidget {
  final double size;
  final ColorScheme colorScheme;

  const _SkeletonPreview({
    required this.size,
    required this.colorScheme,
  });

  @override
  State<_SkeletonPreview> createState() => _SkeletonPreviewState();
}

class _SkeletonPreviewState extends State<_SkeletonPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3 + (_controller.value * 0.2),
            ),
          ),
        );
      },
    );
  }
}
