/// Echo repository for data access abstraction
library;

import 'package:drift/drift.dart';

import '../../domain/entities/echo.dart';
import '../database/app_database.dart';
import '../database/daos/echo_dao.dart';

/// Repository for echo (memory echoes) data operations
class EchoRepository {
  final EchoDao _dao;

  EchoRepository(AppDatabase db) : _dao = EchoDao(db);

  /// Get all echoes
  Future<List<Echo>> getAllEchoes() async {
    final entities = await _dao.getAll();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get echo by ID
  Future<Echo?> getEchoById(int id) async {
    final entity = await _dao.getById(id);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get viewed echoes
  Future<List<Echo>> getViewedEchoes() async {
    final entities = await _dao.getViewed();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get unviewed echoes
  Future<List<Echo>> getUnviewedEchoes() async {
    final entities = await _dao.getUnviewed();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get dismissed echoes
  Future<List<Echo>> getDismissedEchoes() async {
    final entities = await _dao.getDismissed();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get echoes for a specific message
  Future<List<Echo>> getEchoesForMessage(int messageId) async {
    final entities = await _dao.getByMessage(messageId);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get today's echoes
  Future<List<Echo>> getTodaysEchoes() async {
    final entities = await _dao.getTodaysEchoes();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get most recent unviewed echo
  Future<Echo?> getMostRecentUnviewedEcho() async {
    final entity = await _dao.getMostRecentUnviewed();
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Check if a message was recently echoed
  Future<bool> wasMessageRecentlyEchoed(int messageId, {int withinDays = 30}) {
    return _dao.wasRecentlyEchoed(messageId, withinDays: withinDays);
  }

  /// Get recent echoes
  Future<List<Echo>> getRecentEchoes({int limit = 10}) async {
    final entities = await _dao.getRecent(limit: limit);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Watch all echoes (stream)
  Stream<List<Echo>> watchAllEchoes() {
    return _dao.watchAll().map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch unviewed echoes
  Stream<List<Echo>> watchUnviewedEchoes() {
    return _dao.watchUnviewed().map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch today's echoes
  Stream<List<Echo>> watchTodaysEchoes() {
    return _dao.watchTodaysEchoes().map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Surface a message as an echo
  Future<int> surfaceMessage(int messageId) {
    return _dao.surfaceMessage(messageId);
  }

  /// Create a new echo
  Future<int> createEcho(Echo echo) async {
    final companion = EchoesCompanion.insert(
      messageId: echo.messageId,
    );
    return _dao.insertEcho(companion);
  }

  /// Mark echo as viewed
  Future<void> markAsViewed(int id) {
    return _dao.markAsViewed(id);
  }

  /// Mark echo as dismissed
  Future<void> markAsDismissed(int id) {
    return _dao.markAsDismissed(id);
  }

  /// Set reaction for echo
  Future<void> setReaction(int id, EchoReaction? reaction) {
    return _dao.setReaction(id, reaction?.id);
  }

  /// Delete echo
  Future<int> deleteEcho(int id) {
    return _dao.deleteEcho(id);
  }

  /// Delete echoes for a message
  Future<int> deleteEchoesForMessage(int messageId) {
    return _dao.deleteByMessage(messageId);
  }

  /// Get total echo count
  Future<int> getTotalCount() {
    return _dao.getTotalCount();
  }

  /// Get viewed echo count
  Future<int> getViewedCount() {
    return _dao.getViewedCount();
  }

  /// Get unviewed echo count
  Future<int> getUnviewedCount() {
    return _dao.getUnviewedCount();
  }

  /// Clean up old dismissed echoes
  Future<int> cleanupOldDismissed({int olderThanDays = 90}) {
    return _dao.cleanupOldDismissed(olderThanDays: olderThanDays);
  }

  /// Get echoes in date range
  Future<List<Echo>> getEchoesInDateRange(DateTime start, DateTime end) async {
    final entities = await _dao.getInDateRange(start, end);
    return entities.map(_mapEntityToDomain).toList();
  }

  // ============================================================================
  // Mapping Methods
  // ============================================================================

  Echo _mapEntityToDomain(EchoEntity entity) {
    return Echo(
      id: entity.id,
      messageId: entity.messageId,
      surfacedAt: entity.surfacedAt,
      wasViewed: entity.wasViewed,
      wasDismissed: entity.wasDismissed,
      reaction: EchoReaction.fromId(entity.reaction),
    );
  }
}
