import 'package:flutter/material.dart';

/// A beautiful toggle widget for WiFi hidden network setting
/// 
/// Features:
/// - Material 3 Switch with smooth animations
/// - Explanatory label and helper text
/// - Visual feedback with color transitions
/// - Accessible with proper semantics
class HiddenNetworkToggle extends StatefulWidget {
  /// Current value of the hidden network setting
  final bool value;
  
  /// Callback when the value changes
  final ValueChanged<bool> onChanged;
  
  /// Whether the toggle is enabled
  final bool enabled;

  const HiddenNetworkToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<HiddenNetworkToggle> createState() => _HiddenNetworkToggleState();
}

class _HiddenNetworkToggleState extends State<HiddenNetworkToggle> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
      if (isHovered) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      cursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.enabled
                ? (_isHovered
                    ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.7)
                    : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5))
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.value && widget.enabled
                  ? colorScheme.primary.withValues(alpha: 0.3)
                  : colorScheme.outline.withValues(alpha: 0.2),
              width: widget.value && widget.enabled ? 2 : 1,
            ),
            boxShadow: _isHovered && widget.enabled
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.enabled ? () => widget.onChanged(!widget.value) : null,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Icon
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.value && widget.enabled
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.value 
                            ? Icons.visibility_off_outlined 
                            : Icons.visibility_outlined,
                        color: widget.value && widget.enabled
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Label and description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Hidden Network',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: widget.enabled
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.value
                                ? 'Network SSID will not be broadcast'
                                : 'Network SSID will be visible to devices',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: widget.enabled
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Switch
                    AnimatedScale(
                      scale: _isHovered && widget.enabled ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Switch(
                        value: widget.value,
                        onChanged: widget.enabled ? widget.onChanged : null,
                        activeThumbColor: colorScheme.primary,
                        activeTrackColor: colorScheme.primaryContainer,
                        inactiveThumbColor: colorScheme.outline,
                        inactiveTrackColor: colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A simplified version without hover effects for mobile
class HiddenNetworkToggleCompact extends StatelessWidget {
  /// Current value of the hidden network setting
  final bool value;
  
  /// Callback when the value changes
  final ValueChanged<bool> onChanged;
  
  /// Whether the toggle is enabled
  final bool enabled;

  const HiddenNetworkToggleCompact({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: enabled
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value && enabled
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.2),
          width: value && enabled ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? () => onChanged(!value) : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Icon
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: value && enabled
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    value 
                        ? Icons.visibility_off_outlined 
                        : Icons.visibility_outlined,
                    color: value && enabled
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hidden Network',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: enabled
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value
                            ? 'SSID not broadcast'
                            : 'SSID visible',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: enabled
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Switch
                Switch(
                  value: value,
                  onChanged: enabled ? onChanged : null,
                  activeThumbColor: colorScheme.primary,
                  activeTrackColor: colorScheme.primaryContainer,
                  inactiveThumbColor: colorScheme.outline,
                  inactiveTrackColor: colorScheme.surfaceContainerHighest,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
