# 🔨 Building Digital Eclipse from Source

This guide will help you build the Digital Eclipse QR code generator from source code.

---

## 📋 Prerequisites

### For Mobile App (iOS/Android)

1. **Flutter SDK** (3.27.0 or later)
   ```bash
   # macOS (using Homebrew)
   brew install --cask flutter

   # Or download from: https://flutter.dev/docs/get-started/install
   ```

2. **Android Studio** (for Android builds)
   - Download from: https://developer.android.com/studio
   - Install Android SDK (API level 21 or higher)
   - Install Android SDK Build-Tools

3. **Xcode** (for iOS builds - macOS only)
   - Download from Mac App Store
   - Install Command Line Tools:
     ```bash
     xcode-select --install
     ```

4. **Git**
   ```bash
   # macOS
   brew install git

   # Or check if already installed
   git --version
   ```

---

## 🚀 Quick Build

### Android APK

```bash
# Clone the repository
git clone https://github.com/digitaldisconnections/digital-eclipse.git
cd digital-eclipse/barcode_app

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release

# APK will be at: build/app/outputs/flutter-apk/app-release.apk
```

### iOS App (macOS only)

```bash
# Same setup as Android, then:
flutter build ios --release

# Or build for App Store
flutter build ipa --release

# IPA will be at: build/ios/ipa/
```

### Debug Build (for testing)

```bash
# Android
flutter build apk --debug

# iOS
flutter build ios --debug

# Or just run on connected device
flutter run
```

---

## 🌐 Web App

The web app is a single HTML file with no build process needed!

### Using the Web App

Just open `web/index.html` in any browser. That's it!

### Customizing the Web App

Edit `web/index.html` directly. It's self-contained with all CSS and JavaScript inline.

---

## 📱 Testing on Physical Devices

### Android

1. Enable Developer Mode on your Android device:
   - Settings → About Phone → Tap "Build Number" 7 times
   - Settings → Developer Options → Enable "USB Debugging"

2. Connect your device via USB

3. Run the app:
   ```bash
   flutter run
   ```

### iOS

1. Connect your iPhone/iPad via USB
2. In Xcode, select your device as the build target
3. Run:
   ```bash
   flutter run
   ```

**Note**: iOS requires a developer account for physical device testing.

---

## 🎨 Generating Border Frames

If you want to create new border frames:

### Requirements

```bash
pip3 install aiohttp
```

### Usage

```bash
# Generate all borders from prompts file
python3 zimage_generator.py --batch border_prompts_final.txt -s square -c 4

# Generate a single border
python3 zimage_generator.py "Cyberpunk cat border frame with neon effects" -o my_border -s square
```

**Note**: Requires access to a ComfyUI server running Z-Image Turbo. The script is configured to use our remote server at `http://71.112.215.60:8188`.

---

## 🐛 Troubleshooting

### "flutter: command not found"

Add Flutter to your PATH:
```bash
# macOS/Linux - add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:/path/to/flutter/bin"
```

### "Android licenses not accepted"

```bash
flutter doctor --android-licenses
```

### "CocoaPods not installed" (iOS)

```bash
sudo gem install cocoapods
```

### Build fails with dependency errors

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release
```

### "Execution failed for task ':app:lintVitalRelease'"

This is a known Flutter issue. Disable lint checks temporarily:

Edit `android/app/build.gradle`:
```gradle
android {
    lintOptions {
        checkReleaseBuilds false
    }
}
```

---

## 📦 Release Builds

### Signing Android APK (for Play Store)

1. Create a keystore:
   ```bash
   keytool -genkey -v -keystore digital-eclipse.jks -keyalg RSA -keysize 2048 -validity 10000 -alias digital-eclipse
   ```

2. Create `android/key.properties`:
   ```properties
   storePassword=<your-keystore-password>
   keyPassword=<your-key-password>
   keyAlias=digital-eclipse
   storeFile=/path/to/digital-eclipse.jks
   ```

3. Build signed APK:
   ```bash
   flutter build apk --release
   ```

### Building for App Store (iOS)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select "Generic iOS Device" as target
3. Product → Archive
4. Follow App Store submission wizard

---

## 🔧 Development Tips

### Hot Reload

When running with `flutter run`, press:
- `r` - Hot reload (keeps app state)
- `R` - Hot restart (resets app state)
- `q` - Quit

### Debug Output

```bash
# View detailed logs
flutter run --verbose

# View device logs
flutter logs
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/screens/home_screen_test.dart
```

---

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design 3](https://m3.material.io/)

---

## 🤝 Contributing

After building, if you want to contribute:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test thoroughly: `flutter test`
5. Commit: `git commit -am 'Add my feature'`
6. Push: `git push origin feature/my-feature`
7. Open a Pull Request

---

**Questions?** [Open an issue](../../issues/new) and we'll help you out!
