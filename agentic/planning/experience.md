# QR Code Generator App - Requirements & Experience Document

## Project Overview

Build a beautiful, free QR code generator app with decorative borders supporting iOS, Android, and Web platforms from a single codebase.

---

## User Requirements

### Core Features

1. **QR Code Generation**
   - Website/URL encoding
   - WiFi network encoding (SSID, password, encryption type)

2. **Visual Customization**
   - Multiple decorative borders/frames
   - Beautiful, polished UI design
   - Custom styling options

3. **Export Capabilities**
   - High resolution output
   - PNG format (primary)
   - Additional formats as needed (SVG, JPEG)

4. **Pricing**
   - Completely free
   - No ads
   - No in-app purchases

5. **Platform Support**
   - iOS (App Store)
   - Android (Play Store)
   - Web (browser-based)

---

## Framework Research & Decision

### Flutter vs React Native Comparison (2026)

| Criteria | Flutter | React Native |
|----------|---------|--------------|
| **Market Share** | 46% | 35% |
| **GitHub Stars** | 170k | 121k |
| **Web Support** | Native (built-in) | Via react-native-web library |
| **Code Reuse** | ~98% across all platforms | 80-95% (iOS/Android), needs web library |
| **Performance** | AOT compiled to native ARM | JSI bridge, ~10% slower for animations |
| **Rendering** | Impeller engine (60/120 FPS) | Native components |
| **QR Libraries** | Excellent (qr_flutter, custom-qr-generator) | Good (react-native-qrcode-svg) |
| **Custom UI** | Superior (everything is a widget) | Good (native components) |

### Framework Decision: **FLUTTER**

**Reasons:**

1. **True Web Support**: Flutter has first-class web support built into the framework. React Native requires the separate `react-native-web` library with some limitations.

2. **Superior Custom UI**: Flutter's widget-based architecture is perfect for creating decorative QR code borders and custom frames. Everything renders through a single canvas-like system.

3. **Single Codebase Reality**: Flutter achieves ~98% code sharing across iOS, Android, AND Web. React Native typically achieves 70-90% with platform-specific code often needed.

4. **QR Code Libraries**: Flutter has excellent QR generation libraries:
   - `qr_flutter` (4.1.0) - Most popular, highly customizable
   - `custom-qr-generator` - Advanced styling with gradients, custom shapes
   - `pretty_qr_code` - Elegant, easy to use

5. **High-Resolution Export**: Flutter's `RepaintBoundary` + `toImage()` makes high-res PNG export straightforward.

6. **Performance**: Impeller rendering engine delivers consistent 60/120 FPS, ideal for smooth animations when generating/previewing QR codes.

7. **Single Team**: One Flutter developer can target all three platforms effectively.

---

## WiFi QR Code Standard

WiFi QR codes follow the MECARD-like format (originated from ZXing project, 2010):

```
WIFI:T:<encryption>;S:<ssid>;P:<password>;H:<hidden>;;
```

### Fields

| Field | Description | Values |
|-------|-------------|--------|
| `T:` | Authentication type (required) | WPA, WPA2, WPA3, WEP, nopass |
| `S:` | Network name/SSID (required) | UTF-8 string |
| `P:` | Password (optional for open) | UTF-8 string |
| `H:` | Hidden network (optional) | true, false |

### Special Character Escaping

Characters with special meaning must be escaped with backslash:
- Semicolons: `Coffee;Shop` -> `Coffee\;Shop`
- Colons, backslashes, and quotes also need escaping

### Examples

**WPA2 Network:**
```
WIFI:T:WPA;S:MyNetwork;P:mypassword123;;
```

**Hidden WPA3 Network:**
```
WIFI:T:WPA;S:SecretNetwork;P:strongpass;H:true;;
```

**Open Network (no password):**
```
WIFI:T:nopass;S:FreeWiFi;;
```

---

## Technical Architecture

### Platform: Flutter

**Minimum Versions:**
- Flutter SDK: 3.27+ (Impeller stable)
- Dart: 3.2+
- iOS: 12.0+
- Android: API 21+ (Android 5.0)
- Web: Modern browsers (Chrome, Safari, Firefox, Edge)

### Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # QR Code Generation
  qr_flutter: ^4.1.0              # Primary QR generation
  # OR
  pretty_qr_code: ^3.0.0          # Alternative with built-in styling

  # Image Export
  screenshot: ^2.1.0              # Widget to image capture
  image_gallery_saver: ^2.0.3     # Save to device gallery
  share_plus: ^7.0.0              # Share functionality
  path_provider: ^2.1.0           # File system access

  # UI/UX
  flutter_colorpicker: ^1.0.3     # Color selection

  # Platform-specific
  permission_handler: ^11.0.0     # Handle permissions
  url_launcher: ^6.2.0            # Open URLs
```

### App Structure

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── colors.dart
│   │   └── dimensions.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       ├── qr_generator.dart
│       ├── wifi_formatter.dart
│       └── export_helper.dart
│
├── features/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │
│   ├── url_qr/
│   │   ├── url_qr_screen.dart
│   │   └── widgets/
│   │
│   ├── wifi_qr/
│   │   ├── wifi_qr_screen.dart
│   │   └── widgets/
│   │
│   ├── customize/
│   │   ├── customize_screen.dart
│   │   └── widgets/
│   │       ├── border_picker.dart
│   │       ├── color_picker.dart
│   │       └── preview_card.dart
│   │
│   └── export/
│       ├── export_screen.dart
│       └── widgets/
│
├── models/
│   ├── qr_data.dart
│   ├── border_style.dart
│   └── wifi_config.dart
│
├── widgets/
│   ├── qr_preview.dart
│   ├── decorative_border.dart
│   ├── input_field.dart
│   └── action_button.dart
│
└── borders/
    ├── border_base.dart
    ├── classic_border.dart
    ├── ornate_border.dart
    ├── minimal_border.dart
    ├── floral_border.dart
    └── geometric_border.dart
```

---

## Decorative Border System

### Border Types to Implement

1. **Classic** - Simple elegant frame with corners
2. **Ornate** - Victorian/decorative scroll patterns
3. **Minimal** - Clean thin lines, modern look
4. **Floral** - Nature-inspired with leaf/flower elements
5. **Geometric** - Patterns, triangles, hexagons
6. **Rounded** - Soft, rounded corners and edges
7. **Shadow** - 3D effect with drop shadows
8. **Gradient** - Color gradient frames
9. **Dotted** - Dotted line borders
10. **Artistic** - Hand-drawn, sketchy style

### Border Implementation Approach

```dart
abstract class DecorativeBorder {
  final Color primaryColor;
  final Color secondaryColor;
  final double thickness;
  final double padding;

  Widget build(Widget qrCode);

  // For export
  Future<Uint8List> renderToImage(Widget qrCode, double resolution);
}
```

Each border is a `CustomPainter` that draws around the QR code widget, allowing for:
- Vector-based rendering (sharp at any resolution)
- Color customization
- Size adaptation
- Animation support

---

## Export System

### Resolution Options

| Quality | Size | Use Case |
|---------|------|----------|
| Standard | 512x512 | Social media, quick sharing |
| High | 1024x1024 | Print, professional use |
| Ultra | 2048x2048 | Large format printing |
| Custom | User-defined | Specific requirements |

### Export Formats

1. **PNG** (Primary)
   - Transparent background option
   - High quality compression
   - Universal compatibility

2. **JPEG** (Secondary)
   - Smaller file size
   - White background
   - Good for email/messaging

3. **SVG** (Future consideration)
   - Vector format
   - Infinite scalability
   - Requires additional implementation

### Export Flow

```
User taps Export
    ↓
Select Resolution
    ↓
Select Format
    ↓
RepaintBoundary captures widget at specified DPI
    ↓
Platform-specific save:
  - iOS: Photos app / Files
  - Android: Gallery / Downloads
  - Web: Browser download
    ↓
Optional: Share sheet
```

---

## UI/UX Design Principles

### Visual Style

- **Clean & Modern**: Minimal clutter, focus on the QR code
- **Beautiful Borders**: The key differentiator - stunning decorative frames
- **Intuitive Flow**: Generate -> Customize -> Export in 3 simple steps
- **Dark Mode Support**: Full dark/light theme support
- **Responsive**: Adapts to all screen sizes (phone, tablet, web)

### Color Palette

```
Primary: Deep Blue (#1E3A5F)
Secondary: Coral (#FF6B6B)
Accent: Gold (#FFD93D)
Background Light: Off-White (#FAFAFA)
Background Dark: Charcoal (#1A1A2E)
```

