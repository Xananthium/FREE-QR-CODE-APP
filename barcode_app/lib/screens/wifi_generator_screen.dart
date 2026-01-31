import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/navigation/app_router.dart';
import '../core/utils/qr_encoder.dart';
import '../core/animations/widget_animations.dart';
import '../core/animations/animation_constants.dart';
import '../models/qr_data.dart';
import '../models/qr_type.dart';
import '../providers/qr_provider.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/primary_button.dart';
import '../widgets/qr_display.dart';
import 'wifi_generator/widgets/ssid_input.dart';
import 'wifi_generator/widgets/security_selector.dart';
import 'wifi_generator/widgets/password_input.dart';
import 'wifi_generator/widgets/hidden_toggle.dart';

/// WiFi Generator Screen - Create QR codes for WiFi credentials
///
/// Features:
/// - SSID input with validation
/// - Security type selection (WPA2/WPA3/WEP/None)
/// - Password input (conditional on security type)
/// - Hidden network toggle
/// - Live QR code preview with smooth animations
/// - Navigate to customize and export screens
/// - Hero transition for QR code
class WifiGeneratorScreen extends StatefulWidget {
  const WifiGeneratorScreen({super.key});

  @override
  State<WifiGeneratorScreen> createState() => _WifiGeneratorScreenState();
}

