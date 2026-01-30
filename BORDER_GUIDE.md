# QR Code Border Frame System

## Generated PNG Borders (Z-Image Turbo)

**Location**: http://71.112.215.60:8188/output/

**Total**: 30 borders @ 1024x1024px

### Categories

#### Punk Rock (5)
- `punk_torn` - Torn paper, safety pins, spray paint
- `punk_pins` - Safety pins & chains, metallic
- `punk_grunge` - Spray paint drips, stencil
- `punk_anarchy` - Anarchy symbols, torn denim
- `punk_chains` - Chain links, padlocks

#### Cyberpunk (5)
- `cyber_glitch` - Neon glitch effects, digital corruption
- `cyber_neon` - Bright neon grid, holographic
- `cyber_circuit` - Circuit board traces
- `cyber_matrix` - Matrix falling code
- `cyber_holo` - Holographic iridescent

#### Hard/Edgy (5)
- `edgy_skull` - Skull motifs, lightning
- `edgy_lightning` - Electric bolts, sharp angles
- `edgy_metal` - Brushed metal, industrial bolts
- `edgy_flame` - Fire border, intense
- `edgy_blade` - Sharp blade edges, steel

#### Creatures (5 - original designs)
- `creature_blob` - Cute blob monsters
- `creature_plant` - Venus flytrap friends
- `creature_cloud` - Fluffy cloud creatures
- `creature_gem` - Crystal buddies
- `creature_goo` - Translucent slime squad

#### Cats (5)
- `cat_anime` - Kawaii anime cats, paw prints
- `cat_cyber` - Cyberpunk neon cats
- `cat_punk` - Grunge cats with mohawks
- `cat_galaxy` - Cosmic space cats
- `cat_ninja` - Stealth ninja cats

#### Kawaii (5 - original designs, NOT Hello Kitty)
- `kawaii_stars` - Stars, hearts, clouds
- `kawaii_bows` - Ribbons and bows
- `kawaii_hearts` - Heart border
- `kawaii_sweets` - Desserts (donuts, cupcakes)
- `kawaii_flowers` - Cherry blossoms, daisies

## Usage in Flutter

### 1. Download Generated Borders

```bash
# Download all borders from server
curl http://71.112.215.60:8188/view?filename=punk_torn_00001_.png > punk_torn.png
# Repeat for all 30...
```

### 2. Add to Assets

```
barcode_app/assets/borders/
├── punk_torn.png
├── punk_pins.png
├── cyber_glitch.png
├── cat_anime.png
└── ... (30 total)
```

### 3. Update pubspec.yaml

```yaml
flutter:
  assets:
    - assets/images/
    - assets/borders/
```

### 4. Use in QR Display

```dart
Stack(
  alignment: Alignment.center,
  children: [
    // Border frame (background)
    Image.asset(
      'assets/borders/cat_anime.png',
      width: 300,
      height: 300,
      fit: BoxFit.contain,
    ),
    // QR code (foreground - centered in frame)
    Container(
      width: 200,
      height: 200,
      child: QrImageView(data: qrData),
    ),
  ],
)
```

## Border Selection UI

Create a gallery where users can pick a border style:

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: 1,
  ),
  itemCount: borders.length,
  itemBuilder: (context, index) {
    return GestureDetector(
      onTap: () => selectBorder(borders[index]),
      child: Image.asset('assets/borders/${borders[index]}.png'),
    );
  },
)
```

## Fixed Provider Error

**Problem**: `ExportProvider` was missing from main.dart providers list

**Fixed in**: `/Users/xananthium/Performative/barcode/barcode_app/lib/main.dart`

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => QRProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => ExportProvider()), // ✅ ADDED
  ],
  // ...
)
```

## Next Steps

1. ✅ Border generation running (30 frames)
2. ⏳ Download borders from server
3. ⏳ Add borders to Flutter assets
4. ⏳ Create border picker UI
5. ⏳ Integrate borders with QR display
6. ⏳ Add to customize screen

## Notes

- All borders are 1024x1024 square
- QR code should be centered in frame
- Borders have transparent/clear center for QR
- Each border has unique aesthetic matching its category
- Cat borders are prioritized per user request
