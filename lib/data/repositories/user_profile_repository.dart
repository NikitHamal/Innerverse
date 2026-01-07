/// User Profile repository for data access abstraction
library;

import '../../domain/entities/user_profile.dart';
import '../database/app_database.dart';
import '../database/daos/user_profile_dao.dart';

/// Repository for user profile data operations
class UserProfileRepository {
  final UserProfileDao _dao;

  UserProfileRepository(AppDatabase db) : _dao = UserProfileDao(db);

  /// Get the user profile
  Future<UserProfile?> getProfile() async {
    final entity = await _dao.getProfile();
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Watch the user profile (stream)
  Stream<UserProfile?> watchProfile() {
    return _dao.watchProfile().map(
          (entity) => entity != null ? _mapEntityToDomain(entity) : null,
        );
  }

  /// Update user name
  Future<void> updateName(String name) {
    return _dao.updateName(name);
  }

  /// Update avatar path
  Future<void> updateAvatar(String? avatarPath) {
    return _dao.updateAvatar(avatarPath);
  }

  /// Update theme mode
  Future<void> updateThemeMode(String themeMode) {
    return _dao.updateThemeMode(themeMode);
  }

  /// Update ambient sounds setting
  Future<void> updateAmbientSounds(bool enabled) {
    return _dao.updateAmbientSounds(enabled);
  }

  /// Update haptic feedback setting
  Future<void> updateHapticFeedback(bool enabled) {
    return _dao.updateHapticFeedback(enabled);
  }

  /// Update typing sounds setting
  Future<void> updateTypingSounds(bool enabled) {
    return _dao.updateTypingSounds(enabled);
  }

  /// Update vapor mode default setting
  Future<void> updateVaporModeDefault(bool enabled) {
    return _dao.updateVaporModeDefault(enabled);
  }

  /// Update default space
  Future<void> updateDefaultSpace(String spaceType) {
    return _dao.updateDefaultSpace(spaceType);
  }

  /// Update morning ritual time
  Future<void> updateMorningRitualTime(String time) {
    return _dao.updateMorningRitualTime(time);
  }

  /// Update evening ritual time
  Future<void> updateEveningRitualTime(String time) {
    return _dao.updateEveningRitualTime(time);
  }

  /// Update notifications enabled
  Future<void> updateNotificationsEnabled(bool enabled) {
    return _dao.updateNotificationsEnabled(enabled);
  }

  /// Update ritual reminders enabled
  Future<void> updateRitualReminders(bool enabled) {
    return _dao.updateRitualReminders(enabled);
  }

  /// Update biometric enabled
  Future<void> updateBiometricEnabled(bool enabled) {
    return _dao.updateBiometricEnabled(enabled);
  }

  /// Update screenshot blocking enabled
  Future<void> updateScreenshotBlocking(bool enabled) {
    return _dao.updateScreenshotBlocking(enabled);
  }

  /// Update dead man's switch days
  Future<void> updateDeadManSwitchDays(int days) {
    return _dao.updateDeadManSwitchDays(days);
  }

  /// Increment total reflections and update streak
  Future<void> incrementReflections() {
    return _dao.incrementReflections();
  }

  /// Reset streak
  Future<void> resetStreak() {
    return _dao.resetStreak();
  }

  /// Update full profile
  Future<bool> updateProfile(UserProfile profile) async {
    if (profile.id == null) return false;
    final entity = _mapDomainToEntity(profile);
    return _dao.updateProfile(entity);
  }

  /// Check if profile exists
  Future<bool> profileExists() {
    return _dao.profileExists();
  }

  /// Ensure profile exists
  Future<void> ensureProfileExists() {
    return _dao.ensureProfileExists();
  }

  // ============================================================================
  // Mapping Methods
  // ============================================================================

  UserProfile _mapEntityToDomain(UserProfileEntity entity) {
    return UserProfile(
      id: entity.id,
      name: entity.name,
      avatarPath: entity.avatarPath,
      themeMode: entity.themeMode,
      ambientSoundsEnabled: entity.ambientSoundsEnabled,
      hapticFeedbackEnabled: entity.hapticFeedbackEnabled,
      typingSoundsEnabled: entity.typingSoundsEnabled,
      vaporModeDefault: entity.vaporModeDefault,
      defaultSpace: entity.defaultSpace,
      morningRitualTime: entity.morningRitualTime,
      eveningRitualTime: entity.eveningRitualTime,
      notificationsEnabled: entity.notificationsEnabled,
      ritualRemindersEnabled: entity.ritualRemindersEnabled,
      biometricEnabled: entity.biometricEnabled,
      screenshotBlockingEnabled: entity.screenshotBlockingEnabled,
      deadManSwitchDays: entity.deadManSwitchDays,
      currentStreak: entity.currentStreak,
      longestStreak: entity.longestStreak,
      lastReflectionDate: entity.lastReflectionDate,
      totalReflections: entity.totalReflections,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserProfileEntity _mapDomainToEntity(UserProfile profile) {
    return UserProfileEntity(
      id: profile.id!,
      name: profile.name,
      avatarPath: profile.avatarPath,
      themeMode: profile.themeMode,
      ambientSoundsEnabled: profile.ambientSoundsEnabled,
      hapticFeedbackEnabled: profile.hapticFeedbackEnabled,
      typingSoundsEnabled: profile.typingSoundsEnabled,
      vaporModeDefault: profile.vaporModeDefault,
      defaultSpace: profile.defaultSpace,
      morningRitualTime: profile.morningRitualTime,
      eveningRitualTime: profile.eveningRitualTime,
      notificationsEnabled: profile.notificationsEnabled,
      ritualRemindersEnabled: profile.ritualRemindersEnabled,
      biometricEnabled: profile.biometricEnabled,
      screenshotBlockingEnabled: profile.screenshotBlockingEnabled,
      deadManSwitchDays: profile.deadManSwitchDays,
      currentStreak: profile.currentStreak,
      longestStreak: profile.longestStreak,
      lastReflectionDate: profile.lastReflectionDate,
      totalReflections: profile.totalReflections,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }
}