class _WifiGeneratorScreenState extends State<WifiGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();

  SecurityType _selectedSecurity = SecurityType.wpa2;
  bool _isHidden = false;
  bool _hasGenerated = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Load existing QR data if present (from history tap)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingData();
    });
  }

  void _loadExistingData() {
    final qrProvider = context.read<QRProvider>();
    final qrData = qrProvider.currentQRData;

    // Only load if it's WiFi type and has metadata
    if (qrData?.type == QRType.wifi && qrData?.metadata != null) {
      final metadata = qrData!.metadata!;

      setState(() {
        // Populate text fields
        if (metadata['ssid'] != null) {
          _ssidController.text = metadata['ssid'] as String;
        }
        if (metadata['password'] != null) {
          _passwordController.text = metadata['password'] as String;
        }

        // Set security type
        if (metadata['security'] != null) {
          final security = metadata['security'] as String;
          _selectedSecurity = SecurityType.values.firstWhere(
            (s) => s.value == security,
            orElse: () => SecurityType.wpa2,
          );
        }

        // Set hidden flag
        if (metadata['hidden'] != null) {
          _isHidden = metadata['hidden'] as bool;
        }

        _hasGenerated = true;
      });
    }
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _generateQRCode() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
    });

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final qrProvider = context.read<QRProvider>();

    try {
      final ssid = _ssidController.text.trim();
      final password = _selectedSecurity != SecurityType.none
          ? _passwordController.text.trim()
          : null;

      // Encode WiFi credentials
      final wifiString = QREncoder.encodeWifi(
        ssid: ssid,
        password: password,
        security: _selectedSecurity.value,
        hidden: _isHidden,
      );

      // Create QRData with metadata for field population
      final qrData = QRData(
        type: QRType.wifi,
        content: wifiString,
        timestamp: DateTime.now(),
        metadata: {
          'ssid': ssid,
          'password': password ?? '',
          'security': _selectedSecurity.value,
          'hidden': _isHidden,
        },
      );

      // Generate QR code with metadata
      await qrProvider.generateQRFromData(qrData);

      setState(() {
        _hasGenerated = true;
      });

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('WiFi QR code generated successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e
            .toString()
            .replaceAll('Exception: ', '')
            .replaceAll('ArgumentError: ', '');
        _hasGenerated = false;
      });
    }
  }

  void _onSecurityChanged(SecurityType newSecurity) {
    setState(() {
      _selectedSecurity = newSecurity;

      // Clear password when switching to open network
      if (newSecurity == SecurityType.none) {
        _passwordController.clear();
      }
    });
  }

  String? _validatePassword(String? value) {
    // No validation needed for open networks
    if (_selectedSecurity == SecurityType.none) {
      return null;
    }

    // Password required for secured networks
    if (value == null || value.trim().isEmpty) {
      return 'Password is required for secured networks';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final qrProvider = context.watch<QRProvider>();

    return LoadingOverlay(
      isLoading: qrProvider.isGenerating,
      message: 'Generating WiFi QR code...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WiFi QR Generator'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.goBackOrHome(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header section
                  _buildHeader(theme, colorScheme),
                  const SizedBox(height: 32),

                  // SSID Input with staggered animation
                  StaggeredAnimation(
                    index: 0,
                    child: SsidInput(
                      controller: _ssidController,
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Security Type Selector
                  StaggeredAnimation(
                    index: 1,
                    child: SecuritySelector(
                      selectedSecurity: _selectedSecurity,
                      onChanged: _onSecurityChanged,
                      label: 'Security Type',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Password Input (conditional)
                  StaggeredAnimation(
                    index: 2,
                    child: PasswordInput(
                      controller: _passwordController,
                      enabled: _selectedSecurity != SecurityType.none,
                      labelText: 'WiFi Password',
                      hintText: _selectedSecurity == SecurityType.none
                          ? 'No password needed for open network'
                          : 'Enter your WiFi password',
                      validator: _validatePassword,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Hidden Network Toggle
                  StaggeredAnimation(
                    index: 3,
                    child: HiddenNetworkToggle(
                      value: _isHidden,
                      onChanged: (value) => setState(() => _isHidden = value),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Error message
                  if (_errorMessage != null) ...[
                    _buildErrorMessage(theme, colorScheme),
                    const SizedBox(height: 24),
                  ],

                  // Generate button
                  _buildGenerateButton(qrProvider),
                  const SizedBox(height: 32),

                  // QR Code Preview
                  if (_hasGenerated && qrProvider.hasQRData) ...[
                    _buildQRPreview(theme, colorScheme, qrProvider),
                    const SizedBox(height: 24),

                    // Action buttons
                    _buildActionButtons(theme, colorScheme),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build header section with icon and description
  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
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
            Icons.wifi,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Create WiFi QR Code',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Share your WiFi credentials instantly with a scannable QR code',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build error message display
  Widget _buildErrorMessage(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.error,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build generate button with loading state
  Widget _buildGenerateButton(QRProvider qrProvider) {
    return PrimaryButton(
      text: qrProvider.isGenerating ? 'Generating...' : 'Generate WiFi QR Code',
      icon: qrProvider.isGenerating ? null : Icons.qr_code_2_rounded,
      onPressed: qrProvider.isGenerating ? null : _generateQRCode,
      isLoading: qrProvider.isGenerating,
    );
  }

  /// Build QR code preview section with enhanced animations
  Widget _buildQRPreview(
    ThemeData theme,
    ColorScheme colorScheme,
    QRProvider qrProvider,
  ) {
    return FadeScaleTransition(
      show: _hasGenerated,
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
                'Preview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // QR Code display with Hero
          Center(
            child: Hero(
              tag: 'qr_preview',
              child: Material(
                color: Colors.transparent,
                child: QrDisplay.preview(
                  data: qrProvider.currentContent,
                  foregroundColor: qrProvider.qrColor,
                  backgroundColor: qrProvider.backgroundColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Network info card with slide-up animation
          FadeSlideIn(
            delay: AnimationDurations.staggerDelay,
            slideOffset: 40.0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Network Details',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    theme,
                    colorScheme,
                    'Network',
                    _ssidController.text,
                    Icons.wifi,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    theme,
                    colorScheme,
                    'Security',
                    _selectedSecurity.label,
                    Icons.security,
                  ),
                  if (_selectedSecurity != SecurityType.none) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      theme,
                      colorScheme,
                      'Password',
                      '•' * _passwordController.text.length,
                      Icons.lock,
                    ),
                  ],
                  if (_isHidden) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      theme,
                      colorScheme,
                      'Hidden',
                      'Yes',
                      Icons.visibility_off,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build info row for network details
  Widget _buildInfoRow(
    ThemeData theme,
    ColorScheme colorScheme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Build action buttons (Customize and Export)
  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: FadeSlideIn(
            delay: AnimationDurations.staggerDelay * 2,
            child: OutlinedButton.icon(
              onPressed: () => context.goToCustomize(),
              icon: const Icon(Icons.palette_outlined),
              label: const Text('Customize'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color: colorScheme.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FadeSlideIn(
            delay: AnimationDurations.staggerDelay * 3,
            child: FilledButton.icon(
              onPressed: () => context.goToExport(),
              icon: const Icon(Icons.download_outlined),
              label: const Text('Export'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
