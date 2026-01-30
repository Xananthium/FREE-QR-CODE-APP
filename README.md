# 🌘 Digital Eclipse - Free QR Code Generator

**By [Digital Disconnections Inc.](https://digitaldisconnections.com)**

> *No subscriptions. No tricks. Free forever.*

---

## 📖 Why This App Exists

I was planning my daughter's 6th birthday party and printing invitations with a Google Maps QR code to the venue. I clicked on the first website that said "free QR codes." I was very busy planning the party, created the QR code, put it on the cards, and sent them out.

**Three days later** I got an email that said I would need to buy a membership if I wanted this QR code to stay active.

Needless to say, I didn't pay their **$30/year membership** so this QR code could stay active for a few days, and I got several calls from confused parents about broken invitations.

**So I wrote this app. It's free forever.**

---

## 📱 Download Now

### **Android**
👉 **[Download APK](../../releases/latest/download/digital-eclipse.apk)** *(Click to download - 89MB)*

*No Google Play account needed. Just download and install.*

### **iOS**
🍎 **[Download IPA](../../releases/latest/download/digital-eclipse.ipa)** *(54MB)*

*Requires AltStore or sideloading. [How to install →](https://faq.altstore.io/)*

**Or submit to App Store** - See [App Store Submission Guide](#app-store-submission)

### **Web (Works Offline!)**
🌐 **[Open Web App](web/index.html)** - Single HTML file, works offline, no installation needed

*Right-click → Save As to keep it on your computer forever*

---

## ✨ Features

- **7 QR Code Types**
  - 🔗 URL/Website
  - 📶 WiFi Network (auto-connect)
  - 📧 Email (pre-filled)
  - 📞 Phone (direct dial)
  - 💬 SMS (pre-filled text)
  - 👤 Contact/vCard (business cards)
  - 📍 Location (GPS coordinates)

- **30 Decorative Border Frames**
  - 🐱 Cats (anime, cyber, punk, galaxy, ninja)
  - 🎸 Punk Rock (torn paper, chains, grunge, anarchy)
  - 🌆 Cyberpunk (glitch, neon, circuit, matrix, holographic)
  - ⚡ Hard/Edgy (skull, lightning, metal, flame, blade)
  - 👾 Creatures (blob, plant, cloud, gem, goo)
  - 🌸 Kawaii (stars, bows, hearts, sweets, flowers)

- **Fully Customizable**
  - Custom colors for QR code and borders
  - Live preview as you customize
  - Export as high-resolution PNG (512px - 4096px)

- **Works 100% Offline**
  - No internet required after installation
  - No tracking, no analytics, no ads
  - Your data never leaves your device

- **Beautiful Museum-Quality Design**
  - Dark mode support
  - Smooth animations
  - Premium typography (Playfair Display + Inter)
  - Museum gold accents on deep charcoal

---

## 🚀 Quick Start

### Android Users
1. Download the APK from the link above
2. Open the file on your phone
3. If prompted, allow installation from unknown sources
4. Install and enjoy!

### Web Users
1. Click the web app link above
2. Works immediately in any browser
3. Save the HTML file to use offline anytime
4. Bookmark it for quick access

### Building from Source
See [BUILDING.md](BUILDING.md) for instructions on building the app yourself.

---

## 🍎 App Store Submission

The iOS app is **ready for App Store submission**!

### Requirements
- Apple Developer Account ($99/year)
- App Store Connect access

### Submission Steps

1. **Prepare App Store Assets**
   - App icon (1024x1024px)
   - Screenshots (5-10 images)
   - App description (copy from this README)
   - Keywords: QR code, generator, free, offline

2. **Upload IPA**
   ```bash
   # Option 1: Use Apple Transporter (GUI)
   # Download from App Store, drag and drop digital-eclipse.ipa

   # Option 2: Command line
   xcrun altool --upload-app --type ios \
     -f build/ios/ipa/barcode_app.ipa \
     --apiKey YOUR_API_KEY \
     --apiIssuer YOUR_ISSUER_ID
   ```

3. **App Store Connect Setup**
   - App Name: **Digital Eclipse**
   - Subtitle: **Free QR Code Generator**
   - Category: **Utilities**
   - Price: **Free**
   - Age Rating: **4+**
   - Description: Use the birthday party story from this README

4. **Submit for Review**
   - Average review time: 24-48 hours
   - Be sure to explain the app is 100% free with no in-app purchases

### App Store Description Template

Use the birthday party story from the "Why This App Exists" section above, followed by the features list.

---

## 🤝 Contributing

We welcome contributions! This app probably does everything it needs to do, but if you have ideas:

- 🐛 **Found a bug?** [Open an issue](../../issues/new)
- 💡 **Have a feature request?** [Open an issue](../../issues/new)
- 🔧 **Want to contribute code?** Fork the repo and submit a pull request!

### Development Setup

```bash
# Clone the repository
git clone https://github.com/digitaldisconnections/digital-eclipse.git
cd digital-eclipse

# Install Flutter dependencies
cd barcode_app
flutter pub get

# Run on your device
flutter run
```

---

## 📁 Repository Structure

```
digital-eclipse/
├── barcode_app/              # Flutter mobile app (iOS/Android)
│   ├── lib/                  # App source code
│   ├── assets/               # Images, borders, icons
│   └── pubspec.yaml          # Dependencies
├── web/                      # Standalone HTML QR generator
│   └── index.html            # Single-file web app (works offline)
├── borders_generated/        # 30 AI-generated border frames
├── zimage_generator.py       # Script for generating border art
└── README.md                 # This file
```

---

## 🎨 Border Frame Generation

All 30 decorative borders were generated using AI (Z-Image Turbo) to ensure they're original and copyright-free. If you want to generate more borders:

```bash
python3 zimage_generator.py --batch border_prompts_final.txt -s square -c 4
```

See `border_prompts_final.txt` for examples.

---

## 📄 License

**MIT License** - See [LICENSE](LICENSE) for details.

### What This Means:
- ✅ Use it for free
- ✅ Modify it however you want
- ✅ Distribute it (even commercially)
- ✅ No warranty (use at your own risk)

---

## 🌐 Links

- **Website**: [digitaldisconnections.com](https://digitaldisconnections.com)
- **Issues**: [Report bugs or request features](../../issues)
- **Releases**: [Download latest version](../../releases)

---

## 💝 Free Forever

This app will always be free. No subscriptions, no ads, no tracking. We built it because we got scammed by a "free" QR code service, and we don't want that to happen to anyone else.

If you find this useful, share it with others who might need it. That's all we ask.

---

**Made with ❤️ by [Digital Disconnections Inc.](https://digitaldisconnections.com)**

*Creating thoughtful software that helps people disconnect from unnecessary digital noise and focus on what matters.*
