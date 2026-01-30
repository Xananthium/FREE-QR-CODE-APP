# QR Code Scannability Testing Checklist

**Task**: FLUTTER 10.8 - QR Scannability Verification  
**Date**: _______________  
**Tester**: _______________  
**Devices**: _______________

## Test Environment Setup

### Devices
- [ ] iOS device (model: ___________)
- [ ] Android device (model: ___________)

### Scanner Apps Installed
- [ ] iOS Native Camera
- [ ] Android Native Camera  
- [ ] Google Lens (iOS)
- [ ] Google Lens (Android)
- [ ] Third-party QR app: ___________

### Test Networks Available
- [ ] WPA/WPA2 network (name: ___________)
- [ ] Open network (name: ___________)
- [ ] (Optional) WEP network (name: ___________)
- [ ] (Optional) Hidden network (name: ___________)

## Part 1: Basic Functionality Tests

### Test 1.1: Simple URL - No Border
**Configuration**:
- Type: URL
- Data: `https://example.com`
- Border: None
- Resolution: 1024×1024
- Format: PNG

**Results**:
- [ ] iOS Native Camera: PASS / FAIL (time: ___s)
- [ ] Android Native Camera: PASS / FAIL (time: ___s)
- [ ] Google Lens: PASS / FAIL (time: ___s)

**Notes**: _______________

### Test 1.2: Simple URL - Classic Border
**Configuration**:
- Type: URL
- Data: `https://example.com`
- Border: Classic
- Resolution: 1024×1024
- Format: PNG

**Results**:
- [ ] iOS Native Camera: PASS / FAIL (time: ___s)
- [ ] Android Native Camera: PASS / FAIL (time: ___s)

**Notes**: _______________

### Test 1.3: WiFi WPA - No Border
**Configuration**:
- Type: WiFi
- SSID: TestNetwork
- Password: Test123!@#
- Security: WPA
- Border: None
- Resolution: 1024×1024
- Format: PNG

**Results**:
- [ ] iOS connects successfully: PASS / FAIL
- [ ] Android connects successfully: PASS / FAIL
- [ ] Correct password filled: YES / NO

**Notes**: _______________

### Test 1.4: WiFi WPA - Classic Border
**Configuration**:
- Type: WiFi
- SSID: TestNetwork
- Password: Test123!@#
- Security: WPA
- Border: Classic
- Resolution: 1024×1024
- Format: PNG

**Results**:
- [ ] iOS connects successfully: PASS / FAIL
- [ ] Android connects successfully: PASS / FAIL

**Notes**: _______________

**Part 1 Status**: ⬜ ALL PASS ⬜ SOME FAILURES  
*If any failures in Part 1, investigate before continuing.*

---

## Part 2: URL QR Code - Comprehensive Tests

### Test 2.1: URL Variations

| URL Type | Data | Result | Time | Notes |
|----------|------|--------|------|-------|
| Simple | `https://example.com` | ⬜ PASS ⬜ FAIL | ___s | |
| With Path | `https://example.com/path/to/page` | ⬜ PASS ⬜ FAIL | ___s | |
| With Query | `https://example.com?q=test&lang=en` | ⬜ PASS ⬜ FAIL | ___s | |
| Special Chars | `https://example.com/path%20spaces` | ⬜ PASS ⬜ FAIL | ___s | |
| Long URL | `https://example.com/very/long/path/...` | ⬜ PASS ⬜ FAIL | ___s | |

**Configuration**: 1024×1024, PNG, No border, tested on iOS  
**Overall**: ⬜ ALL PASS ⬜ SOME FAILURES

### Test 2.2: Resolution Testing

Test URL: `https://example.com/test`  
Border: Classic  
Format: PNG

| Resolution | iOS Result | Android Result | Notes |
|------------|-----------|----------------|-------|
| 512×512 (Small) | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | |
| 1024×1024 (Medium) | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | |
| 2048×2048 (Large) | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | |
| 4096×4096 (XL) | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | |

**Overall**: ⬜ ALL PASS ⬜ SOME FAILURES

