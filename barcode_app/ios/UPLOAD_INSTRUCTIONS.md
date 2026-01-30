# Upload Instructions for Barcode App v1.0.0

## Quick Upload Guide

### IPA Location
```
/Users/xananthium/Performative/barcode/barcode_app/build/ios/ipa/barcode_app.ipa
```
**Size**: 19.9 MB  
**Signed**: YES (Cloud Managed Apple Distribution)  
**Valid Until**: January 9, 2027

---

## Method 1: Apple Transporter (EASIEST)

1. **Download Apple Transporter**
   - Open Mac App Store
   - Search "Transporter"
   - Download and install (free)

2. **Upload IPA**
   - Open Transporter app
   - Sign in with Apple ID: aftersending1@gmail.com
   - Drag `barcode_app.ipa` into window
   - Click "Deliver"
   - Wait for upload to complete

3. **Verify Upload**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - My Apps > Barcode App > TestFlight
   - Wait 5-30 minutes for processing
   - Build will appear when ready

---

## Method 2: Command Line

### Setup API Keys (One Time)
1. Go to [App Store Connect > Users and Access > Keys](https://appstoreconnect.apple.com/access/api)
2. Click "+" to generate new key
3. Name: "CI Upload Key" (or similar)
4. Access: App Manager
5. Download .p8 file
6. Note Issuer ID and Key ID

### Upload Command
```bash
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/barcode_app.ipa \
  --apiKey YOUR_KEY_ID \
  --apiIssuer YOUR_ISSUER_ID
```

Replace `YOUR_KEY_ID` and `YOUR_ISSUER_ID` with values from App Store Connect.

---

## Method 3: Xcode Organizer

1. Open archive in Xcode:
   ```bash
   open build/ios/archive/Runner.xcarchive
   ```

2. In Xcode Organizer:
   - Select the archive
   - Click "Distribute App"
   - Choose "App Store Connect"
   - Select "Upload"
   - Choose automatic signing
   - Click "Upload"

---

## After Upload

### Processing
- Processing time: 5-30 minutes
- You'll receive email when complete
- Check App Store Connect for build status

### TestFlight
1. Go to App Store Connect
2. Select your app
3. Go to TestFlight tab
4. Select the build
5. Add "What to Test" notes
6. Add internal testers
7. Distribute to testers

### Internal Testing
- No review required
- Available immediately after processing
- Add up to 100 internal testers

### External Testing
- Requires beta app review
- Review time: ~24 hours
- Up to 10,000 external testers

---

## Troubleshooting

### "No build appears in App Store Connect"
- Wait 30 minutes for processing
- Check email for errors
- Verify upload completed successfully

### "Invalid binary"
- Check that bundle ID matches App Store Connect
- Ensure version number is higher than previous builds
- Verify code signing is valid

### "Missing compliance"
- Already handled in Info.plist
- Set to false (standard encryption only)

---

## App Store Connect Setup

If this is your first build:

1. **Create App**
   - Go to App Store Connect > My Apps
   - Click "+" > New App
   - Platform: iOS
   - Name: Barcode App
   - Primary Language: English
   - Bundle ID: com.performative.barcodeApp
   - SKU: barcode-app-001 (or similar)

2. **App Information**
   - Fill in required fields
   - Add privacy policy URL (if applicable)
   - Select app category
   - Complete age rating questionnaire

3. **Pricing**
   - Select price tier (free or paid)
   - Choose availability territories

4. **Submit for Review**
   - Add screenshots (required sizes in BUILD_REPORT.md)
   - Write description
   - Add keywords
   - Submit when ready

---

## Build Information

- **App Name**: Barcode App
- **Bundle ID**: com.performative.barcodeApp
- **Version**: 1.0.0
- **Build**: 1
- **Min iOS**: 13.0
- **Team**: Cassidy Barton (DQ5TLD4XHY)

---

**Need Help?**  
See complete details in `BUILD_REPORT.md`
