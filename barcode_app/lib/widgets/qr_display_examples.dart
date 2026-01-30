import 'package:flutter/material.dart';
import 'qr_display.dart';

/// Examples demonstrating QrDisplay widget usage
/// This file is for reference and testing purposes
class QrDisplayExamples extends StatelessWidget {
  const QrDisplayExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Display Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Example 1: Basic QR Display
          const _ExampleSection(
            title: '1. Basic QR Display',
            description: 'Default QR code with standard size',
            child: Center(
              child: QrDisplay(
                data: 'https://flutter.dev',
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Example 2: Empty State
          const _ExampleSection(
            title: '2. Empty State',
            description: 'Shows placeholder when no data is provided',
            child: Center(
              child: QrDisplay(
                data: null,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Example 3: Preview Size
          _ExampleSection(
            title: '3. Preview Size',
            description: 'Larger size for preview screens',
            child: Center(
              child: QrDisplay.preview(
                data: 'https://example.com/preview',
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Example 4: Thumbnail Size
          _ExampleSection(
            title: '4. Thumbnail Size',
            description: 'Smaller size for lists and grids',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QrDisplay.thumbnail(data: 'Item 1'),
                QrDisplay.thumbnail(data: 'Item 2'),
                QrDisplay.thumbnail(data: 'Item 3'),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Example 5: Custom Colors
          _ExampleSection(
            title: '5. Custom Colors',
            description: 'QR code with custom foreground and background',
            child: Center(
              child: QrDisplay(
                data: 'Colorful QR Code',
                foregroundColor: Colors.purple,
                backgroundColor: Colors.yellow[100],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Example 6: No Container Style
          const _ExampleSection(
            title: '6. No Container',
            description: 'QR code without container styling',
            child: Center(
              child: QrDisplay(
                data: 'Minimal Style',
                showContainer: false,
                showElevation: false,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Example 7: QR Display Card
          _ExampleSection(
            title: '7. QR Display Card',
            description: 'Card variant with title and actions',
            child: QrDisplayCard(
              data: 'https://example.com/card',
              title: 'Business Card',
              subtitle: 'Scan to visit website',
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                  tooltip: 'Share',
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {},
                  tooltip: 'Download',
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Example 8: List Tiles
          _ExampleSection(
            title: '8. List Tiles',
            description: 'QR codes in list format',
            child: Column(
              children: [
                QrDisplayListTile(
                  data: 'https://example.com/1',
                  title: 'Website URL',
                  subtitle: 'Created Jan 29, 2026',
                  onTap: () {},
                ),
                const Divider(),
                QrDisplayListTile(
                  data: 'Contact: John Doe\nPhone: 555-1234',
                  title: 'Contact Card',
                  subtitle: 'Business contact',
                  onTap: () {},
                ),
                const Divider(),
                QrDisplayListTile(
                  data: 'WiFi:T:WPA;S:MyNetwork;P:password123;;',
                  title: 'WiFi Network',
                  subtitle: 'MyNetwork',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Example 9: Different Sizes
          _ExampleSection(
            title: '9. Size Variants',
            description: 'Various QR code sizes',
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: const [
                QrDisplay(data: 'Small', size: 100),
                QrDisplay(data: 'Medium', size: 150),
                QrDisplay(data: 'Large', size: 200),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Example 10: Long Data
          const _ExampleSection(
            title: '10. Long Data String',
            description: 'Handles long text gracefully',
            child: Center(
              child: QrDisplay(
                data: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
                size: 250,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Example 11: Special Characters
          const _ExampleSection(
            title: '11. Special Characters',
            description: 'Unicode and special characters',
            child: Center(
              child: QrDisplay(
                data: 'Hello! 👋 世界 🌍 #special @chars',
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Example 12: Dark Mode Compatible
          Builder(
            builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return _ExampleSection(
                title: '12. Theme Aware',
                description: 'Automatically adapts to ${isDark ? "dark" : "light"} mode',
                child: const Center(
                  child: QrDisplay(
                    data: 'Theme-aware QR code',
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ExampleSection extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const _ExampleSection({
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}
