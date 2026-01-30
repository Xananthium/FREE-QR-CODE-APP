import 'package:flutter/material.dart';
import '../../../models/export_options.dart';

/// A widget that allows users to select the export format (PNG or JPEG)
/// and whether to use a transparent background (PNG only).
/// 
/// This widget displays radio buttons for format selection and a checkbox
/// for transparent background when PNG is selected.
class FormatSelector extends StatelessWidget {
  /// The currently selected export format
  final ExportFormat selectedFormat;
  
  /// Whether transparent background is enabled (only for PNG)
  final bool transparentBackground;
  
  /// Callback when the format changes
  final ValueChanged<ExportFormat> onFormatChanged;
  
  /// Callback when transparent background setting changes
  final ValueChanged<bool> onTransparentChanged;

  const FormatSelector({
    super.key,
    required this.selectedFormat,
    required this.transparentBackground,
    required this.onFormatChanged,
    required this.onTransparentChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Export Format',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Format options container
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // PNG option
              _FormatRadioTile(
                format: ExportFormat.png,
                selectedFormat: selectedFormat,
                onChanged: onFormatChanged,
                title: 'PNG',
                subtitle: 'Lossless quality, supports transparency',
                icon: Icons.image_outlined,
              ),
              
              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  color: colorScheme.outlineVariant,
                ),
              ),
              
              // JPEG option
              _FormatRadioTile(
                format: ExportFormat.jpeg,
                selectedFormat: selectedFormat,
                onChanged: onFormatChanged,
                title: 'JPEG',
                subtitle: 'Smaller file size, no transparency',
                icon: Icons.photo_outlined,
              ),
            ],
          ),
        ),
        
        // Transparent background option (only for PNG)
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: selectedFormat == ExportFormat.png
              ? Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: CheckboxListTile(
                        value: transparentBackground,
                        onChanged: (value) {
                          onTransparentChanged(value ?? false);
                        },
                        title: Text(
                          'Transparent Background',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Remove background color from the exported image',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        secondary: Icon(
                          Icons.layers_clear_outlined,
                          color: colorScheme.primary,
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        activeColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Internal widget for displaying a format radio option
class _FormatRadioTile extends StatelessWidget {
  final ExportFormat format;
  final ExportFormat selectedFormat;
  final ValueChanged<ExportFormat> onChanged;
  final String title;
  final String subtitle;
  final IconData icon;

  const _FormatRadioTile({
    required this.format,
    required this.selectedFormat,
    required this.onChanged,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = format == selectedFormat;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(format),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Format icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Radio button - using custom implementation to avoid deprecated warnings
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    width: 2,
                  ),
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
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
