/// Message Data Access Object for database operations
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/message_table.dart';

part 'message_dao.g.dart';

/// DAO for Message operations
@DriftAccessor(tables: [Messages])
class MessageDao extends DatabaseAccessor<AppDatabase> with _$MessageDaoMixin {
  MessageDao(super.db);

  /// Get all messages for a conversation
  Future<List<MessageEntity>> getByConversation(int conversationId) {
    return (select(messages)
          ..where((m) =>
              m.conversationId.equals(conversationId) &
              m.isDeleted.equals(false))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();
  }

  /// Get all messages for a conversation (including deleted for admin)
  Future<List<MessageEntity>> getAllByConversation(int conversationId) {
    return (select(messages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();
  }

  /// Get message by ID
  Future<MessageEntity?> getById(int id) {
    return (select(messages)..where((m) => m.id.equals(id))).getSingleOrNull();
  }

  /// Get message by UUID
  Future<MessageEntity?> getByUuid(String uuid) {
    return (select(messages)..where((m) => m.uuid.equals(uuid)))
        .getSingleOrNull();
  }

  /// Get messages by persona
  Future<List<MessageEntity>> getByPersona(int personaId) {
    return (select(messages)
          ..where(
              (m) => m.personaId.equals(personaId) & m.isDeleted.equals(false))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .get();
  }

  /// Get starred messages
  Future<List<MessageEntity>> getStarred() {
    return (select(messages)
          ..where((m) => m.isStarred.equals(true) & m.isDeleted.equals(false))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .get();
  }

  /// Get recent messages for echo surfacing
  Future<List<MessageEntity>> getForEchoSurfacing({
    int minAgeDays = 30,
    int limit = 100,
  }) {
    final cutoffDate = DateTime.now().subtract(Duration(days: minAgeDays));
    return (select(messages)
          ..where((m) =>
              m.isDeleted.equals(false) &
              m.isEcho.equals(false) &
              m.createdAt.isSmallerThanValue(cutoffDate))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)])
          ..limit(limit))
        .get();
  }

  /// Get messages by mood tag
  Future<List<MessageEntity>> getByMoodTag(String moodTag) {
    return (select(messages)
          ..where(
              (m) => m.moodTag.equals(moodTag) & m.isDeleted.equals(false))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .get();
  }

  /// Watch messages for a conversation (stream)
  Stream<List<MessageEntity>> watchByConversation(int conversationId) {
    return (select(messages)
          ..where((m) =>
              m.conversationId.equals(conversationId) &
              m.isDeleted.equals(false))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .watch();
  }

  /// Watch single message by ID
  Stream<MessageEntity?> watchById(int id) {
    return (select(messages)..where((m) => m.id.equals(id))).watchSingleOrNull();
  }

  /// Insert new message
  Future<int> insertMessage(MessagesCompanion message) {
    return into(messages).insert(message);
  }

  /// Update existing message
  Future<bool> updateMessage(MessageEntity message) {
    return update(messages).replace(message);
  }

  /// Update message content
  Future<void> updateContent(int id, String content) {
    return (update(messages)..where((m) => m.id.equals(id))).write(
      MessagesCompanion(
        content: Value(content),
      ),
    );
  }

  /// Star/unstar message
  Future<void> setStarred(int id, bool starred) {
    return (update(messages)..where((m) => m.id.equals(id))).write(
      MessagesCompanion(
        isStarred: Value(starred),
      ),
    );
  }

  /// Mark message as echo
  Future<void> markAsEcho(int id) {
    return (update(messages)..where((m) => m.id.equals(id))).write(
      const MessagesCompanion(
        isEcho: Value(true),
      ),
    );
  }

  /// Soft delete message
  Future<void> softDelete(int id) {
    return (update(messages)..where((m) => m.id.equals(id))).write(
      const MessagesCompanion(
        isDeleted: Value(true),
      ),
    );
  }

  /// Delete message permanently
  Future<int> deleteMessage(int id) {
    return (delete(messages)..where((m) => m.id.equals(id))).go();
  }

  /// Delete all messages in a conversation
  Future<int> deleteByConversation(int conversationId) {
    return (delete(messages)..where((m) => m.conversationId.equals(conversationId)))
        .go();
  }

  /// Get message count for a conversation
  Future<int> getCountByConversation(int conversationId) async {
    final count = countAll();
    final query = selectOnly(messages)
      ..where(messages.conversationId.equals(conversationId) &
          messages.isDeleted.equals(false))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get total message count
  Future<int> getTotalCount() async {
    final count = countAll();
    final query = selectOnly(messages)
      ..where(messages.isDeleted.equals(false))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Search messages by content
  Future<List<MessageEntity>> searchByContent(String query) {
    return (select(messages)
          ..where((m) => m.content.like('%$query%') & m.isDeleted.equals(false))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .get();
  }

  /// Get messages in date range
  Future<List<MessageEntity>> getInDateRange(DateTime start, DateTime end) {
    return (select(messages)
          ..where((m) =>
              m.createdAt.isBiggerOrEqualValue(start) &
              m.createdAt.isSmallerOrEqualValue(end) &
              m.isDeleted.equals(false))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .get();
  }

  /// Get messages exactly one year ago (for contrast view)
  Future<List<MessageEntity>> getFromExactlyOneYearAgo() {
    final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
    final startOfDay = DateTime(oneYearAgo.year, oneYearAgo.month, oneYearAgo.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(messages)
          ..where((m) =>
              m.createdAt.isBiggerOrEqualValue(startOfDay) &
              m.createdAt.isSmallerThanValue(endOfDay) &
              m.isDeleted.equals(false))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();
  }

  /// Get latest message for a conversation
  Future<MessageEntity?> getLatestByConversation(int conversationId) {
    return (select(messages)
          ..where((m) =>
              m.conversationId.equals(conversationId) &
              m.isDeleted.equals(false))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get message count by persona
  Future<int> getCountByPersona(int personaId) async {
    final count = countAll();
    final query = selectOnly(messages)
      ..where(
          messages.personaId.equals(personaId) & messages.isDeleted.equals(false))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
