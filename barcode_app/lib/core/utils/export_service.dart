import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import '../../models/export_options.dart';

// Conditional imports for platform-specific functionality
import 'export_service_mobile.dart' if (dart.library.html) 'export_service_web.dart';

/// Service for exporting QR codes with decorative borders as images.
///
/// This service handles:
/// - Widget-to-image conversion using RepaintBoundary
/// - Multiple resolution support (512px to 4096px)
/// - Format conversion (PNG and JPEG)
/// - Cross-platform saving (web download vs mobile file system)
///
/// Example usage:
/// ```dart
/// final exportService = ExportService();
/// final options = ExportOptions(
///   resolution: ExportResolution.large,
///   format: ExportFormat.png,
/// );
/// 
/// final bytes = await exportService.captureWidget(repaintBoundaryKey, options);
/// final path = await exportService.saveImage(bytes, 'qr_code.png', ExportFormat.png);
/// ```
class ExportService {
  /// Captures a widget wrapped in RepaintBoundary as an image.
  ///
  /// The [repaintBoundaryKey] must be attached to a RepaintBoundary widget
  /// that wraps the content to be captured.
  ///
  /// The [options] parameter specifies the output resolution, format, and quality.
  ///
  /// Returns the image data as a [Uint8List] in the requested format.
  ///
  /// Throws [StateError] if the key is not attached to a valid RepaintBoundary.
  /// Throws [Exception] if image capture or conversion fails.
  Future<Uint8List> captureWidget(
    GlobalKey repaintBoundaryKey,
    ExportOptions options,
  ) async {
    try {
      // Get the render object from the key
      final context = repaintBoundaryKey.currentContext;
      if (context == null) {
        throw StateError('RepaintBoundary key is not attached to a widget');
      }

      final boundary = context.findRenderObject();
      if (boundary is! RenderRepaintBoundary) {
        throw StateError('Key is not attached to a RepaintBoundary widget');
      }

      // Calculate pixel ratio based on desired output size
      // The boundary's size is in logical pixels, we need to scale to physical pixels
      final pixelRatio = _calculatePixelRatio(
        boundary.size,
        options.resolution.pixelSize.toDouble(),
      );

      // Capture the widget as an image
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      
      // Convert to PNG bytes first (native format)
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }

      final pngBytes = byteData.buffer.asUint8List();

      // Dispose of the image to free memory
      image.dispose();

      // Convert to JPEG if requested
      if (options.format == ExportFormat.jpeg) {
        return _convertToJpeg(pngBytes, options.quality);
      }

      return pngBytes;
    } catch (e) {
      throw Exception('Failed to capture widget: $e');
    }
  }

  /// Saves the image bytes to the device or triggers a download on web.
  ///
  /// On mobile platforms, saves to the app's documents directory.
  /// On web platforms, triggers a browser download.
  ///
  /// Returns the file path on mobile platforms, or null on web.
  ///
  /// The [filename] should include the appropriate extension (.png or .jpg).
  Future<String?> saveImage(
    Uint8List imageBytes,
    String filename,
    ExportFormat format,
  ) async {
    try {
      return await saveImagePlatform(imageBytes, filename, format);
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  /// Generates a filename with timestamp for the exported image.
  ///
  /// Format: qr_code_YYYYMMDD_HHMMSS.ext
  ///
  /// Example: qr_code_20260129_143052.png
  String generateFilename(ExportFormat format) {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final extension = format.fileExtension;
    return 'qr_code_$timestamp.$extension';
  }

  /// Calculates the pixel ratio needed to achieve the desired output size.
  ///
  /// The [widgetSize] is in logical pixels (the size of the RepaintBoundary).
  /// The [desiredPixelSize] is the target output size in physical pixels.
  ///
  /// Returns a pixel ratio that will scale the widget to the desired size.
  double _calculatePixelRatio(Size widgetSize, double desiredPixelSize) {
    // Use the larger dimension to ensure we capture the full widget
    final largerDimension = widgetSize.width > widgetSize.height
        ? widgetSize.width
        : widgetSize.height;

    // Calculate ratio to scale to desired size
    return desiredPixelSize / largerDimension;
  }

  /// Converts PNG bytes to JPEG format with the specified quality.
  ///
  /// The [pngBytes] parameter contains the PNG image data.
  /// The [quality] parameter ranges from 0-100, where 100 is best quality.
  ///
  /// Returns the JPEG image data as a [Uint8List].
  ///
  /// Throws [Exception] if decoding or encoding fails.
  Uint8List _convertToJpeg(Uint8List pngBytes, int quality) {
    try {
      // Decode the PNG image
      final image = img.decodeImage(pngBytes);
      if (image == null) {
        throw Exception('Failed to decode PNG image');
      }

      // Encode as JPEG with the specified quality
      final jpegBytes = img.encodeJpg(image, quality: quality);
      
      return Uint8List.fromList(jpegBytes);
    } catch (e) {
      throw Exception('Failed to convert to JPEG: $e');
    }
  }
}
