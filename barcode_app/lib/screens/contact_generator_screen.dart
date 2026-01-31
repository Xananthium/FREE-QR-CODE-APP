import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
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

enum ContactMode { pick, create }

/// Contact Generator Screen - Create vCard QR codes
///
/// Features:
/// - Pick from device contacts
/// - Create a new contact card in-app
/// - Live QR preview and export
class ContactGeneratorScreen extends StatefulWidget {
  const ContactGeneratorScreen({super.key});

  @override
  State<ContactGeneratorScreen> createState() => _ContactGeneratorScreenState();
}

class _ContactGeneratorScreenState extends State<ContactGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _titleController = TextEditingController();
  final _websiteController = TextEditingController();

  ContactMode _mode = ContactMode.pick;
  Contact? _selectedContact;
  bool _hasGenerated = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingData();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _titleController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    final qrProvider = context.read<QRProvider>();
    final qrData = qrProvider.currentQRData;

    if (qrData?.type == QRType.contact && qrData?.metadata != null) {
      final metadata = qrData!.metadata!;
      setState(() {
        if (metadata['firstName'] != null) {
          _firstNameController.text = metadata['firstName'] as String;
        }
        if (metadata['lastName'] != null) {
          _lastNameController.text = metadata['lastName'] as String;
        }
        if (metadata['phone'] != null) {
          _phoneController.text = metadata['phone'] as String;
        }
        if (metadata['email'] != null) {
          _emailController.text = metadata['email'] as String;
        }
        if (metadata['company'] != null) {
          _companyController.text = metadata['company'] as String;
        }
        if (metadata['title'] != null) {
          _titleController.text = metadata['title'] as String;
        }
        if (metadata['website'] != null) {
          _websiteController.text = metadata['website'] as String;
        }
        _hasGenerated = true;
        _mode = ContactMode.create;
      });
    }
  }

  Future<void> _pickContact() async {
    setState(() {
      _errorMessage = null;
    });

    final granted = await FlutterContacts.requestPermission();
    if (!granted) {
      _showSnack('Contact permission denied');
      return;
    }

    final contact = await FlutterContacts.openExternalPick();
    if (contact == null) return;

    setState(() {
      _selectedContact = contact;
    });

    await _generateFromContact(contact);
  }

  Future<void> _generateFromContact(Contact contact) async {
    final qrProvider = context.read<QRProvider>();
    qrProvider.updateQRType(QRType.contact);

    final vCard = QREncoder.encodeVCard(contact.toVCard());

    // Extract metadata from contact
    final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
    final email = contact.emails.isNotEmpty ? contact.emails.first.address : '';
    final company = contact.organizations.isNotEmpty
        ? contact.organizations.first.company
        : '';
    final title = contact.organizations.isNotEmpty
        ? contact.organizations.first.title
        : '';
    final website = contact.websites.isNotEmpty
        ? contact.websites.first.url
        : '';

    final qrData = QRData(
      type: QRType.contact,
      content: vCard,
      label: contact.displayName.isNotEmpty ? contact.displayName : 'Contact QR',
      timestamp: DateTime.now(),
      metadata: {
        'firstName': contact.name.first,
        'lastName': contact.name.last,
        'phone': phone,
        'email': email,
        'company': company,
        'title': title,
        'website': website,
      },
    );

    await qrProvider.generateQRFromData(qrData);

    setState(() {
      _hasGenerated = true;
    });
  }

  Future<void> _generateFromForm() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final contact = _buildContactFromForm();
    if (!_contactHasData(contact)) {
      setState(() {
        _errorMessage = 'Add at least a name, phone, or email';
      });
      return;
    }

    await _generateFromContact(contact);
  }

  Future<void> _saveContactToDevice() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final contact = _buildContactFromForm();
    if (!_contactHasData(contact)) {
      setState(() {
        _errorMessage = 'Add at least a name, phone, or email to save';
      });
      return;
    }

    final granted = await FlutterContacts.requestPermission();
    if (!granted) {
      _showSnack('Contact permission denied');
      return;
    }

    final saved = await FlutterContacts.openExternalInsert(contact);
    if (saved != null && mounted) {
      _showSnack('Contact saved');
    }
  }

  Contact _buildContactFromForm() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final displayName =
        [first, last].where((part) => part.isNotEmpty).join(' ');

    final contact = Contact(
      displayName: displayName,
      name: Name(first: first, last: last),
      phones: _phoneController.text.trim().isNotEmpty
          ? [Phone(_phoneController.text.trim())]
          : [],
      emails: _emailController.text.trim().isNotEmpty
          ? [Email(_emailController.text.trim())]
          : [],
      organizations: _companyController.text.trim().isNotEmpty ||
              _titleController.text.trim().isNotEmpty
          ? [
              Organization(
                company: _companyController.text.trim(),
                title: _titleController.text.trim(),
              )
            ]
          : [],
      websites: _websiteController.text.trim().isNotEmpty
          ? [Website(_websiteController.text.trim())]
          : [],
    );

    return contact;
  }

  bool _contactHasData(Contact contact) {
    return contact.displayName.isNotEmpty ||
        contact.phones.isNotEmpty ||
        contact.emails.isNotEmpty;
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
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
      message: 'Generating contact QR code...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contact QR Generator'),
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
                _buildHeader(theme, colorScheme),
                const SizedBox(height: 24),

                // Mode switcher
                FadeSlideIn(
                  delay: AnimationDurations.staggerDelay,
                  child: _buildModeSelector(theme, colorScheme),
                ),
                const SizedBox(height: 20),

                if (_mode == ContactMode.pick) ...[
                  _buildPickContactCard(theme, colorScheme),
                ] else ...[
                  _buildCreateContactForm(theme, colorScheme),
                ],

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
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: -0.1, end: 0.0),
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
                  colorScheme.tertiary,
                  colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.tertiary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.contact_page_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Create Contact QR Code',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Pick a contact or craft a new vCard with beautiful details',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModeSelector(ThemeData theme, ColorScheme colorScheme) {
    return SegmentedButton<ContactMode>(
      segments: const [
        ButtonSegment(
          value: ContactMode.pick,
          label: Text('Pick from Contacts'),
          icon: Icon(Icons.import_contacts_rounded),
        ),
        ButtonSegment(
          value: ContactMode.create,
          label: Text('Create New'),
          icon: Icon(Icons.person_add_alt_1_rounded),
        ),
      ],
      selected: {_mode},
      onSelectionChanged: (values) {
        setState(() {
          _mode = values.first;
          _errorMessage = null;
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceContainerHighest;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimaryContainer;
          }
          return colorScheme.onSurfaceVariant;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildPickContactCard(ThemeData theme, ColorScheme colorScheme) {
    return FadeSlideIn(
      delay: AnimationDurations.staggerDelay * 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.contact_mail_rounded, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Pick from Contacts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Choose an existing contact from your phone and generate a vCard QR code instantly.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: _selectedContact == null ? 'Pick Contact' : 'Pick Another',
              icon: Icons.contacts_rounded,
              onPressed: _pickContact,
            ),
            if (_selectedContact != null) ...[
              const SizedBox(height: 16),
              _buildSelectedContact(theme, colorScheme, _selectedContact!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedContact(
    ThemeData theme,
    ColorScheme colorScheme,
    Contact contact,
  ) {
    final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
    final email = contact.emails.isNotEmpty ? contact.emails.first.address : '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact.displayName.isNotEmpty
                ? contact.displayName
                : 'Selected Contact',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          if (phone.isNotEmpty)
            _buildInfoRow(theme, colorScheme, Icons.phone_rounded, phone),
          if (email.isNotEmpty)
            _buildInfoRow(theme, colorScheme, Icons.email_rounded, email),
        ],
      ),
    );
  }

  Widget _buildCreateContactForm(ThemeData theme, ColorScheme colorScheme) {
    return FadeSlideIn(
      delay: AnimationDurations.staggerDelay * 2,
      child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.person_add_alt_1_rounded,
                      color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Create Contact',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                hint: 'Jane',
                icon: Icons.badge_rounded,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                hint: 'Doe',
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: '+1 (555) 123-4567',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'hello@digitaldisconnections.com',
                icon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _companyController,
                label: 'Company',
                hint: 'Digital Disconnections',
                icon: Icons.business_center_rounded,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _titleController,
                label: 'Job Title',
                hint: 'Founder',
                icon: Icons.work_rounded,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _websiteController,
                label: 'Website',
                hint: 'https://yourcompany.com',
                icon: Icons.language_rounded,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Save to Contacts',
                icon: Icons.save_alt_rounded,
                onPressed: _saveContactToDevice,
                height: 50,
              ),
            ],
          ),
        ),
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
    final isDisabled = qrProvider.isGenerating ||
        (_mode == ContactMode.pick && _selectedContact == null);

    return PrimaryButton(
      text: qrProvider.isGenerating
          ? 'Generating...'
          : 'Generate Contact QR Code',
      icon: qrProvider.isGenerating ? null : Icons.qr_code_2_rounded,
      onPressed: isDisabled
          ? null
          : (_mode == ContactMode.pick
              ? () => _generateFromContact(_selectedContact!)
              : _generateFromForm),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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

  Widget _buildInfoRow(
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onPrimaryContainer),
        const SizedBox(width: 8),
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
}
