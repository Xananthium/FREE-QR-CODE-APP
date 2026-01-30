import 'package:flutter/material.dart';
import '../borders/base_border.dart';
import '../borders/border_registry.dart';
import 'qr_display.dart';

/// A composite widget that combines a QR code with a decorative border.
///
/// This widget seamlessly integrates the QR display system with the decorative
/// border system, creating beautiful bordered QR codes ready for display or export.
///
/// Features:
/// - Combines QR code rendering with any DecorativeBorder
/// - Export-ready with RepaintBoundary for high-quality capture
/// - GlobalKey support for programmatic image export
/// - Responsive sizing that adapts to content
/// - Theme-aware color handling
/// - Multiple factory constructors for common use cases
///
/// Usage:
/// ```dart
/// // Basic usage with default border
/// BorderedQr(
///   data: 'https://example.com',
///   border: BorderRegistry.defaultBorder,
/// )
///
/// // For export with custom key
/// final captureKey = GlobalKey();
/// BorderedQr.forExport(
///   data: 'https://example.com',
///   border: myBorder,
///   captureKey: captureKey,
/// )
///
/// // Preview size with custom styling
/// BorderedQr.preview(
///   data: 'https://example.com',
///   borderType: BorderType.floral,
///   borderColor: Colors.purple,
/// )
/// ```
///
/// The widget automatically wraps itself in a RepaintBoundary for efficient
/// rendering and export capability. When a GlobalKey is provided, it can be
/// used to capture the widget as an image for sharing or saving.
class BorderedQr extends StatelessWidget {
  /// The data to encode in the QR code
  final String? data;

  /// The decorative border to apply around the QR code
  final DecorativeBorder border;

  /// Size of the QR code content (excluding border and padding)
  final double qrSize;

  /// Error correction level for the QR code
  /// - Low: 7% recovery
  /// - Medium: 15% recovery
  /// - Quartile: 25% recovery
  /// - High: 30% recovery
  final int errorCorrectionLevel;

  /// Optional key for capturing this widget as an image
  /// When provided, wrap this widget in a RepaintBoundary with this key
  final GlobalKey? captureKey;

  /// QR foreground color (QR code pixels)
  /// If null, uses black for optimal scannability
  final Color? qrForegroundColor;

  /// QR background color
  /// If null, uses white for optimal scannability
  final Color? qrBackgroundColor;

  /// Whether to show the QR container styling
  /// Set to false for cleaner export without extra decoration
  final bool showQrContainer;

  const BorderedQr({
    super.key,
    required this.data,
    required this.border,
    this.qrSize = 200,
    this.errorCorrectionLevel = 2, // Medium (QrErrorCorrectLevel.M)
    this.captureKey,
    this.qrForegroundColor,
    this.qrBackgroundColor,
    this.showQrContainer = false,
  });

  /// Factory: Create a bordered QR for preview display
  ///
  /// Uses larger size and includes container styling for better visual appeal.
  /// Ideal for showing users a preview before they export or customize.
  factory BorderedQr.preview({
    required String? data,
    required DecorativeBorder border,
    Color? qrForegroundColor,
    Color? qrBackgroundColor,
  }) {
    return BorderedQr(
      data: data,
      border: border,
      qrSize: 280,
      showQrContainer: false,
      qrForegroundColor: qrForegroundColor,
      qrBackgroundColor: qrBackgroundColor,
    );
  }

  /// Factory: Create with border type instead of DecorativeBorder instance
  ///
  /// Convenience constructor that uses BorderRegistry to create the border.
  /// Useful when you want to quickly specify a border type without manually
  /// creating a DecorativeBorder instance.
  factory BorderedQr.withType({
    required String? data,
    BorderType borderType = BorderType.classic,
    Color borderColor = Colors.black,
    Color? borderSecondaryColor,
    double qrSize = 200,
    Color? qrForegroundColor,
    Color? qrBackgroundColor,
    GlobalKey? captureKey,
  }) {
    final border = BorderRegistry.getBorder(
      borderType,
      color: borderColor,
      secondaryColor: borderSecondaryColor,
    );

    return BorderedQr(
      data: data,
      border: border,
      qrSize: qrSize,
      qrForegroundColor: qrForegroundColor,
      qrBackgroundColor: qrBackgroundColor,
      captureKey: captureKey,
    );
  }

