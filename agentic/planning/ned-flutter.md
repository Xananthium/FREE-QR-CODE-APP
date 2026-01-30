# Flutter Architecture Plan - QR Code Generator

## Overview

Single Flutter codebase targeting iOS, Android, and Web platforms. The app generates QR codes for URLs and WiFi networks with beautiful decorative borders.

---

## Project Structure

```
barcode/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── app.dart                     # MaterialApp configuration
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart      # Color palette
│   │   │   ├── app_dimensions.dart  # Spacing, sizes
│   │   │   └── app_strings.dart     # Static strings
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart       # Light/dark themes
│   │   │   └── text_styles.dart     # Typography
│   │   │
│   │   └── utils/
│   │       ├── qr_encoder.dart      # QR data encoding
│   │       ├── wifi_formatter.dart  # WiFi string builder
│   │       ├── export_service.dart  # Image export logic
│   │       └── validators.dart      # Input validation
│   │
│   ├── models/
│   │   ├── qr_type.dart             # Enum: URL, WiFi
│   │   ├── qr_data.dart             # QR content model
│   │   ├── wifi_config.dart         # WiFi settings model
│   │   ├── border_style.dart        # Border configuration
│   │   └── export_options.dart      # Export settings
│   │
│   ├── providers/
│   │   ├── qr_provider.dart         # QR state management
│   │   ├── theme_provider.dart      # Theme toggle
│   │   └── export_provider.dart     # Export state
│   │
│   ├── screens/
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── qr_type_card.dart
│   │   │       └── recent_qr_list.dart
│   │   │
│   │   ├── url_generator/
│   │   │   ├── url_generator_screen.dart
│   │   │   └── widgets/
│   │   │       └── url_input_field.dart
│   │   │
│   │   ├── wifi_generator/
│   │   │   ├── wifi_generator_screen.dart
│   │   │   └── widgets/
│   │   │       ├── ssid_input.dart
│   │   │       ├── password_input.dart
│   │   │       ├── security_selector.dart
│   │   │       └── hidden_toggle.dart
│   │   │
│   │   ├── customize/
│   │   │   ├── customize_screen.dart
│   │   │   └── widgets/
│   │   │       ├── border_gallery.dart
│   │   │       ├── color_picker_sheet.dart
│   │   │       └── live_preview.dart
│   │   │
│   │   └── export/
│   │       ├── export_screen.dart
│   │       └── widgets/
│   │           ├── resolution_picker.dart
│   │           ├── format_selector.dart
│   │           └── export_button.dart
│   │
│   ├── widgets/
│   │   ├── qr_display.dart          # QR code widget
│   │   ├── bordered_qr.dart         # QR with border applied
│   │   ├── app_scaffold.dart        # Common scaffold
│   │   ├── primary_button.dart
│   │   ├── input_field.dart
│   │   └── loading_overlay.dart
│   │
│   └── borders/
│       ├── border_registry.dart     # All borders registered
│       ├── base_border.dart         # Abstract base class
│       ├── borders/
│       │   ├── classic_border.dart
│       │   ├── ornate_border.dart
│       │   ├── minimal_border.dart
│       │   ├── floral_border.dart
│       │   ├── geometric_border.dart
│       │   ├── rounded_border.dart
│       │   ├── shadow_border.dart
│       │   ├── gradient_border.dart
│       │   ├── dotted_border.dart
│       │   └── artistic_border.dart
│       └── painters/
│           └── border_painter.dart   # CustomPainter base
│
├── assets/
│   ├── fonts/
│   │   └── (custom fonts if needed)
│   ├── images/
│   │   └── (app icons, etc.)
│   └── borders/
│       └── (SVG assets for complex borders)
│
├── test/
│   ├── unit/
│   │   ├── qr_encoder_test.dart
│   │   ├── wifi_formatter_test.dart
│   │   └── validators_test.dart
│   ├── widget/
│   │   ├── qr_display_test.dart
│   │   ├── border_test.dart
│   │   └── export_test.dart
│   └── integration/
│       └── generation_flow_test.dart
│
├── web/
│   ├── index.html
│   └── manifest.json               # PWA manifest
│
├── ios/
│   └── (standard iOS config)
│
├── android/
│   └── (standard Android config)
│
└── pubspec.yaml
```

---

## Dependencies

