/// Conversation Data Access Object for database operations
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/conversation_table.dart';

part 'conversation_dao.g.dart';

/// DAO for Conversation operations
@DriftAccessor(tables: [Conversations])
class ConversationDao extends DatabaseAccessor<AppDatabase>
    with _$ConversationDaoMixin {
  ConversationDao(super.db);

  /// Get all non-archived conversations ordered by most recent
  Future<List<ConversationEntity>> getAllActive() {
    return (select(conversations)
          ..where((c) => c.isArchived.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .get();
  }

  /// Get all conversations including archived
  Future<List<ConversationEntity>> getAll() {
    return (select(conversations)
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .get();
  }

  /// Get archived conversations
  Future<List<ConversationEntity>> getArchived() {
    return (select(conversations)
          ..where((c) => c.isArchived.equals(true))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .get();
  }

  /// Get starred conversations
  Future<List<ConversationEntity>> getStarred() {
    return (select(conversations)
          ..where((c) => c.isStarred.equals(true) & c.isArchived.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .get();
  }

  /// Get conversation by ID
  Future<ConversationEntity?> getById(int id) {
    return (select(conversations)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get conversation by UUID
  Future<ConversationEntity?> getByUuid(String uuid) {
    return (select(conversations)..where((c) => c.uuid.equals(uuid)))
        .getSingleOrNull();
  }

  /// Get conversations by space type
  Future<List<ConversationEntity>> getBySpace(String spaceType) {
    return (select(conversations)
          ..where(
              (c) => c.spaceType.equals(spaceType) & c.isArchived.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .get();
  }

  /// Get conversations by mode
  Future<List<ConversationEntity>> getByMode(String mode) {
    return (select(conversations)
          ..where((c) => c.mode.equals(mode) & c.isArchived.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .get();
  }

  /// Get recent conversations (limited)
  Future<List<ConversationEntity>> getRecent({int limit = 10}) {
    return (select(conversations)
          ..where((c) => c.isArchived.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)])
          ..limit(limit))
        .get();
  }

  /// Get conversations that need vapor mode cleanup
  Future<List<ConversationEntity>> getExpiredVaporConversations() {
    final now = DateTime.now();
    return (select(conversations)
          ..where((c) =>
              c.isVaporMode.equals(true) & c.vaporExpiresAt.isSmallerThanValue(now)))
        .get();
  }

  /// Watch all active conversations (stream)
  Stream<List<ConversationEntity>> watchAllActive() {
    return (select(conversations)
          ..where((c) => c.isArchived.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .watch();
  }

  /// Watch conversations by space
  Stream<List<ConversationEntity>> watchBySpace(String spaceType) {
    return (select(conversations)
          ..where(
              (c) => c.spaceType.equals(spaceType) & c.isArchived.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .watch();
  }

  /// Watch single conversation by ID
  Stream<ConversationEntity?> watchById(int id) {
    return (select(conversations)..where((c) => c.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Insert new conversation
  Future<int> insertConversation(ConversationsCompanion conversation) {
    return into(conversations).insert(conversation);
  }

  /// Update existing conversation
  Future<bool> updateConversation(ConversationEntity conversation) {
    return update(conversations).replace(conversation);
  }

  /// Update conversation's updated timestamp
  Future<void> touch(int id) {
    return (update(conversations)..where((c) => c.id.equals(id))).write(
      ConversationsCompanion(
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Archive/unarchive conversation
  Future<void> setArchived(int id, bool archived) {
    return (update(conversations)..where((c) => c.id.equals(id))).write(
      ConversationsCompanion(
        isArchived: Value(archived),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Star/unstar conversation
  Future<void> setStarred(int id, bool starred) {
    return (update(conversations)..where((c) => c.id.equals(id))).write(
      ConversationsCompanion(
        isStarred: Value(starred),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Enable/disable vapor mode
  Future<void> setVaporMode(int id, bool enabled) {
    final expiresAt = enabled ? DateTime.now().add(const Duration(hours: 24)) : null;
    return (update(conversations)..where((c) => c.id.equals(id))).write(
      ConversationsCompanion(
        isVaporMode: Value(enabled),
        vaporExpiresAt: Value(expiresAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete conversation permanently
  Future<int> deleteConversation(int id) {
    return (delete(conversations)..where((c) => c.id.equals(id))).go();
  }

  /// Get conversation count by space
  Future<int> getCountBySpace(String spaceType) async {
    final count = countAll();
    final query = selectOnly(conversations)
      ..where(
          conversations.spaceType.equals(spaceType) & conversations.isArchived.equals(false))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get total active conversation count
  Future<int> getActiveCount() async {
    final count = countAll();
    final query = selectOnly(conversations)
      ..where(conversations.isArchived.equals(false))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Search conversations by title
  Future<List<ConversationEntity>> searchByTitle(String query) {
    return (select(conversations)
          ..where((c) =>
              c.title.like('%$query%') & c.isArchived.equals(false)))
        .get();
  }

  /// Get conversations containing specific persona
  Future<List<ConversationEntity>> getByPersona(int personaId) {
    final personaIdStr = personaId.toString();
    return (select(conversations)
          ..where((c) =>
              c.personaIds.like('%$personaIdStr%') & c.isArchived.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .get();
  }

  /// Get conversations in date range
  Future<List<ConversationEntity>> getInDateRange(
    DateTime start,
    DateTime end,
  ) {
    return (select(conversations)
          ..where((c) =>
              c.createdAt.isBiggerOrEqualValue(start) &
              c.createdAt.isSmallerOrEqualValue(end) &
              c.isArchived.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.createdAt)]))
        .get();
  }
}