### Test 2.3: Border Type Testing

Test URL: `https://example.com/test`  
Resolution: 1024×1024  
Format: PNG  
Device: iOS (or specify: _________)

| Border Type | Scans? | Time | Quiet Zone OK? | Notes |
|-------------|--------|------|----------------|-------|
| None (baseline) | ⬜ PASS ⬜ FAIL | ___s | ⬜ YES | |
| Classic | ⬜ PASS ⬜ FAIL | ___s | ⬜ YES ⬜ NO | |
| Minimal | ⬜ PASS ⬜ FAIL | ___s | ⬜ YES ⬜ NO | |
| Rounded | ⬜ PASS ⬜ FAIL | ___s | ⬜ YES ⬜ NO | |
| Dotted | ⬜ PASS ⬜ FAIL | ___s | ⬜ YES ⬜ NO | |
| Geometric | ⬜ PASS ⬜ FAIL | ___s | ⬜ YES ⬜ NO | |
| Gradient | ⬜ PASS ⬜ FAIL | ___s | ⬜ YES ⬜ NO | |
| Floral | ⬜ PASS ⬜ FAIL | ___s | ⬜ YES ⬜ NO | |
| Ornate | ⬜ PASS ⬜ FAIL | ___s | ⬜ YES ⬜ NO | |
| Shadow | ⬜ PASS ⬜ FAIL | ___s | ⬜ YES ⬜ NO | |

**Overall**: ⬜ ALL PASS ⬜ SOME FAILURES  
**Quiet Zone Issues**: _______________

### Test 2.4: Scanning Distance

Test URL: `https://example.com/test`  
Resolution: 1024×1024  
Border: Classic  
Device: iOS

| Distance | Scans? | Time | Notes |
|----------|--------|------|-------|
| Close (10-20cm) | ⬜ PASS ⬜ FAIL | ___s | |
| Standard (30-50cm) | ⬜ PASS ⬜ FAIL | ___s | |
| Far (80-100cm) | ⬜ PASS ⬜ FAIL | ___s | |

**Overall**: ⬜ ALL PASS ⬜ SOME FAILURES

---

## Part 3: WiFi QR Code - Comprehensive Tests

### Test 3.1: Security Types

| Security | SSID | Password | iOS Connect | Android Connect | Notes |
|----------|------|----------|-------------|-----------------|-------|
| WPA | TestNetwork | Test123!@# | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | |
| Open (nopass) | OpenTest | (none) | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | |
| WEP | WEPTest | 1234567890 | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | |

**Configuration**: 1024×1024, PNG, Classic border  
**Overall**: ⬜ ALL PASS ⬜ SOME FAILURES

### Test 3.2: Special Characters

| SSID | Password | Connects? | Notes |
|------|----------|-----------|-------|
| TestNetwork | Test123!@# | ⬜ PASS ⬜ FAIL | Special chars in password |
| Test Network 2024 | Pass123 | ⬜ PASS ⬜ FAIL | Space in SSID |
| Test_Net | P@ss;w0rd:123 | ⬜ PASS ⬜ FAIL | Special chars: ; and : |
| TestNet | Pass\\"123 | ⬜ PASS ⬜ FAIL | Quotes in password |

**Configuration**: 1024×1024, PNG, No border  
**Overall**: ⬜ ALL PASS ⬜ SOME FAILURES

### Test 3.3: Hidden Network

| SSID | Password | Hidden? | iOS Connect | Android Connect | Notes |
|------|----------|---------|-------------|-----------------|-------|
| HiddenNet | Secret123 | YES | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | H:true flag |

**Configuration**: 1024×1024, PNG, No border  
**Overall**: ⬜ PASS ⬜ FAIL

### Test 3.4: WiFi with Borders

Test Network: WPA, SSID: TestNetwork, Password: Test123!@#  
Resolution: 1024×1024  
Format: PNG

