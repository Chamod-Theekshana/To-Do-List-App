# App Icons Setup

## Required Files

You need to add these image files to this directory:

1. **app_icon.png** - 1024x1024 pixels (for launcher icon)
2. **splash_icon.png** - 512x512 pixels (for splash screen)

## Quick Setup Options

### Option 1: Use the provided SVG template
1. Convert `icon_template.svg` to PNG format (1024x1024) and rename to `app_icon.png`
2. Create a smaller version (512x512) and rename to `splash_icon.png`

### Option 2: Create your own icons
1. Design your app icon (1024x1024 PNG)
2. Design your splash screen icon (512x512 PNG)
3. Save them as `app_icon.png` and `splash_icon.png`

### Option 3: Use online tools
- Use tools like Canva, Figma, or Adobe Express to create icons
- Ensure PNG format with transparent background
- Follow the size requirements above

## After adding icons, run:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

## Colors Used
- Primary Blue: #2196F3
- Dark Blue: #1976D2

You can customize these colors in `pubspec.yaml` under the splash screen configuration.