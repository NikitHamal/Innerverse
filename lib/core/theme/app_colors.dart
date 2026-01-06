/// App color definitions for Innerverse
library;

import 'package:flutter/material.dart';

/// Primary color palette for Innerverse
/// Deep purples, soft teals, warm golds, midnight blues
abstract class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryContainer = Color(0xFFE0E7FF);
  static const Color onPrimaryContainer = Color(0xFF1E1B4B);

  // Secondary Colors
  static const Color secondary = Color(0xFF14B8A6); // Teal
  static const Color secondaryLight = Color(0xFF2DD4BF);
  static const Color secondaryDark = Color(0xFF0D9488);
  static const Color secondaryContainer = Color(0xFFCCFBF1);
  static const Color onSecondaryContainer = Color(0xFF042F2E);

  // Tertiary Colors
  static const Color tertiary = Color(0xFFF59E0B); // Amber/Gold
  static const Color tertiaryLight = Color(0xFFFBBF24);
  static const Color tertiaryDark = Color(0xFFD97706);
  static const Color tertiaryContainer = Color(0xFFFEF3C7);
  static const Color onTertiaryContainer = Color(0xFF451A03);

  // Cosmic Theme Colors
  static const Color cosmicPurple = Color(0xFF1A0A2E);
  static const Color deepSpace = Color(0xFF0F0A1A);
  static const Color nebulaPink = Color(0xFFFF6B9D);
  static const Color starGold = Color(0xFFFFD700);
  static const Color cosmicTeal = Color(0xFF00D9FF);

  // Background Colors - Light
  static const Color backgroundLight = Color(0xFFFAFAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF5F5F7);
  static const Color surfaceContainerLight = Color(0xFFF0F0F5);
  static const Color surfaceContainerHighLight = Color(0xFFE8E8ED);

  // Background Colors - Dark
  static const Color backgroundDark = Color(0xFF0F0F14);
  static const Color surfaceDark = Color(0xFF1A1A24);
  static const Color surfaceVariantDark = Color(0xFF252530);
  static const Color surfaceContainerDark = Color(0xFF1F1F28);
  static const Color surfaceContainerHighDark = Color(0xFF2A2A36);

  // Text Colors - Light
  static const Color textPrimaryLight = Color(0xFF1F1F1F);
  static const Color textSecondaryLight = Color(0xFF6B6B6B);
  static const Color textTertiaryLight = Color(0xFF9E9E9E);
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  // Text Colors - Dark
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF808080);
  static const Color textDisabledDark = Color(0xFF5A5A5A);

  // Semantic Colors
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFF4ADE80);
  static const Color successDark = Color(0xFF16A34A);
  static const Color successContainer = Color(0xFFDCFCE7);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningContainer = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorContainer = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);
  static const Color infoContainer = Color(0xFFDBEAFE);

  // Persona Colors
  static const Color innerChildPink = Color(0xFFFFC1E3);
  static const Color shadowSelfPurple = Color(0xFF4A4A6A);
  static const Color idealSelfGold = Color(0xFFFFD700);
  static const Color criticRed = Color(0xFF8B0000);
  static const Color dreamerViolet = Color(0xFF9B59B6);
  static const Color protectorBlue = Color(0xFF2E86AB);
  static const Color pastSelfLavender = Color(0xFF7B68EE);
  static const Color futureSelfCyan = Color(0xFF00CED1);
  static const Color observerSelfGray = Color(0xFF708090);

  // Space Colors
  static const Color voidBlack = Color(0xFF0D0D0D);
  static const Color stormNavy = Color(0xFF1A1A2E);
  static const Color gardenPink = Color(0xFFFFF5F5);
  static const Color palaceWarm = Color(0xFFF5F0E8);
  static const Color shoreBlue = Color(0xFFE6F2F8);
  static const Color sanctuaryPeace = Color(0xFFF5F5F7);

  // Overlay Colors
  static const Color overlayLight = Color(0x0D000000);
  static const Color overlayMedium = Color(0x1A000000);
  static const Color overlayDark = Color(0x4D000000);
  static const Color overlayHeavy = Color(0x80000000);

  // Scrim
  static const Color scrimLight = Color(0x52000000);
  static const Color scrimDark = Color(0x52000000);

  // Divider
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF3A3A3A);

  // Shadow
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x4D000000);

  // Gradient Presets
  static const List<Color> cosmicGradient = [
    Color(0xFF1A0A2E),
    Color(0xFF2D1B4E),
    Color(0xFF4C3575),
  ];

  static const List<Color> sunriseGradient = [
    Color(0xFFFFA07A),
    Color(0xFFFFD700),
    Color(0xFFFFF8DC),
  ];

  static const List<Color> oceanGradient = [
    Color(0xFF0077B6),
    Color(0xFF00B4D8),
    Color(0xFF90E0EF),
  ];

  static const List<Color> forestGradient = [
    Color(0xFF1B4332),
    Color(0xFF2D6A4F),
    Color(0xFF52B788),
  ];

  static const List<Color> twilightGradient = [
    Color(0xFF0F0A1A),
    Color(0xFF1A0A2E),
    Color(0xFF2D1B4E),
  ];
}

/// Extension for Color manipulation
extension ColorExtension on Color {
  /// Lighten a color by a percentage (0.0 - 1.0)
  Color lighten(double amount) {
    assert(amount >= 0 && amount <= 1);
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * amount)).round().clamp(0, 255),
      (green + ((255 - green) * amount)).round().clamp(0, 255),
      (blue + ((255 - blue) * amount)).round().clamp(0, 255),
    );
  }

  /// Darken a color by a percentage (0.0 - 1.0)
  Color darken(double amount) {
    assert(amount >= 0 && amount <= 1);
    return Color.fromARGB(
      alpha,
      (red * (1 - amount)).round().clamp(0, 255),
      (green * (1 - amount)).round().clamp(0, 255),
      (blue * (1 - amount)).round().clamp(0, 255),
    );
  }

  /// Get color with different opacity
  Color withOpacityValue(double opacity) {
    return withOpacity(opacity.clamp(0.0, 1.0));
  }
}
