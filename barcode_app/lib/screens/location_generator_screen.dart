import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../core/animations/animation_constants.dart';
import '../core/animations/widget_animations.dart';
import '../core/navigation/app_router.dart';
import '../core/utils/qr_encoder.dart';
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
  final _geoStreetController = TextEditingController();
  final _geoCityController = TextEditingController();
  final _geoStateController = TextEditingController();
  final _geoZipController = TextEditingController();

  final _labelController = TextEditingController();

  LocationMode _mode = LocationMode.address;
  bool _hasGenerated = false;
  bool _isGeocoding = false;
  String? _errorMessage;

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _geoStreetController.dispose();
    _geoCityController.dispose();
    _geoStateController.dispose();
    _geoZipController.dispose();
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
      final encoded = _mode == LocationMode.address
          ? QREncoder.encodeLocation(
              address: _formatAddress(),
              label: _labelController.text.trim().isEmpty
                  ? null
                  : _labelController.text.trim(),
            )
          : QREncoder.encodeLocation(
              latitude: double.parse(_latitudeController.text.trim()),
              longitude: double.parse(_longitudeController.text.trim()),
              label: _labelController.text.trim().isEmpty
                  ? null
                  : _labelController.text.trim(),
            );

      await qrProvider.generateQRCode(encoded, label: 'Location QR Code');
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

  /// Format geocoding address parts
  String _formatGeocodingAddress() {
    final parts = <String>[];

    final street = _geoStreetController.text.trim();
    if (street.isNotEmpty) {
      parts.add(street);
    }

    final city = _geoCityController.text.trim();
    final state = _geoStateController.text.trim();
    final zip = _geoZipController.text.trim();

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

  /// Convert address to GPS coordinates using Nominatim (OpenStreetMap) API
  /// This is a free, privacy-friendly geocoding service with no API key required
  Future<void> _getCoordinatesFromAddress() async {
    setState(() {
      _errorMessage = null;
      _isGeocoding = true;
    });

    try {
      // Validate at least some address fields are filled
      if (_geoStreetController.text.trim().isEmpty &&
          _geoCityController.text.trim().isEmpty) {
        throw Exception('Please enter at least a street address or city');
      }

      final address = _formatGeocodingAddress();

      // Call Nominatim API (OpenStreetMap)
      final encodedAddress = Uri.encodeComponent(address);
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$encodedAddress&format=json&limit=1',
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'FreeQRCodeApp/1.0', // Required by Nominatim
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);

        if (results.isEmpty) {
          throw Exception('Address not found. Please check your address.');
        }

        final location = results[0];
        final lat = double.parse(location['lat']);
        final lon = double.parse(location['lon']);

        // Fill in the coordinate values
        setState(() {
          _latitudeController.text = lat.toStringAsFixed(6);
          _longitudeController.text = lon.toStringAsFixed(6);
          _isGeocoding = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Found coordinates: ${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        throw Exception('Geocoding service temporarily unavailable');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isGeocoding = false;
      });
    }
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
            // Coordinates mode: Manual entry OR convert from address
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
            // Address to coordinates converter
            Text(
              'Get coordinates from address:',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _geoStreetController,
              label: 'Street Address',
              hint: '1600 Amphitheatre Pkwy',
              icon: Icons.home_rounded,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _geoCityController,
              label: 'City',
              hint: 'Mountain View',
              icon: Icons.location_city_rounded,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _geoStateController,
                    label: 'State',
                    hint: 'CA',
                    icon: Icons.map_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _geoZipController,
                    label: 'ZIP',
                    hint: '94043',
                    icon: Icons.pin_drop_rounded,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Get Coordinates button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isGeocoding ? null : _getCoordinatesFromAddress,
                icon: _isGeocoding
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location_rounded),
                label: Text(_isGeocoding ? 'Finding...' : 'Get GPS Coordinates'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
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
