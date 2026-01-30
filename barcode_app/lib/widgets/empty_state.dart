import 'package:flutter/material.dart';

/// A reusable empty state widget that displays a placeholder when no data is available.
/// 
/// Features:
/// - Customizable icon, title, and message
/// - Optional action button
/// - Supports both light and dark themes
/// - Responsive design
/// - Beautiful animations
class EmptyState extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// The title text
  final String title;
  
  /// The descriptive message
  final String message;
  
  /// Optional action button text
  final String? actionLabel;
  
  /// Optional action button callback
  final VoidCallback? onActionPressed;
  
  /// Size of the icon (default: 120)
  final double iconSize;
  
  /// Whether to show animation
  final bool animate;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.iconSize = 120,
    this.animate = true,
  });

  /// Factory constructor for empty QR preview state
  factory EmptyState.noQrCode({
    VoidCallback? onCreatePressed,
  }) {
    return EmptyState(
      icon: Icons.qr_code_2_outlined,
      title: 'No QR Code Yet',
      message: 'Select a type from the home screen to create your first QR code',
      actionLabel: 'Go to Home',
      onActionPressed: onCreatePressed,
    );
  }

  /// Factory constructor for empty history state
  factory EmptyState.noHistory({
    VoidCallback? onCreatePressed,
  }) {
    return EmptyState(
      icon: Icons.history_outlined,
      title: 'No History',
      message: 'Your generated QR codes will appear here',
      actionLabel: 'Create QR Code',
      onActionPressed: onCreatePressed,
    );
  }

  /// Factory constructor for empty scan results
  factory EmptyState.noScans({
    VoidCallback? onScanPressed,
  }) {
    return EmptyState(
      icon: Icons.qr_code_scanner_outlined,
      title: 'No Scans Yet',
      message: 'Scanned QR codes and barcodes will appear here',
      actionLabel: 'Start Scanning',
      onActionPressed: onScanPressed,
    );
  }

  /// Factory constructor for no favorites
  factory EmptyState.noFavorites({
    VoidCallback? onBrowsePressed,
  }) {
    return EmptyState(
      icon: Icons.star_border_outlined,
      title: 'No Favorites',
      message: 'Mark QR codes as favorites to quickly access them here',
      actionLabel: 'Browse QR Codes',
      onActionPressed: onBrowsePressed,
    );
  }

  /// Factory constructor for search with no results
  factory EmptyState.noResults({
    String? searchQuery,
  }) {
    return EmptyState(
      icon: Icons.search_off_outlined,
      title: 'No Results Found',
      message: searchQuery != null
          ? 'No results for "$searchQuery"'
          : 'Try adjusting your search terms',
      animate: false,
    );
  }

  /// Factory constructor for network error
  factory EmptyState.networkError({
    VoidCallback? onRetryPressed,
  }) {
    return EmptyState(
      icon: Icons.wifi_off_outlined,
      title: 'Connection Error',
      message: 'Check your internet connection and try again',
      actionLabel: 'Retry',
      onActionPressed: onRetryPressed,
    );
  }

  /// Factory constructor for error state
  factory EmptyState.error({
    String? errorMessage,
    VoidCallback? onRetryPressed,
  }) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Something Went Wrong',
      message: errorMessage ?? 'An unexpected error occurred. Please try again.',
      actionLabel: 'Retry',
      onActionPressed: onRetryPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon with animation
            _EmptyStateIcon(
              icon: icon,
              size: iconSize,
              animate: animate,
              color: colorScheme.primary.withValues(alpha: 0.6),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Message
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Action button
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.arrow_forward),
                label: Text(actionLabel!),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Animated icon for empty state
class _EmptyStateIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final bool animate;
  final Color color;

  const _EmptyStateIcon({
    required this.icon,
    required this.size,
    required this.animate,
    required this.color,
  });

  @override
  State<_EmptyStateIcon> createState() => _EmptyStateIconState();
}

class _EmptyStateIconState extends State<_EmptyStateIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
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
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size + 40,
              height: widget.size + 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withValues(alpha: 0.1),
              ),
              child: Icon(
                widget.icon,
                size: widget.size,
                color: widget.color,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Compact empty state for smaller areas
class CompactEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final double iconSize;

  const CompactEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