```yaml
name: barcode
description: Beautiful QR Code Generator with Decorative Borders
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'
  flutter: '>=3.27.0'

dependencies:
  flutter:
    sdk: flutter

  # QR Code Generation
  qr_flutter: ^4.1.0

  # State Management
  provider: ^6.1.1
  # OR
  flutter_riverpod: ^2.4.9

  # Image/Export
  screenshot: ^2.1.0
  image: ^4.1.0
  share_plus: ^7.2.0
  path_provider: ^2.1.2

  # Platform-specific
  permission_handler: ^11.1.0
  universal_html: ^2.2.4           # Web file download

  # UI Components
  flutter_colorpicker: ^1.0.3
  flutter_svg: ^2.0.9              # SVG border assets

  # Utils
  url_launcher: ^6.2.2
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  mockito: ^5.4.4
  build_runner: ^2.4.8

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/borders/

  fonts:
    - family: AppFont
      fonts:
        - asset: assets/fonts/AppFont-Regular.ttf
        - asset: assets/fonts/AppFont-Bold.ttf
          weight: 700
```

---

## Core Components

### 1. QR Encoder (`core/utils/qr_encoder.dart`)

```dart
/// Handles encoding data into QR-compatible strings
class QREncoder {
  /// Encode a URL (validate and format)
  static String encodeUrl(String url) {
    // Ensure URL has protocol
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
  }

  /// Encode WiFi credentials into MECARD format
  static String encodeWifi(WifiConfig config) {
    return WifiFormatter.format(config);
  }
}
```

### 2. WiFi Formatter (`core/utils/wifi_formatter.dart`)

```dart
/// Formats WiFi credentials into QR-scannable string
class WifiFormatter {
  /// Format: WIFI:T:<type>;S:<ssid>;P:<password>;H:<hidden>;;
  static String format(WifiConfig config) {
    final buffer = StringBuffer('WIFI:');

    // Authentication type
    buffer.write('T:${_encodeAuthType(config.securityType)};');

    // SSID (escaped)
    buffer.write('S:${_escape(config.ssid)};');

    // Password (if not open network)
    if (config.securityType != SecurityType.none && config.password.isNotEmpty) {
      buffer.write('P:${_escape(config.password)};');
    }

    // Hidden network flag
    if (config.isHidden) {
      buffer.write('H:true;');
    }

    buffer.write(';');
    return buffer.toString();
  }

  static String _encodeAuthType(SecurityType type) {
    switch (type) {
      case SecurityType.wpa:
      case SecurityType.wpa2:
      case SecurityType.wpa3:
        return 'WPA';
      case SecurityType.wep:
        return 'WEP';
      case SecurityType.none:
        return 'nopass';
    }
  }

  /// Escape special characters: \ ; , " :
  static String _escape(String value) {
    return value
        .replaceAll(r'\', r'\\')
        .replaceAll(';', r'\;')
        .replaceAll(',', r'\,')
        .replaceAll('"', r'\"')
        .replaceAll(':', r'\:');
  }
}
```

### 3. Export Service (`core/utils/export_service.dart`)

```dart
/// Handles exporting QR codes to images
class ExportService {
  /// Capture widget as image bytes
  static Future<Uint8List?> captureWidget(
    GlobalKey key, {
    double pixelRatio = 3.0,
  }) async {
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;

    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  /// Save image to device (platform-specific)
  static Future<String?> saveToDevice(Uint8List bytes, String filename) async {
    if (kIsWeb) {
      return _saveToWeb(bytes, filename);
    } else if (Platform.isIOS || Platform.isAndroid) {
      return _saveToMobile(bytes, filename);
    }
    return null;
  }

  static Future<String?> _saveToWeb(Uint8List bytes, String filename) async {
    // Use universal_html for web download
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
    return filename;
  }

  static Future<String?> _saveToMobile(Uint8List bytes, String filename) async {
    // Save to gallery on mobile
    final result = await ImageGallerySaver.saveImage(
      bytes,
      name: filename,
      quality: 100,
    );
    return result['filePath'];
  }
}
```

### 4. Border Base Class (`borders/base_border.dart`)

