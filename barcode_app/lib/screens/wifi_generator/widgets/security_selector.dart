import 'package:flutter/material.dart';

/// WiFi security type options
enum SecurityType {
  wpa2('WPA/WPA2', 'WPAOWPA2'),
  wpa3('WPA3', 'WPA3'),
  wep('WEP', 'WEP'),
  none('None', 'nopass');

  final String label;
  final String value;

  const SecurityType(this.label, this.value);
}

/// Security selector dropdown widget for WiFi QR code generation
/// 
/// A beautiful, Material Design 3 compliant dropdown selector that allows
/// users to choose the WiFi security type with visual feedback and icons.
class SecuritySelector extends StatefulWidget {
  /// Currently selected security type
  final SecurityType selectedSecurity;

  /// Callback when security type changes
  final ValueChanged<SecurityType> onChanged;

  /// Whether the selector is enabled
  final bool enabled;

  /// Label text displayed above the selector
  final String? label;

  /// Error text to display (shows selector in error state)
  final String? errorText;

  const SecuritySelector({
    super.key,
    required this.selectedSecurity,
    required this.onChanged,
    this.enabled = true,
    this.label,
    this.errorText,
  });

  @override
  State<SecuritySelector> createState() => _SecuritySelectorState();
}

class _SecuritySelectorState extends State<SecuritySelector> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  IconData _getSecurityIcon(SecurityType type) {
    switch (type) {
      case SecurityType.wpa2:
        return Icons.shield;
      case SecurityType.wpa3:
        return Icons.security;
      case SecurityType.wep:
        return Icons.lock_outline;
      case SecurityType.none:
        return Icons.lock_open;
    }
  }

  Color _getSecurityColor(SecurityType type, ColorScheme colorScheme) {
    switch (type) {
      case SecurityType.wpa3:
        return Colors.green.shade700;
      case SecurityType.wpa2:
        return colorScheme.primary;
      case SecurityType.wep:
        return Colors.orange.shade700;
      case SecurityType.none:
        return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null && widget.label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label!,
              style: theme.textTheme.labelLarge?.copyWith(
                color: hasError
                    ? colorScheme.error
                    : _isFocused
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        // Dropdown container
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isFocused && !hasError
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.enabled
                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              prefixIcon: Icon(
                _getSecurityIcon(widget.selectedSecurity),
                color: hasError
                    ? colorScheme.error
                    : _isFocused
                        ? _getSecurityColor(widget.selectedSecurity, colorScheme)
                        : colorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 2.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SecurityType>(
                value: widget.selectedSecurity,
                focusNode: _focusNode,
                isExpanded: true,
                isDense: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: hasError
                      ? colorScheme.error
                      : _isFocused
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                ),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: widget.enabled
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                ),
                dropdownColor: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                items: SecurityType.values.map((SecurityType type) {
                  return DropdownMenuItem<SecurityType>(
                    value: type,
                    child: Row(
                      children: [
                        Icon(
                          _getSecurityIcon(type),
                          size: 20,
                          color: _getSecurityColor(type, colorScheme),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            type.label,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: type == widget.selectedSecurity
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (type == widget.selectedSecurity)
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: _getSecurityColor(type, colorScheme),
                          ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: widget.enabled
                    ? (SecurityType? newValue) {
                        if (newValue != null) {
                          widget.onChanged(newValue);
                        }
                      }
                    : null,
              ),
            ),
          ),
        ),

        // Error message
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 16),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 14,
                  color: colorScheme.error,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Security info hint
        if (widget.selectedSecurity != SecurityType.wpa2 && widget.errorText == null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 16),
            child: Row(
              children: [
                Icon(
                  _getInfoIcon(widget.selectedSecurity),
                  size: 14,
                  color: _getSecurityColor(widget.selectedSecurity, colorScheme),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _getSecurityHint(widget.selectedSecurity),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  IconData _getInfoIcon(SecurityType type) {
    switch (type) {
      case SecurityType.wpa3:
        return Icons.verified_user;
      case SecurityType.wep:
        return Icons.warning_amber;
      case SecurityType.none:
        return Icons.warning;
      default:
        return Icons.info_outline;
    }
  }

  String _getSecurityHint(SecurityType type) {
    switch (type) {
      case SecurityType.wpa3:
        return 'Most secure option - recommended for modern devices';
      case SecurityType.wep:
        return 'Weak encryption - not recommended for sensitive data';
      case SecurityType.none:
        return 'No password protection - open network';
      default:
        return '';
    }
  }
}
