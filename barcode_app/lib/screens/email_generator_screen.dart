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

/// Email Generator Screen - Create mailto QR codes
class EmailGeneratorScreen extends StatefulWidget {
  const EmailGeneratorScreen({super.key});

  @override
  State<EmailGeneratorScreen> createState() => _EmailGeneratorScreenState();
}

class _EmailGeneratorScreenState extends State<EmailGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  bool _hasGenerated = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingData();
    });
  }

  void _loadExistingData() {
    final qrProvider = context.read<QRProvider>();
    final qrData = qrProvider.currentQRData;

    if (qrData?.type == QRType.email && qrData?.metadata != null) {
      final metadata = qrData!.metadata!;
      setState(() {
        _emailController.text = metadata['email'] ?? '';
        _subjectController.text = metadata['subject'] ?? '';
        _bodyController.text = metadata['body'] ?? '';
        _hasGenerated = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
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
    qrProvider.updateQRType(QRType.email);

    try {
      final email = _emailController.text.trim();
      final subject = _subjectController.text.trim().isEmpty
          ? null
          : _subjectController.text.trim();
      final body = _bodyController.text.trim().isEmpty
          ? null
          : _bodyController.text.trim();

      final encoded = QREncoder.encodeEmail(
        email: email,
        subject: subject,
        body: body,
      );

      final qrData = QRData(
        type: QRType.email,
        content: encoded,
        label: 'Email QR Code',
        timestamp: DateTime.now(),
        metadata: {
          'email': email,
          'subject': subject ?? '',
          'body': body ?? '',
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

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email address';
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
      message: 'Generating email QR code...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Email QR Generator'),
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
                    child: _buildFormCard(theme, colorScheme),
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
                  colorScheme.primary,
                  colorScheme.secondary,
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
              Icons.email_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Create Email QR Code',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pre-fill an email with subject and message in one scan',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormCard(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'hello@digitaldisconnections.com',
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _subjectController,
            label: 'Subject',
            hint: 'Quick hello',
            icon: Icons.subject_rounded,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _bodyController,
            label: 'Message',
            hint: 'Hey there! I just scanned your QR code...',
            icon: Icons.message_rounded,
            maxLines: 4,
          ),
        ],
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
          qrProvider.isGenerating ? 'Generating...' : 'Generate Email QR Code',
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
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