```dart
/// Abstract base for all decorative borders
abstract class DecorativeBorder {
  /// Unique identifier
  String get id;

  /// Display name
  String get name;

  /// Primary color
  Color primaryColor;

  /// Secondary color (for gradients, patterns)
  Color secondaryColor;

  /// Border thickness
  double thickness;

  /// Padding between border and QR code
  double padding;

  DecorativeBorder({
    this.primaryColor = Colors.black,
    this.secondaryColor = Colors.grey,
    this.thickness = 8.0,
    this.padding = 16.0,
  });

  /// Build the border widget wrapping the QR code
  Widget build(Widget qrCode);

  /// Get thumbnail preview for gallery
  Widget buildThumbnail();

  /// Create a copy with new colors
  DecorativeBorder copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    double? thickness,
    double? padding,
  });
}
```

### 5. Example Border Implementation (`borders/borders/classic_border.dart`)

```dart
/// Classic elegant frame border
class ClassicBorder extends DecorativeBorder {
  @override
  String get id => 'classic';

  @override
  String get name => 'Classic';

  ClassicBorder({
    super.primaryColor = const Color(0xFF1E3A5F),
    super.secondaryColor = const Color(0xFFFFD93D),
    super.thickness = 8.0,
    super.padding = 20.0,
  });

  @override
  Widget build(Widget qrCode) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: primaryColor,
          width: thickness,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(
            color: secondaryColor,
            width: 2,
          ),
        ),
        child: qrCode,
      ),
    );
  }

  @override
  Widget buildThumbnail() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryColor, width: 3),
      ),
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: secondaryColor, width: 1),
          ),
        ),
      ),
    );
  }

  @override
  ClassicBorder copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    double? thickness,
    double? padding,
  }) {
    return ClassicBorder(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      thickness: thickness ?? this.thickness,
      padding: padding ?? this.padding,
    );
  }
}
```

---

## State Management

Using **Provider** for simplicity (can swap to Riverpod if needed).

### QR Provider (`providers/qr_provider.dart`)

```dart
/// Manages QR code generation state
class QRProvider extends ChangeNotifier {
  QRType _type = QRType.url;
  String _data = '';
  DecorativeBorder _border = ClassicBorder();

  QRType get type => _type;
  String get data => _data;
  DecorativeBorder get border => _border;

  bool get hasValidData => _data.isNotEmpty;

  void setType(QRType type) {
    _type = type;
    _data = '';
    notifyListeners();
  }

  void setUrlData(String url) {
    _data = QREncoder.encodeUrl(url);
    notifyListeners();
  }

  void setWifiData(WifiConfig config) {
    _data = QREncoder.encodeWifi(config);
    notifyListeners();
  }

  void setBorder(DecorativeBorder border) {
    _border = border;
    notifyListeners();
  }

  void updateBorderColor(Color primary, [Color? secondary]) {
    _border = _border.copyWith(
      primaryColor: primary,
      secondaryColor: secondary,
    );
    notifyListeners();
  }

  void reset() {
    _type = QRType.url;
    _data = '';
    _border = ClassicBorder();
    notifyListeners();
  }
}
```

---

## Models

### WiFi Config (`models/wifi_config.dart`)

```dart
enum SecurityType { wpa, wpa2, wpa3, wep, none }

class WifiConfig {
  final String ssid;
  final String password;
  final SecurityType securityType;
  final bool isHidden;

  const WifiConfig({
    required this.ssid,
    this.password = '',
    this.securityType = SecurityType.wpa2,
    this.isHidden = false,
  });

  WifiConfig copyWith({
    String? ssid,
    String? password,
    SecurityType? securityType,
    bool? isHidden,
  }) {
    return WifiConfig(
      ssid: ssid ?? this.ssid,
      password: password ?? this.password,
      securityType: securityType ?? this.securityType,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}
```

### Export Options (`models/export_options.dart`)

```dart
enum ExportResolution {
  standard(512, 'Standard (512px)'),
  high(1024, 'High (1024px)'),
  ultra(2048, 'Ultra (2048px)');

  final int pixels;
  final String label;
  const ExportResolution(this.pixels, this.label);
}

enum ExportFormat {
  png('PNG', 'png'),
  jpeg('JPEG', 'jpg');

  final String label;
  final String extension;
  const ExportFormat(this.label, this.extension);
}

class ExportOptions {
  final ExportResolution resolution;
  final ExportFormat format;
  final bool transparentBackground;

  const ExportOptions({
    this.resolution = ExportResolution.high,
    this.format = ExportFormat.png,
    this.transparentBackground = false,
  });
}
```

