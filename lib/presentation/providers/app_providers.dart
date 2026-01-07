/// Application-wide Riverpod providers for Innerverse
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../data/database/app_database.dart';
import '../../services/audio_service.dart';
import '../../services/security_service.dart';

// ============================================================================
// Core Infrastructure Providers
// ============================================================================

/// Database provider - must be overridden in main.dart
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database provider must be overridden');
});

/// SharedPreferences provider - must be overridden in main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences provider must be overridden');
});

/// Audio service provider - must be overridden in main.dart
final audioServiceProvider = Provider<AudioService>((ref) {
  throw UnimplementedError('AudioService provider must be overridden');
});

/// Security service provider
final securityServiceProvider = Provider<SecurityService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SecurityService(prefs);
});

// ============================================================================
// Authentication State Providers
// ============================================================================

/// Whether the user has completed onboarding
final hasCompletedOnboardingProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool(StorageKeys.hasCompletedOnboarding) ?? false;
});

/// Whether the user is currently authenticated
final isAuthenticatedProvider = StateProvider<bool>((ref) {
  return false; // Starts as false, becomes true after PIN/biometric
});

// ============================================================================
// Theme Providers
// ============================================================================

/// Current theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return ThemeModeNotifier(prefs);
  },
);

/// Theme mode state notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs) : super(_loadThemeMode(_prefs));

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final value = prefs.getString(StorageKeys.themeMode);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(StorageKeys.themeMode, mode.name);
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(newMode);
  }
}

// ============================================================================
// Settings Providers
// ============================================================================

/// App settings state
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return SettingsNotifier(prefs);
  },
);

/// App settings model
class AppSettings {
  final bool ambientSoundsEnabled;
  final bool hapticFeedbackEnabled;
  final bool typingSoundsEnabled;
  final bool vaporModeDefault;
  final bool lockOnBackground;
  final bool screenshotBlockingEnabled;
  final int? deadManSwitchDays;
  final TimeOfDay? morningRitualTime;
  final TimeOfDay? eveningRitualTime;
  final bool notificationsEnabled;

  const AppSettings({
    this.ambientSoundsEnabled = true,
    this.hapticFeedbackEnabled = true,
    this.typingSoundsEnabled = false,
    this.vaporModeDefault = false,
    this.lockOnBackground = true,
    this.screenshotBlockingEnabled = false,
    this.deadManSwitchDays,
    this.morningRitualTime,
    this.eveningRitualTime,
    this.notificationsEnabled = true,
  });