  /// Factory: Create for high-quality export
  ///
  /// Optimized for exporting as an image:
  /// - High error correction for better scannability
  /// - Large size for maximum quality
  /// - Explicit colors for consistency
  /// - No container decoration (clean export)
  /// - Requires a capture key for image generation
  factory BorderedQr.forExport({
    required String data,
    required DecorativeBorder border,
    required GlobalKey captureKey,
    double qrSize = 1024,
    Color qrForegroundColor = Colors.black,
    Color qrBackgroundColor = Colors.white,
  }) {
    return BorderedQr(
      data: data,
      border: border,
      qrSize: qrSize,
      errorCorrectionLevel: 3, // High (QrErrorCorrectLevel.H)
      captureKey: captureKey,
      qrForegroundColor: qrForegroundColor,
      qrBackgroundColor: qrBackgroundColor,
      showQrContainer: false,
    );
  }

  /// Factory: Create a thumbnail for list display
  ///
  /// Small size optimized for list items or grid views.
  /// Minimal decoration to keep it compact.
  factory BorderedQr.thumbnail({
    required String data,
    required DecorativeBorder border,
    double qrSize = 80,
  }) {
    return BorderedQr(
      data: data,
      border: border,
      qrSize: qrSize,
      showQrContainer: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build the QR code widget
    final qrWidget = QrDisplay(
      data: data,
      size: qrSize,
      errorCorrectionLevel: errorCorrectionLevel,
      foregroundColor: qrForegroundColor,
      backgroundColor: qrBackgroundColor,
      showContainer: showQrContainer,
      showElevation: false, // Border provides the visual frame
      padding: 0, // Border provides the padding
    );

    // Wrap QR with the decorative border
    final borderedWidget = border.build(qrWidget);

    // Wrap in RepaintBoundary for performance and export capability
    // If captureKey is provided, use it for the RepaintBoundary
    // Otherwise, use an anonymous RepaintBoundary for performance benefits
    if (captureKey != null) {
      return RepaintBoundary(
        key: captureKey,
        child: borderedWidget,
      );
    } else {
      return RepaintBoundary(
        child: borderedWidget,
      );
    }
  }
}

/// A card-based variant of BorderedQr with additional context.
///
/// Displays a bordered QR code within a Material card, with optional
/// title, subtitle, and action buttons. Perfect for preview screens
/// or when you need to present the QR code with explanatory text.
///
/// Example:
/// ```dart
/// BorderedQrCard(
///   data: 'https://example.com',
///   border: myBorder,
///   title: 'Website URL',
///   subtitle: 'Scan to visit our website',
///   actions: [
///     IconButton(icon: Icon(Icons.share), onPressed: () {}),
///     IconButton(icon: Icon(Icons.download), onPressed: () {}),
///   ],
/// )
/// ```
class BorderedQrCard extends StatelessWidget {
  /// The data to encode
  final String? data;

  /// The decorative border
  final DecorativeBorder border;

  /// Optional title displayed above the QR
  final String? title;

  /// Optional subtitle/description
  final String? subtitle;

  /// Size of the QR code
  final double qrSize;

  /// Action buttons to display below the QR code
  final List<Widget>? actions;

  /// Optional capture key for export
  final GlobalKey? captureKey;

  /// QR code colors
  final Color? qrForegroundColor;
  final Color? qrBackgroundColor;

  const BorderedQrCard({
    super.key,
    required this.data,
    required this.border,
    this.title,
    this.subtitle,
    this.qrSize = 250,
    this.actions,
    this.captureKey,
    this.qrForegroundColor,
    this.qrBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],

            // Subtitle
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],

            // Bordered QR Code
            BorderedQr(
              data: data,
              border: border,
              qrSize: qrSize,
              captureKey: captureKey,
              qrForegroundColor: qrForegroundColor,
              qrBackgroundColor: qrBackgroundColor,
            ),

            // Action buttons
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: actions!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A gallery item showing a bordered QR with selectable interaction.
///
/// Used in selection UIs where users can choose a border style.
/// Shows the border applied to sample QR code data, with selection
/// highlighting and tap interaction.
///
/// Example:
/// ```dart
/// BorderedQrGalleryItem(
///   data: 'Sample',
///   border: myBorder,
///   isSelected: currentBorder == myBorder,
///   onTap: () => setState(() => currentBorder = myBorder),
/// )
/// ```
class BorderedQrGalleryItem extends StatelessWidget {
  /// Sample data to display in the QR
  final String data;

  /// The border to showcase
  final DecorativeBorder border;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Callback when item is tapped
  final VoidCallback? onTap;

  /// Size of the QR + border combo
  final double size;

  const BorderedQrGalleryItem({
    super.key,
    required this.data,
    required this.border,
    this.isSelected = false,
    this.onTap,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? colorScheme.primaryContainer.withValues(alpha: 0.1)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bordered QR thumbnail
            SizedBox(
              width: size,
              height: size,
              child: BorderedQr.thumbnail(
                data: data,
                border: border,
                qrSize: size * 0.6, // QR takes 60% of total size
              ),
            ),
            const SizedBox(height: 8),
            // Border name
            Text(
              border.name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? colorScheme.primary : null,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
