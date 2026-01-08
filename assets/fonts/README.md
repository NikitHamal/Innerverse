# Innerverse Fonts

## Primary Font: Poppins

Innerverse uses Poppins from Google Fonts as its primary typeface.

### Required Weights

Download from: https://fonts.google.com/specimen/Poppins

- `Poppins-Thin.ttf` (100)
- `Poppins-Light.ttf` (300)
- `Poppins-Regular.ttf` (400)
- `Poppins-Medium.ttf` (500)
- `Poppins-SemiBold.ttf` (600)
- `Poppins-Bold.ttf` (700)

### Why Poppins?

- **Modern & Clean:** Geometric sans-serif with friendly character
- **Excellent Readability:** Clear at all sizes, great for both headings and body text
- **Wide Language Support:** Supports Latin, Latin Extended
- **Google Fonts:** Free, open-source, regularly updated

### Usage in App

```dart
// pubspec.yaml already configured to use local font files
// Access via Theme.of(context).textTheme

Text(
  'Hello',
  style: Theme.of(context).textTheme.headlineMedium,
);
```

### Fallback

If fonts fail to load, the app falls back to:
- iOS: San Francisco
- Android: Roboto
- Web: System sans-serif

## Download Instructions

1. Visit https://fonts.google.com/specimen/Poppins
2. Click "Download family"
3. Extract the ZIP file
4. Copy the required .ttf files to this directory