### Typography

- Headers: SF Pro Display / Roboto (system fonts)
- Body: SF Pro Text / Roboto
- Monospace (for data): JetBrains Mono / Fira Code

---

## User Flows

### Flow 1: URL QR Code

```
1. Open App
2. Tap "URL/Website"
3. Enter URL
4. Preview QR code (default border)
5. Tap "Customize"
6. Select decorative border
7. Adjust colors (optional)
8. Tap "Export"
9. Choose resolution/format
10. Save to device
```

### Flow 2: WiFi QR Code

```
1. Open App
2. Tap "WiFi Network"
3. Enter:
   - Network Name (SSID)
   - Password
   - Security Type (WPA/WPA2/WPA3/WEP/None)
   - Hidden Network toggle
4. Preview QR code
5. Customize border
6. Export
```

---

## Platform-Specific Considerations

### iOS

- Request photo library permission for saving
- Support iOS sharing extensions
- Follow Human Interface Guidelines
- App Store metadata and screenshots

### Android

- Handle storage permissions (scoped storage)
- Support Android sharing
- Follow Material Design 3
- Play Store listing

### Web

- Progressive Web App (PWA) capable
- Browser download API for export
- Responsive design (mobile-first)
- SEO considerations for landing page

---

## Testing Strategy

### Unit Tests

- QR data encoding (URL, WiFi)
- WiFi string formatting
- Export image generation

### Widget Tests

- Border rendering
- Input validation
- Preview updates

### Integration Tests

- Full generation flow
- Export functionality
- Platform-specific behaviors

### Manual Testing

- Visual inspection of borders
- QR code scannability at all resolutions
- Cross-platform consistency

---

## Success Metrics

1. **Scannability**: 100% of generated QR codes must scan correctly
2. **Export Quality**: High-res exports render crisp at intended sizes
3. **Performance**: QR generation < 100ms, export < 2s
4. **User Satisfaction**: Beautiful borders that users want to share
5. **Platform Parity**: Identical experience across iOS, Android, Web

---

## Future Enhancements (Post-MVP)

1. **Additional QR Types**
   - Contact cards (vCard)
   - Calendar events
   - Phone numbers
   - SMS messages
   - Email addresses
   - App store links

2. **Advanced Customization**
   - Logo embedding in QR center
   - Custom color gradients
   - Pattern fills

3. **History & Favorites**
   - Save generated QR codes
   - Quick re-generation

4. **Analytics Dashboard** (Web only)
   - Track QR scans (with user consent)

---

## Research Sources

### Framework Comparison
- [Flutter vs React Native 2026 - TechAhead](https://www.techaheadcorp.com/blog/flutter-vs-react-native-in-2026-the-ultimate-showdown-for-app-development-dominance/)
- [React Native vs Flutter - MobiLoud](https://www.mobiloud.com/blog/react-native-vs-flutter)
- [Flutter vs React Native Guide - Luciq](https://www.luciq.ai/blog/flutter-vs-react-native-guide)
- [Why Flutter Outperforms - Foresight Mobile](https://foresightmobile.com/blog/why-flutter-will-outperform-the-competition-in-2026)

### Flutter QR Libraries
- [qr_flutter - GitHub](https://github.com/theyakka/qr.flutter)
- [custom-qr-generator - GitHub](https://github.com/alexzhirkevich/custom-qr-generator-flutter)
- [pretty_qr_code - pub.dev](https://pub.dev/packages/pretty_qr_code)
- [Flutter QR Code Packages - Flutter Gems](https://fluttergems.dev/qr-code-bar-code/)

### WiFi QR Standard
- [WiFi QR Code Format - Technical Documentation](https://datalogic.github.io/wifiqrdoc/overview/)
- [WiFi QR Code Format Explained](https://wifiqrcode.app/guides/qr-code-format-technical)

### QR Design Best Practices
- [QR Code Frame Design - Scanova](https://scanova.io/features/qr-code-frame/)
- [QR Code Design Ideas - QR Code Generator](https://www.qr-code-generator.com/blog/qr-code-design-ideas/)
- [How to Add QR Code Border - Uniqode](https://www.uniqode.com/blog/qr-code-customization/how-to-add-a-qr-code-border)

---

## Document History

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| 2026-01-29 | 1.0 | Planning Phase | Initial requirements document |
