import 'package:flutter/material.dart';

/// States that the export button can be in
enum ExportButtonState {
  /// Default state - ready to export
  ready,
  
  /// Currently exporting
  loading,
  
  /// Export completed successfully
  success,
  
  /// Export failed
  error,
}

/// A specialized button widget for exporting QR codes with enhanced states.
///
/// This button provides visual feedback for the export process including:
/// - Loading state with progress indicator
/// - Success state with checkmark animation
/// - Error state with error icon
/// - Automatic state reset after success/error
///
/// Example usage:
/// ```dart
/// ExportButton(
///   state: _exportState,
///   onPressed: () async {
///     setState(() => _exportState = ExportButtonState.loading);
///     final success = await exportQRCode();
///     setState(() => _exportState = success 
///       ? ExportButtonState.success 
///       : ExportButtonState.error);
///   },
/// )
/// ```
class ExportButton extends StatefulWidget {
  /// Current state of the export button
  final ExportButtonState state;
  
  /// Callback when the button is pressed (only in ready state)
  final VoidCallback? onPressed;
  
  /// Custom text for ready state (defaults to "Export QR Code")
  final String? readyText;
  
  /// Custom text for loading state (defaults to "Exporting...")
  final String? loadingText;
  
  /// Custom text for success state (defaults to "Exported!")
  final String? successText;
  
  /// Custom text for error state (defaults to "Export Failed")
  final String? errorText;
  
  /// Width of the button (defaults to full width)
  final double? width;
  
  /// Height of the button
  final double height;
  
  /// Duration to show success/error state before reverting to ready
  final Duration feedbackDuration;

  const ExportButton({
    super.key,
    required this.state,
    required this.onPressed,
    this.readyText,
    this.loadingText,
    this.successText,
    this.errorText,
    this.width,
    this.height = 56,
    this.feedbackDuration = const Duration(seconds: 2),
  });

  @override
  State<ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<ExportButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(ExportButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Trigger scale animation on state change
    if (oldWidget.state != widget.state) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Returns button content based on current state
  Widget _buildButtonContent(ThemeData theme, ColorScheme colorScheme) {
    switch (widget.state) {
      case ExportButtonState.loading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.loadingText ?? 'Exporting...',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );

      case ExportButtonState.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 22,
              color: colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Text(
              widget.successText ?? 'Exported!',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );

      case ExportButtonState.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 22,
              color: colorScheme.onError,
            ),
            const SizedBox(width: 12),
            Text(
              widget.errorText ?? 'Export Failed',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );

      case ExportButtonState.ready:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_rounded,
              size: 22,
              color: colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Text(
              widget.readyText ?? 'Export QR Code',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
    }
  }

  /// Returns background color based on state
  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (widget.state) {
      case ExportButtonState.loading:
        return colorScheme.primary.withValues(alpha: 0.8);
      case ExportButtonState.success:
        return const Color(0xFF4CAF50); // Material Green
      case ExportButtonState.error:
        return colorScheme.error;
      case ExportButtonState.ready:
        return colorScheme.primary;
    }
  }

  /// Determines if button should be enabled
  bool get _isEnabled {
    return widget.state == ExportButtonState.ready && widget.onPressed != null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ElevatedButton(
          onPressed: _isEnabled ? widget.onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getBackgroundColor(colorScheme),
            foregroundColor: widget.state == ExportButtonState.error
                ? colorScheme.onError
                : colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.surfaceContainerHighest,
            disabledForegroundColor: colorScheme.onSurfaceVariant,
            elevation: _isEnabled ? 3 : 0,
            shadowColor: _getBackgroundColor(colorScheme).withValues(alpha: 0.4),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: _buildButtonContent(theme, colorScheme),
          ),
        ),
      ),
    );
  }
}

/// A compact version of the export button for smaller spaces
class CompactExportButton extends StatelessWidget {
  final ExportButtonState state;
  final VoidCallback? onPressed;

  const CompactExportButton({
    super.key,
    required this.state,
    required this.onPressed,
  });

  IconData _getIcon() {
    switch (state) {
      case ExportButtonState.loading:
        return Icons.hourglass_empty_rounded;
      case ExportButtonState.success:
        return Icons.check_circle_rounded;
      case ExportButtonState.error:
        return Icons.error_outline_rounded;
      case ExportButtonState.ready:
        return Icons.download_rounded;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (state) {
      case ExportButtonState.success:
        return const Color(0xFF4CAF50);
      case ExportButtonState.error:
        return colorScheme.error;
      case ExportButtonState.loading:
        return colorScheme.primary.withValues(alpha: 0.8);
      case ExportButtonState.ready:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = state == ExportButtonState.ready && onPressed != null;

    return IconButton(
      onPressed: isEnabled ? onPressed : null,
      icon: state == ExportButtonState.loading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.onPrimary,
                ),
              ),
            )
          : Icon(_getIcon()),
      style: IconButton.styleFrom(
        backgroundColor: _getBackgroundColor(colorScheme),
        foregroundColor: state == ExportButtonState.error
            ? colorScheme.onError
            : colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        padding: const EdgeInsets.all(12),
        minimumSize: const Size(48, 48),
      ),
    );
  }
}
