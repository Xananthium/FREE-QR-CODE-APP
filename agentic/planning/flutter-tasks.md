# Flutter Tasks - QR Code Generator

## Overview

This document contains all implementation tasks for the QR Code Generator Flutter app, organized by feature area with dependencies clearly marked.

---

## Task Numbering Convention

- **FLUTTER 1.x** - Project Setup & Core Infrastructure
- **FLUTTER 2.x** - Models & Data Layer
- **FLUTTER 3.x** - QR Code Generation Core
- **FLUTTER 4.x** - Decorative Borders System
- **FLUTTER 5.x** - URL QR Feature
- **FLUTTER 6.x** - WiFi QR Feature
- **FLUTTER 7.x** - Customization Screen
- **FLUTTER 8.x** - Export System
- **FLUTTER 9.x** - UI/UX Polish
- **FLUTTER 10.x** - Testing
- **FLUTTER 11.x** - Platform Configuration & Deployment

---

## FLUTTER 1: Project Setup & Core Infrastructure

### FLUTTER 1.1: Initialize Flutter Project
**Dependencies**: None
**Description**: Create new Flutter project with proper structure
**Acceptance Criteria**:
- Run `flutter create barcode_app`
- Configure `pubspec.yaml` with all dependencies
- Set up folder structure as per architecture doc
- Verify builds on iOS, Android, and Web
**Files**:
- `pubspec.yaml`
- `lib/main.dart`
- `lib/app.dart`

### FLUTTER 1.2: Configure App Theme
**Dependencies**: FLUTTER 1.1
**Description**: Set up light and dark themes with color palette
**Acceptance Criteria**:
- Create `app_theme.dart` with light/dark ThemeData
- Define color constants in `app_colors.dart`
- Define text styles in `text_styles.dart`
- App responds to system theme changes
**Files**:
- `lib/core/theme/app_theme.dart`
- `lib/core/constants/app_colors.dart`
- `lib/core/theme/text_styles.dart`

### FLUTTER 1.3: Set Up State Management
**Dependencies**: FLUTTER 1.1
**Description**: Configure Provider for state management
**Acceptance Criteria**:
- Add Provider to `main.dart` with MultiProvider
- Create placeholder providers (QRProvider, ThemeProvider)
- Verify state flows through app correctly
**Files**:
- `lib/main.dart`
- `lib/providers/qr_provider.dart`
- `lib/providers/theme_provider.dart`

### FLUTTER 1.4: Create Common Widgets
**Dependencies**: FLUTTER 1.2
**Description**: Build reusable UI components
**Acceptance Criteria**:
- Create `PrimaryButton` widget with loading state
- Create `InputField` widget with validation display
- Create `AppScaffold` with common app bar
- Create `LoadingOverlay` widget
**Files**:
- `lib/widgets/primary_button.dart`
- `lib/widgets/input_field.dart`
- `lib/widgets/app_scaffold.dart`
- `lib/widgets/loading_overlay.dart`

### FLUTTER 1.5: Configure Navigation
**Dependencies**: FLUTTER 1.1
**Description**: Set up app navigation structure
**Acceptance Criteria**:
- Create route constants
- Set up Navigator 2.0 or GoRouter
- Define all screen routes
- Implement navigation helpers
**Files**:
- `lib/core/navigation/routes.dart`
- `lib/core/navigation/app_router.dart`

---

## FLUTTER 2: Models & Data Layer

### FLUTTER 2.1: Create QR Data Models
**Dependencies**: FLUTTER 1.1
**Description**: Define data models for QR content
**Acceptance Criteria**:
- Create `QRType` enum (url, wifi)
- Create `QRData` model class
- Implement `copyWith`, `toJson`, `fromJson`
**Files**:
- `lib/models/qr_type.dart`
- `lib/models/qr_data.dart`

