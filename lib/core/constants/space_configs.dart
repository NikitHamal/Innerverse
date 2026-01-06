/// Space configuration data for Innerverse emotional spaces
library;

import 'package:flutter/material.dart';
import 'app_constants.dart';

/// Configuration for an emotional space
class SpaceConfig {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String audioAsset;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color textColor;
  final Color backgroundColor;
  final List<Color> gradientColors;
  final String fontFamily;
  final double letterSpacing;
  final String ambiance;
  final bool allowsMessageDeletion;
  final bool hasSpecialAnimation;
  final String specialAnimationType;

  const SpaceConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.audioAsset,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.textColor,
    required this.backgroundColor,
    required this.gradientColors,
    this.fontFamily = 'Poppins',
    this.letterSpacing = 0.0,
    required this.ambiance,
    this.allowsMessageDeletion = true,
    this.hasSpecialAnimation = false,
    this.specialAnimationType = '',
  });
}

/// All emotional spaces available in Innerverse
const List<SpaceConfig> allSpaces = [
  // The Void - Pure dark mode for overwhelming moments
  SpaceConfig(
    id: SpaceTypeIds.theVoid,
    name: 'The Void',
    description: 'Pure dark mode, minimal UI. Scream into emptiness.',
    emoji: '\u{1F311}',
    audioAsset: AssetPaths.voidAmbient,
    primaryColor: Color(0xFF0D0D0D),
    secondaryColor: Color(0xFF1A1A1A),
    accentColor: Color(0xFF333333),
    textColor: Color(0xFF888888),
    backgroundColor: Color(0xFF000000),
    gradientColors: [Color(0xFF000000), Color(0xFF0D0D0D), Color(0xFF1A1A1A)],
    letterSpacing: 0.5,
    ambiance: 'Deep silence with occasional distant rumbles',
    allowsMessageDeletion: true,
    hasSpecialAnimation: true,
    specialAnimationType: 'dissolve',
  ),

  // The Storm Room - For anger and frustration
  SpaceConfig(
    id: SpaceTypeIds.stormRoom,
    name: 'The Storm Room',
    description: 'Animated storms for anger and venting. Burn what needs burning.',
    emoji: '\u{1F327}\u{FE0F}',
    audioAsset: AssetPaths.stormAmbient,
    primaryColor: Color(0xFF1A1A2E),
    secondaryColor: Color(0xFF16213E),
    accentColor: Color(0xFFE94560),
    textColor: Color(0xFFEEEEEE),
    backgroundColor: Color(0xFF0F0F1A),
    gradientColors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E), Color(0xFF16213E)],
    ambiance: 'Rain, thunder, howling wind',
    hasSpecialAnimation: true,
    specialAnimationType: 'burn',
  ),

  // The Dream Garden - For hopes and gratitude
  SpaceConfig(
    id: SpaceTypeIds.dreamGarden,
    name: 'The Dream Garden',
    description: 'Soft beauty for hopes, dreams, and gratitude.',
    emoji: '\u{1F338}',
    audioAsset: AssetPaths.gardenAmbient,
    primaryColor: Color(0xFFFFF5F5),
    secondaryColor: Color(0xFFFFE4E6),
    accentColor: Color(0xFFF472B6),
    textColor: Color(0xFF4A4A4A),
    backgroundColor: Color(0xFFFFFBFB),
    gradientColors: [Color(0xFFFFFBFB), Color(0xFFFFF5F5), Color(0xFFFFE4E6)],
    ambiance: 'Birds singing, gentle breeze, nature sounds',
    hasSpecialAnimation: true,
    specialAnimationType: 'bloom',
  ),

  // Memory Palace - Architectural for past conversations
  SpaceConfig(
    id: SpaceTypeIds.memoryPalace,
    name: 'Memory Palace',
    description: 'Walk through rooms of past conversations by theme.',
    emoji: '\u{1F3DB}\u{FE0F}',
    audioAsset: AssetPaths.palaceAmbient,
    primaryColor: Color(0xFFF5F0E8),
    secondaryColor: Color(0xFFE8DFD0),
    accentColor: Color(0xFFB8860B),
    textColor: Color(0xFF2F2F2F),
    backgroundColor: Color(0xFFFAF7F2),
    gradientColors: [Color(0xFFFAF7F2), Color(0xFFF5F0E8), Color(0xFFE8DFD0)],
    letterSpacing: 0.3,
    ambiance: 'Echoing halls, subtle reverb, distant footsteps',
  ),

  // The Shore - For grief and letting go
  SpaceConfig(
    id: SpaceTypeIds.theShore,
    name: 'The Shore',
    description: 'Calm waves for processing grief and sadness.',
    emoji: '\u{1F30A}',
    audioAsset: AssetPaths.shoreAmbient,
    primaryColor: Color(0xFFE6F2F8),
    secondaryColor: Color(0xFFD0E4F0),
    accentColor: Color(0xFF5B9BD5),
    textColor: Color(0xFF3A3A3A),
    backgroundColor: Color(0xFFF0F7FB),
    gradientColors: [Color(0xFFF0F7FB), Color(0xFFE6F2F8), Color(0xFFD0E4F0)],
    ambiance: 'Waves lapping, ocean breeze, distant seagulls',
    hasSpecialAnimation: true,
    specialAnimationType: 'wash_away',
  ),

  // The Sanctuary - Default peaceful space
  SpaceConfig(
    id: SpaceTypeIds.sanctuary,
    name: 'The Sanctuary',
    description: 'Your default peaceful space for everyday reflection.',
    emoji: '\u{1F33F}',
    audioAsset: AssetPaths.sanctuaryAmbient,
    primaryColor: Color(0xFFF5F5F7),
    secondaryColor: Color(0xFFE8E8ED),
    accentColor: Color(0xFF6366F1),
    textColor: Color(0xFF1F1F1F),
    backgroundColor: Color(0xFFFAFAFC),
    gradientColors: [Color(0xFFFAFAFC), Color(0xFFF5F5F7), Color(0xFFE8E8ED)],
    ambiance: 'Peaceful meditation tones, soft ambient music',
  ),
];

