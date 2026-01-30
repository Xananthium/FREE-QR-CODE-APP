# Android Release Build Instructions

## Beautiful QR Code Generator - Production Build Guide

This document provides complete instructions for building and deploying the Android version of the Beautiful QR Code Generator app to the Google Play Store.

---

## Build Information

- **App Name:** Beautiful QR Code Generator
- **Package Name:** com.performative.barcode_app
- **Version:** 1.0.0+1
- **Target SDK:** 36 (Android 15)
- **Min SDK:** 21 (Android 5.0)
- **Build Type:** Android App Bundle (AAB)
- **AAB Size:** ~41 MB (with R8 optimization)

---

## Prerequisites

1. **Flutter SDK** (3.27.0 or higher)
2. **Java Development Kit** (JDK 17 or higher)
3. **Android SDK** with API 36
4. **Keystore file** (already created at `android/app/upload-keystore.jks`)

---

## Keystore Information

### Location
```
android/app/upload-keystore.jks
```

### Configuration File
```
android/app/key.properties
```

### IMPORTANT SECURITY NOTES

1. **NEVER commit the keystore file to version control**
2. **NEVER commit key.properties to version control**
3. **Store keystore password securely** (password manager recommended)
4. **Backup the keystore file** to a secure location
5. If you lose the keystore, you cannot update the app on Play Store

### Keystore Details

- **Alias:** upload
- **Algorithm:** RSA
- **Key Size:** 2048 bits
- **Validity:** 10,000 days (27+ years)
- **Format:** JKS (Java KeyStore)

### Creating a New Keystore (If Needed)

If you need to create a new keystore for a different app or environment:

```bash
cd android/app
keytool -genkey -v -keystore upload-keystore.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

You will be prompted for:
- Keystore password (choose a strong password)
- Key password (can be the same as keystore password)
- Your name, organization, city, state, country

Then create `android/app/key.properties`:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

---

## Build Configuration

### ProGuard/R8 Configuration

The app uses R8 for code shrinking and obfuscation. Configuration is in:
```
android/app/proguard-rules.pro
```

Key features:
- Flutter framework preservation
- Plugin compatibility (QR Flutter, Share Plus, etc.)
- Play Core library support
- Kotlin preservation
- Production log removal

### build.gradle.kts Configuration

Located at `android/app/build.gradle.kts`:

- **Compile SDK:** 36 (Android 15)
- **Target SDK:** 36
- **Min SDK:** 21 (Android 5.0+)
- **R8 Minification:** Enabled
- **ProGuard:** Enabled with custom rules
- **Signing:** Automatic for release builds

---

## Building the AAB

### Step 1: Clean Previous Builds

```bash
flutter clean
```

### Step 2: Get Dependencies

```bash
flutter pub get
```

### Step 3: Build Release AAB

```bash
flutter build appbundle --release
```

### Build Output

The AAB will be created at:
```
build/app/outputs/bundle/release/app-release.aab
```

### Expected Build Time

- First build: 1-2 minutes
- Incremental builds: 20-40 seconds

### Build Optimizations

The build process automatically:
- Tree-shakes font assets (99.5%+ reduction)
- Minifies and obfuscates code with R8
- Removes debug symbols and logging
- Optimizes resource compression
- Signs with release keystore

---

## Testing the Release Build Locally

### Using bundletool

1. **Install bundletool:**
```bash
brew install bundletool
```

2. **Generate APKs from AAB:**
```bash
bundletool build-apks \
  --bundle=build/app/outputs/bundle/release/app-release.aab \
  --output=barcode_app.apks \
  --mode=universal
