# Innerverse App Icons

## Design Concept

The Innerverse icon represents interconnected nodes forming a constellation - symbolizing the multiple inner selves that users explore within the app.

**Key Elements:**
- Central node: The core self
- Orbiting nodes: Different inner personas (Inner Child, Shadow Self, Ideal Self, etc.)
- Connecting lines: Relationships and dialogues between selves
- Gradient: Deep purple → teal representing the cosmic/ethereal aesthetic

## Generating Icons

### Option 1: Using flutter_launcher_icons

1. Place your source icon at `assets/icons/app_icon.png` (1024x1024 minimum)
2. Run: `flutter pub run flutter_launcher_icons`

### Option 2: Manual Generation

Use a tool like https://appicon.co/ or Adobe XD to generate all sizes from `app_icon.svg`.

## Required Sizes

### Android
- `mipmap-mdpi/ic_launcher.png` - 48x48
- `mipmap-hdpi/ic_launcher.png` - 72x72
- `mipmap-xhdpi/ic_launcher.png` - 96x96
- `mipmap-xxhdpi/ic_launcher.png` - 144x144
- `mipmap-xxxhdpi/ic_launcher.png` - 192x192

### iOS
- `Icon-20.png` - 20x20
- `Icon-29.png` - 29x29
- `Icon-40.png` - 40x40
- `Icon-60.png` - 60x60
- `Icon-76.png` - 76x76
- `Icon-83.5.png` - 83.5x83.5
- `Icon-1024.png` - 1024x1024

### Web
- `favicon.png` - 16x16
- `Icon-192.png` - 192x192
- `Icon-512.png` - 512x512
- `Icon-maskable-192.png` - 192x192 (with safe zone)
- `Icon-maskable-512.png` - 512x512 (with safe zone)

## Converting SVG to PNG

```bash
# Using ImageMagick
convert -density 300 -background none app_icon.svg -resize 1024x1024 app_icon.png

# Using Inkscape
inkscape app_icon.svg --export-type=png --export-width=1024 --export-filename=app_icon.png
```