### FLUTTER 2.2: Create WiFi Config Model
**Dependencies**: FLUTTER 2.1
**Description**: Define WiFi configuration model
**Acceptance Criteria**:
- Create `SecurityType` enum (wpa, wpa2, wpa3, wep, none)
- Create `WifiConfig` model with all fields
- Implement validation methods
- Implement `copyWith`
**Files**:
- `lib/models/wifi_config.dart`

### FLUTTER 2.3: Create Border Style Model
**Dependencies**: FLUTTER 2.1
**Description**: Define border configuration model
**Acceptance Criteria**:
- Create `BorderStyle` model
- Include color, thickness, padding properties
- Support serialization for persistence
**Files**:
- `lib/models/border_style.dart`

### FLUTTER 2.4: Create Export Options Model
**Dependencies**: FLUTTER 2.1
**Description**: Define export settings model
**Acceptance Criteria**:
- Create `ExportResolution` enum with pixel sizes
- Create `ExportFormat` enum (png, jpeg)
- Create `ExportOptions` model class
**Files**:
- `lib/models/export_options.dart`

---

## FLUTTER 3: QR Code Generation Core

### FLUTTER 3.1: Implement URL Encoder
**Dependencies**: FLUTTER 2.1
**Description**: Create URL validation and encoding
**Acceptance Criteria**:
- Validate URL format
- Auto-add https:// if missing
- Handle special characters
- Return encoded string
**Files**:
- `lib/core/utils/qr_encoder.dart`

### FLUTTER 3.2: Implement WiFi Formatter
**Dependencies**: FLUTTER 2.2
**Description**: Create WiFi QR string formatter
**Acceptance Criteria**:
- Format WiFi config to MECARD string
- Handle all security types (WPA/WPA2/WPA3/WEP/none)
- Escape special characters correctly
- Handle hidden network flag
- Unit tests pass for all cases
**Files**:
- `lib/core/utils/wifi_formatter.dart`

### FLUTTER 3.3: Create QR Display Widget
**Dependencies**: FLUTTER 3.1, FLUTTER 3.2
**Description**: Build core QR code display widget
**Acceptance Criteria**:
- Use `qr_flutter` package
- Accept data string as input
- Configurable size
- Handle empty/invalid data gracefully
- Show placeholder when no data
**Files**:
- `lib/widgets/qr_display.dart`

### FLUTTER 3.4: Implement QR Provider
**Dependencies**: FLUTTER 3.3, FLUTTER 1.3
**Description**: Complete state management for QR generation
**Acceptance Criteria**:
- Manage QR type selection
- Store current QR data
- Store current border selection
- Provide methods to update all state
- Notify listeners on changes
**Files**:
- `lib/providers/qr_provider.dart`

---

## FLUTTER 4: Decorative Borders System

### FLUTTER 4.1: Create Border Base Class
**Dependencies**: FLUTTER 2.3
**Description**: Define abstract border interface
**Acceptance Criteria**:
- Define `DecorativeBorder` abstract class
- Include all required properties
- Define `build()` method signature
- Define `buildThumbnail()` method
- Define `copyWith()` pattern
**Files**:
- `lib/borders/base_border.dart`

### FLUTTER 4.2: Implement Classic Border
**Dependencies**: FLUTTER 4.1
**Description**: Create elegant double-frame border
**Acceptance Criteria**:
- Implement `DecorativeBorder`
- Double-line frame design
- Customizable colors
- Clean corners
- Thumbnail preview
**Files**:
- `lib/borders/borders/classic_border.dart`

### FLUTTER 4.3: Implement Minimal Border
**Dependencies**: FLUTTER 4.1
**Description**: Create thin, modern border
**Acceptance Criteria**:
- Single thin line frame
- Large padding
- Modern aesthetic
- Works well in dark mode
**Files**:
- `lib/borders/borders/minimal_border.dart`

