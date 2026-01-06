/// Echo Data Access Object for database operations
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/echo_table.dart';

part 'echo_dao.g.dart';

/// DAO for Echo operations (Memory Echoes feature)
@DriftAccessor(tables: [Echoes])
class EchoDao extends DatabaseAccessor<AppDatabase> with _$EchoDaoMixin {
  EchoDao(super.db);

  /// Get all echoes ordered by surfaced date
  Future<List<EchoEntity>> getAll() {
    return (select(echoes)
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)]))
        .get();
  }

  /// Get echo by ID
  Future<EchoEntity?> getById(int id) {
    return (select(echoes)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  /// Get viewed echoes
  Future<List<EchoEntity>> getViewed() {
    return (select(echoes)
          ..where((e) => e.wasViewed.equals(true))
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)]))
        .get();
  }

  /// Get unviewed echoes
  Future<List<EchoEntity>> getUnviewed() {
    return (select(echoes)
          ..where((e) => e.wasViewed.equals(false))
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)]))
        .get();
  }

  /// Get dismissed echoes
  Future<List<EchoEntity>> getDismissed() {
    return (select(echoes)
          ..where((e) => e.wasDismissed.equals(true))
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)]))
        .get();
  }

  /// Get echoes for a specific message
  Future<List<EchoEntity>> getByMessage(int messageId) {
    return (select(echoes)
          ..where((e) => e.messageId.equals(messageId))
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)]))
        .get();
  }

  /// Get today's echoes
  Future<List<EchoEntity>> getTodaysEchoes() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(echoes)
          ..where((e) =>
              e.surfacedAt.isBiggerOrEqualValue(startOfDay) &
              e.surfacedAt.isSmallerThanValue(endOfDay))
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)]))
        .get();
  }

  /// Get most recent unviewed echo
  Future<EchoEntity?> getMostRecentUnviewed() {
    return (select(echoes)
          ..where((e) => e.wasViewed.equals(false) & e.wasDismissed.equals(false))
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Check if message was already echoed recently (within days)
  Future<bool> wasRecentlyEchoed(int messageId, {int withinDays = 30}) async {
    final cutoff = DateTime.now().subtract(Duration(days: withinDays));
    final result = await (select(echoes)
          ..where((e) =>
              e.messageId.equals(messageId) &
              e.surfacedAt.isBiggerThanValue(cutoff))
          ..limit(1))
        .getSingleOrNull();
    return result != null;
  }

  /// Get recent echoes (limited)
  Future<List<EchoEntity>> getRecent({int limit = 10}) {
    return (select(echoes)
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)])
          ..limit(limit))
        .get();
  }

  /// Watch all echoes (stream)
  Stream<List<EchoEntity>> watchAll() {
    return (select(echoes)
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)]))
        .watch();
  }

  /// Watch unviewed echoes
  Stream<List<EchoEntity>> watchUnviewed() {
    return (select(echoes)
          ..where((e) => e.wasViewed.equals(false) & e.wasDismissed.equals(false))
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)]))
        .watch();
  }

  /// Watch today's echoes
  Stream<List<EchoEntity>> watchTodaysEchoes() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(echoes)
          ..where((e) =>
              e.surfacedAt.isBiggerOrEqualValue(startOfDay) &
              e.surfacedAt.isSmallerThanValue(endOfDay))
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)]))
        .watch();
  }

  /// Insert new echo
  Future<int> insertEcho(EchoesCompanion echo) {
    return into(echoes).insert(echo);
  }

  /// Surface a message as an echo
  Future<int> surfaceMessage(int messageId) {
    return into(echoes).insert(
      EchoesCompanion.insert(
        messageId: messageId,
      ),
    );
  }

  /// Mark echo as viewed
  Future<void> markAsViewed(int id) {
    return (update(echoes)..where((e) => e.id.equals(id))).write(
      const EchoesCompanion(
        wasViewed: Value(true),
      ),
    );
  }

  /// Mark echo as dismissed
  Future<void> markAsDismissed(int id) {
    return (update(echoes)..where((e) => e.id.equals(id))).write(
      const EchoesCompanion(
        wasDismissed: Value(true),
      ),
    );
  }

  /// Set reaction for echo
  Future<void> setReaction(int id, String? reaction) {
    return (update(echoes)..where((e) => e.id.equals(id))).write(
      EchoesCompanion(
        reaction: Value(reaction),
      ),
    );
  }

  /// Delete echo
  Future<int> deleteEcho(int id) {
    return (delete(echoes)..where((e) => e.id.equals(id))).go();
  }

  /// Delete echoes for a message
  Future<int> deleteByMessage(int messageId) {
    return (delete(echoes)..where((e) => e.messageId.equals(messageId))).go();
  }

  /// Get total echo count
  Future<int> getTotalCount() async {
    final count = countAll();
    final query = selectOnly(echoes)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get viewed echo count
  Future<int> getViewedCount() async {
    final count = countAll();
    final query = selectOnly(echoes)
      ..where(echoes.wasViewed.equals(true))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get unviewed echo count
  Future<int> getUnviewedCount() async {
    final count = countAll();
    final query = selectOnly(echoes)
      ..where(echoes.wasViewed.equals(false) & echoes.wasDismissed.equals(false))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Clean up old dismissed echoes (older than days)
  Future<int> cleanupOldDismissed({int olderThanDays = 90}) {
    final cutoff = DateTime.now().subtract(Duration(days: olderThanDays));
    return (delete(echoes)
          ..where((e) =>
              e.wasDismissed.equals(true) &
              e.surfacedAt.isSmallerThanValue(cutoff)))
        .go();
  }

  /// Get echoes in date range
  Future<List<EchoEntity>> getInDateRange(DateTime start, DateTime end) {
    return (select(echoes)
          ..where((e) =>
              e.surfacedAt.isBiggerOrEqualValue(start) &
              e.surfacedAt.isSmallerOrEqualValue(end))
          ..orderBy([(e) => OrderingTerm.desc(e.surfacedAt)]))
        .get();
  }
}
