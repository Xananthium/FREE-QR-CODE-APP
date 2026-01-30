import 'package:flutter/material.dart';
import '../models/export_options.dart';
import '../core/utils/export_service.dart';

/// Result class for export operations
/// 
/// Represents the outcome of an export operation with either
/// success (file path) or failure (error message).
class ExportResult {
  /// Whether the export operation was successful
  final bool success;
  
  /// File path where the exported image was saved (success only)
  final String? filePath;
  
  /// Error message describing the failure (error only)
  final String? errorMessage;

  /// Creates a successful export result with the file path
  const ExportResult.success(this.filePath)
      : success = true,
        errorMessage = null;

  /// Creates a failed export result with an error message
  const ExportResult.error(this.errorMessage)
      : success = false,
        filePath = null;

  @override
  String toString() {
    if (success) {
      return 'ExportResult.success(filePath: $filePath)';
    } else {
      return 'ExportResult.error(errorMessage: $errorMessage)';
    }
  }
}

/// Provider for managing QR code export state
/// 
/// This provider handles:
/// - Export options (resolution, format, quality)
/// - Export progress tracking (percentage, status)
/// - Export results (success/error states)
/// - State cleanup and reset
class ExportProvider extends ChangeNotifier {
  // Export State
  ExportOptions _options = const ExportOptions();
  bool _isExporting = false;
  double _progress = 0.0;
  String _statusMessage = '';
  ExportResult? _exportResult;

  // Getters - Export Options

  /// Current export options (resolution, format, quality)
  ExportOptions get options => _options;

  /// Current export resolution setting
  ExportResolution get resolution => _options.resolution;

  /// Current export format setting
  ExportFormat get format => _options.format;

  /// Current JPEG quality setting (0-100)
  int get quality => _options.quality;

  // Getters - Export Progress

  /// Whether an export operation is currently in progress
  bool get isExporting => _isExporting;

  /// Export progress as a value from 0.0 to 1.0
  double get progress => _progress;

  /// Current status message describing the export operation
  String get statusMessage => _statusMessage;

  // Getters - Export Results

  /// Result of the last export operation (null if no export yet)
  ExportResult? get exportResult => _exportResult;

  /// Whether there is an export result available
  bool get hasResult => _exportResult != null;

  /// Whether the last export was successful
  bool get lastExportSucceeded => _exportResult?.success ?? false;

  /// Whether the last export failed
  bool get lastExportFailed => 
      _exportResult != null && !_exportResult!.success;

  // Export Options Management

  /// Update the export resolution
  /// 
  /// Changes the output image size for future exports.
  /// Does not affect exports already in progress.
  void updateResolution(ExportResolution resolution) {
    if (_options.resolution != resolution) {
      _options = _options.copyWith(resolution: resolution);
      notifyListeners();
    }
  }

  /// Update the export format
  /// 
  /// Changes the output image format (PNG or JPEG) for future exports.
  /// Does not affect exports already in progress.
  void updateFormat(ExportFormat format) {
    if (_options.format != format) {
      _options = _options.copyWith(format: format);
      notifyListeners();
    }
  }

  /// Update the JPEG quality setting
  /// 
  /// The [quality] parameter must be between 0 and 100, where
  /// 100 is best quality. Only applies to JPEG exports.
  /// 
  /// Throws [AssertionError] if quality is out of range.
  void updateQuality(int quality) {
    assert(quality >= 0 && quality <= 100, 'Quality must be between 0 and 100');
    
    if (_options.quality != quality) {
      _options = _options.copyWith(quality: quality);
      notifyListeners();
    }
  }

  /// Update all export options at once
  /// 
  /// Useful for restoring saved settings or applying a preset.
  void updateOptions(ExportOptions options) {
    if (_options != options) {
      _options = options;
      notifyListeners();
    }
  }

  // Export Execution

  /// Export a QR code as an image with progress tracking
  /// 
  /// The [repaintBoundaryKey] must be attached to a RepaintBoundary widget
  /// wrapping the QR code to be exported.
  /// 
  /// The [exportService] handles the actual image capture and save operations.
  /// 
  /// Returns an [ExportResult] indicating success or failure.
  /// Updates [progress] and [statusMessage] during the operation.
  /// 
  /// If an export is already in progress, returns an error result immediately.
  /// 
  /// Example:
  /// ```dart
  /// final result = await exportProvider.exportQRCode(
  ///   _repaintBoundaryKey,
  ///   ExportService(),
  /// );
  /// 
  /// if (result.success) {
  ///   print('Exported to: ${result.filePath}');
  /// } else {
  ///   print('Export failed: ${result.errorMessage}');
  /// }
  /// ```
  Future<ExportResult> exportQRCode(
    GlobalKey repaintBoundaryKey,
    ExportService exportService,
  ) async {
    // Guard against duplicate calls
    if (_isExporting) {
      return const ExportResult.error('Export already in progress');
    }

    _isExporting = true;
    _exportResult = null;
    notifyListeners();

    try {
      // Step 1: Prepare export (0%)
      _updateProgress(0.0, 'Preparing export...');
      await Future.delayed(const Duration(milliseconds: 100));

      // Step 2: Capture widget as image (25%)
      _updateProgress(0.25, 'Capturing QR code...');
      final imageBytes = await exportService.captureWidget(
        repaintBoundaryKey,
        _options,
      );

      // Step 3: Convert to desired format (50%)
      _updateProgress(0.5, 'Converting image...');
      await Future.delayed(const Duration(milliseconds: 100));

      // Step 4: Save to device (75%)
      _updateProgress(0.75, 'Saving file...');
      final filename = exportService.generateFilename(_options.format);
      final filePath = await exportService.saveImage(
        imageBytes,
        filename,
        _options.format,
      );

      // Step 5: Complete (100%)
      _updateProgress(1.0, 'Export complete!');
      await Future.delayed(const Duration(milliseconds: 200));

      // Create success result
      _exportResult = ExportResult.success(filePath);
      return _exportResult!;

    } catch (e) {
      // Create error result
      final errorMessage = 'Export failed: ${e.toString()}';
      _exportResult = ExportResult.error(errorMessage);
      _updateProgress(0.0, 'Export failed');
      return _exportResult!;

    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }

  // State Management

  /// Clear export progress and results
  /// 
  /// Resets progress to 0, clears status message and export result.
  /// Does not clear export options (use [resetToDefaults] for that).
  /// 
  /// Cannot be called while an export is in progress.
  void clearExportState() {
    if (_isExporting) return;

    _progress = 0.0;
    _statusMessage = '';
    _exportResult = null;
    notifyListeners();
  }

  /// Reset all export settings to defaults
  /// 
  /// Restores default export options:
  /// - Resolution: Medium (1024x1024)
  /// - Format: PNG
  /// - Quality: 85
  /// 
  /// Also clears progress and results.
  /// Cannot be called while an export is in progress.
  void resetToDefaults() {
    if (_isExporting) return;

    _options = const ExportOptions();
    _progress = 0.0;
    _statusMessage = '';
    _exportResult = null;
    notifyListeners();
  }

  // Internal Helpers

  /// Update progress and status message
  /// 
  /// The [progress] parameter should be between 0.0 and 1.0.
  /// The [message] describes the current operation.
  void _updateProgress(double progress, String message) {
    _progress = progress;
    _statusMessage = message;
    notifyListeners();
  }
}