### FLUTTER 4.4: Implement Rounded Border
**Dependencies**: FLUTTER 4.1
**Description**: Create soft rounded corner border
**Acceptance Criteria**:
- Rounded corners on frame
- Configurable corner radius
- Subtle shadow option
**Files**:
- `lib/borders/borders/rounded_border.dart`

### FLUTTER 4.5: Implement Ornate Border
**Dependencies**: FLUTTER 4.1
**Description**: Create decorative Victorian-style border
**Acceptance Criteria**:
- Custom painter for scroll patterns
- Corner flourishes
- Multiple color support
**Files**:
- `lib/borders/borders/ornate_border.dart`
- `lib/borders/painters/ornate_painter.dart`

### FLUTTER 4.6: Implement Geometric Border
**Dependencies**: FLUTTER 4.1
**Description**: Create pattern-based geometric border
**Acceptance Criteria**:
- Repeating geometric pattern
- Triangle or hexagon motifs
- Clean mathematical design
**Files**:
- `lib/borders/borders/geometric_border.dart`
- `lib/borders/painters/geometric_painter.dart`

### FLUTTER 4.7: Implement Gradient Border
**Dependencies**: FLUTTER 4.1
**Description**: Create gradient color border
**Acceptance Criteria**:
- Linear gradient support
- Start and end colors
- Configurable direction
**Files**:
- `lib/borders/borders/gradient_border.dart`

### FLUTTER 4.8: Implement Shadow Border
**Dependencies**: FLUTTER 4.1
**Description**: Create 3D shadow effect border
**Acceptance Criteria**:
- Drop shadow effect
- Elevated card appearance
- Configurable shadow intensity
**Files**:
- `lib/borders/borders/shadow_border.dart`

### FLUTTER 4.9: Implement Dotted Border
**Dependencies**: FLUTTER 4.1
**Description**: Create dotted line border
**Acceptance Criteria**:
- Configurable dot spacing
- Rounded dots
- Clean corners
**Files**:
- `lib/borders/borders/dotted_border.dart`

### FLUTTER 4.10: Implement Floral Border
**Dependencies**: FLUTTER 4.1
**Description**: Create nature-inspired decorative border
**Acceptance Criteria**:
- Leaf or vine patterns
- Corner decorations
- Natural, organic feel
**Files**:
- `lib/borders/borders/floral_border.dart`
- `lib/borders/painters/floral_painter.dart`

### FLUTTER 4.11: Create Border Registry
**Dependencies**: FLUTTER 4.2 through FLUTTER 4.10
**Description**: Register all borders for easy access
**Acceptance Criteria**:
- List all available borders
- Factory method to get border by ID
- Default border selection
**Files**:
- `lib/borders/border_registry.dart`

### FLUTTER 4.12: Create Bordered QR Widget
**Dependencies**: FLUTTER 4.11, FLUTTER 3.3
**Description**: Composite widget combining QR and border
**Acceptance Criteria**:
- Accept QR data and border
- Render QR inside selected border
- Support RepaintBoundary for export
- GlobalKey for capture
**Files**:
- `lib/widgets/bordered_qr.dart`

---

## FLUTTER 5: URL QR Feature

### FLUTTER 5.1: Create Home Screen
**Dependencies**: FLUTTER 1.4, FLUTTER 1.5
**Description**: Build main landing screen
**Acceptance Criteria**:
- App logo/branding
- Two cards: URL and WiFi
- Tap navigates to respective generator
- Clean, beautiful design
**Files**:
- `lib/screens/home/home_screen.dart`
- `lib/screens/home/widgets/qr_type_card.dart`

### FLUTTER 5.2: Create URL Input Widget
**Dependencies**: FLUTTER 1.4
**Description**: Build URL input field
**Acceptance Criteria**:
- Text field with URL keyboard
- Paste button
- Real-time validation
- Clear button
**Files**:
- `lib/screens/url_generator/widgets/url_input_field.dart`

