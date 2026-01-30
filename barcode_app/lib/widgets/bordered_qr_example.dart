import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../borders/border_registry.dart';
import 'bordered_qr.dart';

/// Example screen demonstrating BorderedQr widget usage.
/// 
/// This file shows practical examples of how to use the BorderedQr widget
/// in various scenarios including preview, export, and selection.
class BorderedQrExampleScreen extends StatefulWidget {
  const BorderedQrExampleScreen({super.key});

  @override
  State<BorderedQrExampleScreen> createState() => _BorderedQrExampleScreenState();
}

class _BorderedQrExampleScreenState extends State<BorderedQrExampleScreen> {
  // Sample data for QR codes
  final String _sampleUrl = 'https://example.com';
  
  // Selected border for customization
  BorderType _selectedBorderType = BorderType.classic;
  Color _borderColor = Colors.black;
  
  // Capture key for export functionality
  final GlobalKey _captureKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bordered QR Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Example 1: Basic Usage
            _buildSectionHeader('Basic Usage', theme),
            _buildBasicExample(),
            const SizedBox(height: 32),
            
            // Example 2: Preview Mode
            _buildSectionHeader('Preview Mode', theme),
            _buildPreviewExample(),
            const SizedBox(height: 32),
            
            // Example 3: Export Mode
            _buildSectionHeader('Export Mode (with Capture)', theme),
            _buildExportExample(),
            const SizedBox(height: 32),
            
            // Example 4: Border Selection Gallery
            _buildSectionHeader('Border Selection Gallery', theme),
            _buildGalleryExample(),
            const SizedBox(height: 32),
            
            // Example 5: Card Variant
            _buildSectionHeader('Card Variant', theme),
            _buildCardExample(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Example 1: Basic usage with default settings
  Widget _buildBasicExample() {
    return Center(
      child: BorderedQr(
        data: _sampleUrl,
        border: BorderRegistry.defaultBorder,
      ),
    );
  }

  /// Example 2: Preview mode with larger size
  Widget _buildPreviewExample() {
    final border = BorderRegistry.getBorder(
      BorderType.floral,
      color: Colors.purple,
    );
    
    return Center(
      child: BorderedQr.preview(
        data: _sampleUrl,
        border: border,
      ),
    );
  }

  /// Example 3: Export mode with capture capability
  Widget _buildExportExample() {
    final border = BorderRegistry.getBorder(
      _selectedBorderType,
      color: _borderColor,
    );
    
    return Column(
      children: [
        // The bordered QR with capture key
        Center(
          child: BorderedQr.forExport(
            data: _sampleUrl,
            border: border,
            captureKey: _captureKey,
            qrSize: 300,
          ),
        ),
        const SizedBox(height: 16),
        
        // Export button
        ElevatedButton.icon(
          icon: const Icon(Icons.download),
          label: const Text('Export as Image'),
          onPressed: _exportImage,
        ),
      ],
    );
  }

  /// Example 4: Gallery for border selection
  Widget _buildGalleryExample() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: BorderType.values.length,
      itemBuilder: (context, index) {
        final borderType = BorderType.values[index];
        final border = BorderRegistry.getBorder(borderType);
        
        return BorderedQrGalleryItem(
          data: 'SAMPLE',
          border: border,
          isSelected: _selectedBorderType == borderType,
          onTap: () {
            setState(() {
              _selectedBorderType = borderType;
            });
          },
        );
      },
    );
  }

  /// Example 5: Card variant with actions
  Widget _buildCardExample() {
    final border = BorderRegistry.getBorder(
      BorderType.rounded,
      color: Colors.blue,
    );
    
    return BorderedQrCard(
      data: _sampleUrl,
      border: border,
      title: 'My Website',
      subtitle: 'Scan to visit',
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: 'Share',
          onPressed: () {
            // Share functionality
            _showSnackBar('Share functionality would go here');
          },
        ),
        IconButton(
          icon: const Icon(Icons.download),
          tooltip: 'Download',
          onPressed: () {
            // Download functionality
            _showSnackBar('Download functionality would go here');
          },
        ),
      ],
    );
  }

  /// Export the bordered QR as an image
  Future<void> _exportImage() async {
    try {
      // Get the RenderRepaintBoundary from the key
      final boundary = _captureKey.currentContext?.findRenderObject() 
          as RenderRepaintBoundary?;
      
      if (boundary == null) {
        _showSnackBar('Unable to capture image');
        return;
      }

      // Capture the widget as an image
      final image = await boundary.toImage(pixelRatio: 3.0);
      
      // Convert to byte data (PNG format)
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      
      if (byteData == null) {
        _showSnackBar('Failed to convert image');
        return;
      }

      // In a real app, you would save or share the image here
      // For this example, just show success
      _showSnackBar('Image captured! ${image.width}x${image.height}px');
      
      // Example: Save to device or share
      // final pngBytes = byteData.buffer.asUint8List();
      // await saveImageToDevice(pngBytes);
      
    } catch (e) {
      _showSnackBar('Error capturing image: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// Standalone example function showing minimal usage
void exampleMinimalUsage() {
  // Most basic usage
  const basic = BorderedQr(
    data: 'https://example.com',
    border: null, // Will use defaultBorder
  );

  // With specific border type
  final withType = BorderedQr.withType(
    data: 'https://example.com',
    borderType: BorderType.floral,
    borderColor: Colors.purple,
  );

  // For export
  final captureKey = GlobalKey();
  final forExport = BorderedQr.forExport(
    data: 'https://example.com',
    border: BorderRegistry.getBorder(BorderType.classic),
    captureKey: captureKey,
  );
}

/// Example of programmatic image capture
Future<ui.Image?> captureWidgetAsImage(GlobalKey key) async {
  try {
    final boundary = key.currentContext?.findRenderObject() 
        as RenderRepaintBoundary?;
    
    if (boundary == null) return null;
    
    return await boundary.toImage(pixelRatio: 3.0);
  } catch (e) {
    debugPrint('Error capturing image: $e');
    return null;
  }
}
