/// Space Statistics Data Access Object for database operations
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/space_statistics_table.dart';

part 'space_statistics_dao.g.dart';

/// DAO for Space Statistics operations
@DriftAccessor(tables: [SpaceStatistics])
class SpaceStatisticsDao extends DatabaseAccessor<AppDatabase>
    with _$SpaceStatisticsDaoMixin {
  SpaceStatisticsDao(super.db);

  /// Get all space statistics
  Future<List<SpaceStatisticsEntity>> getAll() {
    return (select(spaceStatistics)
          ..orderBy([(s) => OrderingTerm.desc(s.visitCount)]))
        .get();
  }

  /// Get statistics for a specific space
  Future<SpaceStatisticsEntity?> getBySpaceType(String spaceType) {
    return (select(spaceStatistics)..where((s) => s.spaceType.equals(spaceType)))
        .getSingleOrNull();
  }

  /// Get statistics by ID
  Future<SpaceStatisticsEntity?> getById(int id) {
    return (select(spaceStatistics)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get most visited space
  Future<SpaceStatisticsEntity?> getMostVisited() {
    return (select(spaceStatistics)
          ..orderBy([(s) => OrderingTerm.desc(s.visitCount)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get space with most time spent
  Future<SpaceStatisticsEntity?> getMostTimeSpent() {
    return (select(spaceStatistics)
          ..orderBy([(s) => OrderingTerm.desc(s.totalTimeSpent)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get space with most messages
  Future<SpaceStatisticsEntity?> getMostMessages() {
    return (select(spaceStatistics)
          ..orderBy([(s) => OrderingTerm.desc(s.messageCount)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get recently visited spaces (ordered by last visit)
  Future<List<SpaceStatisticsEntity>> getRecentlyVisited() {
    return (select(spaceStatistics)
          ..where((s) => s.lastVisitedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.desc(s.lastVisitedAt)]))
        .get();
  }

  /// Watch all space statistics (stream)
  Stream<List<SpaceStatisticsEntity>> watchAll() {
    return (select(spaceStatistics)
          ..orderBy([(s) => OrderingTerm.desc(s.visitCount)]))
        .watch();
  }

  /// Watch specific space statistics
  Stream<SpaceStatisticsEntity?> watchBySpaceType(String spaceType) {
    return (select(spaceStatistics)
          ..where((s) => s.spaceType.equals(spaceType)))
        .watchSingleOrNull();
  }

  /// Record a space visit
  Future<void> recordVisit(String spaceType) async {
    final stats = await getBySpaceType(spaceType);
    final now = DateTime.now();

    if (stats != null) {
      await (update(spaceStatistics)
            ..where((s) => s.spaceType.equals(spaceType)))
          .write(
        SpaceStatisticsCompanion(
          visitCount: Value(stats.visitCount + 1),
          lastVisitedAt: Value(now),
          firstVisitedAt: stats.firstVisitedAt == null
              ? Value(now)
              : const Value.absent(),
        ),
      );
    } else {
      await into(spaceStatistics).insert(
        SpaceStatisticsCompanion.insert(
          spaceType: spaceType,
          visitCount: const Value(1),
          lastVisitedAt: Value(now),
          firstVisitedAt: Value(now),
        ),
      );
    }
  }

  /// Add time spent in a space
  Future<void> addTimeSpent(String spaceType, int seconds) async {
    final stats = await getBySpaceType(spaceType);

    if (stats != null) {
      await (update(spaceStatistics)
            ..where((s) => s.spaceType.equals(spaceType)))
          .write(
        SpaceStatisticsCompanion(
          totalTimeSpent: Value(stats.totalTimeSpent + seconds),
        ),
      );
    }
  }

  /// Increment message count for a space
  Future<void> incrementMessageCount(String spaceType) async {
    final stats = await getBySpaceType(spaceType);

    if (stats != null) {
      await (update(spaceStatistics)
            ..where((s) => s.spaceType.equals(spaceType)))
          .write(
        SpaceStatisticsCompanion(
          messageCount: Value(stats.messageCount + 1),
        ),
      );
    }
  }

  /// Increment conversation count for a space
  Future<void> incrementConversationCount(String spaceType) async {
    final stats = await getBySpaceType(spaceType);

    if (stats != null) {
      await (update(spaceStatistics)
            ..where((s) => s.spaceType.equals(spaceType)))
          .write(
        SpaceStatisticsCompanion(
          conversationCount: Value(stats.conversationCount + 1),
        ),
      );
    }
  }

  /// Update statistics
  Future<bool> updateStatistics(SpaceStatisticsEntity stats) {
    return update(spaceStatistics).replace(stats);
  }

  /// Reset statistics for a space
  Future<void> resetForSpace(String spaceType) {
    return (update(spaceStatistics)
          ..where((s) => s.spaceType.equals(spaceType)))
        .write(
      const SpaceStatisticsCompanion(
        visitCount: Value(0),
        totalTimeSpent: Value(0),
        messageCount: Value(0),
        conversationCount: Value(0),
        lastVisitedAt: Value(null),
        firstVisitedAt: Value(null),
      ),
    );
  }

  /// Reset all statistics
  Future<void> resetAll() async {
    await (update(spaceStatistics)).write(
      const SpaceStatisticsCompanion(
        visitCount: Value(0),
        totalTimeSpent: Value(0),
        messageCount: Value(0),
        conversationCount: Value(0),
        lastVisitedAt: Value(null),
        firstVisitedAt: Value(null),
      ),
    );
  }

  /// Get total visits across all spaces
  Future<int> getTotalVisits() async {
    final sum = spaceStatistics.visitCount.sum();
    final query = selectOnly(spaceStatistics)..addColumns([sum]);
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  /// Get total time spent across all spaces (in seconds)
  Future<int> getTotalTimeSpent() async {
    final sum = spaceStatistics.totalTimeSpent.sum();
    final query = selectOnly(spaceStatistics)..addColumns([sum]);
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  /// Get total messages across all spaces
  Future<int> getTotalMessages() async {
    final sum = spaceStatistics.messageCount.sum();
    final query = selectOnly(spaceStatistics)..addColumns([sum]);
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  /// Get total conversations across all spaces
  Future<int> getTotalConversations() async {
    final sum = spaceStatistics.conversationCount.sum();
    final query = selectOnly(spaceStatistics)..addColumns([sum]);
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  /// Ensure all spaces have statistics entries
  Future<void> ensureAllSpacesExist(List<String> spaceTypes) async {
    for (final spaceType in spaceTypes) {
      final exists = await getBySpaceType(spaceType);
      if (exists == null) {
        await into(spaceStatistics).insert(
          SpaceStatisticsCompanion.insert(
            spaceType: spaceType,
          ),
        );
      }
    }
  }
}
