import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/qr_provider.dart';
import '../../models/border_style.dart' as qr_models;
import '../../borders/border_registry.dart' as registry;
import '../../core/animations/widget_animations.dart';
import '../../core/animations/animation_constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/navigation/app_router.dart';
import 'widgets/live_preview.dart';
import 'widgets/border_gallery.dart';
import 'widgets/border_frame_picker.dart';
import 'widgets/color_picker_sheet.dart';

/// Customize Screen - Main QR code customization interface
///
/// A beautiful, comprehensive customization screen featuring:
/// - Live preview with real-time updates and Hero animation
/// - Border style gallery with visual selection
/// - Color customization for QR code and border with press feedback
/// - Export functionality with loading states
/// - Smooth animations throughout
/// - Fully responsive design for phone/tablet/desktop
class CustomizeScreen extends StatelessWidget {
  const CustomizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize QR Code'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: responsive.padding,
              child: ResponsiveLayout(
                // Phone layout - vertical stacking
                phone: _buildPhoneLayout(context, theme, responsive),
                // Tablet/Desktop layout - side-by-side when possible
                tablet: _buildTabletLayout(context, theme, responsive),
                desktop: _buildDesktopLayout(context, theme, responsive),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Phone layout - everything stacked vertically
  Widget _buildPhoneLayout(BuildContext context, ThemeData theme, Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Preview Section
        _buildPreviewSection(context, theme, responsive),
        SizedBox(height: responsive.cardSpacing * 1.25),

        // Border Frame Picker Section (PNG overlays - removed flutter-generated borders)
        FadeSlideIn(
          delay: AnimationDurations.staggerDelay * 1.5,
          child: _buildBorderFrameSection(context, theme, responsive),
        ),
        SizedBox(height: responsive.cardSpacing * 1.25),

        // Color Customization Section
        FadeSlideIn(
          delay: AnimationDurations.staggerDelay * 2,
          child: _buildColorSection(context, theme, responsive),
        ),
        SizedBox(height: responsive.cardSpacing * 1.25),

        // Export Button Section
        FadeSlideIn(
          delay: AnimationDurations.staggerDelay * 3,
          child: _buildExportSection(context, theme, responsive),
        ),
        SizedBox(height: responsive.spacing * 3),
      ],
    );
  }

  /// Tablet layout - preview + controls in 2 columns
  Widget _buildTabletLayout(BuildContext context, ThemeData theme, Responsive responsive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column - Preview (40%)
        Expanded(
          flex: 4,
          child: _buildPreviewSection(context, theme, responsive),
        ),
        SizedBox(width: responsive.cardSpacing),
        
        // Right column - Controls (60%)
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeSlideIn(
                delay: AnimationDurations.staggerDelay,
                child: _buildBorderFrameSection(context, theme, responsive),
              ),
              SizedBox(height: responsive.cardSpacing),

              FadeSlideIn(
                delay: AnimationDurations.staggerDelay * 2,
                child: _buildColorSection(context, theme, responsive),
              ),
              SizedBox(height: responsive.cardSpacing),
              
              FadeSlideIn(
                delay: AnimationDurations.staggerDelay * 3,
                child: _buildExportSection(context, theme, responsive),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Desktop layout - preview centered, controls in wide 2-column grid
  Widget _buildDesktopLayout(BuildContext context, ThemeData theme, Responsive responsive) {
    return Column(
      children: [
        // Top - Large centered preview
        _buildPreviewSection(context, theme, responsive),
        SizedBox(height: responsive.cardSpacing * 1.5),
        
        // Bottom - Controls in 2 columns
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  FadeSlideIn(
                    delay: AnimationDurations.staggerDelay,
                    child: _buildBorderFrameSection(context, theme, responsive),
                  ),
                ],
              ),
            ),
            SizedBox(width: responsive.cardSpacing),
            Expanded(
              child: Column(
                children: [
                  FadeSlideIn(
                    delay: AnimationDurations.staggerDelay * 2,
                    child: _buildColorSection(context, theme, responsive),
                  ),
                  SizedBox(height: responsive.cardSpacing),
                  FadeSlideIn(
                    delay: AnimationDurations.staggerDelay * 3,
                    child: _buildExportSection(context, theme, responsive),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewSection(BuildContext context, ThemeData theme, Responsive responsive) {
    final qrSize = responsive.value(
      phone: 280.0,
      tablet: 320.0,
      desktop: 360.0,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.visibility_rounded,
              size: responsive.iconSize * 0.83,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: responsive.spacing),
            Text(
              'Live Preview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                fontSize: responsive.value(
                  phone: 20.0,
                  tablet: 22.0,
                  desktop: 24.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.spacing * 3),
        // Hero-wrapped live preview for smooth transition
        Hero(
          tag: 'qr_preview',
          child: Material(
            color: Colors.transparent,
            child: LivePreview(qrSize: qrSize),
          ),
        ),
      ],
    );
  }

  Widget _buildBorderFrameSection(BuildContext context, ThemeData theme, Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.photo_library_rounded,
          title: 'Decorative Frames',
          subtitle: 'Add cool visual borders',
          theme: theme,
          responsive: responsive,
        ),
        SizedBox(height: responsive.cardSpacing),
        const BorderFramePicker(),
      ],
    );
  }

  Widget _buildColorSection(BuildContext context, ThemeData theme, Responsive responsive) {
    final provider = context.watch<QRProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.palette_rounded,
          title: 'Customize Colors',
          subtitle: 'Personalize your QR code appearance',
          theme: theme,
          responsive: responsive,
        ),
        SizedBox(height: responsive.cardSpacing),
        ResponsiveRowColumn(
          spacing: responsive.cardSpacing,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ScaleOnTap(
                onTap: () => _openColorPicker(context),
                scaleTo: 0.9,
                child: _ColorChip(
                  label: 'QR Color',
                  color: provider.qrColor,
                  onTap: () => _openColorPicker(context),
                  theme: theme,
                  responsive: responsive,
                ),
              ),
            ),
            Expanded(
              child: ScaleOnTap(
                onTap: () => _openColorPicker(context),
                scaleTo: 0.9,
                child: _ColorChip(
                  label: 'Border Color',
                  color: provider.borderStyle.color,
                  onTap: () => _openColorPicker(context),
                  theme: theme,
                  responsive: responsive,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.spacing * 1.5),
        Center(
          child: Text(
            'Tap any color to customize',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
              fontSize: responsive.value(
                phone: 12.0,
                tablet: 13.0,
                desktop: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExportSection(BuildContext context, ThemeData theme, Responsive responsive) {
    final provider = context.watch<QRProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.download_rounded,
          title: 'Export',
          subtitle: 'Save or share your customized QR code',
          theme: theme,
          responsive: responsive,
        ),
        SizedBox(height: responsive.cardSpacing),
        SizedBox(
          width: double.infinity,
          child: PulseAnimation(
            enabled: provider.hasQRData && !provider.isExporting,
            child: ElevatedButton.icon(
              onPressed: provider.hasQRData && !provider.isExporting
                  ? () => _exportQRCode(context)
                  : null,
              icon: provider.isExporting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.download_rounded,
                      size: responsive.iconSize,
                    ),
              label: Text(
                provider.isExporting ? 'Exporting...' : 'Export QR Code',
                style: TextStyle(
                  fontSize: responsive.value(
                    phone: 16.0,
                    tablet: 17.0,
                    desktop: 18.0,
                  ),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: responsive.value(
                    phone: 18.0,
                    tablet: 20.0,
                    desktop: 22.0,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: provider.hasQRData && !provider.isExporting ? 2 : 0,
              ),
            ),
          ),
        ),
        if (!provider.hasQRData) ...[
          SizedBox(height: responsive.spacing * 1.5),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: responsive.iconSize * 0.67,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: responsive.spacing * 0.75),
                Text(
                  'Generate a QR code first',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _openColorPicker(BuildContext context) {
    final provider = context.read<QRProvider>();

    ColorPickerSheet.show(
      context: context,
      initialPrimaryColor: provider.qrColor,
      initialSecondaryColor: provider.borderStyle.color,
      onColorsSelected: (primary, secondary) async {
        await provider.updateQRColor(primary);
        await provider.updateBorderColor(secondary);
      },
    );
  }

  void _exportQRCode(BuildContext context) {
    // Navigate to export screen where user can choose format, resolution, save/share
    context.goToExport();
  }
}

/// Section Header Widget - Responsive styling for section titles
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeData theme;
  final Responsive responsive;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.theme,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final containerSize = responsive.value(
      phone: 44.0,
      tablet: 48.0,
      desktop: 52.0,
    );

    return Row(
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: responsive.iconSize,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        SizedBox(width: responsive.spacing * 1.5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  fontSize: responsive.value(
                    phone: 16.0,
                    tablet: 17.0,
                    desktop: 18.0,
                  ),
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: responsive.value(
                    phone: 12.0,
                    tablet: 13.0,
                    desktop: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Color Chip Widget - Responsive color display
class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final ThemeData theme;
  final Responsive responsive;

  const _ColorChip({
    required this.label,
    required this.color,
    required this.onTap,
    required this.theme,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final argb = color.toARGB32();
    final hexCode = '#${argb.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    
    final chipHeight = responsive.value(
      phone: 80.0,
      tablet: 90.0,
      desktop: 100.0,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: responsive.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    size: responsive.iconSize * 0.58,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: responsive.spacing * 0.5),
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: responsive.value(
                        phone: 12.0,
                        tablet: 13.0,
                        desktop: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.spacing * 1.5),
              AnimatedContainer(
                duration: AnimationDurations.fast,
                width: double.infinity,
                height: chipHeight,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.colorize,
                    color: _getContrastColor(color),
                    size: responsive.iconSize * 1.33,
                  ),
                ),
              ),
              SizedBox(height: responsive.spacing * 1.5),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.spacing * 1.5,
                    vertical: responsive.spacing * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hexCode,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: 1.2,
                      fontSize: responsive.value(
                        phone: 11.0,
                        tablet: 12.0,
                        desktop: 13.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
