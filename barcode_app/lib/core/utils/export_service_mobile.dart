import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import '../../models/export_options.dart';

/// Mobile-specific implementation for saving images.
///
/// This file is imported when running on mobile platforms (iOS/Android).
/// Saves images to the user's photo gallery using the `gal` package.
Future<String?> saveImagePlatform(
  Uint8List imageBytes,
  String filename,
  ExportFormat format,
) async {
  try {
    // First save to a temporary file (required by gal package)
    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/$filename';
    final tempFile = File(tempFilePath);
    await tempFile.writeAsBytes(imageBytes);

    // Save to photo gallery using gal package
    // This makes it visible in the Photos/Gallery app
    await Gal.putImage(tempFilePath);

    // Clean up temp file
    await tempFile.delete();

    // Return success message instead of path (gallery doesn't expose paths)
    return 'Saved to Photos';
  } catch (e) {
    throw Exception('Failed to save image to gallery: $e');
  }
}