### FLUTTER 5.3: Create URL Generator Screen
**Dependencies**: FLUTTER 5.2, FLUTTER 3.3, FLUTTER 3.4
**Description**: Build complete URL QR generation screen
**Acceptance Criteria**:
- URL input at top
- Live QR preview below
- Customize button (navigates to customize)
- Export button (navigates to export)
- QR updates as user types
**Files**:
- `lib/screens/url_generator/url_generator_screen.dart`

---

## FLUTTER 6: WiFi QR Feature

### FLUTTER 6.1: Create SSID Input Widget
**Dependencies**: FLUTTER 1.4
**Description**: Build network name input
**Acceptance Criteria**:
- Text field for SSID
- Required field validation
- Max length handling
**Files**:
- `lib/screens/wifi_generator/widgets/ssid_input.dart`

### FLUTTER 6.2: Create Password Input Widget
**Dependencies**: FLUTTER 1.4
**Description**: Build password input with toggle
**Acceptance Criteria**:
- Obscured text field
- Toggle visibility button
- Optional (disabled for open networks)
**Files**:
- `lib/screens/wifi_generator/widgets/password_input.dart`

### FLUTTER 6.3: Create Security Selector Widget
**Dependencies**: FLUTTER 2.2
**Description**: Build security type dropdown
**Acceptance Criteria**:
- Dropdown with all security types
- Labels: WPA/WPA2, WPA3, WEP, None
- Default to WPA/WPA2
**Files**:
- `lib/screens/wifi_generator/widgets/security_selector.dart`

### FLUTTER 6.4: Create Hidden Network Toggle
**Dependencies**: FLUTTER 1.4
**Description**: Build hidden network switch
**Acceptance Criteria**:
- Switch/checkbox for hidden
- Label explaining purpose
**Files**:
- `lib/screens/wifi_generator/widgets/hidden_toggle.dart`

### FLUTTER 6.5: Create WiFi Generator Screen
**Dependencies**: FLUTTER 6.1 through FLUTTER 6.4, FLUTTER 3.3, FLUTTER 3.4
**Description**: Build complete WiFi QR generation screen
**Acceptance Criteria**:
- All WiFi inputs
- Live QR preview
- Enable/disable password based on security
- Customize and Export buttons
- Form validation before proceeding
**Files**:
- `lib/screens/wifi_generator/wifi_generator_screen.dart`

---

## FLUTTER 7: Customization Screen

### FLUTTER 7.1: Create Border Gallery Widget
**Dependencies**: FLUTTER 4.11
**Description**: Build horizontal border picker
**Acceptance Criteria**:
- Grid/horizontal list of border thumbnails
- Selected state indication
- Tap to select
- Smooth scrolling
**Files**:
- `lib/screens/customize/widgets/border_gallery.dart`

### FLUTTER 7.2: Create Color Picker Sheet
**Dependencies**: FLUTTER 1.4
**Description**: Build color selection bottom sheet
**Acceptance Criteria**:
- Use flutter_colorpicker
- Primary and secondary color selection
- Preset color options
- Custom color picker
- Apply button
**Files**:
- `lib/screens/customize/widgets/color_picker_sheet.dart`

### FLUTTER 7.3: Create Live Preview Widget
**Dependencies**: FLUTTER 4.12
**Description**: Build real-time preview of customizations
**Acceptance Criteria**:
- Large QR display with current border
- Updates immediately on changes
- Proper aspect ratio
**Files**:
- `lib/screens/customize/widgets/live_preview.dart`

### FLUTTER 7.4: Create Customize Screen
**Dependencies**: FLUTTER 7.1 through FLUTTER 7.3
**Description**: Build complete customization screen
**Acceptance Criteria**:
- Live preview at top
- Border gallery below
- Color customization section
- Export button
- All changes update preview in real-time
**Files**:
- `lib/screens/customize/customize_screen.dart`

---

## FLUTTER 8: Export System

