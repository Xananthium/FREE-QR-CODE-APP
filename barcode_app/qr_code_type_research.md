# QR Code Type Research for Digital Disconnections Barcode App

**Motto:** "You shouldn't have to rent your own phone"

**Current Features:**
- URL/Website QR codes
- WiFi QR codes

**Research Date:** January 29, 2026

---

## Summary of Recommendations

### High Priority (v1.0)
1. **vCard/Contact** - Essential for business cards and contact sharing
2. **Email (mailto)** - Extremely common, simple format
3. **Phone (tel)** - Universal need, simple implementation
4. **SMS** - Popular for customer service and feedback
5. **Geo/Location** - Maps integration, standardized format

### Medium Priority (v1.1)
6. **Calendar/Event (iCalendar)** - Useful for events, more complex
7. **Social Media Profiles** - Modern use case, multiple platforms

### Low Priority (Future)
8. **Payment QR codes** - Complex, privacy concerns, standards still evolving

---

## Detailed Analysis

### 1. vCard/Contact QR Codes

**Priority:** HIGH

**Standard:** [RFC 6350](https://www.rfc-editor.org/rfc/rfc6350.html) (vCard 4.0, published August 2011 by IETF)

**Format Versions:**
- vCard 2.1 (basic support)
- vCard 3.0 (most widely supported)
- vCard 4.0 (current standard, RFC 6350)

**Format Structure:**
```
BEGIN:VCARD
VERSION:3.0
FN:John Doe
TEL:+1-555-123-4567
EMAIL:john.doe@example.com
ORG:Digital Disconnections
URL:https://example.com
ADR:;;123 Main St;Anytown;CA;12345;USA
END:VCARD
```

**Common Use Cases:**
- Business cards (physical card with QR code)
- Email signatures
- Conference badges
- Networking events
- Contact sharing between phones

**Why v1.0:**
- Extremely common use case
- Simple text format
- No privacy concerns (user controls what data to share)
- No external services required
- Universal support across all phones

**Implementation Notes:**
- Use vCard 3.0 for maximum compatibility
- All vCards must contain VERSION property
- Must begin with `BEGIN:VCARD` and end with `END:VCARD`

**Sources:**
- [RFC 6350: vCard Format Specification](https://www.rfc-editor.org/rfc/rfc6350.html)
- [QuickChart vCard QR Codes Documentation](https://quickchart.io/documentation/vcard-qr-codes/)

---

### 2. Email (mailto) QR Codes

**Priority:** HIGH

**Standard:** mailto URI scheme (widely standardized)

**Format:**
```
mailto:email@example.com?subject=Subject%20Text&body=Message%20body%20here
```

**Parameters:**
- `mailto:` - Required protocol
- Email address - Required
- `subject=` - Optional (URL encoded)
- `body=` - Optional (URL encoded)
- `cc=` - Optional (comma-separated for multiple)
- `bcc=` - Optional (comma-separated for multiple)

**Common Use Cases:**
- Customer support ("Send us feedback")
- Business contact information
- Event registration
- Report issues
- Newsletter signups

**Why v1.0:**
- Extremely simple format
- Universal support (all devices have email)
- No tracking or privacy issues
- Opens default mail app
- Very common use case

**Best Practices:**
- URL encode special characters and spaces
- Keep subject and body short (long content = complex QR)
- Use descriptive subject lines

**Example:**
```
mailto:support@digitaldisconnections.com?subject=App%20Feedback&body=Tell%20us%20what%20you%20think
```

**Sources:**
- [QuickChart Email QR Codes](https://quickchart.io/documentation/qr-codes/email-qr-codes/)
- [Linkly Mailto QR Codes](https://linklyhq.com/support/mailto-qr-codes)

---

### 3. Phone (tel) QR Codes

**Priority:** HIGH

**Standard:** tel URI scheme (RFC 3966)

**Format:**
```
tel:+1-212-555-1212
```

**Best Practices:**
- Always use international E.164 format
- Include country code with `+` prefix
- No spaces, dashes, or parentheses (some devices break)
- Example: `tel:+14155551234` (best)
- Avoid: `tel:415-555-1234` (local only, fails internationally)

**Common Use Cases:**
- Business contact cards
- Customer service "Call us" signs
- Emergency contacts
- Sales/support hotlines
- Restaurant/hotel room cards

**Why v1.0:**
- Universal need
- Simplest possible format
- No privacy concerns
- Opens phone dialer automatically
- Works on all devices

**Behavior:**
- Opens device dialer with pre-filled number
- Does NOT automatically initiate call (user must tap "Call")

**Sources:**
- [GitHub qrcode-library phone format](https://github.com/2amigos/qrcode-library/blob/master/docs/formats/phone.md)
- [QRStuff Phone Number Generator](https://www.qrstuff.com/type/phone-number)

---

### 4. SMS QR Codes

**Priority:** HIGH

**Standard:** SMSTO format (widely supported)

**Format Options:**
1. **Standard:** `SMSTO:+15551234567:Message text here`
2. **URI format:** `sms:+15551234567?body=Message text here`

**Variations:**
- Text only (no number): `SMSTO::Type your message here` (two colons)
- Number only (blank message): `SMSTO:+15551234567:` (blank after colon)

**Common Use Cases:**
- Customer feedback ("Text us your thoughts")
- Event RSVPs
- Opt-in for updates
- Support tickets
- Quick contact methods

**Why v1.0:**
- Very common use case
- Simple format
- No privacy concerns
- Opens SMS app with pre-filled message
- User still has control (must hit send)

**Best Practices:**
- Use international format (+country code)
- Max 160 characters for best compatibility
- Don't skip country code (fails for travelers)

**Example:**
```
SMSTO:+14155551234:Thanks for visiting! Text us your feedback.
```

**Sources:**
- [goQR SMS QR Code Documentation](https://goqr.me/qr-codes/type-qr-sms.html)
- [QR.io SMS QR Code Guide](https://qr.io/blog/sms-qr-code/)

---

### 5. Geo/Location QR Codes

**Priority:** HIGH

**Standard:** [RFC 5870](https://datatracker.ietf.org/doc/html/rfc5870) - geo URI scheme (published June 8, 2010 by IETF)

**Format:**
```
geo:latitude,longitude
geo:latitude,longitude,altitude
geo:latitude,longitude?u=uncertainty
```

**Default CRS:** World Geodetic System 1984 (WGS-84)

**Coordinate Requirements:**
- Latitude: -90 to 90 decimal degrees
- Longitude: -180 to 180 decimal degrees
- Altitude: optional (meters)
- Uncertainty parameter `u`: optional (meters)

**Examples:**
```
geo:37.786971,-122.399677
geo:37.786971,-122.399677,100
geo:37.786971,-122.399677?u=35
```

**Common Use Cases:**
- Business locations
- Event venues
- Meeting points
- Tourist attractions
- Delivery addresses
- Parking locations

**Why v1.0:**
- RFC standardized (RFC 5870)
- Simple format
- No privacy concerns (static location only)
- Opens default maps app
- Very useful for local businesses

**Behavior:**
- Opens device's default mapping application
- Shows location on map
- User can get directions

**Sources:**
- [RFC 5870: geo URI Specification](https://datatracker.ietf.org/doc/html/rfc5870)
- [geo URI scheme Wikipedia](https://en.wikipedia.org/wiki/Geo_URI_scheme)
- [geouri.org](https://geouri.org/)

---

### 6. Calendar/Event (iCalendar) QR Codes

**Priority:** MEDIUM

**Standard:** iCalendar format (RFC 5545) / ICS file format

**MIME Type:** `text/calendar`

**Format:**
```
BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
SUMMARY:Event Title
DTSTART:20260215T100000Z
DTEND:20260215T110000Z
LOCATION:123 Main St, City, State
DESCRIPTION:Event description here
END:VEVENT
END:VCALENDAR
```

**Common Use Cases:**
- Event invitations
- Conference sessions
- Webinar registration
- Appointment reminders
- Meeting scheduling

**Why Medium Priority:**
- More complex format than others
- Less frequently used than contact/email/phone
- Requires timezone handling (UTC conversion)
- Must URL encode entire string
- Still very useful for events

**Best Practices:**
- Use `Z` suffix for UTC time
- Convert local time to UTC or specify timezone
- URL encode the entire calendar string
- Keep descriptions short

**Implementation Complexity:** Medium (datetime handling, URL encoding)

**Sources:**
- [QuickChart Calendar Event QR Codes](https://quickchart.io/documentation/qr-codes/calendar-event-qr-codes/)
- [Scanova Calendar QR Code Guide](https://scanova.io/blog/calendar-qr-code/)

---

### 7. Social Media QR Codes

**Priority:** MEDIUM

**Standard:** No unified standard (platform-specific or URL-based)

**Approach Options:**

**Option A: Direct Profile URLs**
- Instagram: `https://instagram.com/username`
- Twitter/X: `https://twitter.com/username`
- Facebook: `https://facebook.com/username`
- LinkedIn: `https://linkedin.com/in/username`
- TikTok: `https://tiktok.com/@username`

**Option B: Platform Native QR Codes**
- Instagram has built-in QR codes (app navigation panel)
- Twitter has profile QR codes (app navigation bar)
- LinkedIn has QR codes (mobile app, QR icon)
- Facebook has page QR codes (More > Edit Page > QR code)

**Common Use Cases:**
- Influencer marketing
- Business social media promotion
- Event networking
- Content creator growth
- Brand awareness

**Why Medium Priority:**
- Users can just use platform's built-in QR codes
- Simple URL format works fine
- Not as universally needed as contact/email
- Target audience may prefer other methods

**Privacy Notes:**
- Direct URLs are privacy-respecting
- No tracking (just opens URL)
- User controls what they share

**Implementation:** Simple (just URL QR codes, already supported)

**Sources:**
- [QRCodeKIT Social Media QR Codes](https://qrcodekit.com/types/social-media-qr-code/)
- [QR.io Social Media Guide](https://qr.io/blog/qr-code-for-all-social-media/)

---

### 8. Payment QR Codes

**Priority:** LOW (Future consideration)

**Standards:**
- **EMVCo QR Code Specifications** - International standard (CPM and MPM modes)
- **X9 QR Code Standard** - U.S. standard (currently being drafted, 2026)
- **Platform-specific:** Venmo, PayPal, Cash App (proprietary formats)

**Why Low Priority:**
- Standards still evolving (X9 draft in 2026)
- Privacy concerns (user caution about QR payments)
- Security complexities
- Liability issues for app developer
- Platform-specific implementations (Venmo, PayPal are proprietary)
- Not aligned with "Digital Disconnections" privacy-first philosophy

**Privacy Concerns:**
- Payment data is sensitive
- Cybersecurity risks
- User trust issues with QR payments
- Requires secure, digitally signed codes

**Recommendation:**
- Skip for v1.0, v1.1, possibly v2.0
- Revisit when X9 standard finalizes
- Consider only if user demand is high
- Would require extensive security audit
- May require financial compliance

**If Implemented (Future):**
- Use open standards only (EMVCo, X9)
- Avoid proprietary platforms (Venmo, PayPal)
- Implement strong security measures
- Add prominent disclaimers
- Consider legal/financial liability

**Sources:**
- [X9 QR Code Standard (FedNow)](https://www.frbservices.org/financial-services/fednow/industry-stories/innovation-spotlight/qr-code-transactions)
- [EMVCo QR Code Specifications](https://www.emvco.com/emv-technologies/qr-codes/)
- [World Bank QR Codes in Payments Focus Note](https://fastpayments.worldbank.org/sites/default/files/2021-10/QR_Codes_in_Payments_Final.pdf)

---

## Implementation Roadmap

### v1.0 (High Priority - All Simple Formats)
1. **vCard/Contact** - Business cards, networking
2. **Email (mailto)** - Customer support, feedback
3. **Phone (tel)** - Direct calling
4. **SMS** - Text messaging
5. **Geo/Location** - Maps and addresses

**Rationale:**
- All are standardized formats
- All are simple to implement
- All are privacy-respecting
- All have universal device support
- All are commonly used daily

### v1.1 (Medium Priority)
6. **Calendar/Event** - More complex but useful
7. **Social Media** - Modern use case (if demand exists)

### Future (Low Priority)
8. **Payment QR codes** - Wait for standards to mature, assess demand

---

## Technical Implementation Notes

### QR Code Encoding
- All formats are text-based
- Use UTF-8 encoding
- URL encode when necessary (mailto, calendar)
- Error correction level: Medium (M) or High (H) recommended

### User Experience
- Generate QR code preview before saving
- Show decoded content in human-readable format
- Validate input before encoding
- Provide examples for each type
- Clear labels and instructions

### Privacy First
- All formats are static (no tracking)
- No external services required
- No data collection
- User controls all content
- Offline generation

### Testing
- Test on iOS and Android
- Verify all formats open correct apps
- Test international phone numbers
- Test special characters in text fields
- Test long content (QR complexity limits)

---

## Competitive Analysis

**Most QR apps include:**
1. URL - ✅ (Already have)
2. WiFi - ✅ (Already have)
3. vCard - ❌ (Need to add)
4. Email - ❌ (Need to add)
5. Phone - ❌ (Need to add)
6. SMS - ❌ (Need to add)
7. Location - ❌ (Need to add)

**Adding these 5 types brings the app to feature parity with major QR code apps, while maintaining privacy-first, ad-free philosophy.**

---

## Sources

### Standards Organizations
- [RFC 6350 (vCard 4.0)](https://www.rfc-editor.org/rfc/rfc6350.html)
- [RFC 5870 (geo URI)](https://datatracker.ietf.org/doc/html/rfc5870)
- [RFC 5545 (iCalendar)](https://datatracker.ietf.org/doc/html/rfc5545)
- [RFC 3966 (tel URI)](https://datatracker.ietf.org/doc/html/rfc3966)

### Documentation
- [QuickChart QR Code Documentation](https://quickchart.io/documentation/)
- [goQR.me QR Code Types](https://goqr.me/)
- [Scanova QR Code Types Guide](https://scanova.io/blog/types-of-qr-code-guide-uses-examples/)

### Industry Reports
- [QR Code Statistics 2026](https://www.qrcode-tiger.com/qr-code-statistics-2022-q1)
- [Types of QR Codes Guide](https://www.uniqode.com/qr-code-generator/types-of-qr-code)

### Payment Standards
- [EMVCo QR Specifications](https://www.emvco.com/emv-technologies/qr-codes/)
- [FedNow X9 QR Code Standard](https://www.frbservices.org/financial-services/fednow/)
- [Faster Payments Council QR White Paper](https://fasterpaymentscouncil.org/)

---

## Conclusion

**Recommended for v1.0:**
Add 5 new QR code types (vCard, Email, Phone, SMS, Geo) to reach feature parity with competitors while maintaining Digital Disconnections' privacy-first, ad-free philosophy.

**Total QR types after v1.0:** 7 types
- URL/Website ✅
- WiFi ✅
- vCard/Contact (NEW)
- Email (NEW)
- Phone (NEW)
- SMS (NEW)
- Geo/Location (NEW)

**All formats:**
- Are open standards
- Require no external services
- Have no tracking or analytics
- Respect user privacy
- Work offline
- Are free to use

**Aligned with "You shouldn't have to rent your own phone" philosophy.**
