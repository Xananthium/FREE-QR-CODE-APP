import 'package:flutter/material.dart';
import '../../../models/export_options.dart';

/// Resolution picker widget for barcode/QR code export
/// 
/// A beautiful, Material Design 3 compliant radio button selector that allows
/// users to choose the export resolution with visual feedback and pixel dimensions.
/// 
/// Example usage:
/// ```dart
/// ResolutionPicker(
///   selectedResolution: ExportResolution.medium,
///   onChanged: (resolution) {
///     print('Selected: ${resolution.displayName}');
///   },
/// )
/// ```
class ResolutionPicker extends StatelessWidget {
  /// Currently selected resolution
  final ExportResolution selectedResolution;

  /// Callback when resolution changes
  final ValueChanged<ExportResolution> onChanged;

  /// Whether the picker is enabled
  final bool enabled;

  /// Optional label text displayed above the picker
  final String? label;

  const ResolutionPicker({
    super.key,
    required this.selectedResolution,
    required this.onChanged,
    this.enabled = true,
    this.label,
  });

  /// Returns an appropriate icon for each resolution level
  IconData _getResolutionIcon(ExportResolution resolution) {
    switch (resolution) {
      case ExportResolution.small:
        return Icons.photo_size_select_small;
      case ExportResolution.medium:
        return Icons.photo_size_select_large;
      case ExportResolution.large:
        return Icons.photo_size_select_actual;
      case ExportResolution.extraLarge:
        return Icons.high_quality;
    }
  }

  /// Returns a color indicating quality level for each resolution
  Color _getResolutionColor(ExportResolution resolution, ColorScheme colorScheme) {
    switch (resolution) {
      case ExportResolution.small:
        return Colors.orange.shade700;
      case ExportResolution.medium:
        return colorScheme.primary;
      case ExportResolution.large:
        return Colors.blue.shade700;
      case ExportResolution.extraLarge:
        return Colors.green.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Optional label
        if (label != null && label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              label!,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        // Radio button list container
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: ExportResolution.values.map((resolution) {
              final isSelected = resolution == selectedResolution;
              final isFirst = resolution == ExportResolution.values.first;
              final isLast = resolution == ExportResolution.values.last;

              return Column(
                children: [
                  // Divider between items (except before first item)
                  if (!isFirst)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),

                  // Radio button tile
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: enabled
                          ? () => onChanged(resolution)
                          : null,
                      borderRadius: BorderRadius.vertical(
                        top: isFirst ? const Radius.circular(11) : Radius.zero,
                        bottom: isLast ? const Radius.circular(11) : Radius.zero,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            // Custom radio button indicator
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.outline,
                                  width: 2,
                                ),
                                color: Colors.transparent,
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),

                            const SizedBox(width: 16),

                            // Resolution icon
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _getResolutionColor(resolution, colorScheme)
                                        .withValues(alpha: 0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getResolutionIcon(resolution),
                                size: 20,
                                color: isSelected
                                    ? _getResolutionColor(resolution, colorScheme)
                                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Resolution label and dimensions
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Resolution name
                                  Text(
                                    resolution.displayName.split(' ').first,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: enabled
                                          ? (isSelected
                                              ? colorScheme.onSurface
                                              : colorScheme.onSurfaceVariant)
                                          : colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.5),
                                    ),
                                  ),

                                  // Pixel dimensions
                                  Text(
                                    '${resolution.pixelSize}×${resolution.pixelSize} px',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: enabled
                                          ? (isSelected
                                              ? colorScheme.primary
                                              : colorScheme.onSurfaceVariant
                                                  .withValues(alpha: 0.7))
                                          : colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.4),
                                      fontWeight: isSelected
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Selected indicator
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: _getResolutionColor(resolution, colorScheme),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),

        // Helper text
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _getResolutionHint(selectedResolution),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns helpful hint text for the selected resolution
  String _getResolutionHint(ExportResolution resolution) {
    switch (resolution) {
      case ExportResolution.small:
        return 'Best for quick sharing and web use';
      case ExportResolution.medium:
        return 'Recommended for most uses';
      case ExportResolution.large:
        return 'High quality for print and detailed scanning';
      case ExportResolution.extraLarge:
        return 'Maximum quality for professional printing';
    }
  }
}