### FLUTTER 8.1: Implement Export Service
**Dependencies**: FLUTTER 4.12
**Description**: Build image capture and export logic
**Acceptance Criteria**:
- Capture widget as PNG bytes
- Support multiple resolutions
- Handle platform differences (web vs mobile)
- JPEG conversion option
**Files**:
- `lib/core/utils/export_service.dart`

### FLUTTER 8.2: Create Resolution Picker Widget
**Dependencies**: FLUTTER 2.4
**Description**: Build resolution selection UI
**Acceptance Criteria**:
- Radio buttons for Standard/High/Ultra
- Show pixel dimensions
- Default to High
**Files**:
- `lib/screens/export/widgets/resolution_picker.dart`

### FLUTTER 8.3: Create Format Selector Widget
**Dependencies**: FLUTTER 2.4
**Description**: Build format selection UI
**Acceptance Criteria**:
- Radio buttons for PNG/JPEG
- Default to PNG
- Transparent background option (PNG only)
**Files**:
- `lib/screens/export/widgets/format_selector.dart`

### FLUTTER 8.4: Create Export Button Widget
**Dependencies**: FLUTTER 8.1
**Description**: Build export action button
**Acceptance Criteria**:
- Save to device functionality
- Loading state during export
- Success feedback
- Error handling
**Files**:
- `lib/screens/export/widgets/export_button.dart`

### FLUTTER 8.5: Implement Share Functionality
**Dependencies**: FLUTTER 8.1
**Description**: Add sharing capability
**Acceptance Criteria**:
- Share button alongside save
- Use share_plus package
- Share image via system share sheet
**Files**:
- `lib/core/utils/share_service.dart`

### FLUTTER 8.6: Create Export Screen
**Dependencies**: FLUTTER 8.2 through FLUTTER 8.5
**Description**: Build complete export screen
**Acceptance Criteria**:
- Final preview display
- Resolution picker
- Format selector
- Transparent background toggle
- Save and Share buttons
- Success/error feedback
**Files**:
- `lib/screens/export/export_screen.dart`

### FLUTTER 8.7: Create Export Provider
**Dependencies**: FLUTTER 8.1
**Description**: State management for export flow
**Acceptance Criteria**:
- Track export options
- Track export progress
- Handle success/error states
**Files**:
- `lib/providers/export_provider.dart`

---

## FLUTTER 9: UI/UX Polish

### FLUTTER 9.1: Add Animations
**Dependencies**: FLUTTER 5.3, FLUTTER 6.5, FLUTTER 7.4
**Description**: Add smooth transitions and feedback
**Acceptance Criteria**:
- Page transitions
- QR preview fade-in
- Border selection animation
- Button press feedback
**Files**:
- Various screen files
- `lib/core/animations/`

### FLUTTER 9.2: Implement Dark Mode
**Dependencies**: FLUTTER 1.2
**Description**: Complete dark mode support
**Acceptance Criteria**:
- All screens work in dark mode
- Colors adapt properly
- QR codes remain scannable
- Border colors adjust
**Files**:
- `lib/core/theme/app_theme.dart`
- Various widget files

### FLUTTER 9.3: Add Loading States
**Dependencies**: FLUTTER 1.4
**Description**: Add loading indicators throughout
**Acceptance Criteria**:
- QR generation loading (if slow)
- Export loading indicator
- Skeleton screens where appropriate
**Files**:
- Various screen files

### FLUTTER 9.4: Add Error Handling UI
**Dependencies**: FLUTTER 1.4
**Description**: Graceful error display
**Acceptance Criteria**:
- Error snackbars
- Inline validation errors
- Retry options where applicable
**Files**:
- `lib/widgets/error_display.dart`
- Various screen files

### FLUTTER 9.5: Add Empty States
**Dependencies**: FLUTTER 1.4
**Description**: Design empty/placeholder states
**Acceptance Criteria**:
- Empty QR preview state
- Instructions when no data
- Helpful prompts
**Files**:
- `lib/widgets/empty_state.dart`