| Border | iOS Connect | Android Connect | Notes |
|--------|-------------|-----------------|-------|
| None | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | Baseline |
| Classic | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | |
| Minimal | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | |
| Floral | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | |
| Ornate | ⬜ PASS ⬜ FAIL | ⬜ PASS ⬜ FAIL | |

**Overall**: ⬜ ALL PASS ⬜ SOME FAILURES

---

## Part 4: Format and Quality Tests

### Test 4.1: PNG vs JPEG

Test URL: `https://example.com/test`  
Resolution: 1024×1024  
Border: Classic

| Format | Quality | Scans? | Time | Visual Quality | Notes |
|--------|---------|--------|------|----------------|-------|
| PNG | N/A | ⬜ PASS ⬜ FAIL | ___s | ⬜ Perfect ⬜ Good ⬜ Poor | |
| JPEG | 85 (default) | ⬜ PASS ⬜ FAIL | ___s | ⬜ Perfect ⬜ Good ⬜ Poor | |
| JPEG | 100 (max) | ⬜ PASS ⬜ FAIL | ___s | ⬜ Perfect ⬜ Good ⬜ Poor | |
| JPEG | 50 (low) | ⬜ PASS ⬜ FAIL | ___s | ⬜ Perfect ⬜ Good ⬜ Poor | |

**Overall**: ⬜ ALL PASS ⬜ JPEG HAS ISSUES  
**Recommendation**: _______________

### Test 4.2: Compression Artifacts

Examine JPEG exports at 85% quality for artifacts:
- [ ] No visible artifacts
- [ ] Minor artifacts (corners, edges)
- [ ] Moderate artifacts (visible but scannable)
- [ ] Severe artifacts (may affect scannability)

**Visual inspection**: _______________  
**Impact on scanning**: _______________

---

## Part 5: Edge Case and Stress Tests

### Test 5.1: Lighting Conditions

Test URL: `https://example.com/test`  
Resolution: 1024×1024  
Border: Classic

| Condition | Scans? | Time | Notes |
|-----------|--------|------|-------|
| Normal indoor | ⬜ PASS ⬜ FAIL | ___s | Baseline |
| Low light | ⬜ PASS ⬜ FAIL | ___s | Dim room |
| Bright sunlight | ⬜ PASS ⬜ FAIL | ___s | Direct sun, possible glare |
| Backlit screen | ⬜ PASS ⬜ FAIL | ___s | Screen brightness max |

**Overall**: ⬜ ALL PASS ⬜ SOME ISSUES  
**Worst condition**: _______________

### Test 5.2: Scanning Angle

Test URL: `https://example.com/test`  
Resolution: 1024×1024  
Border: Classic  
Distance: Standard (30-50cm)

| Angle | Scans? | Time | Notes |
|-------|--------|------|-------|
| 0° (perpendicular) | ⬜ PASS ⬜ FAIL | ___s | Baseline |
| 30° angle | ⬜ PASS ⬜ FAIL | ___s | |
| 45° angle | ⬜ PASS ⬜ FAIL | ___s | |
| 60° angle | ⬜ PASS ⬜ FAIL | ___s | Severe angle |

**Overall**: ⬜ ALL PASS ⬜ SOME ISSUES  
**Maximum working angle**: _______________

### Test 5.3: Minimum Resolution

Test same QR at smallest resolution:

Test URL: `https://example.com/test`  
Resolution: 512×512 (smallest)  
Border: Classic

| Device | Scans? | Time | Notes |
|--------|--------|------|-------|
| iOS | ⬜ PASS ⬜ FAIL | ___s | |
| Android | ⬜ PASS ⬜ FAIL | ___s | |

**Long URL** (200+ chars) at 512×512:
- [ ] PASS
- [ ] FAIL - Data too dense for small resolution

**Overall**: ⬜ 512px is adequate ⬜ 512px has issues

### Test 5.4: Maximum Data Density

Long URL (stress test):
```
https://example.com/very/long/path/with/many/segments/to/test/maximum/data/density/and/ensure/scannability/with/high/information/content/in/qr/code/that/might/challenge/scanners/especially/at/lower/resolutions
```

