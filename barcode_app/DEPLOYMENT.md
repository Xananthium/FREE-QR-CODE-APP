# Barcode Scanner - Web Deployment Guide

## Current Status

**Build Status:** COMPLETE  
**Local Testing:** http://localhost:8080 (currently running)  
**Build Date:** January 29, 2026  
**Build Size:** ~2.8MB (main.dart.js)

## Production Deployment Options

### Option 1: Netlify (Recommended - Fastest)

#### Prerequisites
```bash
npm install -g netlify-cli
```

#### Deploy Steps
```bash
# Navigate to project
cd /Users/xananthium/Performative/barcode/barcode_app

# Deploy to Netlify
netlify deploy --prod --dir=build/web
```

**First Time Setup:**
1. CLI will open browser for authentication
2. Choose "Create & configure a new site"
3. Select team (or create new)
4. Enter site name (e.g., barcode-scanner-app)
5. Confirm deployment

**Subsequent Deploys:**
```bash
# Rebuild and deploy
flutter build web --release
netlify deploy --prod --dir=build/web
```

**Features:**
- Automatic HTTPS/SSL
- Global CDN
- Free tier (100GB bandwidth/month)
- Custom domain support
- Instant rollbacks
- Deploy previews

---

### Option 2: Firebase Hosting (Google Ecosystem)

#### Prerequisites
```bash
npm install -g firebase-tools
```

#### First Time Setup
```bash
cd /Users/xananthium/Performative/barcode/barcode_app

# Login to Firebase
firebase login

# Initialize hosting
firebase init hosting
```

**Configuration:**
- Public directory: `build/web`
- Single-page app: `Yes`
- Automatic builds with GitHub: `No`

#### Deploy
```bash
# Build and deploy
flutter build web --release
firebase deploy --only hosting
```

**Features:**
- Automatic HTTPS/SSL
- Google's global CDN
- Free tier (10GB storage, 360MB/day transfer)
- Firebase ecosystem integration
- Custom domain support
- Version history

---

### Option 3: GitHub Pages (Free for Public Repos)

#### Prerequisites
- GitHub repository (public)
- Git installed

#### Setup
```bash
cd /Users/xananthium/Performative/barcode/barcode_app

# Initialize git if not already
git init
git add .
git commit -m "Initial commit"

# Add GitHub remote
git remote add origin https://github.com/yourusername/barcode-scanner.git
git push -u origin main

# Build web
flutter build web --release --base-href "/barcode-scanner/"

# Deploy to gh-pages branch
git subtree push --prefix build/web origin gh-pages
```

**Enable GitHub Pages:**
1. Go to repository Settings
2. Pages section
3. Source: Deploy from branch
4. Branch: gh-pages, root
5. Save

**URL:** `https://yourusername.github.io/barcode-scanner/`

**Features:**
- Free for public repos
- HTTPS included
- Custom domain support
- Automatic deployment from branch

---

### Option 4: Vercel (Optimal Performance)

#### Prerequisites
```bash
npm install -g vercel
```

#### Deploy
```bash
cd /Users/xananthium/Performative/barcode/barcode_app

# Login and deploy
vercel --prod
```

**Configuration:**
- Framework: Other
- Output directory: `build/web`

**Features:**
- Automatic HTTPS
- Edge network (fastest)
- Free tier (100GB bandwidth)
- Serverless functions
- Analytics included

---

## Post-Deployment Verification

### 1. Basic Functionality
- [ ] App loads without errors
- [ ] UI renders correctly
- [ ] Navigation works
- [ ] Settings page accessible

### 2. PWA Features
- [ ] Service worker registers (DevTools > Application > Service Workers)
- [ ] Manifest loads (DevTools > Application > Manifest)
- [ ] Install prompt appears (in supported browsers)
- [ ] App works offline (reload page after first visit)

### 3. Core Features
- [ ] Camera permissions prompt (if supported)
- [ ] Barcode scanning functionality
- [ ] History saves and loads
- [ ] Export to CSV works
- [ ] Settings persist across sessions

### 4. Performance Testing

**Using Lighthouse (Chrome DevTools):**
```
1. Open deployed URL
2. DevTools (F12) > Lighthouse
3. Select: Progressive Web App
4. Generate report
```

**Target Scores:**
- PWA: 90+
- Performance: 80+
- Accessibility: 90+
- Best Practices: 90+
- SEO: 90+

### 5. Browser Compatibility

Test in:
- Chrome/Edge (Chromium) - Full PWA support
- Safari (macOS/iOS) - Partial PWA support
- Firefox - Full PWA support
- Mobile browsers - Camera access may vary

---

## Current Build Information

### Files Generated
```
build/web/
├── assets/               # Flutter assets
├── canvaskit/           # Flutter rendering engine
├── icons/               # PWA icons (192x192, 512x512)
├── favicon.png          # Browser icon
├── flutter_bootstrap.js # Flutter loader
├── flutter_service_worker.js # PWA service worker
├── flutter.js           # Flutter runtime
├── index.html           # Main HTML
├── main.dart.js         # Compiled Dart (2.8MB)
├── manifest.json        # PWA manifest
└── version.json         # Build version
```

