/// User Profile Data Access Object for database operations
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/user_profile_table.dart';

part 'user_profile_dao.g.dart';

/// DAO for User Profile operations (single-row table)
@DriftAccessor(tables: [UserProfiles])
class UserProfileDao extends DatabaseAccessor<AppDatabase>
    with _$UserProfileDaoMixin {
  UserProfileDao(super.db);

  /// Get the user profile (always ID 1)
  Future<UserProfileEntity?> getProfile() {
    return (select(userProfiles)..where((u) => u.id.equals(1)))
        .getSingleOrNull();
  }

  /// Watch the user profile (stream)
  Stream<UserProfileEntity?> watchProfile() {
    return (select(userProfiles)..where((u) => u.id.equals(1)))
        .watchSingleOrNull();
  }

  /// Update user name
  Future<void> updateName(String name) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        name: Value(name),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update avatar path
  Future<void> updateAvatar(String? avatarPath) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        avatarPath: Value(avatarPath),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update theme mode
  Future<void> updateThemeMode(String themeMode) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        themeMode: Value(themeMode),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update ambient sounds setting
  Future<void> updateAmbientSounds(bool enabled) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        ambientSoundsEnabled: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update haptic feedback setting
  Future<void> updateHapticFeedback(bool enabled) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        hapticFeedbackEnabled: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update typing sounds setting
  Future<void> updateTypingSounds(bool enabled) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        typingSoundsEnabled: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update vapor mode default setting
  Future<void> updateVaporModeDefault(bool enabled) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        vaporModeDefault: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update default space
  Future<void> updateDefaultSpace(String spaceType) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        defaultSpace: Value(spaceType),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update morning ritual time
  Future<void> updateMorningRitualTime(String time) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        morningRitualTime: Value(time),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update evening ritual time
  Future<void> updateEveningRitualTime(String time) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        eveningRitualTime: Value(time),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update notifications enabled
  Future<void> updateNotificationsEnabled(bool enabled) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        notificationsEnabled: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update ritual reminders enabled
  Future<void> updateRitualReminders(bool enabled) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        ritualRemindersEnabled: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update biometric enabled
  Future<void> updateBiometricEnabled(bool enabled) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        biometricEnabled: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update screenshot blocking enabled
  Future<void> updateScreenshotBlocking(bool enabled) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        screenshotBlockingEnabled: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update dead man's switch days
  Future<void> updateDeadManSwitchDays(int days) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        deadManSwitchDays: Value(days),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update streak (called after reflection)
  Future<void> updateStreak({
    required int currentStreak,
    required int longestStreak,
    required DateTime lastReflectionDate,
    required int totalReflections,
  }) {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        currentStreak: Value(currentStreak),
        longestStreak: Value(longestStreak),
        lastReflectionDate: Value(lastReflectionDate),
        totalReflections: Value(totalReflections),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Increment total reflections
  Future<void> incrementReflections() async {
    final profile = await getProfile();
    if (profile != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastReflection = profile.lastReflectionDate;

      int newStreak = profile.currentStreak;

      if (lastReflection != null) {
        final lastReflectionDay = DateTime(
          lastReflection.year,
          lastReflection.month,
          lastReflection.day,
        );
        final daysDiff = today.difference(lastReflectionDay).inDays;

        if (daysDiff == 1) {
          // Consecutive day - increase streak
          newStreak++;
        } else if (daysDiff > 1) {
          // Streak broken - reset
          newStreak = 1;
        }
        // daysDiff == 0 means same day - don't change streak
      } else {
        // First reflection ever
        newStreak = 1;
      }

      final newLongest =
          newStreak > profile.longestStreak ? newStreak : profile.longestStreak;

      await updateStreak(
        currentStreak: newStreak,
        longestStreak: newLongest,
        lastReflectionDate: now,
        totalReflections: profile.totalReflections + 1,
      );
    }
  }

  /// Reset streak (called when streak is broken)
  Future<void> resetStreak() {
    return (update(userProfiles)..where((u) => u.id.equals(1))).write(
      UserProfilesCompanion(
        currentStreak: const Value(0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update full profile
  Future<bool> updateProfile(UserProfileEntity profile) {
    return update(userProfiles).replace(profile);
  }

  /// Check if profile exists
  Future<bool> profileExists() async {
    final profile = await getProfile();
    return profile != null;
  }

  /// Create default profile if not exists
  Future<void> ensureProfileExists() async {
    final exists = await profileExists();
    if (!exists) {
      await into(userProfiles).insert(
        UserProfilesCompanion.insert(
          name: 'Explorer',
        ),
      );
    }
  }
}
