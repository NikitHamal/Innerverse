/// Message repository for data access abstraction
library;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/message.dart';
import '../database/app_database.dart';
import '../database/daos/message_dao.dart';

/// Repository for message data operations
class MessageRepository {
  final MessageDao _dao;
  final _uuid = const Uuid();

  MessageRepository(AppDatabase db) : _dao = MessageDao(db);

  /// Get messages for a conversation
  Future<List<Message>> getMessagesByConversation(int conversationId) async {
    final entities = await _dao.getByConversation(conversationId);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get all messages for a conversation (including deleted)
  Future<List<Message>> getAllMessagesByConversation(int conversationId) async {
    final entities = await _dao.getAllByConversation(conversationId);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get message by ID
  Future<Message?> getMessageById(int id) async {
    final entity = await _dao.getById(id);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get message by UUID
  Future<Message?> getMessageByUuid(String uuid) async {
    final entity = await _dao.getByUuid(uuid);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get messages by persona
  Future<List<Message>> getMessagesByPersona(int personaId) async {
    final entities = await _dao.getByPersona(personaId);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get starred messages
  Future<List<Message>> getStarredMessages() async {
    final entities = await _dao.getStarred();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get messages for echo surfacing
  Future<List<Message>> getMessagesForEchoSurfacing({
    int minAgeDays = 30,
    int limit = 100,
  }) async {
    final entities = await _dao.getForEchoSurfacing(
      minAgeDays: minAgeDays,
      limit: limit,
    );
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get messages by mood tag
  Future<List<Message>> getMessagesByMoodTag(MoodTag moodTag) async {
    final entities = await _dao.getByMoodTag(moodTag.id);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Watch messages for a conversation (stream)
  Stream<List<Message>> watchMessagesByConversation(int conversationId) {
    return _dao.watchByConversation(conversationId).map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch single message by ID
  Stream<Message?> watchMessageById(int id) {
    return _dao.watchById(id).map(
          (entity) => entity != null ? _mapEntityToDomain(entity) : null,
        );
  }

  /// Create a new message
  Future<int> createMessage({
    required int conversationId,
    required int personaId,
    required String content,
    MoodTag? moodTag,
  }) async {
    final companion = MessagesCompanion.insert(
      uuid: _uuid.v4(),
      conversationId: conversationId,
      personaId: personaId,
      content: content,
      moodTag: Value(moodTag?.id),
    );
    return _dao.insertMessage(companion);
  }

  /// Create message from domain entity
  Future<int> createMessageFromEntity(Message message) async {
    final companion = MessagesCompanion.insert(
      uuid: message.uuid,
      conversationId: message.conversationId,
      personaId: message.personaId,
      content: message.content,
      moodTag: Value(message.moodTag?.id),
      isEcho: Value(message.isEcho),
      isStarred: Value(message.isStarred),
    );
    return _dao.insertMessage(companion);
  }

  /// Update message
  Future<bool> updateMessage(Message message) async {
    if (message.id == null) return false;
    final entity = _mapDomainToEntity(message);
    return _dao.updateMessage(entity);
  }

  /// Update message content
  Future<void> updateMessageContent(int id, String content) {
    return _dao.updateContent(id, content);
  }

  /// Star message
  Future<void> starMessage(int id) {
    return _dao.setStarred(id, true);
  }

  /// Unstar message
  Future<void> unstarMessage(int id) {
    return _dao.setStarred(id, false);
  }

  /// Mark message as echo
  Future<void> markAsEcho(int id) {
    return _dao.markAsEcho(id);
  }

  /// Soft delete message
  Future<void> softDeleteMessage(int id) {
    return _dao.softDelete(id);
  }

  /// Delete message permanently
  Future<int> deleteMessage(int id) {
    return _dao.deleteMessage(id);
  }

  /// Delete all messages in a conversation
  Future<int> deleteMessagesByConversation(int conversationId) {
    return _dao.deleteByConversation(conversationId);
  }

  /// Get message count for a conversation
  Future<int> getCountByConversation(int conversationId) {
    return _dao.getCountByConversation(conversationId);
  }

  /// Get total message count
  Future<int> getTotalCount() {
    return _dao.getTotalCount();
  }

  /// Search messages by content
  Future<List<Message>> searchByContent(String query) async {
    final entities = await _dao.searchByContent(query);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get messages in date range
  Future<List<Message>> getMessagesInDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final entities = await _dao.getInDateRange(start, end);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get messages from exactly one year ago
  Future<List<Message>> getMessagesFromOneYearAgo() async {
    final entities = await _dao.getFromExactlyOneYearAgo();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get latest message for a conversation
  Future<Message?> getLatestMessageByConversation(int conversationId) async {
    final entity = await _dao.getLatestByConversation(conversationId);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get message count by persona
  Future<int> getCountByPersona(int personaId) {
    return _dao.getCountByPersona(personaId);
  }

  // ============================================================================
  // Mapping Methods
  // ============================================================================

  Message _mapEntityToDomain(MessageEntity entity) {
    return Message(
      id: entity.id,
      uuid: entity.uuid,
      conversationId: entity.conversationId,
      personaId: entity.personaId,
      content: entity.content,
      moodTag: MoodTag.fromId(entity.moodTag),
      isEcho: entity.isEcho,
      isStarred: entity.isStarred,
      isDeleted: entity.isDeleted,
      createdAt: entity.createdAt,
    );
  }

  MessageEntity _mapDomainToEntity(Message message) {
    return MessageEntity(
      id: message.id!,
      uuid: message.uuid,
      conversationId: message.conversationId,
      personaId: message.personaId,
      content: message.content,
      moodTag: message.moodTag?.id,
      isEcho: message.isEcho,
      isStarred: message.isStarred,
      isDeleted: message.isDeleted,
      createdAt: message.createdAt,
    );
  }
}
