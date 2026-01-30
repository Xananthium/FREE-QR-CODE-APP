# QR Display Widget

Beautiful, theme-aware QR code display widget for Flutter.

## Overview

The `QrDisplay` widget provides a production-ready QR code display component with:
- Multiple size variants (preview, thumbnail, export)
- Graceful error handling (empty/invalid data)
- Theme-aware styling (light/dark mode)
- Configurable colors and sizes
- Proper quiet zone padding for scannability
- Accessibility support

## Features

### Core Widget: `QrDisplay`

Main QR code display widget with full customization.

```dart
QrDisplay(
  data: 'https://example.com',
  size: 200,
  foregroundColor: Colors.black,
  backgroundColor: Colors.white,
)
```

**Parameters:**
- `data` (String?): Data to encode (required)
- `size` (double): QR code size in pixels (default: 200)
- `errorCorrectionLevel` (int): Error correction level (default: Medium)
- `foregroundColor` (Color?): QR pixels color (default: theme onSurface)
- `backgroundColor` (Color?): Background color (default: theme surface)
- `showContainer` (bool): Show container decoration (default: true)
- `padding` (double): Quiet zone padding (default: 20)
- `borderRadius` (double): Container corner radius (default: 16)
- `showElevation` (bool): Show shadow (default: true)

### Factory Constructors

#### Preview Size
```dart
QrDisplay.preview(
  data: 'https://example.com',
  foregroundColor: Colors.purple,
)
```
- Size: 280px
- Padding: 24px
- Border radius: 20px
- Use case: Detail/preview screens

#### Thumbnail Size
```dart
QrDisplay.thumbnail(
  data: 'https://example.com',
)
```
- Size: 120px
- Padding: 12px
- No container/elevation
- Use case: Lists, grids, small previews

#### Export Quality
```dart
QrDisplay.export(
  data: 'https://example.com',
  size: 1024,
)
```
- Size: 1024px (configurable)
- Error correction: High (30% recovery)
- 5% quiet zone
- No shadows
- Use case: High-quality exports, printing

### Variant Widgets

#### QrDisplayCard
Card layout with title, subtitle, and action buttons.

```dart
QrDisplayCard(
  data: 'https://example.com',
  title: 'Business Card',
  subtitle: 'Scan to visit',
  actions: [
    IconButton(icon: Icon(Icons.share), onPressed: () {}),
    IconButton(icon: Icon(Icons.download), onPressed: () {}),
  ],
)
```

#### QrDisplayListTile
List item with QR thumbnail.

```dart
QrDisplayListTile(
  data: 'https://example.com',
  title: 'Website URL',
  subtitle: 'Created Jan 29',
  onTap: () {},
)
```

## Error Handling

### Empty Data
Shows placeholder with icon and message:
```dart
QrDisplay(data: null)  // Shows "No data to display"
QrDisplay(data: '')    // Shows "No data to display"
```

### Invalid Data
The widget gracefully handles:
- Very long strings (1000+ characters)
- Special characters (!@#$%^&*()
- Unicode (世界 🌍)
- URLs, emails, phone numbers
- WiFi credentials
- vCards

## Best Practices

### QR Code Scannability

1. **Minimum Size**: Use at least 100px for displays
2. **Quiet Zone**: Default 20px padding ensures scannability
3. **Contrast**: High contrast between foreground/background
4. **Error Correction Levels**:
   - Low (7%): Simple data, perfect conditions
   - Medium (15%): Most use cases (default)
   - Quartile (25%): Potential damage/distortion
   - High (30%): Exports, printing, harsh conditions

### Sizing Guidelines

| Use Case | Size | Constructor |
|----------|------|-------------|
| List items | 60-80px | `thumbnail` |
| Small previews | 120px | `thumbnail` |
| Standard display | 200px | Default |
| Detail view | 280px | `preview` |
| Print/export | 1024px+ | `export` |

### Color Recommendations

**Light Mode:**
```dart
foregroundColor: Colors.black,
backgroundColor: Colors.white,
```

**Dark Mode:**
```dart
foregroundColor: Colors.white,
backgroundColor: Colors.black,
```

**Custom Branding:**
```dart
foregroundColor: AppColors.primaryLight,
backgroundColor: Colors.grey.shade50,
```

## Theme Integration

The widget automatically adapts to your app's theme:

```dart
// Uses theme's onSurface and surface colors
QrDisplay(data: 'Auto theme colors')

// Respects dark mode
// Light: black QR on white
// Dark: white QR on dark
```

## Usage Examples

### Basic Display
```dart
Center(
  child: QrDisplay(
    data: 'https://flutter.dev',
  ),
)
```

### Preview Screen
```dart
Column(
  children: [
    Text('Your QR Code'),
    SizedBox(height: 16),
    QrDisplay.preview(
      data: userData,
    ),
    SizedBox(height: 16),
    Row(
      children: [
        ElevatedButton(
          onPressed: _share,
          child: Text('Share'),
        ),
        ElevatedButton(
          onPressed: _download,
          child: Text('Download'),
        ),
      ],
    ),
  ],
)
```

### History List
```dart
ListView.builder(
  itemCount: qrCodes.length,
  itemBuilder: (context, index) {
    final qr = qrCodes[index];
    return QrDisplayListTile(
      data: qr.data,
      title: qr.title,
      subtitle: qr.createdAt,
      onTap: () => _viewDetails(qr),
    );
  },
)
```

### Export Flow
```dart
// Generate high-quality image
final qr = QrDisplay.export(
  data: userData,
  size: 2048,  // 2K resolution
);

// Wrap in RepaintBoundary for screenshot
RepaintBoundary(
  key: _screenshotKey,
  child: qr,
)
```

## Accessibility

The widget includes semantic labels:
```dart
semanticsLabel: 'QR code containing: https://example.com'
```

Screen readers will announce the QR code content, truncating long strings at 50 characters.

## Testing

Comprehensive test coverage included:
- Widget rendering
- Empty state handling
- Factory constructors
- Custom parameters
- Edge cases (long strings, special chars, unicode)
- Theme integration

Run tests:
```bash
flutter test test/widgets/qr_display_test.dart
```

## Performance

- Uses `qr_flutter` package (optimized for Flutter)
- Automatic QR version selection
- Efficient rebuilds with proper const constructors
- No unnecessary repaints

## Dependencies

```yaml
dependencies:
  qr_flutter: ^4.1.0
```

## Related Widgets

- `EmptyState`: Used for placeholder display
- `CompactEmptyState`: Used internally for empty data
- `ErrorDisplay`: For error handling in parent screens

## Examples

See `qr_display_examples.dart` for 12+ visual examples covering:
- All size variants
- Color customization
- Card layouts
- List tiles
- Theme adaptation
- Edge cases

## Migration Notes

If migrating from basic QR implementations:

**Before:**
```dart
QrImage(data: url, size: 200)
```

**After:**
```dart
QrDisplay(data: url)  // Same result, better styling
```

## Future Enhancements

Potential additions:
- Custom eye shapes (rounded, circular)
- Embedded logos/images in center
- Gradient colors
- Animation on appear
- Copy data to clipboard on long-press

## Support

For issues or questions:
1. Check the examples file
2. Review test cases for usage patterns
3. Verify qr_flutter package documentation
4. Check theme configuration

## License

Part of the Barcode App project.
