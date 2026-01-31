import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/animations/animation_constants.dart';
import '../core/animations/widget_animations.dart';
import '../core/navigation/app_router.dart';
import '../core/utils/qr_encoder.dart';
import '../models/qr_data.dart';
import '../models/qr_type.dart';
import '../providers/qr_provider.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/primary_button.dart';
import '../widgets/qr_display.dart';

/// Phone Generator Screen - Create tel: QR codes
class PhoneGeneratorScreen extends StatefulWidget {
  const PhoneGeneratorScreen({super.key});

  @override
  State<PhoneGeneratorScreen> createState() => _PhoneGeneratorScreenState();
}

class _PhoneGeneratorScreenState extends State<PhoneGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

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

    // Only load if it's Phone type and has metadata
    if (qrData?.type == QRType.phone && qrData?.metadata != null) {
      final metadata = qrData!.metadata!;

      setState(() {
        if (metadata['phone'] != null) {
          _phoneController.text = metadata['phone'] as String;
        }
        _hasGenerated = true;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _generateQRCode() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final qrProvider = context.read<QRProvider>();
    qrProvider.updateQRType(QRType.phone);

    try {
      final phone = _phoneController.text.trim();
      final encoded = QREncoder.encodePhone(phone);

      // Create QRData with metadata for field population
      final qrData = QRData(
        type: QRType.phone,
        content: encoded,
        label: 'Phone QR Code',
        timestamp: DateTime.now(),
        metadata: {
          'phone': phone,
        },
      );

      await qrProvider.generateQRFromData(qrData);
      setState(() {
        _hasGenerated = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('ArgumentError: ', '');
      });
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digitsOnly = value.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');
    if (digitsOnly.isEmpty) {
      return 'Enter a valid phone number';
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
      message: 'Generating phone QR code...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Phone QR Generator'),
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
                  _buildHeader(theme, colorScheme),
                  const SizedBox(height: 28),
                  FadeSlideIn(
                    delay: AnimationDurations.staggerDelay,
                    child: _buildInputCard(colorScheme),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    _buildErrorMessage(theme, colorScheme),
                  ],
                  const SizedBox(height: 20),
                  _buildGenerateButton(qrProvider),
                  const SizedBox(height: 28),
                  if (_hasGenerated && qrProvider.hasQRData) ...[
                    _buildQRPreview(theme, colorScheme, qrProvider),
                    const SizedBox(height: 24),
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

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: -0.08, end: 0.0),
          duration: AnimationDurations.slow,
          curve: AnimationCurves.overshoot,
          builder: (context, value, child) {
            return Transform.rotate(angle: value, child: child);
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.secondary,
                  colorScheme.tertiary,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.secondary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.phone_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Create Phone QR Code',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Let users call instantly with a scan',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInputCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: _buildTextField(
        controller: _phoneController,
        label: 'Phone Number',
        hint: '+1 (555) 123-4567',
        icon: Icons.phone_rounded,
        keyboardType: TextInputType.phone,
        validator: _validatePhone,
      ),
    );
  }

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

  Widget _buildGenerateButton(QRProvider qrProvider) {
    return PrimaryButton(
      text:
          qrProvider.isGenerating ? 'Generating...' : 'Generate Phone QR Code',
      icon: qrProvider.isGenerating ? null : Icons.qr_code_2_rounded,
      onPressed: qrProvider.isGenerating ? null : _generateQRCode,
      isLoading: qrProvider.isGenerating,
    );
  }

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
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: FadeSlideIn(
            delay: AnimationDurations.staggerDelay * 2,
            child: SecondaryButton(
              text: 'Customize',
              icon: Icons.palette_outlined,
              onPressed: () => context.goToCustomize(),
              height: 52,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FadeSlideIn(
            delay: AnimationDurations.staggerDelay * 3,
            child: PrimaryButton(
              text: 'Export',
              icon: Icons.download_outlined,
              onPressed: () => context.goToExport(),
              height: 52,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: colorScheme.outline.withValues(alpha: 0.4)),
        ),
      ),
    );
  }
}