---

## Screen Flows

### Home Screen
```
┌────────────────────────────┐
│    QR Code Generator       │
│         [Logo]             │
├────────────────────────────┤
│                            │
│   ┌──────────────────┐     │
│   │                  │     │
│   │   URL/Website    │     │
│   │                  │     │
│   └──────────────────┘     │
│                            │
│   ┌──────────────────┐     │
│   │                  │     │
│   │   WiFi Network   │     │
│   │                  │     │
│   └──────────────────┘     │
│                            │
└────────────────────────────┘
```

### URL Generator Screen
```
┌────────────────────────────┐
│  ←  URL QR Code            │
├────────────────────────────┤
│                            │
│  Enter website URL:        │
│  ┌──────────────────────┐  │
│  │ https://             │  │
│  └──────────────────────┘  │
│                            │
│  ┌────────────────────┐    │
│  │                    │    │
│  │    [QR Preview]    │    │
│  │                    │    │
│  └────────────────────┘    │
│                            │
│  ┌──────────────────────┐  │
│  │    Customize        │   │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │    Export           │   │
│  └──────────────────────┘  │
│                            │
└────────────────────────────┘
```

### WiFi Generator Screen
```
┌────────────────────────────┐
│  ←  WiFi QR Code           │
├────────────────────────────┤
│                            │
│  Network Name (SSID):      │
│  ┌──────────────────────┐  │
│  │                      │  │
│  └──────────────────────┘  │
│                            │
│  Password:                 │
│  ┌──────────────────────┐  │
│  │ ••••••••        👁️   │  │
│  └──────────────────────┘  │
│                            │
│  Security:                 │
│  [WPA/WPA2 ▼]              │
│                            │
│  [ ] Hidden Network        │
│                            │
│  ┌────────────────────┐    │
│  │    [QR Preview]    │    │
│  └────────────────────┘    │
│                            │
│  [Customize]  [Export]     │
│                            │
└────────────────────────────┘
```

### Customize Screen
```
┌────────────────────────────┐
│  ←  Customize              │
├────────────────────────────┤
│  ┌────────────────────┐    │
│  │                    │    │
│  │  [Live QR Preview] │    │
│  │   with border      │    │
│  │                    │    │
│  └────────────────────┘    │
│                            │
│  Border Style:             │
│  ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐  │
│  │  │ │  │ │  │ │  │ │  │  │
│  └──┘ └──┘ └──┘ └──┘ └──┘  │
│   ↑    ↑    ↑    ↑    ↑    │
│  ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐  │
│  │  │ │  │ │  │ │  │ │  │  │
│  └──┘ └──┘ └──┘ └──┘ └──┘  │
│                            │
│  Primary Color: [■ Pick]   │
│  Secondary Color: [■ Pick] │
│                            │
│  ┌──────────────────────┐  │
│  │       Export         │  │
│  └──────────────────────┘  │
└────────────────────────────┘
```

### Export Screen
```
┌────────────────────────────┐
│  ←  Export                 │
├────────────────────────────┤
│  ┌────────────────────┐    │
│  │                    │    │
│  │  [Final Preview]   │    │
│  │                    │    │
│  └────────────────────┘    │
│                            │
│  Resolution:               │
│  ○ Standard (512px)        │
│  ● High (1024px)           │
│  ○ Ultra (2048px)          │
│                            │
│  Format:                   │
│  ● PNG                     │
│  ○ JPEG                    │
│                            │
│  [ ] Transparent BG (PNG)  │
│                            │
│  ┌──────────────────────┐  │
│  │    Save to Device    │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │       Share          │  │
│  └──────────────────────┘  │
└────────────────────────────┘
```

---

## Platform-Specific Code

### iOS (Permissions)

`ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need access to save QR codes to your photo library.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to save QR codes to your photo library.</string>
```

### Android (Permissions)

`android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="28"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32"/>
```

### Web (PWA)

`web/manifest.json`:
```json
{
  "name": "QR Code Generator",
  "short_name": "QR Gen",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#FAFAFA",
  "theme_color": "#1E3A5F",
  "description": "Beautiful QR Code Generator with Decorative Borders",
  "orientation": "portrait",
  "prefer_related_applications": false,
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-maskable-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "maskable"
    },
    {
      "src": "icons/Icon-maskable-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable"
    }
  ]
}
```

