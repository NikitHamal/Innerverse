/// Space Statistics repository for data access abstraction
library;

import '../../domain/entities/conversation.dart';
import '../../domain/entities/space_statistics.dart';
import '../database/app_database.dart';
import '../database/daos/space_statistics_dao.dart';

/// Repository for space statistics data operations
class SpaceStatisticsRepository {
  final SpaceStatisticsDao _dao;

  SpaceStatisticsRepository(AppDatabase db) : _dao = SpaceStatisticsDao(db);

  /// Get all space statistics
  Future<List<SpaceStatistics>> getAllStatistics() async {
    final entities = await _dao.getAll();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get statistics for a specific space
  Future<SpaceStatistics?> getStatisticsForSpace(SpaceType spaceType) async {
    final entity = await _dao.getBySpaceType(spaceType.id);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get statistics by ID
  Future<SpaceStatistics?> getStatisticsById(int id) async {
    final entity = await _dao.getById(id);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get most visited space
  Future<SpaceStatistics?> getMostVisitedSpace() async {
    final entity = await _dao.getMostVisited();
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get space with most time spent
  Future<SpaceStatistics?> getMostTimeSpentSpace() async {
    final entity = await _dao.getMostTimeSpent();
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get space with most messages
  Future<SpaceStatistics?> getMostMessagesSpace() async {
    final entity = await _dao.getMostMessages();
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get recently visited spaces
  Future<List<SpaceStatistics>> getRecentlyVisitedSpaces() async {
    final entities = await _dao.getRecentlyVisited();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Watch all space statistics (stream)
  Stream<List<SpaceStatistics>> watchAllStatistics() {
    return _dao.watchAll().map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch statistics for a specific space
  Stream<SpaceStatistics?> watchStatisticsForSpace(SpaceType spaceType) {
    return _dao.watchBySpaceType(spaceType.id).map(
          (entity) => entity != null ? _mapEntityToDomain(entity) : null,
        );
  }

  /// Record a space visit
  Future<void> recordVisit(SpaceType spaceType) {
    return _dao.recordVisit(spaceType.id);
  }

  /// Add time spent in a space
  Future<void> addTimeSpent(SpaceType spaceType, int seconds) {
    return _dao.addTimeSpent(spaceType.id, seconds);
  }

  /// Increment message count for a space
  Future<void> incrementMessageCount(SpaceType spaceType) {
    return _dao.incrementMessageCount(spaceType.id);
  }

  /// Increment conversation count for a space
  Future<void> incrementConversationCount(SpaceType spaceType) {
    return _dao.incrementConversationCount(spaceType.id);
  }

  /// Reset statistics for a space
  Future<void> resetStatisticsForSpace(SpaceType spaceType) {
    return _dao.resetForSpace(spaceType.id);
  }

  /// Reset all statistics
  Future<void> resetAllStatistics() {
    return _dao.resetAll();
  }

  /// Get total visits across all spaces
  Future<int> getTotalVisits() {
    return _dao.getTotalVisits();
  }

  /// Get total time spent across all spaces (in seconds)
  Future<int> getTotalTimeSpent() {
    return _dao.getTotalTimeSpent();
  }

  /// Get total messages across all spaces
  Future<int> getTotalMessages() {
    return _dao.getTotalMessages();
  }

  /// Get total conversations across all spaces
  Future<int> getTotalConversations() {
    return _dao.getTotalConversations();
  }

  /// Get a complete summary of all space statistics
  Future<SpaceStatisticsSummary> getSummary() async {
    final allStats = await getAllStatistics();
    final mostVisited = await getMostVisitedSpace();
    final mostTimeSpent = await getMostTimeSpentSpace();
    final totalVisits = await getTotalVisits();
    final totalTimeSpent = await getTotalTimeSpent();
    final totalMessages = await getTotalMessages();
    final totalConversations = await getTotalConversations();

    return SpaceStatisticsSummary(
      totalVisits: totalVisits,
      totalTimeSpent: totalTimeSpent,
      totalMessages: totalMessages,
      totalConversations: totalConversations,
      mostVisitedSpace: mostVisited?.spaceType,
      mostTimeSpentSpace: mostTimeSpent?.spaceType,
      allStats: allStats,
    );
  }

  /// Ensure all spaces have statistics entries
  Future<void> ensureAllSpacesExist() {
    final spaceTypeIds = SpaceType.values.map((s) => s.id).toList();
    return _dao.ensureAllSpacesExist(spaceTypeIds);
  }

  // ============================================================================
  // Mapping Methods
  // ============================================================================

  SpaceStatistics _mapEntityToDomain(SpaceStatisticsEntity entity) {
    return SpaceStatistics(
      id: entity.id,
      spaceType: SpaceType.fromId(entity.spaceType),
      visitCount: entity.visitCount,
      totalTimeSpent: entity.totalTimeSpent,
      messageCount: entity.messageCount,
      conversationCount: entity.conversationCount,
      lastVisitedAt: entity.lastVisitedAt,
      firstVisitedAt: entity.firstVisitedAt,
    );
  }
}
