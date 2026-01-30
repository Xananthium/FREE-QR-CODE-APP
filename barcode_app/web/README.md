# Web Configuration for Barcode Scanner PWA

## Overview
This directory contains the web-specific configuration for the Barcode Scanner Flutter Progressive Web App (PWA).

## Files

### manifest.json
Production-ready PWA manifest with:
- App name: "Barcode Scanner"
- Professional description
- Blue theme (#2196F3)
- Standalone display mode
- Categories: productivity, utilities
- Proper icon configuration (192x192, 512x512, maskable variants)

### index.html
Production-ready HTML with:
- SEO meta tags (title, description, keywords)
- Open Graph tags for social media sharing
- Twitter Card tags
- Proper viewport configuration
- iOS PWA meta tags
- Theme color configuration
- Service worker registration

### Icons
- `favicon.png` - Browser favicon
- `icons/Icon-192.png` - PWA icon (192x192)
- `icons/Icon-512.png` - PWA icon (512x512)
- `icons/Icon-maskable-192.png` - Maskable icon (192x192)
- `icons/Icon-maskable-512.png` - Maskable icon (512x512)

## Service Worker

The service worker (`flutter_service_worker.js`) is **automatically generated** by Flutter during the build process.

### Build Command
```bash
flutter build web --release
```

This will:
1. Generate `flutter_service_worker.js` with proper caching strategies
2. Create optimized assets
3. Configure offline support
4. Set up asset precaching

### Service Worker Features (Auto-Generated)
- Asset caching for offline access
- Automatic updates when new versions are deployed
- Network-first strategy for API calls
- Cache-first strategy for static assets

## Deployment

1. Build the web app:
   ```bash
   cd /Users/xananthium/Performative/barcode/barcode_app
   flutter build web --release
   ```

2. Deploy the `build/web` directory to your hosting service

3. Ensure HTTPS is enabled (required for PWA features)

## Testing

### Local Testing
```bash
flutter run -d chrome --web-renderer html
# or
flutter run -d chrome --web-renderer canvaskit
```

### PWA Testing
1. Build for release: `flutter build web --release`
2. Serve locally: `python3 -m http.server 8000 --directory build/web`
3. Open in Chrome: `http://localhost:8000`
4. Check PWA features in DevTools > Application

### Lighthouse Audit
Run Google Lighthouse to verify PWA compliance:
1. Open in Chrome
2. DevTools > Lighthouse
3. Select "Progressive Web App"
4. Generate report

## Configuration Notes

### Theme Color
- Primary: #2196F3 (Material Blue)
- Background: #FFFFFF (White)

### Display Mode
- `standalone` - App looks like a native app without browser UI

### Orientation
- `portrait-primary` - Optimized for portrait mode

### Start URL & Scope
- Both set to `/` for root deployment
- Update if deploying to a subdirectory

## Browser Support

Supports all modern browsers:
- Chrome/Edge (Chromium) - Full PWA support
- Safari (iOS/macOS) - Partial PWA support
- Firefox - Full PWA support

## Performance Optimization

The configuration includes:
- Preconnect hints for Google Fonts
- Async loading of Flutter bootstrap
- Optimized viewport settings
- Proper caching via service worker

## Security

- HTTPS required for service worker and PWA features
- Content Security Policy can be added via meta tags if needed
- No external scripts loaded (except Flutter's own)

## Updates

When deploying updates:
1. Flutter automatically updates `flutter_service_worker.js`
2. Users will get the update on next visit
3. Service worker handles cache invalidation automatically

## Troubleshooting

### PWA not installing
- Verify HTTPS is enabled
- Check manifest.json is accessible
- Verify service worker registration in DevTools

### Icons not showing
- Check icon paths in manifest.json
- Verify icon files exist in `icons/` directory
- Clear browser cache and retry

### Service worker errors
- Rebuild the app: `flutter build web --release`
- Check console for specific errors
- Verify flutter_service_worker.js was generated