### PWA Manifest Details
```json
{
  "name": "Barcode Scanner",
  "short_name": "Barcode",
  "description": "Professional barcode scanner and QR code reader",
  "start_url": "/",
  "display": "standalone",
  "theme_color": "#2196F3",
  "background_color": "#FFFFFF"
}
```

### Service Worker
- Auto-generated by Flutter
- Handles offline caching
- Updates automatically on new deployments
- Caches all static assets

---

## Local Testing

### Current Test Server
```bash
# Server is running at:
http://localhost:8080

# To stop:
kill $(cat /tmp/web_server.pid)

# To restart:
cd /Users/xananthium/Performative/barcode/barcode_app/build/web
python3 -m http.server 8080
```

### Alternative Local Servers

**Using Flutter:**
```bash
cd /Users/xananthium/Performative/barcode/barcode_app
flutter run -d chrome --web-renderer html
```

**Using Node:**
```bash
npx serve build/web
```

---

## Deployment Commands Quick Reference

### Rebuild
```bash
cd /Users/xananthium/Performative/barcode/barcode_app
flutter build web --release
```

### Deploy to Netlify
```bash
netlify deploy --prod --dir=build/web
```

### Deploy to Firebase
```bash
firebase deploy --only hosting
```

### Deploy to Vercel
```bash
vercel --prod
```

### Deploy to GitHub Pages
```bash
flutter build web --release --base-href "/repo-name/"
git subtree push --prefix build/web origin gh-pages
```

---

## Custom Domain Setup

### Netlify
1. Netlify Dashboard > Domain Settings
2. Add custom domain
3. Follow DNS configuration instructions

### Firebase
1. Firebase Console > Hosting
2. Add custom domain
3. Verify ownership
4. Update DNS records

### GitHub Pages
1. Repository Settings > Pages
2. Custom domain field
3. Add CNAME record to DNS

### Vercel
1. Vercel Dashboard > Domains
2. Add domain
3. Configure DNS

---

## Troubleshooting

### PWA Not Installing
**Symptoms:** No install button in browser
**Solutions:**
- Ensure HTTPS is enabled (all services provide this)
- Verify manifest.json loads correctly
- Check service worker registration in DevTools
- Try in different browser

### Camera Not Working
**Symptoms:** Camera permission denied or not accessible
**Solutions:**
- HTTPS is required (HTTP won't work)
- Check browser camera permissions
- Some browsers don't support camera on web
- Test in Chrome first (best support)

### App Not Loading
**Symptoms:** White screen or errors
**Solutions:**
- Check browser console for errors
- Verify all files deployed correctly
- Check base-href if using subdirectory
- Clear browser cache and retry

### Service Worker Errors
**Symptoms:** Offline mode not working
**Solutions:**
- Rebuild: `flutter build web --release`
- Clear service workers in DevTools
- Hard refresh (Cmd+Shift+R / Ctrl+Shift+F5)
- Check service worker registration script

### Performance Issues
**Symptoms:** Slow loading
**Solutions:**
- Ensure using `--release` build (not debug)
- Check CDN/hosting provider status
- Consider using `--web-renderer=html` for better compatibility
- Enable gzip compression on server

---

## Security Considerations

### HTTPS Required
- Service worker requires HTTPS
- Camera API requires HTTPS
- Geolocation requires HTTPS
- All hosting options provide automatic HTTPS

### Content Security Policy (Optional)
Add to `web/index.html` if needed:
```html
<meta http-equiv="Content-Security-Policy" 
      content="default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';">
```

### Privacy
- No tracking by default
- No external API calls
- Data stored locally only
- No user data collected

---

## Monitoring & Analytics (Optional)

### Add Google Analytics
1. Get GA tracking ID
2. Add to `web/index.html`:
```html
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

### Firebase Analytics
- Automatic with Firebase Hosting
- No code changes needed
- View in Firebase Console

---

## Next Steps

1. **Choose Hosting Provider** (Recommended: Netlify for simplicity)
2. **Deploy to Production**
3. **Test Deployment** (use checklist above)
4. **Run Lighthouse Audit**
5. **Set Up Custom Domain** (optional)
6. **Add Analytics** (optional)
7. **Share URL** 🎉

---

## Support & Resources

- **Flutter Web Docs:** https://docs.flutter.dev/platform-integration/web
- **PWA Guide:** https://web.dev/progressive-web-apps/
- **Netlify Docs:** https://docs.netlify.com/
- **Firebase Docs:** https://firebase.google.com/docs/hosting
- **Lighthouse:** https://developers.google.com/web/tools/lighthouse

---

**Last Updated:** January 29, 2026  
**Flutter Version:** Check with `flutter --version`  
**Build Type:** Release  
**Web Renderer:** Auto (canvaskit/html)