---

## Testing Strategy

### Unit Tests

```dart
// test/unit/wifi_formatter_test.dart
void main() {
  group('WifiFormatter', () {
    test('formats basic WPA2 network', () {
      final config = WifiConfig(
        ssid: 'MyNetwork',
        password: 'password123',
        securityType: SecurityType.wpa2,
      );
      expect(
        WifiFormatter.format(config),
        'WIFI:T:WPA;S:MyNetwork;P:password123;;',
      );
    });

    test('escapes special characters in SSID', () {
      final config = WifiConfig(
        ssid: 'My;Network',
        password: 'pass',
        securityType: SecurityType.wpa,
      );
      expect(
        WifiFormatter.format(config),
        'WIFI:T:WPA;S:My\\;Network;P:pass;;',
      );
    });

    test('handles open network without password', () {
      final config = WifiConfig(
        ssid: 'FreeWiFi',
        securityType: SecurityType.none,
      );
      expect(
        WifiFormatter.format(config),
        'WIFI:T:nopass;S:FreeWiFi;;',
      );
    });

    test('includes hidden flag when true', () {
      final config = WifiConfig(
        ssid: 'Hidden',
        password: 'secret',
        isHidden: true,
      );
      expect(
        WifiFormatter.format(config),
        contains('H:true'),
      );
    });
  });
}
```

### Widget Tests

```dart
// test/widget/qr_display_test.dart
void main() {
  testWidgets('QrDisplay renders with valid data', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: QrDisplay(data: 'https://example.com'),
      ),
    );

    expect(find.byType(QrImageView), findsOneWidget);
  });

  testWidgets('BorderedQr applies border correctly', (tester) async {
    final border = ClassicBorder();

    await tester.pumpWidget(
      MaterialApp(
        home: BorderedQr(
          data: 'test',
          border: border,
        ),
      ),
    );

    // Verify border container exists
    final container = find.byType(Container);
    expect(container, findsWidgets);
  });
}
```

---

## Performance Considerations

1. **QR Generation**: Use `qr_flutter`'s `QrImageView` which efficiently renders QR codes using a custom painter.

2. **Border Rendering**: Borders use `CustomPainter` for efficient drawing without rebuilding widget tree.

3. **Export**: Use isolates for image processing on mobile to prevent UI jank during high-res exports.

4. **Web Performance**:
   - Lazy load border assets
   - Use canvas-based rendering for web export
   - Implement service worker for offline support

5. **Memory**:
   - Dispose of image data after export
   - Use `RepaintBoundary` only when capturing

---

## Accessibility

1. **Semantic Labels**: All interactive elements have semantic labels
2. **Color Contrast**: Meet WCAG AA standards
3. **Touch Targets**: Minimum 48x48dp touch targets
4. **Screen Reader**: Full VoiceOver/TalkBack support
5. **Dynamic Text**: Support system font scaling

---

## Localization (Future)

Structure ready for localization:
```
lib/l10n/
├── app_en.arb
├── app_es.arb
└── app_fr.arb
```

---

## Build Commands

```bash
# Development
flutter run                     # Run on connected device
flutter run -d chrome           # Run on web
flutter run -d ios              # Run on iOS simulator
flutter run -d android          # Run on Android emulator

# Testing
flutter test                    # Run all tests
flutter test --coverage         # Generate coverage report

# Build
flutter build ios               # iOS release
flutter build appbundle         # Android AAB
flutter build web               # Web build

# Analyze
flutter analyze                 # Static analysis
flutter format .                # Format code
```

---

## Deployment

### iOS (App Store)

1. Configure `ios/Runner.xcodeproj` with bundle ID
2. Set up App Store Connect
3. Run `flutter build ipa`
4. Upload via Xcode or Transporter

### Android (Play Store)

1. Configure `android/app/build.gradle` with package name
2. Create signing key
3. Run `flutter build appbundle`
4. Upload to Play Console

### Web (Static Hosting)

1. Run `flutter build web`
2. Deploy `build/web/` to:
   - Firebase Hosting
   - Vercel
   - Netlify
   - GitHub Pages
   - Any static host

---

## Document History

| Date | Version | Changes |
|------|---------|---------|
| 2026-01-29 | 1.0 | Initial architecture document |
