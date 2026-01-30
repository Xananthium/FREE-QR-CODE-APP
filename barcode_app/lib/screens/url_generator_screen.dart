import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../core/navigation/app_router.dart';
import '../core/utils/qr_encoder.dart';
import '../core/animations/widget_animations.dart';
import '../core/animations/animation_constants.dart';
import '../providers/qr_provider.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/primary_button.dart';
import 'url_generator/widgets/url_input_field.dart';

/// URL Generator Screen - Create QR codes from URLs with live preview
/// 
/// Features:
/// - URL input with real-time validation
/// - Live QR code preview as user types (debounced)
/// - Customize button to apply decorative borders
/// - Export button to save/share QR code
/// - Beautiful Material Design 3 UI with smooth animations
/// - Hero transition to customize screen
class UrlGeneratorScreen extends StatefulWidget {
  const UrlGeneratorScreen({super.key});

  @override
  State<UrlGeneratorScreen> createState() => _UrlGeneratorScreenState();
}

class _UrlGeneratorScreenState extends State<UrlGeneratorScreen> {
  final _urlController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _urlController.dispose();
    super.dispose();
  }

  /// Validate URL format
  bool _validateUrlFormat(String url) {
    if (url.trim().isEmpty) return false;

    final urlPattern = RegExp(
      r'^(https?:\/\/)?' // Optional protocol
      r'([\da-z\.-]+)' // Domain name
      r'\.([a-z\.]{2,6})' // Extension
      r'([\/\w \.-]*)*' // Path
      r'\/?$', // Optional trailing slash
      caseSensitive: false,
    );

    return urlPattern.hasMatch(url.trim());
  }

  /// Handle URL input changes with debouncing
  void _onUrlChanged(String value) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Validate URL format
    final isValid = _validateUrlFormat(value);

    // Only generate QR if URL is valid
    if (!isValid) {
      return;
    }

    // Debounce QR generation (500ms delay)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _generateQRCode(value);
    });
  }

  /// Generate QR code from URL
  Future<void> _generateQRCode(String url) async {
    if (!mounted) return;

    final qrProvider = context.read<QRProvider>();
    final trimmedUrl = url.trim();

    try {
      // Add protocol if missing
      String formattedUrl = trimmedUrl;
      if (!trimmedUrl.startsWith('http://') && !trimmedUrl.startsWith('https://')) {
        formattedUrl = 'https://$trimmedUrl';
      }

      // Encode and generate QR
      final encodedUrl = QREncoder.encodeUrl(formattedUrl);
      await qrProvider.generateQRCode(encodedUrl, label: 'URL QR Code');
    } catch (e) {
      // Silently handle errors - validation happens in UI
      debugPrint('QR generation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final qrProvider = context.watch<QRProvider>();
    final hasQRCode = qrProvider.currentContent.isNotEmpty;

    return LoadingOverlay(
      isLoading: qrProvider.isGenerating,
      message: 'Generating QR code...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('URL QR Generator'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.goBackOrHome(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header section with animated icon
                _buildHeader(theme, colorScheme),
                const SizedBox(height: 32),

                // URL Input with live validation
                URLInputField(
                  controller: _urlController,
                  onChanged: _onUrlChanged,
                  autofocus: true,
                ),
                const SizedBox(height: 24),

                // Live QR Code Preview with enhanced animation
                if (hasQRCode) ...[
                  _buildQRPreview(theme, colorScheme, qrProvider),
                  const SizedBox(height: 24),

                  // Action Buttons (Customize & Export) - staggered
                  _buildActionButtons(theme, colorScheme, qrProvider),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build header section with gradient icon
  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Gradient icon container with subtle rotation on entrance
        TweenAnimationBuilder<double>(
          tween: Tween(begin: -0.1, end: 0.0),
          duration: AnimationDurations.slow,
          curve: AnimationCurves.overshoot,
          builder: (context, value, child) {
            return Transform.rotate(
              angle: value,
              child: child,
            );
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary,
                  colorScheme.tertiary,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.link_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          'Create URL QR Code',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),

        // Description
        Text(
          'Enter any website URL and watch the QR code generate in real-time',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build QR code preview section with enhanced fade + scale animation
  Widget _buildQRPreview(
    ThemeData theme,
    ColorScheme colorScheme,
    QRProvider qrProvider,
  ) {
    return FadeScaleTransition(
      show: true,
      duration: AnimationDurations.normal,
      curve: AnimationCurves.overshoot,
      child: Column(
        children: [
          // Preview header
          Row(
            children: [
              Icon(
                Icons.visibility_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Live Preview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // QR Code display card with Hero for smooth transition to customize
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: qrProvider.backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Hero(
              tag: 'qr_preview',
              child: Material(
                color: Colors.transparent,
                child: QrImageView(
                  data: qrProvider.currentContent,
                  version: QrVersions.auto,
                  size: 280,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: qrProvider.qrColor,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: qrProvider.qrColor,
                  ),
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(50, 50),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build action buttons (Customize & Export) with staggered fade-in
  Widget _buildActionButtons(
    ThemeData theme,
    ColorScheme colorScheme,
    QRProvider qrProvider,
  ) {
    final isDisabled = qrProvider.isGenerating;

    return Row(
      children: [
        // Customize button - appears first
        Expanded(
          child: FadeSlideIn(
            delay: AnimationDurations.staggerDelay,
            duration: AnimationDurations.normal,
            child: PrimaryButton(
              text: 'Customize',
              icon: Icons.palette,
              onPressed: isDisabled ? null : () => context.goToCustomize(),
              height: 56,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Export button - appears second
        Expanded(
          child: FadeSlideIn(
            delay: AnimationDurations.staggerDelay * 2,
            duration: AnimationDurations.normal,
            child: SecondaryButton(
              text: 'Export',
              icon: Icons.file_download,
              onPressed: isDisabled ? null : () => context.goToExport(),
              height: 56,
            ),
          ),
        ),
      ],
    );
  }
}
