import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/navigation/app_router.dart';
import '../../core/utils/export_service.dart';
import '../../core/utils/share_service.dart';
import '../../models/export_options.dart';
import '../../providers/export_provider.dart';
import '../../providers/qr_provider.dart';
import 'widgets/export_button.dart';
import 'widgets/format_selector.dart';
import 'widgets/resolution_picker.dart';

/// Export Screen - Professional QR code export with all options
///
/// Features:
/// - Real-time QR preview with export settings
/// - Resolution selection (512px - 4096px)
/// - Format selection (PNG/JPEG)
/// - Transparent background toggle (PNG only)
/// - Export progress tracking
/// - Save and Share functionality
/// - Success/error feedback
class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  // Global key for capturing the QR code widget as an image
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  
  // Services
  final ExportService _exportService = ExportService();
  final ShareService _shareService = ShareService();
  
  // Export button states (separate for Save and Share)
  ExportButtonState _saveButtonState = ExportButtonState.ready;
  ExportButtonState _shareButtonState = ExportButtonState.ready;

  @override
  void initState() {
    super.initState();
    // Reset export state when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExportProvider>().clearExportState();
    });
  }

  /// Handles the Save action - exports QR code to device storage
  Future<void> _handleSave() async {
    final qrProvider = context.read<QRProvider>();
    final exportProvider = context.read<ExportProvider>();

    if (qrProvider.currentContent.isEmpty) {
      _showError('No QR code to export. Please generate one first.');
      return;
    }

    setState(() => _saveButtonState = ExportButtonState.loading);

    try {
      // Export using ExportProvider (handles progress tracking)
      final result = await exportProvider.exportQRCode(
        _repaintBoundaryKey,
        _exportService,
      );

      if (!mounted) return;

      if (result.success) {
        setState(() => _saveButtonState = ExportButtonState.success);
        _showSuccess('Saved to ${result.filePath}');
        
        // Reset button after 2 seconds
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() => _saveButtonState = ExportButtonState.ready);
        }
      } else {
        setState(() => _saveButtonState = ExportButtonState.error);
        _showError(result.errorMessage ?? 'Export failed');
        
        // Reset button after 2 seconds
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() => _saveButtonState = ExportButtonState.ready);
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saveButtonState = ExportButtonState.error);
      _showError('Export failed: ${e.toString()}');
      
      // Reset button after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _saveButtonState = ExportButtonState.ready);
      }
    }
  }

  /// Handles the Share action - shares QR code via system share sheet
  Future<void> _handleShare() async {
    final qrProvider = context.read<QRProvider>();
    final exportProvider = context.read<ExportProvider>();

    if (qrProvider.currentContent.isEmpty) {
      _showError('No QR code to share. Please generate one first.');
      return;
    }

    setState(() => _shareButtonState = ExportButtonState.loading);

    try {
      // Capture the QR code as image bytes
      final imageBytes = await _captureQRCode();
      
      // Generate filename
      final filename = _exportService.generateFilename(
        exportProvider.format,
      );

      // Share via system share sheet
      final result = await _shareService.shareImage(imageBytes, filename);

      if (!mounted) return;

      // ShareResultStatus can be: success, dismissed, unavailable
      if (result.status.name == 'success') {
        setState(() => _shareButtonState = ExportButtonState.success);
        _showSuccess('Shared successfully!');
        
        // Reset button after 2 seconds
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() => _shareButtonState = ExportButtonState.ready);
        }
      } else if (result.status.name == 'dismissed') {
        // User dismissed the share sheet - just reset
        setState(() => _shareButtonState = ExportButtonState.ready);
      } else {
        setState(() => _shareButtonState = ExportButtonState.error);
        _showError('Sharing not available');
        
        // Reset button after 2 seconds
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() => _shareButtonState = ExportButtonState.ready);
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _shareButtonState = ExportButtonState.error);
      _showError('Share failed: ${e.toString()}');
      
      // Reset button after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _shareButtonState = ExportButtonState.ready);
      }
    }
  }

  /// Captures the QR code widget as image bytes
  Future<Uint8List> _captureQRCode() async {
    final exportProvider = context.read<ExportProvider>();
    return await _exportService.captureWidget(
      _repaintBoundaryKey,
      exportProvider.options,
    );
  }

  /// Shows success feedback to user
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Shows error feedback to user
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final qrProvider = context.watch<QRProvider>();
    final exportProvider = context.watch<ExportProvider>();
    
    final hasQRCode = qrProvider.currentContent.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export QR Code'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goBackOrHome(),
        ),
      ),
      body: SafeArea(
        child: hasQRCode
            ? _buildExportContent(theme, colorScheme, qrProvider, exportProvider)
            : _buildEmptyState(theme, colorScheme),
      ),
    );
  }

  /// Builds the main export content when QR code exists
  Widget _buildExportContent(
    ThemeData theme,
    ColorScheme colorScheme,
    QRProvider qrProvider,
    ExportProvider exportProvider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with icon
          _buildHeader(theme, colorScheme),
          const SizedBox(height: 32),

          // QR Code Preview
          _buildQRPreview(theme, colorScheme, qrProvider, exportProvider),
          const SizedBox(height: 32),

          // Export Progress (if exporting)
          if (exportProvider.isExporting)
            _buildExportProgress(theme, colorScheme, exportProvider),
          
          if (exportProvider.isExporting)
            const SizedBox(height: 32),

          // Format Selector
          FormatSelector(
            selectedFormat: exportProvider.format,
            transparentBackground: false, // TODO: Add transparent bg support
            onFormatChanged: (format) {
              exportProvider.updateFormat(format);
            },
            onTransparentChanged: (transparent) {
              // TODO: Implement transparent background toggle
            },
          ),
          const SizedBox(height: 24),

          // Resolution Picker
          ResolutionPicker(
            selectedResolution: exportProvider.resolution,
            onChanged: (resolution) {
              exportProvider.updateResolution(resolution);
            },
            label: 'Export Resolution',
            enabled: !exportProvider.isExporting,
          ),
          const SizedBox(height: 32),

          // Export Buttons (Save & Share)
          _buildExportButtons(theme, colorScheme, exportProvider),
          
          const SizedBox(height: 16),

          // Export Info
          _buildExportInfo(theme, colorScheme, exportProvider),
        ],
      ),
    );
  }

  /// Builds the header with icon and description
  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Gradient icon container
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
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.ios_share_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        
        Text(
          'Export & Share',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        
        Text(
          'Choose your export settings and save or share your QR code',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Builds the QR code preview with RepaintBoundary for export
  Widget _buildQRPreview(
    ThemeData theme,
    ColorScheme colorScheme,
    QRProvider qrProvider,
    ExportProvider exportProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preview label
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
            const Spacer(),
            // Export format badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${exportProvider.format.displayName} • ${exportProvider.resolution.displayName}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // QR Code Preview Container
        Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: qrProvider.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: RepaintBoundary(
              key: _repaintBoundaryKey,
              child: Container(
                color: qrProvider.backgroundColor,
                padding: const EdgeInsets.all(16),
                child: QrImageView(
                  data: qrProvider.currentContent,
                  version: QrVersions.auto,
                  size: 220,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: qrProvider.qrColor,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: qrProvider.qrColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds export progress indicator
  Widget _buildExportProgress(
    ThemeData theme,
    ColorScheme colorScheme,
    ExportProvider exportProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: exportProvider.progress,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          
          // Status message
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                exportProvider.statusMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the Save and Share buttons
  Widget _buildExportButtons(
    ThemeData theme,
    ColorScheme colorScheme,
    ExportProvider exportProvider,
  ) {
    final isExporting = exportProvider.isExporting;

    return Row(
      children: [
        // Save Button
        Expanded(
          child: ExportButton(
            state: _saveButtonState,
            onPressed: isExporting ? null : _handleSave,
            readyText: 'Save',
            loadingText: 'Saving...',
            successText: 'Saved!',
            errorText: 'Failed',
            height: 56,
          ),
        ),
        const SizedBox(width: 16),
        
        // Share Button
        Expanded(
          child: ExportButton(
            state: _shareButtonState,
            onPressed: isExporting ? null : _handleShare,
            readyText: 'Share',
            loadingText: 'Sharing...',
            successText: 'Shared!',
            errorText: 'Failed',
            height: 56,
          ),
        ),
      ],
    );
  }

  /// Builds export information panel
  Widget _buildExportInfo(
    ThemeData theme,
    ColorScheme colorScheme,
    ExportProvider exportProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
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
                'Export Details',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          _buildInfoRow(
            theme,
            colorScheme,
            Icons.aspect_ratio,
            'Resolution',
            exportProvider.resolution.displayName,
          ),
          const SizedBox(height: 8),
          
          _buildInfoRow(
            theme,
            colorScheme,
            Icons.image_outlined,
            'Format',
            exportProvider.format.displayName.toUpperCase(),
          ),
          const SizedBox(height: 8),
          
          if (exportProvider.format == ExportFormat.jpeg)
            _buildInfoRow(
              theme,
              colorScheme,
              Icons.tune,
              'Quality',
              '${exportProvider.quality}%',
            ),
        ],
      ),
    );
  }

  /// Builds a single info row
  Widget _buildInfoRow(
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Builds empty state when no QR code exists
  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.qr_code_2_rounded,
                size: 64,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'No QR Code to Export',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            
            Text(
              'Generate a QR code first, then come back here to export and share it',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Go back button
            FilledButton.icon(
              onPressed: () => context.goBackOrHome(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
