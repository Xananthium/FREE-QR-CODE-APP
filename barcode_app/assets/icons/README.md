# App Icon System - QR Code Generator

## Design Concept: "Pixelated Portal"

**Aesthetic**: Neo-brutalist QR code with 3D dimensional depth and vibrant gradient energy

**Key Features**:
- 3D-extruded QR pattern blocks with isometric perspective
- Radial gradient flow: violet core → magenta → cyan → lime edges
- Sharp pixel edges with subtle highlights
- Deep gradient background (#1a1a2e to #0a0a0f)
- Dimensional shadows and depth effects

## How to Generate Icons

### Step 1: Open Icon Generator
1. Open `icon_generator.html` in your browser
2. You'll see all required icon sizes displayed

### Step 2: Download Icons
Click "Download PNG" for each size. The key sizes you need:

**iOS**:
- icon_1024.png (App Store)
- icon_180.png (iPhone 3x)
- icon_167.png (iPad Pro)
- icon_152.png (iPad 2x)
- icon_120.png (iPhone 2x, iPad 3x)

**Android**:
- icon_432.png (Adaptive launcher)
- icon_192.png (xxxhdpi)
- icon_144.png (xxhdpi)
- icon_96.png (xhdpi)
- icon_72.png (hdpi)
- icon_48.png (mdpi)

**Web/PWA**:
- icon_512.png (PWA large)
- icon_192.png (PWA standard)

### Step 3: Create Adaptive Icon Foreground
For Android adaptive icons, you need a transparent foreground:
1. Download icon_432.png
2. Save as `icon_adaptive_foreground.png` in this folder
3. (The background color is handled in flutter_launcher_icons.yaml)

### Step 4: Run Flutter Launcher Icons
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

This will automatically generate all platform-specific icons from your downloaded images.

## Design Philosophy

**"Pixelated Portal"** - The QR code isn't just a static square. It's a dimensional gateway that generates vibrant, living codes. The 3D extrusion suggests depth and creation, while the radial gradient from violet to lime creates energy and movement from center to edge.

**Why this works**:
- ✅ Instantly recognizable as a QR code app
- ✅ Memorable 3D effect stands out in app grids
- ✅ Vibrant gradients catch the eye
- ✅ Sharp geometry feels modern and precise
- ✅ Neo-brutalist aesthetic avoids generic flat design

## Technical Notes

- All icons generated via HTML5 Canvas
- High DPI support (retina-ready)
- Programmatic generation ensures consistency
- Gradient calculations use radial distance for smooth transitions
- 3D effect achieved with shadow layers and face rendering
