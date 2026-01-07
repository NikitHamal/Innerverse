/// Conversation repository for data access abstraction
library;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/conversation.dart';
import '../database/app_database.dart';
import '../database/daos/conversation_dao.dart';

/// Repository for conversation data operations
class ConversationRepository {
  final ConversationDao _dao;
  final _uuid = const Uuid();

  ConversationRepository(AppDatabase db) : _dao = ConversationDao(db);

  /// Get all active (non-archived) conversations
  Future<List<Conversation>> getActiveConversations() async {
    final entities = await _dao.getAllActive();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get all conversations including archived
  Future<List<Conversation>> getAllConversations() async {
    final entities = await _dao.getAll();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get archived conversations
  Future<List<Conversation>> getArchivedConversations() async {
    final entities = await _dao.getArchived();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get starred conversations
  Future<List<Conversation>> getStarredConversations() async {
    final entities = await _dao.getStarred();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get conversation by ID
  Future<Conversation?> getConversationById(int id) async {
    final entity = await _dao.getById(id);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get conversation by UUID
  Future<Conversation?> getConversationByUuid(String uuid) async {
    final entity = await _dao.getByUuid(uuid);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get conversations by space type
  Future<List<Conversation>> getConversationsBySpace(SpaceType space) async {
    final entities = await _dao.getBySpace(space.id);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get conversations by mode
  Future<List<Conversation>> getConversationsByMode(ConversationMode mode) async {
    final entities = await _dao.getByMode(mode.id);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get recent conversations
  Future<List<Conversation>> getRecentConversations({int limit = 10}) async {
    final entities = await _dao.getRecent(limit: limit);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get expired vapor conversations
  Future<List<Conversation>> getExpiredVaporConversations() async {
    final entities = await _dao.getExpiredVaporConversations();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Watch all active conversations (stream)
  Stream<List<Conversation>> watchActiveConversations() {
    return _dao.watchAllActive().map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch conversations by space
  Stream<List<Conversation>> watchConversationsBySpace(SpaceType space) {
    return _dao.watchBySpace(space.id).map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch single conversation by ID
  Stream<Conversation?> watchConversationById(int id) {
    return _dao.watchById(id).map(
          (entity) => entity != null ? _mapEntityToDomain(entity) : null,
        );
  }

  /// Create a new conversation
  Future<int> createConversation({
    String? title,
    required List<int> personaIds,
    SpaceType spaceType = SpaceType.sanctuary,
    ConversationMode mode = ConversationMode.mirror,
    bool isVaporMode = false,
  }) async {
    final now = DateTime.now();
    final companion = ConversationsCompanion.insert(
      uuid: _uuid.v4(),
      title: Value(title),
      personaIds: personaIds.join(','),
      spaceType: spaceType.id,
      mode: mode.id,
      isVaporMode: Value(isVaporMode),
      vaporExpiresAt: isVaporMode
          ? Value(now.add(const Duration(hours: 24)))
          : const Value(null),
    );
    return _dao.insertConversation(companion);
  }

  /// Create conversation from domain entity
  Future<int> createConversationFromEntity(Conversation conversation) async {
    final companion = ConversationsCompanion.insert(
      uuid: conversation.uuid,
      title: Value(conversation.title),
      personaIds: conversation.personaIdsString,
      spaceType: conversation.spaceType.id,
      mode: conversation.mode.id,
      isVaporMode: Value(conversation.isVaporMode),
      vaporExpiresAt: Value(conversation.vaporExpiresAt),
    );
    return _dao.insertConversation(companion);
  }

  /// Update conversation
  Future<bool> updateConversation(Conversation conversation) async {
    if (conversation.id == null) return false;
    final entity = _mapDomainToEntity(conversation);
    return _dao.updateConversation(entity);
  }

  /// Touch conversation (update timestamp)
  Future<void> touchConversation(int id) {
    return _dao.touch(id);
  }

  /// Archive conversation
  Future<void> archiveConversation(int id) {
    return _dao.setArchived(id, true);
  }

  /// Unarchive conversation
  Future<void> unarchiveConversation(int id) {
    return _dao.setArchived(id, false);
  }

  /// Star conversation
  Future<void> starConversation(int id) {
    return _dao.setStarred(id, true);
  }

  /// Unstar conversation
  Future<void> unstarConversation(int id) {
    return _dao.setStarred(id, false);
  }

  /// Enable vapor mode
  Future<void> enableVaporMode(int id) {
    return _dao.setVaporMode(id, true);
  }

  /// Disable vapor mode
  Future<void> disableVaporMode(int id) {
    return _dao.setVaporMode(id, false);
  }

  /// Delete conversation permanently
  Future<int> deleteConversation(int id) {
    return _dao.deleteConversation(id);
  }

  /// Get conversation count by space
  Future<int> getCountBySpace(SpaceType space) {
    return _dao.getCountBySpace(space.id);
  }

  /// Get total active conversation count
  Future<int> getActiveCount() {
    return _dao.getActiveCount();
  }

  /// Search conversations by title
  Future<List<Conversation>> searchByTitle(String query) async {
    final entities = await _dao.searchByTitle(query);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get conversations containing a specific persona
  Future<List<Conversation>> getConversationsByPersona(int personaId) async {
    final entities = await _dao.getByPersona(personaId);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get conversations in date range
  Future<List<Conversation>> getConversationsInDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final entities = await _dao.getInDateRange(start, end);
    return entities.map(_mapEntityToDomain).toList();
  }

  // ============================================================================
  // Mapping Methods
  // ============================================================================

  Conversation _mapEntityToDomain(ConversationEntity entity) {
    return Conversation(
      id: entity.id,
      uuid: entity.uuid,
      title: entity.title,
      personaIds: Conversation.parsePersonaIds(entity.personaIds),
      spaceType: SpaceType.fromId(entity.spaceType),
      mode: ConversationMode.fromId(entity.mode),
      isVaporMode: entity.isVaporMode,
      vaporExpiresAt: entity.vaporExpiresAt,
      isArchived: entity.isArchived,
      isStarred: entity.isStarred,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ConversationEntity _mapDomainToEntity(Conversation conversation) {
    return ConversationEntity(
      id: conversation.id!,
      uuid: conversation.uuid,
      title: conversation.title,
      personaIds: conversation.personaIdsString,
      spaceType: conversation.spaceType.id,
      mode: conversation.mode.id,
      isVaporMode: conversation.isVaporMode,
      vaporExpiresAt: conversation.vaporExpiresAt,
      isArchived: conversation.isArchived,
      isStarred: conversation.isStarred,
      createdAt: conversation.createdAt,
      updatedAt: conversation.updatedAt,
    );
  }
}