/// Get space config by ID
SpaceConfig getSpaceConfig(String id) {
  try {
    return allSpaces.firstWhere((s) => s.id == id);
  } catch (_) {
    return allSpaces.last; // Return Sanctuary as default
  }
}

/// Get space emoji by ID
String getSpaceEmoji(String id) {
  return getSpaceConfig(id).emoji;
}

/// Get space name by ID
String getSpaceName(String id) {
  return getSpaceConfig(id).name;
}

/// Get space colors by ID
List<Color> getSpaceGradient(String id) {
  return getSpaceConfig(id).gradientColors;
}

/// Get space primary color by ID
Color getSpacePrimaryColor(String id) {
  return getSpaceConfig(id).primaryColor;
}

/// Get space accent color by ID
Color getSpaceAccentColor(String id) {
  return getSpaceConfig(id).accentColor;
}

/// Dark mode variants for spaces
SpaceConfig getDarkVariant(SpaceConfig config) {
  if (config.id == SpaceTypeIds.theVoid) return config;

  return SpaceConfig(
    id: config.id,
    name: config.name,
    description: config.description,
    emoji: config.emoji,
    audioAsset: config.audioAsset,
    primaryColor: _darken(config.primaryColor, 0.7),
    secondaryColor: _darken(config.secondaryColor, 0.7),
    accentColor: config.accentColor,
    textColor: const Color(0xFFEEEEEE),
    backgroundColor: const Color(0xFF121212),
    gradientColors: config.gradientColors.map((c) => _darken(c, 0.7)).toList(),
    fontFamily: config.fontFamily,
    letterSpacing: config.letterSpacing,
    ambiance: config.ambiance,
    allowsMessageDeletion: config.allowsMessageDeletion,
    hasSpecialAnimation: config.hasSpecialAnimation,
    specialAnimationType: config.specialAnimationType,
  );
}

Color _darken(Color color, double factor) {
  return Color.fromARGB(
    color.alpha,
    (color.red * (1 - factor)).round(),
    (color.green * (1 - factor)).round(),
    (color.blue * (1 - factor)).round(),
  );
}
