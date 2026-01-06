/// Time Capsule Data Access Object for database operations
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/time_capsule_table.dart';

part 'time_capsule_dao.g.dart';

/// DAO for Time Capsule operations
@DriftAccessor(tables: [TimeCapsules])
class TimeCapsuleDao extends DatabaseAccessor<AppDatabase>
    with _$TimeCapsuleDaoMixin {
  TimeCapsuleDao(super.db);

  /// Get all non-archived time capsules
  Future<List<TimeCapsuleEntity>> getAllActive() {
    return (select(timeCapsules)
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.unlockAt)]))
        .get();
  }

  /// Get all time capsules including archived
  Future<List<TimeCapsuleEntity>> getAll() {
    return (select(timeCapsules)
          ..orderBy([(t) => OrderingTerm.asc(t.unlockAt)]))
        .get();
  }

  /// Get locked (pending) time capsules
  Future<List<TimeCapsuleEntity>> getLocked() {
    return (select(timeCapsules)
          ..where(
              (t) => t.isUnlocked.equals(false) & t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.unlockAt)]))
        .get();
  }

  /// Get unlocked but unread capsules
  Future<List<TimeCapsuleEntity>> getUnlockedUnread() {
    return (select(timeCapsules)
          ..where((t) =>
              t.isUnlocked.equals(true) &
              t.isRead.equals(false) &
              t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.unlockAt)]))
        .get();
  }

  /// Get unlocked and read capsules
  Future<List<TimeCapsuleEntity>> getUnlockedRead() {
    return (select(timeCapsules)
          ..where((t) =>
              t.isUnlocked.equals(true) &
              t.isRead.equals(true) &
              t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.unlockAt)]))
        .get();
  }

  /// Get archived capsules
  Future<List<TimeCapsuleEntity>> getArchived() {
    return (select(timeCapsules)
          ..where((t) => t.isArchived.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.unlockAt)]))
        .get();
  }

  /// Get time capsule by ID
  Future<TimeCapsuleEntity?> getById(int id) {
    return (select(timeCapsules)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get time capsule by UUID
  Future<TimeCapsuleEntity?> getByUuid(String uuid) {
    return (select(timeCapsules)..where((t) => t.uuid.equals(uuid)))
        .getSingleOrNull();
  }

  /// Get capsules that should be unlocked (time has passed)
  Future<List<TimeCapsuleEntity>> getReadyToUnlock() {
    final now = DateTime.now();
    return (select(timeCapsules)
          ..where((t) =>
              t.isUnlocked.equals(false) &
              t.unlockAt.isSmallerOrEqualValue(now)))
        .get();
  }

  /// Get capsules unlocking soon (within days)
  Future<List<TimeCapsuleEntity>> getUnlockingSoon({int withinDays = 7}) {
    final now = DateTime.now();
    final future = now.add(Duration(days: withinDays));
    return (select(timeCapsules)
          ..where((t) =>
              t.isUnlocked.equals(false) &
              t.unlockAt.isSmallerOrEqualValue(future) &
              t.unlockAt.isBiggerThanValue(now))
          ..orderBy([(t) => OrderingTerm.asc(t.unlockAt)]))
        .get();
  }

  /// Get capsules by persona
  Future<List<TimeCapsuleEntity>> getByPersona(int personaId) {
    return (select(timeCapsules)
          ..where(
              (t) => t.personaId.equals(personaId) & t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.unlockAt)]))
        .get();
  }

  /// Get capsules by occasion
  Future<List<TimeCapsuleEntity>> getByOccasion(String occasion) {
    return (select(timeCapsules)
          ..where(
              (t) => t.occasion.equals(occasion) & t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.unlockAt)]))
        .get();
  }

  /// Watch all active capsules (stream)
  Stream<List<TimeCapsuleEntity>> watchAllActive() {
    return (select(timeCapsules)
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.unlockAt)]))
        .watch();
  }

  /// Watch locked capsules
  Stream<List<TimeCapsuleEntity>> watchLocked() {
    return (select(timeCapsules)
          ..where(
              (t) => t.isUnlocked.equals(false) & t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.unlockAt)]))
        .watch();
  }

  /// Watch unlocked unread capsules
  Stream<List<TimeCapsuleEntity>> watchUnlockedUnread() {
    return (select(timeCapsules)
          ..where((t) =>
              t.isUnlocked.equals(true) &
              t.isRead.equals(false) &
              t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.unlockAt)]))
        .watch();
  }

  /// Watch single capsule by ID
  Stream<TimeCapsuleEntity?> watchById(int id) {
    return (select(timeCapsules)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Insert new time capsule
  Future<int> insertCapsule(TimeCapsuleCompanion capsule) {
    return into(timeCapsules).insert(capsule);
  }

  /// Update existing capsule
  Future<bool> updateCapsule(TimeCapsuleEntity capsule) {
    return update(timeCapsules).replace(capsule);
  }

  /// Unlock a capsule
  Future<void> unlock(int id) {
    return (update(timeCapsules)..where((t) => t.id.equals(id))).write(
      const TimeCapsuleCompanion(
        isUnlocked: Value(true),
      ),
    );
  }

  /// Mark capsule as read
  Future<void> markAsRead(int id) {
    return (update(timeCapsules)..where((t) => t.id.equals(id))).write(
      const TimeCapsuleCompanion(
        isRead: Value(true),
      ),
    );
  }

  /// Archive/unarchive capsule
  Future<void> setArchived(int id, bool archived) {
    return (update(timeCapsules)..where((t) => t.id.equals(id))).write(
      TimeCapsuleCompanion(
        isArchived: Value(archived),
      ),
    );
  }

  /// Delete capsule permanently
  Future<int> deleteCapsule(int id) {
    return (delete(timeCapsules)..where((t) => t.id.equals(id))).go();
  }

  /// Get count of locked capsules
  Future<int> getLockedCount() async {
    final count = countAll();
    final query = selectOnly(timeCapsules)
      ..where(timeCapsules.isUnlocked.equals(false) &
          timeCapsules.isArchived.equals(false))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get count of unlocked unread capsules
  Future<int> getUnreadCount() async {
    final count = countAll();
    final query = selectOnly(timeCapsules)
      ..where(timeCapsules.isUnlocked.equals(true) &
          timeCapsules.isRead.equals(false) &
          timeCapsules.isArchived.equals(false))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get next capsule to unlock
  Future<TimeCapsuleEntity?> getNextToUnlock() {
    final now = DateTime.now();
    return (select(timeCapsules)
          ..where((t) =>
              t.isUnlocked.equals(false) & t.unlockAt.isBiggerThanValue(now))
          ..orderBy([(t) => OrderingTerm.asc(t.unlockAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Unlock all capsules that are ready
  Future<int> unlockAllReady() async {
    final now = DateTime.now();
    return (update(timeCapsules)
          ..where((t) =>
              t.isUnlocked.equals(false) &
              t.unlockAt.isSmallerOrEqualValue(now)))
        .write(const TimeCapsuleCompanion(isUnlocked: Value(true)));
  }
}