### FLUTTER 9.6: Responsive Design
**Dependencies**: All UI tasks
**Description**: Ensure responsive layout
**Acceptance Criteria**:
- Works on phones (small)
- Works on tablets (medium)
- Works on web (large)
- Adaptive layouts
**Files**:
- Various screen files
- `lib/core/utils/responsive.dart`

---

## FLUTTER 10: Testing

### FLUTTER 10.1: Unit Tests - WiFi Formatter
**Dependencies**: FLUTTER 3.2
**Description**: Test WiFi string formatting
**Acceptance Criteria**:
- Test all security types
- Test special character escaping
- Test hidden network flag
- Test edge cases
**Files**:
- `test/unit/wifi_formatter_test.dart`

### FLUTTER 10.2: Unit Tests - URL Encoder
**Dependencies**: FLUTTER 3.1
**Description**: Test URL encoding
**Acceptance Criteria**:
- Test URL validation
- Test protocol addition
- Test special characters
**Files**:
- `test/unit/qr_encoder_test.dart`

### FLUTTER 10.3: Unit Tests - Export Service
**Dependencies**: FLUTTER 8.1
**Description**: Test export functionality
**Acceptance Criteria**:
- Test image capture
- Test file naming
- Test format conversion
**Files**:
- `test/unit/export_service_test.dart`

### FLUTTER 10.4: Widget Tests - QR Display
**Dependencies**: FLUTTER 3.3
**Description**: Test QR display widget
**Acceptance Criteria**:
- Renders with valid data
- Shows placeholder without data
- Handles size changes
**Files**:
- `test/widget/qr_display_test.dart`

### FLUTTER 10.5: Widget Tests - Borders
**Dependencies**: FLUTTER 4.12
**Description**: Test border widgets
**Acceptance Criteria**:
- Each border renders correctly
- Colors apply properly
- Thumbnails display
**Files**:
- `test/widget/border_test.dart`

### FLUTTER 10.6: Integration Tests - URL Flow
**Dependencies**: FLUTTER 5.3, FLUTTER 7.4, FLUTTER 8.6
**Description**: Test complete URL QR flow
**Acceptance Criteria**:
- Enter URL → Preview → Customize → Export
- End-to-end flow works
**Files**:
- `test/integration/url_flow_test.dart`

### FLUTTER 10.7: Integration Tests - WiFi Flow
**Dependencies**: FLUTTER 6.5, FLUTTER 7.4, FLUTTER 8.6
**Description**: Test complete WiFi QR flow
**Acceptance Criteria**:
- Enter WiFi details → Preview → Customize → Export
- End-to-end flow works
**Files**:
- `test/integration/wifi_flow_test.dart`

### FLUTTER 10.8: QR Scannability Verification
**Dependencies**: FLUTTER 4.12
**Description**: Verify generated QR codes scan correctly
**Acceptance Criteria**:
- Test URL QR codes scan on real devices
- Test WiFi QR codes connect to networks
- Test at all export resolutions
- Test with all borders (ensure quiet zone maintained)
**Files**:
- Manual testing checklist

---

## FLUTTER 11: Platform Configuration & Deployment

### FLUTTER 11.1: Configure iOS Project
**Dependencies**: All features complete
**Description**: Set up iOS build configuration
**Acceptance Criteria**:
- Set bundle ID
- Configure Info.plist permissions
- Set up app icons
- Configure launch screen
**Files**:
- `ios/Runner/Info.plist`
- `ios/Runner/Assets.xcassets/`

