/// Application-wide constants for Innerverse
library;

/// App metadata constants
abstract class AppMetadata {
  static const String appName = 'Innerverse';
  static const String appTagline = 'Your mind is a universe worth exploring';
  static const String packageName = 'com.inner.verse';
  static const String version = '1.0.0';
  static const int buildNumber = 1;
}

/// Animation duration constants
abstract class AppDurations {
  static const Duration instant = Duration(milliseconds: 50);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 800);
  static const Duration splash = Duration(seconds: 3);
  static const Duration breathingCycle = Duration(seconds: 4);
  static const Duration fadeTransition = Duration(milliseconds: 400);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration vaporModeExpiry = Duration(hours: 24);
}

/// Size and spacing constants
abstract class AppSizes {
  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircular = 100.0;

  // Icon sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Avatar sizes
  static const double avatarS = 32.0;
  static const double avatarM = 48.0;
  static const double avatarL = 64.0;
  static const double avatarXL = 96.0;

  // Bottom navigation
  static const double bottomNavHeight = 80.0;
  static const double sideNavWidth = 80.0;
  static const double sideNavExpandedWidth = 280.0;

  // Card dimensions
  static const double cardMinHeight = 100.0;
  static const double cardMaxWidth = 600.0;

  // Message bubble
  static const double messageBubbleMaxWidth = 300.0;
  static const double messageBubbleMinHeight = 40.0;
}

/// Responsive breakpoints
abstract class AppBreakpoints {
  static const double mobile = 600.0;
  static const double tablet = 1024.0;
  static const double desktop = 1440.0;
}

/// Storage keys for SharedPreferences
abstract class StorageKeys {
  // Onboarding
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String userName = 'user_name';
  static const String userAvatar = 'user_avatar';

  // Security
  static const String pinHash = 'pin_hash';
  static const String decoyPinHash = 'decoy_pin_hash';
  static const String biometricEnabled = 'biometric_enabled';
  static const String lastOpenedAt = 'last_opened_at';
  static const String deadManSwitchDays = 'dead_man_switch_days';
  static const String screenshotBlockingEnabled = 'screenshot_blocking_enabled';

  // Preferences
  static const String themeMode = 'theme_mode';
  static const String currentSpace = 'current_space';
  static const String ambientSoundsEnabled = 'ambient_sounds_enabled';
  static const String hapticFeedbackEnabled = 'haptic_feedback_enabled';
  static const String typingSoundsEnabled = 'typing_sounds_enabled';
  static const String vaporModeDefault = 'vapor_mode_default';

  // Notifications
  static const String morningRitualTime = 'morning_ritual_time';
  static const String eveningRitualTime = 'evening_ritual_time';
  static const String notificationsEnabled = 'notifications_enabled';

  // Statistics
  static const String currentStreak = 'current_streak';
  static const String longestStreak = 'longest_streak';
  static const String lastReflectionDate = 'last_reflection_date';
  static const String totalReflections = 'total_reflections';
}

/// Asset paths
abstract class AssetPaths {
  // Images
  static const String images = 'assets/images';
  static const String splashBackground = '$images/splash_background.png';
  static const String onboardingWelcome = '$images/onboarding_welcome.png';
  static const String onboardingSelves = '$images/onboarding_selves.png';
  static const String onboardingTime = '$images/onboarding_time.png';
  static const String onboardingSpaces = '$images/onboarding_spaces.png';
  static const String onboardingPrivacy = '$images/onboarding_privacy.png';
  static const String emptyState = '$images/empty_state.png';

  // Icons
  static const String icons = 'assets/icons';
  static const String appIcon = '$icons/app_icon.png';
  static const String appIconForeground = '$icons/app_icon_foreground.png';

  // Audio
  static const String audio = 'assets/audio';
  static const String voidAmbient = '$audio/void_ambient.mp3';
  static const String stormAmbient = '$audio/storm_ambient.mp3';
  static const String gardenAmbient = '$audio/garden_ambient.mp3';
  static const String palaceAmbient = '$audio/palace_ambient.mp3';
  static const String shoreAmbient = '$audio/shore_ambient.mp3';
  static const String sanctuaryAmbient = '$audio/sanctuary_ambient.mp3';
  static const String typingSoft = '$audio/typing_soft.mp3';
  static const String messageSent = '$audio/message_sent.mp3';
  static const String capsuleUnlock = '$audio/capsule_unlock.mp3';
  static const String burnEffect = '$audio/burn_effect.mp3';

  // Animations
  static const String animations = 'assets/animations';
  static const String breathingAnimation = '$animations/breathing.json';
  static const String cosmicAnimation = '$animations/cosmic.json';
  static const String starsAnimation = '$animations/stars.json';
  static const String fireAnimation = '$animations/fire.json';
  static const String wavesAnimation = '$animations/waves.json';

  // Fonts
  static const String fonts = 'assets/fonts';
}

/// Persona type identifiers
abstract class PersonaTypeIds {
  static const String innerChild = 'inner_child';
  static const String shadowSelf = 'shadow_self';
  static const String idealSelf = 'ideal_self';
  static const String critic = 'critic';
  static const String dreamer = 'dreamer';
  static const String protector = 'protector';
  static const String pastSelf = 'past_self';
  static const String futureSelf = 'future_self';
  static const String observerSelf = 'observer_self';
  static const String custom = 'custom';
}

/// Space type identifiers
abstract class SpaceTypeIds {
  static const String theVoid = 'the_void';
  static const String stormRoom = 'storm_room';
  static const String dreamGarden = 'dream_garden';
  static const String memoryPalace = 'memory_palace';
  static const String theShore = 'the_shore';
  static const String sanctuary = 'sanctuary';
}

/// Conversation mode identifiers
abstract class ConversationModeIds {
  static const String mirror = 'mirror';
  static const String council = 'council';
  static const String timeline = 'timeline';
  static const String roleReversal = 'role_reversal';
  static const String socratic = 'socratic';
  static const String prompt = 'prompt';
  static const String stream = 'stream';
}

/// Ritual type identifiers
abstract class RitualTypeIds {
  static const String morningIntention = 'morning_intention';
  static const String eveningReflection = 'evening_reflection';
  static const String weeklyCouncil = 'weekly_council';
  static const String birthdayLetter = 'birthday_letter';
  static const String burningCeremony = 'burning_ceremony';
  static const String custom = 'custom';
}