```

3. **Install on connected device:**
```bash
bundletool install-apks --apks=barcode_app.apks
```

### Verification Checklist

Before uploading to Play Console:

- [ ] App launches without crashes
- [ ] QR code generation works
- [ ] Border selection works
- [ ] Export to image works
- [ ] Share functionality works
- [ ] All permissions requested correctly
- [ ] No debug logs visible
- [ ] App icon displays correctly
- [ ] Version number is correct

---

## Uploading to Google Play Console

### Step 1: Create App in Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Click "Create app"
3. Fill in app details:
   - App name: Beautiful QR Code Generator
   - Default language: English (United States)
   - App type: App
   - Category: Tools
   - Free/Paid: Free

### Step 2: Complete Store Listing

Required information:
- App name
- Short description (80 chars max)
- Full description (4000 chars max)
- App icon (512x512 PNG)
- Feature graphic (1024x500 PNG)
- Screenshots (at least 2 per device type)
- Privacy policy URL (if collecting data)

### Step 3: Upload AAB

1. Navigate to "Production" → "Releases"
2. Click "Create new release"
3. Upload `app-release.aab`
4. Add release notes
5. Review and rollout

### Step 4: Internal Testing (Recommended First)

1. Navigate to "Testing" → "Internal testing"
2. Create new release
3. Upload AAB
4. Add test users (email addresses)
5. Share testing link with testers
6. Collect feedback before production release

### Internal Testing Track Setup

To enable internal testing:

1. Go to "Testing" → "Internal testing"
2. Click "Create new release"
3. Upload the AAB file
4. Add release notes
5. Save and review
6. Distribute to testers via email link

Test users can install the app via:
```
https://play.google.com/apps/internaltest/[YOUR_TEST_LINK]
```

---

## Version Management

### Current Version
- Version name: 1.0.0
- Version code: 1

### Updating Version

Edit `pubspec.yaml`:
```yaml
version: 1.0.1+2
```

Format: `MAJOR.MINOR.PATCH+BUILD_NUMBER`
- Version name: 1.0.1
- Version code: 2

**Important:** Version code must increase with each upload to Play Store.

### Version History

| Version | Code | Date | Notes |
|---------|------|------|-------|
| 1.0.0   | 1    | 2026-01-29 | Initial release |

---

## Troubleshooting

### Build Fails with R8 Errors

If you see "Missing classes detected while running R8":
1. Check `proguard-rules.pro` has all necessary keep rules
2. Add missing class rules to ProGuard file
3. Rebuild

### Signing Errors

If you see "Failed to read key from keystore":
1. Verify `key.properties` has correct passwords
2. Verify `upload-keystore.jks` exists
3. Check keystore path is relative to `android/app/`

### Build Size Too Large

Current AAB is ~41 MB, which is acceptable. To reduce further:
1. Remove unused assets
2. Compress images more aggressively
3. Review dependencies for unused packages

### Gradle Sync Issues

If Gradle fails to sync:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

---

## Build Artifacts

### Generated Files (Do Not Commit)

These files are generated and should NOT be committed to git:

```
android/app/upload-keystore.jks
android/app/key.properties
build/
.dart_tool/
```

### Files to Commit

These files should be in version control:

```
android/app/build.gradle.kts
android/app/proguard-rules.pro
android/.gitignore
pubspec.yaml
BUILD_INSTRUCTIONS.md
```

---

## Security Checklist

Before distributing the app:

- [ ] Keystore backed up to secure location
- [ ] key.properties NOT in version control
- [ ] No hardcoded API keys or secrets
- [ ] ProGuard enabled and configured
- [ ] Debug logging removed
- [ ] SSL/TLS for any network connections
- [ ] Input validation on all user inputs
- [ ] Proper permission handling

---

## Support & Maintenance

### Updating Dependencies

```bash
flutter pub outdated
flutter pub upgrade
```

### Testing After Updates

Always run full test suite after dependency updates:
```bash
flutter test
flutter test integration_test
```

### Monitoring Crashes

After release, monitor crashes via:
- Google Play Console → Quality → Android vitals
- Firebase Crashlytics (if integrated)

---

## Quick Reference

### Build Commands

```bash
# Clean build
flutter clean && flutter pub get && flutter build appbundle --release

# Build APK for testing (not for Play Store)
flutter build apk --release

# Build debug version
flutter build appbundle --debug
```

### File Locations

```
AAB:        build/app/outputs/bundle/release/app-release.aab
Keystore:   android/app/upload-keystore.jks
ProGuard:   android/app/proguard-rules.pro
Config:     android/app/build.gradle.kts
```

### Important Links

- [Flutter Release Documentation](https://docs.flutter.dev/deployment/android)
- [Google Play Console](https://play.google.com/console)
- [Android App Bundle Documentation](https://developer.android.com/guide/app-bundle)

---

## Build Complete

**Status:** Production AAB successfully built and ready for Play Store upload.

**Next Steps:**
1. Test AAB locally using bundletool
2. Upload to Internal Testing track
3. Distribute to test users
4. Collect feedback
5. Promote to Production when ready

**Build Date:** 2026-01-29
**Built By:** Flutter Build System
**AAB Location:** `build/app/outputs/bundle/release/app-release.aab`
