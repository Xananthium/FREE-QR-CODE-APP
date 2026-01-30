import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;
import '../../models/export_options.dart';

/// Web-specific implementation for downloading images.
///
/// This file is imported when running on web platforms.
/// It triggers a browser download using blob URLs.
Future<String?> saveImagePlatform(
  Uint8List imageBytes,
  String filename,
  ExportFormat format,
) async {
  try {
    // Create a blob from the image bytes
    final blob = html.Blob([imageBytes], format.mimeType);
    
    // Create a temporary URL for the blob
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    // Create an anchor element and trigger a download
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..style.display = 'none';
    
    // Add to document, click, and remove
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    
    // Clean up the blob URL
    html.Url.revokeObjectUrl(url);
    
    // Return null for web (no file path)
    return null;
  } catch (e) {
    throw Exception('Failed to download image on web: $e');
  }
}
