import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// URL input field widget with validation and clipboard integration
///
/// A specialized text input field for URL entry with:
/// - Real-time URL validation
/// - Paste from clipboard button
/// - Clear button
/// - Visual feedback for valid/invalid URLs
class URLInputField extends StatefulWidget {
  /// Controller for the URL text field
  final TextEditingController controller;

  /// Callback when URL changes
  final ValueChanged<String>? onChanged;

  /// Callback when URL is submitted
  final ValueChanged<String>? onSubmitted;

  /// Whether to auto-focus this field
  final bool autofocus;

  const URLInputField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  State<URLInputField> createState() => _URLInputFieldState();
}

class _URLInputFieldState extends State<URLInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  String? _validationError;
  bool _isValidUrl = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_validateUrl);
    _validateUrl();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_validateUrl);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _validateUrl() {
    final url = widget.controller.text.trim();
    
    setState(() {
      if (url.isEmpty) {
        _validationError = null;
        _isValidUrl = false;
        return;
      }

      // Basic URL validation
      final urlPattern = RegExp(
        r'^(https?:\/\/)?' // Optional protocol
        r'([\da-z\.-]+)' // Domain name
        r'\.([a-z\.]{2,6})' // Extension
        r'([\/\w \.-]*)*' // Path
        r'\/?$', // Optional trailing slash
        caseSensitive: false,
      );

      if (!urlPattern.hasMatch(url)) {
        _validationError = 'Please enter a valid URL';
        _isValidUrl = false;
      } else {
        _validationError = null;
        _isValidUrl = true;
      }
    });
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      widget.controller.text = clipboardData!.text!;
      widget.onChanged?.call(clipboardData.text!);
    }
  }

  void _clearField() {
    widget.controller.clear();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasError = _validationError != null;
    final hasText = widget.controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.link,
                size: 18,
                color: hasError
                    ? colorScheme.error
                    : _isFocused
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Enter URL',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: hasError
                      ? colorScheme.error
                      : _isFocused
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              // Paste button
              TextButton.icon(
                onPressed: _pasteFromClipboard,
                icon: const Icon(Icons.content_paste, size: 16),
                label: const Text('Paste'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),

        // Text field
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
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'https://example.com',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              prefixIcon: Icon(
                _isValidUrl
                    ? Icons.check_circle_outline
                    : Icons.language,
                color: _isValidUrl
                    ? colorScheme.primary
                    : hasError
                        ? colorScheme.error
                        : _isFocused
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
              ),
              suffixIcon: hasText
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: _clearField,
                      tooltip: 'Clear',
                    )
                  : null,
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
                  color: _isValidUrl
                      ? colorScheme.primary.withValues(alpha: 0.3)
                      : colorScheme.outline.withValues(alpha: 0.5),
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),

        // Validation feedback
        if (hasText)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  if (hasError)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.error_outline,
                        size: 14,
                        color: colorScheme.error,
                      ),
                    )
                  else if (_isValidUrl)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.check_circle,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      _isValidUrl
                          ? 'Valid URL'
                          : (_validationError ?? ''),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _isValidUrl
                            ? colorScheme.primary
                            : colorScheme.error,
                        fontWeight: _isValidUrl ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
