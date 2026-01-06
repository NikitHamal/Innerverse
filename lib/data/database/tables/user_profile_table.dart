/// User profile table definition for Drift database
library;

import 'package:drift/drift.dart';

/// User profile table - stores single row of user data
@DataClassName('UserProfileEntity')
class UserProfiles extends Table {
  /// Primary key (always 1 - single row table)
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// User's display name
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Path to user's avatar image
  TextColumn get avatarPath => text().nullable()();

  /// When the user first created their profile
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last profile update
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Preferences stored as JSON strings
  /// Theme mode: 'system', 'light', 'dark', 'cosmic'
  TextColumn get themeMode => text().withDefault(const Constant('system'))();

  /// Whether ambient sounds are enabled
  BoolColumn get ambientSoundsEnabled =>
      boolean().withDefault(const Constant(true))();

  /// Whether haptic feedback is enabled (mobile only)
  BoolColumn get hapticFeedbackEnabled =>
      boolean().withDefault(const Constant(true))();

  /// Whether typing sounds are enabled
  BoolColumn get typingSoundsEnabled =>
      boolean().withDefault(const Constant(false))();

  /// Whether vapor mode is default for new conversations
  BoolColumn get vaporModeDefault =>
      boolean().withDefault(const Constant(false))();

  /// Default space type for new conversations
  TextColumn get defaultSpace =>
      text().withDefault(const Constant('sanctuary'))();

  /// Morning ritual time (HH:mm format)
  TextColumn get morningRitualTime =>
      text().withDefault(const Constant('08:00'))();

  /// Evening ritual time (HH:mm format)
  TextColumn get eveningRitualTime =>
      text().withDefault(const Constant('21:00'))();

  /// Whether notifications are enabled
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();

  /// Whether ritual reminders are enabled
  BoolColumn get ritualRemindersEnabled =>
      boolean().withDefault(const Constant(true))();

  // Security settings
  /// Whether biometric auth is enabled
  BoolColumn get biometricEnabled =>
      boolean().withDefault(const Constant(false))();

  /// Whether screenshot blocking is enabled (Android only)
  BoolColumn get screenshotBlockingEnabled =>
      boolean().withDefault(const Constant(true))();

  /// Dead man's switch days (0 = disabled)
  IntColumn get deadManSwitchDays => integer().withDefault(const Constant(0))();

  /// Current reflection streak count
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();

  /// Longest reflection streak achieved
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();

  /// Date of last reflection (for streak calculation)
  DateTimeColumn get lastReflectionDate => dateTime().nullable()();

  /// Total number of reflections/entries
  IntColumn get totalReflections => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
