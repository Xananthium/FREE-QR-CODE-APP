# Responsive Design System

## Overview
This app now includes a comprehensive responsive design system that adapts seamlessly across phones, tablets, and desktop/web platforms.

## Breakpoints
- **Phone (Small)**: < 600px width
- **Tablet (Medium)**: 600px - 1200px width
- **Desktop (Large)**: > 1200px width
- **Extra Large Desktop**: > 1600px width

## Usage

### 1. Quick Access via Extension
```dart
final responsive = context.responsive;

// Check device type
if (responsive.isPhone) {
  // Phone-specific layout
} else if (responsive.isTablet) {
  // Tablet layout
} else {
  // Desktop layout
}
```

### 2. Responsive Values
```dart
final padding = responsive.value(
  phone: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);
```

### 3. Pre-built Responsive Padding
```dart
Padding(
  padding: responsive.horizontalPadding, // 16/32/48
  child: child,
)

Padding(
  padding: responsive.padding, // 16/24/32 all sides
  child: child,
)
```

### 4. ResponsiveLayout Widget
```dart
ResponsiveLayout(
  phone: PhoneLayout(),
  tablet: TabletLayout(),   // Falls back to phone if not provided
  desktop: DesktopLayout(), // Falls back to tablet/phone
)
```

### 5. ResponsiveCenter Widget
```dart
// Constrains content width for desktop, full width on mobile
ResponsiveCenter(
  child: content,
)
```

### 6. ResponsiveRowColumn Widget
```dart
// Automatically switches between Row and Column
ResponsiveRowColumn(
  spacing: 16,
  children: [
    item1,
    item2,
  ],
)
```

### 7. ResponsiveGrid Widget
```dart
ResponsiveGrid(
  phoneColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  children: items,
)
```

## Responsive Properties

### Spacing
- `responsive.spacing` - 8/12/16
- `responsive.cardSpacing` - 16/24/32

### Icons
- `responsive.iconSize` - 24/28/32

### Layout
- `responsive.maxContentWidth` - ∞/800/1200
- `responsive.gridColumns` - 1/2/3
- `responsive.gridAspectRatio` - 1.0/1.2/1.5

## Implemented Screens

### Home Screen
- Logo size scales responsively
- Cards switch between vertical (phone) and horizontal (tablet/desktop) layout
- Spacing and typography scale appropriately

### Customize Screen
- Phone: Vertical stacking
- Tablet: Side-by-side preview and controls (40/60 split)
- Desktop: Centered preview, controls in 2-column grid

### Future Screens
All screens should follow these patterns for consistency.

## Testing Responsiveness

### Chrome DevTools
1. Run: `flutter run -d chrome`
2. Open Chrome DevTools (F12)
3. Click "Toggle Device Toolbar" (Cmd+Shift+M)
4. Test different device sizes:
   - iPhone SE (375x667) - Phone
   - iPad (768x1024) - Tablet
   - Desktop (1440x900) - Desktop

### Visual Studio Code
1. Run: `flutter run -d chrome`
2. Resize browser window to test different breakpoints

## Best Practices

1. **Use responsive.value() for dimensions**
   ```dart
   fontSize: responsive.value(phone: 14.0, tablet: 16.0, desktop: 18.0)
   ```

2. **Use responsive padding helpers**
   ```dart
   Padding(padding: responsive.horizontalPadding, child: ...)
   ```

3. **Use ResponsiveLayout for different layouts**
   ```dart
   ResponsiveLayout(
     phone: _buildPhoneLayout(),
     desktop: _buildDesktopLayout(),
   )
   ```

4. **Wrap wide content with ResponsiveCenter**
   ```dart
   ResponsiveCenter(child: content)
   ```

5. **Use ResponsiveRowColumn for flexible layouts**
   ```dart
   ResponsiveRowColumn(children: [a, b, c])
   ```

## Migration Guide

To make an existing screen responsive:

1. **Import responsive utils**
   ```dart
   import '../../core/utils/responsive.dart';
   ```

2. **Get responsive instance**
   ```dart
   final responsive = context.responsive;
   ```

3. **Replace fixed padding**
   ```dart
   // Before
   padding: EdgeInsets.all(16)
   
   // After
   padding: responsive.padding
   ```

4. **Make sizes responsive**
   ```dart
   // Before
   height: 280
   
   // After
   height: responsive.value(phone: 280.0, tablet: 320.0, desktop: 360.0)
   ```

5. **Use responsive layouts**
   ```dart
   // Before
   Row(children: [a, b])
   
   // After
   ResponsiveRowColumn(children: [a, b])  // Auto switches to Column on phone
   ```

## Acceptance Criteria Met

✅ Works on phones (< 600px) - Vertical stacking, compact spacing
✅ Works on tablets (600-1200px) - Side-by-side layouts where appropriate
✅ Works on desktop/web (> 1200px) - Max-width constraints, multi-column grids
✅ Adaptive layouts - Components intelligently adapt to available space
✅ Responsive spacing - Padding and margins scale with screen size
✅ Responsive typography - Text sizes scale appropriately
✅ Responsive icons - Icon sizes scale with device type

