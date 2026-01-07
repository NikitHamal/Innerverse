/// Ritual repository for data access abstraction
library;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/ritual.dart';
import '../database/app_database.dart';
import '../database/daos/ritual_dao.dart';

/// Repository for ritual data operations
class RitualRepository {
  final RitualDao _dao;
  final _uuid = const Uuid();

  RitualRepository(AppDatabase db) : _dao = RitualDao(db);

  /// Get all rituals
  Future<List<Ritual>> getAllRituals() async {
    final entities = await _dao.getAll();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get rituals by type
  Future<List<Ritual>> getRitualsByType(RitualType type) async {
    final entities = await _dao.getByType(type.id);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get ritual by ID
  Future<Ritual?> getRitualById(int id) async {
    final entity = await _dao.getById(id);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get ritual by UUID
  Future<Ritual?> getRitualByUuid(String uuid) async {
    final entity = await _dao.getByUuid(uuid);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get today's rituals
  Future<List<Ritual>> getTodaysRituals() async {
    final entities = await _dao.getTodaysRituals();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Check if ritual type was completed today
  Future<bool> wasCompletedToday(RitualType type) {
    return _dao.wasCompletedToday(type.id);
  }

  /// Get this week's rituals
  Future<List<Ritual>> getThisWeeksRituals() async {
    final entities = await _dao.getThisWeeksRituals();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get this month's rituals
  Future<List<Ritual>> getThisMonthsRituals() async {
    final entities = await _dao.getThisMonthsRituals();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get recent rituals
  Future<List<Ritual>> getRecentRituals({int limit = 10}) async {
    final entities = await _dao.getRecent(limit: limit);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get rituals in date range
  Future<List<Ritual>> getRitualsInDateRange(DateTime start, DateTime end) async {
    final entities = await _dao.getInDateRange(start, end);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Watch all rituals (stream)
  Stream<List<Ritual>> watchAllRituals() {
    return _dao.watchAll().map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch today's rituals
  Stream<List<Ritual>> watchTodaysRituals() {
    return _dao.watchTodaysRituals().map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch single ritual by ID
  Stream<Ritual?> watchRitualById(int id) {
    return _dao.watchById(id).map(
          (entity) => entity != null ? _mapEntityToDomain(entity) : null,
        );
  }

  /// Create a new ritual (record completion)
  Future<int> createRitual({
    required RitualType type,
    String? customName,
    String? notes,
    int? moodRating,
    int? durationSeconds,
  }) async {
    final companion = RitualsCompanion.insert(
      uuid: _uuid.v4(),
      type: type.id,
      customName: Value(customName),
      notes: Value(notes),
      moodRating: Value(moodRating),
      durationSeconds: Value(durationSeconds),
    );
    return _dao.insertRitual(companion);
  }

  /// Create ritual from domain entity
  Future<int> createRitualFromEntity(Ritual ritual) async {
    final companion = RitualsCompanion.insert(
      uuid: ritual.uuid,
      type: ritual.type.id,
      customName: Value(ritual.customName),
      notes: Value(ritual.notes),
      moodRating: Value(ritual.moodRating),
      durationSeconds: Value(ritual.durationSeconds),
    );
    return _dao.insertRitual(companion);
  }

  /// Update ritual
  Future<bool> updateRitual(Ritual ritual) async {
    if (ritual.id == null) return false;
    final entity = _mapDomainToEntity(ritual);
    return _dao.updateRitual(entity);
  }

  /// Delete ritual
  Future<int> deleteRitual(int id) {
    return _dao.deleteRitual(id);
  }

  /// Get total ritual count
  Future<int> getTotalCount() {
    return _dao.getTotalCount();
  }

  /// Get count by type
  Future<int> getCountByType(RitualType type) {
    return _dao.getCountByType(type.id);
  }

  /// Get completion streak for a ritual type
  Future<int> getStreakForType(RitualType type) {
    return _dao.getStreakForType(type.id);
  }

  /// Get average mood rating for ritual type
  Future<double?> getAverageMoodRating(RitualType type) {
    return _dao.getAverageMoodRating(type.id);
  }

  /// Get average duration for ritual type (in seconds)
  Future<double?> getAverageDuration(RitualType type) {
    return _dao.getAverageDuration(type.id);
  }

  /// Get unique days with rituals completed
  Future<int> getUniqueDaysWithRituals() {
    return _dao.getUniqueDaysWithRituals();
  }

  // ============================================================================
  // Mapping Methods
  // ============================================================================

  Ritual _mapEntityToDomain(RitualEntity entity) {
    return Ritual(
      id: entity.id,
      uuid: entity.uuid,
      type: RitualType.fromId(entity.type),
      customName: entity.customName,
      completedAt: entity.completedAt,
      notes: entity.notes,
      moodRating: entity.moodRating,
      durationSeconds: entity.durationSeconds,
    );
  }

  RitualEntity _mapDomainToEntity(Ritual ritual) {
    return RitualEntity(
      id: ritual.id!,
      uuid: ritual.uuid,
      type: ritual.type.id,
      customName: ritual.customName,
      completedAt: ritual.completedAt,
      notes: ritual.notes,
      moodRating: ritual.moodRating,
      durationSeconds: ritual.durationSeconds,
    );
  }
}
