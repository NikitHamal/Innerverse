/// Ritual Data Access Object for database operations
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/ritual_table.dart';

part 'ritual_dao.g.dart';

/// DAO for Ritual operations
@DriftAccessor(tables: [Rituals])
class RitualDao extends DatabaseAccessor<AppDatabase> with _$RitualDaoMixin {
  RitualDao(super.db);

  /// Get all rituals ordered by completion date
  Future<List<RitualEntity>> getAll() {
    return (select(rituals)
          ..orderBy([(r) => OrderingTerm.desc(r.completedAt)]))
        .get();
  }

  /// Get rituals by type
  Future<List<RitualEntity>> getByType(String type) {
    return (select(rituals)
          ..where((r) => r.type.equals(type))
          ..orderBy([(r) => OrderingTerm.desc(r.completedAt)]))
        .get();
  }

  /// Get ritual by ID
  Future<RitualEntity?> getById(int id) {
    return (select(rituals)..where((r) => r.id.equals(id))).getSingleOrNull();
  }

  /// Get ritual by UUID
  Future<RitualEntity?> getByUuid(String uuid) {
    return (select(rituals)..where((r) => r.uuid.equals(uuid)))
        .getSingleOrNull();
  }

  /// Get today's rituals
  Future<List<RitualEntity>> getTodaysRituals() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(rituals)
          ..where((r) =>
              r.completedAt.isBiggerOrEqualValue(startOfDay) &
              r.completedAt.isSmallerThanValue(endOfDay))
          ..orderBy([(r) => OrderingTerm.desc(r.completedAt)]))
        .get();
  }

  /// Check if ritual type was completed today
  Future<bool> wasCompletedToday(String type) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await (select(rituals)
          ..where((r) =>
              r.type.equals(type) &
              r.completedAt.isBiggerOrEqualValue(startOfDay) &
              r.completedAt.isSmallerThanValue(endOfDay))
          ..limit(1))
        .getSingleOrNull();

    return result != null;
  }

  /// Get rituals completed this week
  Future<List<RitualEntity>> getThisWeeksRituals() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekMidnight =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return (select(rituals)
          ..where((r) => r.completedAt.isBiggerOrEqualValue(startOfWeekMidnight))
          ..orderBy([(r) => OrderingTerm.desc(r.completedAt)]))
        .get();
  }

  /// Get rituals completed this month
  Future<List<RitualEntity>> getThisMonthsRituals() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    return (select(rituals)
          ..where((r) => r.completedAt.isBiggerOrEqualValue(startOfMonth))
          ..orderBy([(r) => OrderingTerm.desc(r.completedAt)]))
        .get();
  }

  /// Get recent rituals (limited)
  Future<List<RitualEntity>> getRecent({int limit = 10}) {
    return (select(rituals)
          ..orderBy([(r) => OrderingTerm.desc(r.completedAt)])
          ..limit(limit))
        .get();
  }

  /// Get rituals in date range
  Future<List<RitualEntity>> getInDateRange(DateTime start, DateTime end) {
    return (select(rituals)
          ..where((r) =>
              r.completedAt.isBiggerOrEqualValue(start) &
              r.completedAt.isSmallerOrEqualValue(end))
          ..orderBy([(r) => OrderingTerm.desc(r.completedAt)]))
        .get();
  }

  /// Watch all rituals (stream)
  Stream<List<RitualEntity>> watchAll() {
    return (select(rituals)
          ..orderBy([(r) => OrderingTerm.desc(r.completedAt)]))
        .watch();
  }

  /// Watch today's rituals
  Stream<List<RitualEntity>> watchTodaysRituals() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(rituals)
          ..where((r) =>
              r.completedAt.isBiggerOrEqualValue(startOfDay) &
              r.completedAt.isSmallerThanValue(endOfDay))
          ..orderBy([(r) => OrderingTerm.desc(r.completedAt)]))
        .watch();
  }

  /// Watch single ritual by ID
  Stream<RitualEntity?> watchById(int id) {
    return (select(rituals)..where((r) => r.id.equals(id))).watchSingleOrNull();
  }

  /// Insert new ritual
  Future<int> insertRitual(RitualsCompanion ritual) {
    return into(rituals).insert(ritual);
  }

  /// Update existing ritual
  Future<bool> updateRitual(RitualEntity ritual) {
    return update(rituals).replace(ritual);
  }

  /// Delete ritual
  Future<int> deleteRitual(int id) {
    return (delete(rituals)..where((r) => r.id.equals(id))).go();
  }

  /// Get total ritual count
  Future<int> getTotalCount() async {
    final count = countAll();
    final query = selectOnly(rituals)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get count by type
  Future<int> getCountByType(String type) async {
    final count = countAll();
    final query = selectOnly(rituals)
      ..where(rituals.type.equals(type))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get completion streak for a ritual type
  Future<int> getStreakForType(String type) async {
    final now = DateTime.now();
    var streak = 0;
    var currentDate = DateTime(now.year, now.month, now.day);

    while (true) {
      final startOfDay = currentDate;
      final endOfDay = currentDate.add(const Duration(days: 1));

      final result = await (select(rituals)
            ..where((r) =>
                r.type.equals(type) &
                r.completedAt.isBiggerOrEqualValue(startOfDay) &
                r.completedAt.isSmallerThanValue(endOfDay))
            ..limit(1))
          .getSingleOrNull();

      if (result != null) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  /// Get average mood rating for ritual type
  Future<double?> getAverageMoodRating(String type) async {
    final avgMood = rituals.moodRating.avg();
    final query = selectOnly(rituals)
      ..where(rituals.type.equals(type) & rituals.moodRating.isNotNull())
      ..addColumns([avgMood]);
    final result = await query.getSingle();
    return result.read(avgMood);
  }

  /// Get average duration for ritual type (in seconds)
  Future<double?> getAverageDuration(String type) async {
    final avgDuration = rituals.durationSeconds.avg();
    final query = selectOnly(rituals)
      ..where(rituals.type.equals(type) & rituals.durationSeconds.isNotNull())
      ..addColumns([avgDuration]);
    final result = await query.getSingle();
    return result.read(avgDuration);
  }

  /// Get unique days with rituals completed (for stats)
  Future<int> getUniqueDaysWithRituals() async {
    final allRituals = await (select(rituals)
          ..orderBy([(r) => OrderingTerm.desc(r.completedAt)]))
        .get();

    final uniqueDays = <String>{};
    for (final ritual in allRituals) {
      final dateKey =
          '${ritual.completedAt.year}-${ritual.completedAt.month}-${ritual.completedAt.day}';
      uniqueDays.add(dateKey);
    }

    return uniqueDays.length;
  }
}