### FLUTTER 11.2: Configure Android Project
**Dependencies**: All features complete
**Description**: Set up Android build configuration
**Acceptance Criteria**:
- Set package name
- Configure AndroidManifest permissions
- Set up app icons (adaptive)
- Configure splash screen
- Set up signing
**Files**:
- `android/app/build.gradle`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/res/`

### FLUTTER 11.3: Configure Web Project
**Dependencies**: All features complete
**Description**: Set up web build configuration
**Acceptance Criteria**:
- Configure manifest.json for PWA
- Set up favicon and icons
- Configure index.html metadata
- Set up service worker
**Files**:
- `web/manifest.json`
- `web/index.html`
- `web/icons/`

### FLUTTER 11.4: Create App Icons
**Dependencies**: None
**Description**: Design and generate app icons
**Acceptance Criteria**:
- Design app icon (QR-themed)
- Generate all iOS sizes
- Generate all Android sizes (adaptive)
- Generate PWA icons
- Use flutter_launcher_icons package
**Files**:
- `assets/icons/`
- `pubspec.yaml` (flutter_launcher_icons config)

### FLUTTER 11.5: Build iOS Release
**Dependencies**: FLUTTER 11.1, FLUTTER 11.4
**Description**: Create iOS App Store build
**Acceptance Criteria**:
- Build passes without errors
- Archive uploads to App Store Connect
- TestFlight build available
**Files**:
- Build artifacts

### FLUTTER 11.6: Build Android Release
**Dependencies**: FLUTTER 11.2, FLUTTER 11.4
**Description**: Create Android Play Store build
**Acceptance Criteria**:
- Build AAB without errors
- Upload to Play Console
- Internal testing track available
**Files**:
- Build artifacts

### FLUTTER 11.7: Deploy Web
**Dependencies**: FLUTTER 11.3, FLUTTER 11.4
**Description**: Deploy web build to hosting
**Acceptance Criteria**:
- Build web release
- Deploy to hosting service
- PWA installable
- All features work in browsers
**Files**:
- `build/web/`

---

## Task Summary

| Category | Tasks | Description |
|----------|-------|-------------|
| FLUTTER 1 | 5 tasks | Project setup, theme, state, widgets, navigation |
| FLUTTER 2 | 4 tasks | Data models |
| FLUTTER 3 | 4 tasks | QR core functionality |
| FLUTTER 4 | 12 tasks | Decorative borders system |
| FLUTTER 5 | 3 tasks | URL QR feature |
| FLUTTER 6 | 5 tasks | WiFi QR feature |
| FLUTTER 7 | 4 tasks | Customization screen |
| FLUTTER 8 | 7 tasks | Export system |
| FLUTTER 9 | 6 tasks | UI/UX polish |
| FLUTTER 10 | 8 tasks | Testing |
| FLUTTER 11 | 7 tasks | Platform config & deployment |

**Total: 65 tasks**

---

## Critical Path

The following tasks are on the critical path (must complete in sequence):

```
FLUTTER 1.1 (Project Setup)
    ↓
FLUTTER 2.1-2.4 (Models) → FLUTTER 3.1-3.2 (Encoders)
    ↓
FLUTTER 3.3 (QR Display) → FLUTTER 4.1-4.11 (Borders)
    ↓
FLUTTER 4.12 (Bordered QR)
    ↓
FLUTTER 5.3/6.5 (Generator Screens) + FLUTTER 7.4 (Customize)
    ↓
FLUTTER 8.1-8.6 (Export)
    ↓
FLUTTER 9.x (Polish) + FLUTTER 10.x (Testing)
    ↓
FLUTTER 11.x (Deployment)
```

---

## Parallel Work Opportunities

The following task groups can be worked on in parallel:

1. **Models** (FLUTTER 2.1-2.4) - all independent
2. **Borders** (FLUTTER 4.2-4.10) - all independent after 4.1
3. **URL and WiFi Features** (FLUTTER 5.x and 6.x) - can parallel after 3.4
4. **Testing** (FLUTTER 10.1-10.5) - can start as soon as features complete
5. **Platform Configs** (FLUTTER 11.1-11.3) - all independent

---

## Document History

| Date | Version | Changes |
|------|---------|---------|
| 2026-01-29 | 1.0 | Initial task breakdown |
