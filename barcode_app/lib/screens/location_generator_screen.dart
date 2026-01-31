import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

enum LocationMode { address, coordinates }

/// Location Generator Screen - Create location QR codes
class LocationGeneratorScreen extends StatefulWidget {
  const LocationGeneratorScreen({super.key});

  @override
  State<LocationGeneratorScreen> createState() =>
      _LocationGeneratorScreenState();
}

class _LocationGeneratorScreenState extends State<LocationGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Address fields
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  // Coordinate fields
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  // Geocoding fields (for converting address to coordinates)
  final _addressSearchController = TextEditingController();

  final _labelController = TextEditingController();

  LocationMode _mode = LocationMode.address;
  bool _hasGenerated = false;
  bool _isGeocoding = false;
  bool _showSuggestions = false;
  List<Map<String, dynamic>> _addressSuggestions = [];
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

    // Only load if it's Location type and has metadata
    if (qrData?.type == QRType.location && qrData?.metadata != null) {
      final metadata = qrData!.metadata!;

      setState(() {
        // Restore mode
        if (metadata['mode'] == 'coordinates') {
          _mode = LocationMode.coordinates;
        } else {
          _mode = LocationMode.address;
        }

        // Restore label
        if (metadata['label'] != null) {
          _labelController.text = metadata['label'] as String;
        }

        // Restore mode-specific fields
        if (_mode == LocationMode.address) {
          if (metadata['street'] != null) {
            _streetController.text = metadata['street'] as String;
          }
          if (metadata['city'] != null) {
            _cityController.text = metadata['city'] as String;
          }
          if (metadata['state'] != null) {
            _stateController.text = metadata['state'] as String;
          }
          if (metadata['zip'] != null) {
            _zipController.text = metadata['zip'] as String;
          }
        } else {
          if (metadata['latitude'] != null) {
            _latitudeController.text = metadata['latitude'] as String;
          }
          if (metadata['longitude'] != null) {
            _longitudeController.text = metadata['longitude'] as String;
          }
        }

        _hasGenerated = true;
      });
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _addressSearchController.dispose();
    _labelController.dispose();
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
    qrProvider.updateQRType(QRType.location);

    try {
      final label = _labelController.text.trim().isEmpty
          ? null
          : _labelController.text.trim();

      // Build metadata based on mode
      final Map<String, dynamic> metadata = {
        'mode': _mode == LocationMode.address ? 'address' : 'coordinates',
        'label': label ?? '',
      };

      String encoded;
      if (_mode == LocationMode.address) {
        // Address mode
        metadata['street'] = _streetController.text.trim();
        metadata['city'] = _cityController.text.trim();
        metadata['state'] = _stateController.text.trim();
        metadata['zip'] = _zipController.text.trim();

        encoded = QREncoder.encodeLocation(
          address: _formatAddress(),
          label: label,
        );
      } else {
        // Coordinates mode
        final lat = _latitudeController.text.trim();
        final lng = _longitudeController.text.trim();
        metadata['latitude'] = lat;
        metadata['longitude'] = lng;

        encoded = QREncoder.encodeLocation(
          latitude: double.parse(lat),
          longitude: double.parse(lng),
          label: label,
        );
      }

      // Create QRData with metadata for field population
      final qrData = QRData(
        type: QRType.location,
        content: encoded,
        label: 'Location QR Code',
        timestamp: DateTime.now(),
        metadata: metadata,
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

  /// Format address parts into proper format: "Street, City, State Zip"
  String _formatAddress() {
    final parts = <String>[];

    final street = _streetController.text.trim();
    if (street.isNotEmpty) {
      parts.add(street);
    }

    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final zip = _zipController.text.trim();

    // Build "City, State Zip" part
    final cityStateParts = <String>[];
    if (city.isNotEmpty) {
      cityStateParts.add(city);
    }

    if (state.isNotEmpty && zip.isNotEmpty) {
      cityStateParts.add('$state $zip');
    } else if (state.isNotEmpty) {
      cityStateParts.add(state);
    } else if (zip.isNotEmpty) {
      cityStateParts.add(zip);
    }

    if (cityStateParts.isNotEmpty) {
      parts.add(cityStateParts.join(', '));
    }

    return parts.join(', ');
  }

  /// Search for addresses as user types (autocomplete)
  Future<void> _searchAddresses(String query) async {
    if (query.trim().length < 3) {
      setState(() {
        _showSuggestions = false;
        _addressSuggestions = [];
      });
      return;
    }

    try {
      final encodedQuery = Uri.encodeComponent(query.trim());
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=5',
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'FreeQRCodeApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);

        setState(() {
          _addressSuggestions = results.cast<Map<String, dynamic>>();
          _showSuggestions = results.isNotEmpty;
        });
      }
    } catch (e) {
      // Silently fail autocomplete - user can still type manually
      setState(() {
        _showSuggestions = false;
        _addressSuggestions = [];
      });
    }
  }

  /// Handle selection of an address suggestion
  void _selectAddressSuggestion(Map<String, dynamic> suggestion) {
    final lat = double.parse(suggestion['lat']);
    final lon = double.parse(suggestion['lon']);

    setState(() {
      _latitudeController.text = lat.toStringAsFixed(6);
      _longitudeController.text = lon.toStringAsFixed(6);
      _addressSearchController.text = suggestion['display_name'];
      _showSuggestions = false;
      _addressSuggestions = [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Set coordinates: ${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }


  String? _validateStreet(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Street address is required';
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City is required';
    }
    return null;
  }

  String? _validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'State is required';
    }
    return null;
  }

  String? _validateZip(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ZIP code is required';
    }
    return null;
  }

  String? _validateCoordinate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid number';
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
      message: 'Generating location QR code...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Location QR Generator'),
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
                  const SizedBox(height: 24),
                  FadeSlideIn(
                    delay: AnimationDurations.staggerDelay,
                    child: _buildModeSelector(colorScheme),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    delay: AnimationDurations.staggerDelay * 2,
                    child: _buildFormCard(colorScheme),
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
                  const Color(0xFF4CAF50),
                  const Color(0xFF009688),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.location_on_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Create Location QR Code',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Share an address or coordinates in a single scan',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModeSelector(ColorScheme colorScheme) {
    return SegmentedButton<LocationMode>(
      segments: const [
        ButtonSegment(
          value: LocationMode.address,
          label: Text('Address'),
          icon: Icon(Icons.home_rounded),
        ),
        ButtonSegment(
          value: LocationMode.coordinates,
          label: Text('Coordinates'),
          icon: Icon(Icons.my_location_rounded),
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

  Widget _buildFormCard(ColorScheme colorScheme) {
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
          if (_mode == LocationMode.address) ...[
            // Simple address entry
            _buildTextField(
              controller: _streetController,
              label: 'Street Address',
              hint: '1600 Amphitheatre Pkwy',
              icon: Icons.home_rounded,
              validator: _validateStreet,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _cityController,
              label: 'City',
              hint: 'Mountain View',
              icon: Icons.location_city_rounded,
              validator: _validateCity,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _stateController,
                    label: 'State',
                    hint: 'CA',
                    icon: Icons.map_rounded,
                    validator: _validateState,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _zipController,
                    label: 'ZIP',
                    hint: '94043',
                    icon: Icons.pin_drop_rounded,
                    keyboardType: TextInputType.number,
                    validator: _validateZip,
                  ),
                ),
              ],
            ),
          ] else ...[
            // Coordinates mode: Manual entry OR search address
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _latitudeController,
                    label: 'Latitude',
                    hint: '37.4220',
                    icon: Icons.south_rounded,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    validator: _validateCoordinate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _longitudeController,
                    label: 'Longitude',
                    hint: '-122.0841',
                    icon: Icons.east_rounded,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    validator: _validateCoordinate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Divider with "OR"
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            // Address search with autocomplete
            Text(
              'Search for an address:',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                TextFormField(
                  controller: _addressSearchController,
                  onChanged: _searchAddresses,
                  decoration: InputDecoration(
                    labelText: 'Type address...',
                    hintText: 'Start typing: 1600 Amphitheatre...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _addressSearchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              setState(() {
                                _addressSearchController.clear();
                                _showSuggestions = false;
                                _addressSuggestions = [];
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.4)),
                    ),
                  ),
                ),
                // Autocomplete suggestions dropdown
                if (_showSuggestions && _addressSuggestions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _addressSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _addressSuggestions[index];
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.location_on_rounded,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          title: Text(
                            suggestion['display_name'],
                            style: const TextStyle(fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => _selectAddressSuggestion(suggestion),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ],
          const SizedBox(height: 16),
          _buildTextField(
            controller: _labelController,
            label: 'Label (optional)',
            hint: 'HQ Entrance',
            icon: Icons.label_rounded,
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
      text: qrProvider.isGenerating
          ? 'Generating...'
          : 'Generate Location QR Code',
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