| Resolution | Border | Scans? | Time | Notes |
|------------|--------|--------|------|-------|
| 512×512 | None | ⬜ PASS ⬜ FAIL | ___s | |
| 1024×1024 | None | ⬜ PASS ⬜ FAIL | ___s | |
| 1024×1024 | Classic | ⬜ PASS ⬜ FAIL | ___s | |
| 2048×2048 | Classic | ⬜ PASS ⬜ FAIL | ___s | |

**Overall**: ⬜ ALL PASS ⬜ SOME ISSUES  
**Recommendation**: _______________

---

## Part 6: Quiet Zone Verification

### Test 6.1: Visual Measurement

Export a QR at 2048×2048 with Classic border:
1. Open in image editor
2. Measure QR code width: _____ px
3. Measure quiet zone (white space): _____ px
4. Calculate percentage: (quiet zone / QR width) × 100 = _____%

**Expected**: ≥10% (minimum), ≥15% (recommended)  
**Result**: ⬜ PASS ⬜ FAIL

### Test 6.2: Border Encroachment Check

For each border type at 1024×1024, visually inspect:

| Border | Quiet Zone Clear? | Decorations Separated? | Notes |
|--------|-------------------|------------------------|-------|
| Classic | ⬜ YES ⬜ NO | ⬜ YES ⬜ NO | |
| Minimal | ⬜ YES ⬜ NO | ⬜ YES ⬜ NO | |
| Rounded | ⬜ YES ⬜ NO | ⬜ YES ⬜ NO | |
| Dotted | ⬜ YES ⬜ NO | ⬜ YES ⬜ NO | |
| Geometric | ⬜ YES ⬜ NO | ⬜ YES ⬜ NO | |
| Gradient | ⬜ YES ⬜ NO | ⬜ YES ⬜ NO | |
| Floral | ⬜ YES ⬜ NO | ⬜ YES ⬜ NO | |
| Ornate | ⬜ YES ⬜ NO | ⬜ YES ⬜ NO | |
| Shadow | ⬜ YES ⬜ NO | ⬜ YES ⬜ NO | |

**Overall**: ⬜ ALL BORDERS COMPLIANT ⬜ ISSUES FOUND  
**Issues**: _______________

### Test 6.3: Programmatic Validation

Run QRValidator utility on all export resolutions:

```dart
// Expected results:
// 512px with 10% padding: ADEQUATE
// 1024px with 10% padding: ADEQUATE  
// 2048px with 10% padding: ADEQUATE
// 4096px with 10% padding: ADEQUATE
```

- [ ] All resolutions pass validation
- [ ] Issues found: _______________

---

## Summary and Results

### Overall Statistics

**Total Tests Conducted**: _____  
**Tests Passed**: _____  
**Tests Failed**: _____  
**Pass Rate**: _____%

### Critical Test Results

- [ ] Basic URL QR scans (Part 1)
- [ ] Basic WiFi QR connects (Part 1)
- [ ] All resolutions scannable (Test 2.2)
- [ ] All borders maintain quiet zone (Test 6.2)
- [ ] WiFi special characters work (Test 3.2)

**Critical Issues**: ⬜ NONE ⬜ FOUND (see below)

### Issues Found

#### Critical Issues (Block Release)
1. Issue: _______________
   - Configuration: _______________
   - Impact: _______________
   - Fix needed: _______________

#### Minor Issues (Can Release)
1. Issue: _______________
   - Configuration: _______________
   - Impact: _______________
   - Priority: LOW / MEDIUM

### Recommendations

1. _______________
2. _______________
3. _______________

### Task Completion

**FLUTTER 10.8 Status**:
- ⬜ COMPLETE - All acceptance criteria met, no critical issues
- ⬜ BLOCKED - Critical issues must be resolved
- ⬜ IN PROGRESS - Testing continues

**Sign-off**:
- Tester: _______________ Date: _______________
- Reviewer: _______________ Date: _______________

---

## Notes and Observations

_______________________________________________
_______________________________________________
_______________________________________________
_______________________________________________
_______________________________________________