  AppSettings copyWith({
    bool? ambientSoundsEnabled,
    bool? hapticFeedbackEnabled,
    bool? typingSoundsEnabled,
    bool? vaporModeDefault,
    bool? lockOnBackground,
    bool? screenshotBlockingEnabled,
    int? deadManSwitchDays,
    TimeOfDay? morningRitualTime,
    TimeOfDay? eveningRitualTime,
    bool? notificationsEnabled,
  }) {
    return AppSettings(
      ambientSoundsEnabled: ambientSoundsEnabled ?? this.ambientSoundsEnabled,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      typingSoundsEnabled: typingSoundsEnabled ?? this.typingSoundsEnabled,
      vaporModeDefault: vaporModeDefault ?? this.vaporModeDefault,
      lockOnBackground: lockOnBackground ?? this.lockOnBackground,
      screenshotBlockingEnabled:
          screenshotBlockingEnabled ?? this.screenshotBlockingEnabled,
      deadManSwitchDays: deadManSwitchDays ?? this.deadManSwitchDays,
      morningRitualTime: morningRitualTime ?? this.morningRitualTime,
      eveningRitualTime: eveningRitualTime ?? this.eveningRitualTime,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

/// Settings state notifier
class SettingsNotifier extends StateNotifier<AppSettings> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs) : super(_loadSettings(_prefs));

  static AppSettings _loadSettings(SharedPreferences prefs) {
    return AppSettings(
      ambientSoundsEnabled:
          prefs.getBool(StorageKeys.ambientSoundsEnabled) ?? true,
      hapticFeedbackEnabled:
          prefs.getBool(StorageKeys.hapticFeedbackEnabled) ?? true,
      typingSoundsEnabled:
          prefs.getBool(StorageKeys.typingSoundsEnabled) ?? false,
      vaporModeDefault: prefs.getBool(StorageKeys.vaporModeDefault) ?? false,
      lockOnBackground: true,
      screenshotBlockingEnabled:
          prefs.getBool(StorageKeys.screenshotBlockingEnabled) ?? false,
      deadManSwitchDays: prefs.getInt(StorageKeys.deadManSwitchDays),
      morningRitualTime: _parseTimeOfDay(
        prefs.getString(StorageKeys.morningRitualTime),
      ),
      eveningRitualTime: _parseTimeOfDay(
        prefs.getString(StorageKeys.eveningRitualTime),
      ),
      notificationsEnabled:
          prefs.getBool(StorageKeys.notificationsEnabled) ?? true,
    );
  }

  static TimeOfDay? _parseTimeOfDay(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  static String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> setAmbientSoundsEnabled(bool value) async {
    state = state.copyWith(ambientSoundsEnabled: value);
    await _prefs.setBool(StorageKeys.ambientSoundsEnabled, value);
  }

  Future<void> setHapticFeedbackEnabled(bool value) async {
    state = state.copyWith(hapticFeedbackEnabled: value);
    await _prefs.setBool(StorageKeys.hapticFeedbackEnabled, value);
  }

  Future<void> setTypingSoundsEnabled(bool value) async {
    state = state.copyWith(typingSoundsEnabled: value);
    await _prefs.setBool(StorageKeys.typingSoundsEnabled, value);
  }

  Future<void> setVaporModeDefault(bool value) async {
    state = state.copyWith(vaporModeDefault: value);
    await _prefs.setBool(StorageKeys.vaporModeDefault, value);
  }

  Future<void> setScreenshotBlockingEnabled(bool value) async {
    state = state.copyWith(screenshotBlockingEnabled: value);
    await _prefs.setBool(StorageKeys.screenshotBlockingEnabled, value);
  }

  Future<void> setDeadManSwitchDays(int? days) async {
    state = state.copyWith(deadManSwitchDays: days);
    if (days != null) {
      await _prefs.setInt(StorageKeys.deadManSwitchDays, days);
    } else {
      await _prefs.remove(StorageKeys.deadManSwitchDays);
    }
  }

  Future<void> setMorningRitualTime(TimeOfDay? time) async {
    state = state.copyWith(morningRitualTime: time);
    if (time != null) {
      await _prefs.setString(
        StorageKeys.morningRitualTime,
        _formatTimeOfDay(time),
      );
    } else {
      await _prefs.remove(StorageKeys.morningRitualTime);
    }
  }

  Future<void> setEveningRitualTime(TimeOfDay? time) async {
    state = state.copyWith(eveningRitualTime: time);
    if (time != null) {
      await _prefs.setString(
        StorageKeys.eveningRitualTime,
        _formatTimeOfDay(time),
      );
    } else {
      await _prefs.remove(StorageKeys.eveningRitualTime);
    }
  }

  Future<void> setNotificationsEnabled(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    await _prefs.setBool(StorageKeys.notificationsEnabled, value);
  }
}

// ============================================================================
// User Profile Providers
// ============================================================================

/// User name provider
final userNameProvider = StateProvider<String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getString(StorageKeys.userName) ?? 'Explorer';
});

/// User avatar path provider
final userAvatarProvider = StateProvider<String?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getString(StorageKeys.userAvatar);
});

// ============================================================================
// Statistics Providers
// ============================================================================

/// Current reflection streak
final currentStreakProvider = StateProvider<int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getInt(StorageKeys.currentStreak) ?? 0;
});

/// Longest reflection streak
final longestStreakProvider = StateProvider<int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getInt(StorageKeys.longestStreak) ?? 0;
});

/// Total reflections count
final totalReflectionsProvider = StateProvider<int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getInt(StorageKeys.totalReflections) ?? 0;
});

// ============================================================================
// Current Space Provider
// ============================================================================

/// Currently selected space ID
final currentSpaceProvider = StateProvider<String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getString(StorageKeys.currentSpace) ?? 'sanctuary';
});
