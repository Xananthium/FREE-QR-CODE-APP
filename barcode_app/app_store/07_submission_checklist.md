# App Store Submission Checklist

**For: QR Code Generator by Digital Disconnections Inc.**

Use this checklist to ensure everything is ready before submitting to the App Store.

---

## Phase 1: Pre-Submission Preparation

### App Development

- [ ] App builds successfully in Xcode
- [ ] App runs without crashes on physical devices
- [ ] All features work as expected
- [ ] App works offline (critical for our value prop)
- [ ] Tested on multiple device sizes (SE, 14/15, 15 Pro Max, iPad)
- [ ] Tested on minimum iOS version (set in Xcode)
- [ ] No debug code or test features left in production build
- [ ] App bundle ID is correct (e.g., `com.digitaldisconnections.qrcodegenerator`)

### Code Quality

- [ ] No compiler warnings
- [ ] No analyzer issues
- [ ] Code signing is configured correctly
- [ ] Provisioning profiles are valid
- [ ] App capabilities match what you're using (e.g., photo library access)

### Testing

- [ ] Manual testing on real devices (not just simulator)
- [ ] Test all QR code types (URL, vCard, WiFi, etc.)
- [ ] Test saving to photo library
- [ ] Test offline functionality
- [ ] Test on low battery mode
- [ ] Test interruptions (phone calls, notifications)
- [ ] Test storage limits (create 100+ codes)
- [ ] Beta testing with TestFlight (optional but recommended)

---

## Phase 2: App Store Connect Setup

### Account & Legal

- [ ] Apple Developer account is active ($99/year paid)
- [ ] Enrolled in App Store program
- [ ] Agreements accepted in App Store Connect
- [ ] Tax forms completed (if applicable)
- [ ] Banking info entered (even though app is free)

### App Information

- [ ] App created in App Store Connect
- [ ] Bundle ID matches Xcode project
- [ ] SKU created (internal tracking number)
- [ ] Primary language set (English)
- [ ] Additional languages added (if applicable)

---

## Phase 3: App Metadata

### Basic Info

- [ ] **App Name:** `FreeQR - Code Generator` (or chosen name)
- [ ] **Subtitle:** `Free Forever QR Generator` (30 chars max)
- [ ] **Primary Category:** Utilities
- [ ] **Secondary Category:** Business or Productivity (optional)
- [ ] **Content Rights:** Check if you own all rights

### Descriptions

- [ ] **Promotional Text** (170 chars)
  ```
  Create QR codes that work forever. No subscriptions, no expiring links, no data collection. Works offline. Completely free. "You shouldn't have to rent your phone."
  ```

- [ ] **Description** (4000 chars max)
  - Copy from `01_app_store_description.md`
  - Include the birthday party story
  - Highlight: free forever, offline, privacy, no expiration

- [ ] **Keywords** (100 chars)
  ```
  qr code,barcode,free,offline,privacy,no ads,generator,scanner,wifi,vcard,url,永久,二维码,gratis
  ```

- [ ] **Support URL:** `https://digitaldisconnections.com/qr-support`
- [ ] **Marketing URL:** `https://digitaldisconnections.com` (optional)

### Pricing & Availability

- [ ] Price: **Free** (always)
- [ ] Availability: **All countries** (or specify)
- [ ] Pre-order: No (unless you want to build hype)

---

## Phase 4: Screenshots & Media

### iPhone Screenshots (REQUIRED)

**6.7" Display (iPhone 15 Pro Max)** - Required
- [ ] Screenshot 1: Hero (codes work forever)
- [ ] Screenshot 2: Story (never get held hostage)
- [ ] Screenshot 3: Privacy (no data collection)
- [ ] Screenshot 4: Features (all QR types)
- [ ] Screenshot 5: Offline capability

