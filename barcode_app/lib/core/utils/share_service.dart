import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

/// Service for sharing QR code images via the system share sheet.
///
/// This service handles:
/// - Writing image bytes to temporary storage
/// - Triggering the native system share sheet
/// - Cross-platform sharing (iOS, Android, Web, Desktop)
/// - Tablet/desktop popover positioning
///
/// Example usage:
/// ```dart
/// final shareService = ShareService();
/// 
/// // Basic sharing
/// final result = await shareService.shareImage(
///   imageBytes,
///   'qr_code_20260129.png',
/// );
/// 
/// // Sharing with popover position (for tablets/desktop)
/// final box = context.findRenderObject() as RenderBox?;
/// final sharePosition = box!.localToGlobal(Offset.zero) & box.size;
/// 
/// final result = await shareService.shareImageWithPosition(
///   imageBytes,
///   'qr_code_20260129.png',
///   sharePosition,
/// );
/// ```
class ShareService {
  /// Shares an image via the system share sheet.
  ///
  /// The [imageBytes] parameter contains the image data (PNG or JPEG).
  /// The [filename] parameter specifies the name for the shared file.
  ///
  /// Returns a [ShareResult] indicating the outcome of the share operation:
  /// - [ShareResultStatus.success]: User successfully shared the image
  /// - [ShareResultStatus.dismissed]: User dismissed the share sheet
  /// - [ShareResultStatus.unavailable]: Sharing is not available on this platform
  ///
  /// The image is written to a temporary file before sharing, which is
  /// automatically cleaned up by the operating system.
  ///
  /// Throws [Exception] if the image cannot be written or shared.
  ///
  /// Example:
  /// ```dart
  /// final result = await shareService.shareImage(
  ///   pngBytes,
  ///   'qr_code.png',
  /// );
  /// 
  /// if (result.status == ShareResultStatus.success) {
  ///   print('Image shared successfully!');
  /// }
  /// ```
  Future<ShareResult> shareImage(
    Uint8List imageBytes,
    String filename,
  ) async {
    try {
      // Create temporary file with the image data
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(imageBytes);

      // Determine MIME type from filename extension
      final mimeType = _getMimeType(filename);

      // Share the file via system share sheet
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: mimeType)],
          text: 'QR Code generated with Barcode App',
        ),
      );

      return result;
    } catch (e) {
      throw Exception('Failed to share image: $e');
    }
  }

  /// Shares an image with specified popover position for tablets/desktop.
  ///
  /// This method is identical to [shareImage] but includes the
  /// [sharePositionOrigin] parameter for better popover positioning on
  /// tablets and desktop platforms.
  ///
  /// On phones, the [sharePositionOrigin] is ignored and the share sheet
  /// appears as a standard bottom sheet.
  ///
  /// The [sharePositionOrigin] should be the bounding box of the share button:
  /// ```dart
  /// final box = context.findRenderObject() as RenderBox?;
  /// if (box != null) {
  ///   final sharePosition = box.localToGlobal(Offset.zero) & box.size;
  ///   await shareService.shareImageWithPosition(
  ///     imageBytes,
  ///     filename,
  ///     sharePosition,
  ///   );
  /// }
  /// ```
  ///
  /// Returns a [ShareResult] indicating the outcome of the share operation.
  ///
  /// Throws [Exception] if the image cannot be written or shared.
  Future<ShareResult> shareImageWithPosition(
    Uint8List imageBytes,
    String filename,
    Rect sharePositionOrigin,
  ) async {
    try {
      // Create temporary file with the image data
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(imageBytes);

      // Determine MIME type from filename extension
      final mimeType = _getMimeType(filename);

      // Share the file via system share sheet with position
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: mimeType)],
          text: 'QR Code generated with Barcode App',
          sharePositionOrigin: sharePositionOrigin,
        ),
      );

      return result;
    } catch (e) {
      throw Exception('Failed to share image: $e');
    }
  }

  /// Determines the MIME type from the filename extension.
  ///
  /// Supports:
  /// - .png → image/png
  /// - .jpg, .jpeg → image/jpeg
  ///
  /// Defaults to image/png if extension is not recognized.
  String _getMimeType(String filename) {
    final extension = filename.toLowerCase().split('.').last;
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      default:
        return 'image/png'; // Default to PNG
    }
  }
}
