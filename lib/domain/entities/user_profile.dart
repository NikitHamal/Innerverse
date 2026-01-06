/// User Profile domain entity for Innerverse
library;

import 'package:equatable/equatable.dart';

import 'conversation.dart';

/// Theme mode options
enum ThemeMode {
  system,
  light,
  dark,
  cosmic;

  String get id => name;

  String get displayName => switch (this) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
        ThemeMode.cosmic => 'Cosmic',
      };

  String get description => switch (this) {
        ThemeMode.system => 'Follow system settings',
        ThemeMode.light => 'Light theme for daytime',
        ThemeMode.dark => 'Dark theme for night',
        ThemeMode.cosmic => 'Special cosmic theme with stars',
      };

  static ThemeMode fromId(String id) {
    return ThemeMode.values.firstWhere(
      (t) => t.id == id,
      orElse: () => ThemeMode.system,
    );
  }
}

/// User Profile domain model
class UserProfile extends Equatable {
  final int id;
  final String name;
  final String? avatarPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserPreferences preferences;
  final UserSecuritySettings security;
  final UserStatistics statistics;

  const UserProfile({
    this.id = 1,
    required this.name,
    this.avatarPath,
    required this.createdAt,
    required this.updatedAt,
    required this.preferences,
    required this.security,
    required this.statistics,
  });

  /// Create a default profile
  factory UserProfile.defaultProfile() {
    final now = DateTime.now();
    return UserProfile(
      name: 'Explorer',
      createdAt: now,
      updatedAt: now,
      preferences: const UserPreferences(),
      security: const UserSecuritySettings(),
      statistics: const UserStatistics(),
    );
  }

  /// Get member duration text
  String get memberSinceText {
    final days = DateTime.now().difference(createdAt).inDays;
    if (days < 1) return 'Joined today';
    if (days == 1) return 'Member for 1 day';
    if (days < 30) return 'Member for $days days';
    if (days < 365) {
      final months = (days / 30).floor();
      return 'Member for $months ${months == 1 ? 'month' : 'months'}';
    }
    final years = (days / 365).floor();
    return 'Member for $years ${years == 1 ? 'year' : 'years'}';
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    int? id,
    String? name,
    String? avatarPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserPreferences? preferences,
    UserSecuritySettings? security,
    UserStatistics? statistics,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
      security: security ?? this.security,
      statistics: statistics ?? this.statistics,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatarPath,
        createdAt,
        updatedAt,
        preferences,
        security,
        statistics,
      ];
}

/// User preferences
class UserPreferences extends Equatable {
  final ThemeMode themeMode;
  final bool ambientSoundsEnabled;
  final bool hapticFeedbackEnabled;
  final bool typingSoundsEnabled;
  final bool vaporModeDefault;
  final SpaceType defaultSpace;
  final String morningRitualTime;
  final String eveningRitualTime;
  final bool notificationsEnabled;
  final bool ritualRemindersEnabled;

  const UserPreferences({
    this.themeMode = ThemeMode.system,
    this.ambientSoundsEnabled = true,
    this.hapticFeedbackEnabled = true,
    this.typingSoundsEnabled = false,
    this.vaporModeDefault = false,
    this.defaultSpace = SpaceType.sanctuary,
    this.morningRitualTime = '08:00',
    this.eveningRitualTime = '21:00',
    this.notificationsEnabled = true,
    this.ritualRemindersEnabled = true,
  });

  /// Parse morning ritual time to TimeOfDay-like values
  (int hour, int minute) get morningRitualTimeOfDay {
    final parts = morningRitualTime.split(':');
    return (int.parse(parts[0]), int.parse(parts[1]));
  }

  /// Parse evening ritual time to TimeOfDay-like values
  (int hour, int minute) get eveningRitualTimeOfDay {
    final parts = eveningRitualTime.split(':');
    return (int.parse(parts[0]), int.parse(parts[1]));
  }

  UserPreferences copyWith({
    ThemeMode? themeMode,
    bool? ambientSoundsEnabled,
    bool? hapticFeedbackEnabled,
    bool? typingSoundsEnabled,
    bool? vaporModeDefault,
    SpaceType? defaultSpace,
    String? morningRitualTime,
    String? eveningRitualTime,
    bool? notificationsEnabled,
    bool? ritualRemindersEnabled,
  }) {
    return UserPreferences(
      themeMode: themeMode ?? this.themeMode,
      ambientSoundsEnabled: ambientSoundsEnabled ?? this.ambientSoundsEnabled,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      typingSoundsEnabled: typingSoundsEnabled ?? this.typingSoundsEnabled,
      vaporModeDefault: vaporModeDefault ?? this.vaporModeDefault,
      defaultSpace: defaultSpace ?? this.defaultSpace,
      morningRitualTime: morningRitualTime ?? this.morningRitualTime,
      eveningRitualTime: eveningRitualTime ?? this.eveningRitualTime,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      ritualRemindersEnabled:
          ritualRemindersEnabled ?? this.ritualRemindersEnabled,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        ambientSoundsEnabled,
        hapticFeedbackEnabled,
        typingSoundsEnabled,
        vaporModeDefault,
        defaultSpace,
        morningRitualTime,
        eveningRitualTime,
        notificationsEnabled,
        ritualRemindersEnabled,
      ];
}

/// User security settings
class UserSecuritySettings extends Equatable {
  final bool biometricEnabled;
  final bool screenshotBlockingEnabled;
  final int deadManSwitchDays;

  const UserSecuritySettings({
    this.biometricEnabled = false,
    this.screenshotBlockingEnabled = true,
    this.deadManSwitchDays = 0,
  });

  /// Check if dead man's switch is enabled
  bool get isDeadManSwitchEnabled => deadManSwitchDays > 0;

  UserSecuritySettings copyWith({
    bool? biometricEnabled,
    bool? screenshotBlockingEnabled,
    int? deadManSwitchDays,
  }) {
    return UserSecuritySettings(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      screenshotBlockingEnabled:
          screenshotBlockingEnabled ?? this.screenshotBlockingEnabled,
      deadManSwitchDays: deadManSwitchDays ?? this.deadManSwitchDays,
    );
  }

  @override
  List<Object?> get props =>
      [biometricEnabled, screenshotBlockingEnabled, deadManSwitchDays];
}

/// User statistics
class UserStatistics extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastReflectionDate;
  final int totalReflections;

  const UserStatistics({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastReflectionDate,
    this.totalReflections = 0,
  });

  /// Check if user reflected today
  bool get reflectedToday {
    if (lastReflectionDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(
      lastReflectionDate!.year,
      lastReflectionDate!.month,
      lastReflectionDate!.day,
    );
    return lastDate == today;
  }

  /// Check if streak is at risk (didn't reflect yesterday)
  bool get isStreakAtRisk {
    if (currentStreak == 0) return false;
    if (reflectedToday) return false;

    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    if (lastReflectionDate == null) return true;

    final lastDate = DateTime(
      lastReflectionDate!.year,
      lastReflectionDate!.month,
      lastReflectionDate!.day,
    );
    return lastDate.isBefore(yesterday);
  }

  UserStatistics copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastReflectionDate,
    int? totalReflections,
  }) {
    return UserStatistics(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastReflectionDate: lastReflectionDate ?? this.lastReflectionDate,
      totalReflections: totalReflections ?? this.totalReflections,
    );
  }

  @override
  List<Object?> get props =>
      [currentStreak, longestStreak, lastReflectionDate, totalReflections];
}