**6.5" Display (iPhone 14 Plus)** - Recommended
- [ ] All 5 screenshots (can be same as 6.7" if layout is similar)

**5.5" Display (iPhone 8 Plus)** - Optional
- [ ] All 5 screenshots (for older devices)

### iPad Screenshots (if supporting iPad)

**12.9" iPad Pro (2nd/3rd gen)**
- [ ] At least 1 screenshot
- [ ] Up to 10 screenshots

**12.9" iPad Pro (6th gen)**
- [ ] At least 1 screenshot
- [ ] Up to 10 screenshots

### Screenshot Specifications

- [ ] File format: PNG or JPEG (PNG recommended)
- [ ] Color space: RGB (not CMYK)
- [ ] Size: Exact pixel dimensions for each device
  - 6.7": 1290 x 2796 pixels
  - 6.5": 1242 x 2688 pixels
  - 5.5": 1242 x 2208 pixels
  - 12.9" iPad (6th): 2048 x 2732 pixels
- [ ] File size: Under 30MB each
- [ ] No alpha channel/transparency in screenshots
- [ ] Text overlays are clear and readable
- [ ] Screenshots show actual app UI (required by Apple)

### App Icon

- [ ] 1024 x 1024 pixels
- [ ] PNG format
- [ ] RGB color space
- [ ] No transparency
- [ ] No rounded corners (Apple adds them)
- [ ] Represents the app clearly
- [ ] Matches in-app icon

### App Preview Video (OPTIONAL but recommended)

- [ ] 15-30 seconds long
- [ ] H.264 or HEVC format
- [ ] Same sizes as screenshots
- [ ] Shows actual app usage
- [ ] No third-party content
- [ ] Audio is optional (recommended: on)

---

## Phase 5: App Review Information

### Contact Information

- [ ] **First Name:** Your first name
- [ ] **Last Name:** Your last name
- [ ] **Phone Number:** Reachable number during review
- [ ] **Email:** support@digitaldisconnections.com
- [ ] **Notes to Reviewer:**
  ```
  This is a simple QR code generator that works completely offline with no data collection.

  Key features to test:
  1. Create a URL QR code (no internet required)
  2. Save to photo library (will request permission)
  3. View creation history
  4. Try different QR types (WiFi, vCard, etc.)

  No login required. No server connection. All data stays on device.

  Our mission: "You shouldn't have to rent your own phone."
  ```

### Demo Account (if applicable)

- [ ] Not needed (app doesn't require login) ✓

### Attachments

- [ ] Upload any demo files if needed (not needed for this app)

---

## Phase 6: Privacy Information

### Privacy Practices (CRITICAL)

Apple's "Privacy Nutrition Label" - this appears on the App Store.

**Data Used to Track You:**
- [ ] None ✓

**Data Linked to You:**
- [ ] None ✓

**Data Not Linked to You:**
- [ ] None ✓

**Specific Questions:**

1. **Do you collect data from this app?**
   - [ ] Answer: **NO**

2. **Do you or your third-party partners collect data from this app?**
   - [ ] Answer: **NO**

3. **Do you use data from this app for tracking purposes?**
   - [ ] Answer: **NO**

4. **Privacy Policy URL:**
   - [ ] `https://digitaldisconnections.com/privacy`
   - [ ] Ensure it's accessible (not password protected)
   - [ ] Ensure it matches what's in the app

**Result:** Your app will display **"No Data Collected"** with a green badge. This is the best possible privacy label.

---

## Phase 7: Build Upload

### Xcode Archive

- [ ] Open Xcode project
- [ ] Select "Generic iOS Device" or a real device (not simulator)
- [ ] Product > Archive
- [ ] Archive builds successfully
- [ ] Open Organizer (Window > Organizer)
- [ ] Select your archive
- [ ] Click "Distribute App"
- [ ] Select "App Store Connect"
- [ ] Upload build

### App Store Connect

- [ ] Build appears in App Store Connect (may take 5-10 minutes)
- [ ] Build status: "Processing" → "Ready to Submit"
- [ ] No errors or warnings
- [ ] Export Compliance: Select appropriate option
  - Likely: "No, app does not use encryption" (unless you added HTTPS/encryption)

### Version Information

- [ ] **Version Number:** 1.0 (or your version)
- [ ] **Build Number:** 1 (or your build)
- [ ] **Copyright:** © 2026 Digital Disconnections Inc.

---

## Phase 8: Age Rating

### Content Questions

Answer Apple's questionnaire about content:

- [ ] Cartoon or Fantasy Violence: **None**
- [ ] Realistic Violence: **None**
- [ ] Sexual Content or Nudity: **None**
- [ ] Profanity or Crude Humor: **None**
- [ ] Alcohol, Tobacco, or Drug Use: **None**
- [ ] Mature/Suggestive Themes: **None**
- [ ] Horror/Fear Themes: **None**
- [ ] Gambling: **None**
- [ ] Contests: **None**
- [ ] Unrestricted Web Access: **None** (app works offline)
- [ ] Medical/Treatment Info: **None**

**Result:** Age rating should be **4+** (suitable for all ages)

---

## Phase 9: App Capabilities & Permissions

### Required Permissions

**Photo Library Usage:**
- [ ] Purpose string (in Info.plist):
  ```
  We need access to save QR codes to your photo library. We never read existing photos—only write QR codes you explicitly save.
  ```
- [ ] Appears in app when requesting permission
- [ ] User can deny and app still works (just can't save to photos)

**Camera Usage (if adding scanner in future):**
- [ ] Purpose string:
  ```
  We need camera access to scan QR codes. The camera is only used when you explicitly open the scanner.
  ```

### Not Requesting (Confirm)

- [ ] Location: NO
- [ ] Contacts: NO
- [ ] Calendar: NO
- [ ] Reminders: NO
- [ ] Bluetooth: NO
- [ ] Microphone: NO
- [ ] Speech Recognition: NO
- [ ] Motion: NO
- [ ] Health: NO
- [ ] HomeKit: NO
- [ ] Media Library: NO
- [ ] Siri: NO

---

## Phase 10: Final Pre-Submission Checks

### Legal Compliance

- [ ] App doesn't violate any trademarks
- [ ] App doesn't use third-party content without permission
- [ ] Privacy policy is accurate and accessible
- [ ] Terms of service (if any) are accessible
- [ ] App doesn't make false claims
- [ ] App doesn't use Apple APIs in unauthorized ways

### App Store Guidelines

Review against: [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

Key sections for this app:

**2.1 App Completeness:**
- [ ] App is fully functional (no placeholder features)
- [ ] All buttons and features work

**2.3 Accurate Metadata:**
- [ ] Description matches app functionality
- [ ] Screenshots show actual app features
- [ ] No misleading claims

**3.1 Payments:**
- [ ] No in-app purchases ✓
- [ ] No subscriptions ✓
- [ ] Completely free ✓

**5.1 Privacy:**
- [ ] Privacy policy accessible
- [ ] No data collection (verified) ✓
- [ ] Privacy practices declared accurately ✓

**4.2 Minimum Functionality:**
- [ ] App does more than just generate QR codes (has customization, history, multiple types, etc.)
- [ ] Provides value beyond a simple web wrapper

---

## Phase 11: Submission

### Submit for Review

- [ ] Go to App Store Connect
- [ ] Select your app
- [ ] Select version (e.g., 1.0)
- [ ] Verify all information is correct
- [ ] Click "Submit for Review"
- [ ] Confirm submission

### Post-Submission

- [ ] Status changes to "Waiting for Review"
- [ ] You receive confirmation email
- [ ] Average review time: 24-48 hours (can be faster or slower)

### Monitoring

- [ ] Check App Store Connect daily for status updates
- [ ] Monitor email for Apple communication
- [ ] Respond quickly if Apple requests info

---

## Phase 12: If Rejected

### Common Rejection Reasons

**If rejected for "4.2 Minimum Functionality":**
- Response: Highlight offline functionality, privacy features, customization options
- Emphasize: "This app provides value through privacy (no data collection), offline operation, and permanent QR codes (unlike competitors who hold codes hostage)"

**If rejected for "2.3 Metadata Accuracy":**
- Review screenshots and description for any misleading info
- Ensure all claims are accurate and provable

**If rejected for "5.1 Privacy":**
- Verify privacy policy is accessible
- Ensure privacy practices in App Store Connect match reality
- Confirm no third-party SDKs are collecting data

### Response Process

- [ ] Read rejection message carefully
- [ ] Understand what needs to change
- [ ] Make necessary changes (code or metadata)
- [ ] Upload new build (if code changes) or update metadata
- [ ] Respond to Apple in Resolution Center
- [ ] Resubmit

---

## Phase 13: After Approval

### Launch Prep

- [ ] App status: "Ready for Sale"
- [ ] App appears on App Store (may take 24 hours to propagate)
- [ ] Test downloading from App Store on real device
- [ ] Verify app page looks correct

### Marketing Launch

- [ ] Announce on social media
- [ ] Email press contacts (if you have a list)
- [ ] Post on relevant forums/communities (r/privacy, r/degoogle, etc.)
- [ ] Update digitaldisconnections.com with App Store link
- [ ] Create shareable graphics/tweets

### Monitoring

- [ ] Check App Store reviews daily (first week)
- [ ] Respond to reviews (especially negative ones)
- [ ] Monitor crash reports in App Store Connect
- [ ] Track downloads and engagement

---

## Quick Reference: Required Assets

### Metadata (Text)
- [x] App name (30 chars)
- [x] Subtitle (30 chars)
- [x] Promotional text (170 chars)
- [x] Description (4000 chars)
- [x] Keywords (100 chars)
- [x] Privacy policy URL
- [x] Support URL

### Visual Assets
- [ ] App icon (1024x1024)
- [ ] 5+ iPhone screenshots (6.7" device)
- [ ] iPad screenshots (if supporting iPad)
- [ ] App preview video (optional)

### Technical
- [ ] App build (uploaded via Xcode)
- [ ] Privacy practices declared
- [ ] Age rating completed
- [ ] Export compliance answered

### Legal
- [ ] Privacy policy published
- [ ] Terms of service (optional but recommended)
- [ ] Contact email working

---

## Timeline Estimate

**Week 1:**
- Finish app development
- Internal testing
- Create all metadata and assets

**Week 2:**
- Set up App Store Connect
- Upload build
- Complete all metadata fields
- Submit for review

**Week 3:**
- Apple review (1-3 days typical)
- Launch (if approved)
- Marketing push

**If rejected:** Add 3-7 days for fixes and resubmission.

---

## Emergency Contacts

**Apple Developer Support:**
- Phone: 1-800-633-2152 (US)
- Online: developer.apple.com/support

**Digital Disconnections Internal:**
- Technical: [your email]
- Marketing: [your email]
- Press: press@digitaldisconnections.com
- Support: support@digitaldisconnections.com

---

## Post-Launch Checklist

### Week 1 After Launch

- [ ] Monitor reviews (respond to all)
- [ ] Check for crash reports
- [ ] Monitor support email
- [ ] Track downloads
- [ ] Gather user feedback

### Month 1

- [ ] Analyze common user requests
- [ ] Plan first update (bug fixes, minor improvements)
- [ ] Build email list of interested users
- [ ] Engage with community

### Month 3

- [ ] Release v1.1 with improvements
- [ ] Refresh App Store screenshots if needed
- [ ] Update promotional text based on what resonates
- [ ] Consider adding new QR code types based on requests

---

## Success Metrics

**Week 1:**
- Downloads: [set goal]
- Rating: Target 4.5+ stars
- Reviews: Target 10+ reviews

**Month 1:**
- Downloads: [set goal]
- Active users: Track retention
- Support emails: Should decrease as app stabilizes

**Year 1:**
- Downloads: [set goal]
- Build community of loyal users
- Prove privacy-first model can succeed

---

## Final Notes

**Remember:**
- Apple review can take 1-3 days (sometimes longer)
- Rejections are common - don't panic, just fix and resubmit
- First impression matters - polish everything
- Support responsiveness builds trust
- Stay true to mission: "You shouldn't have to rent your phone"

**Good luck with your launch!**

---

**Checklist Version:** 1.0
**Last Updated:** January 29, 2026
**Next Review:** After first submission (update based on learnings)
