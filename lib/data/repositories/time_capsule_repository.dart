/// Time Capsule repository for data access abstraction
library;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/time_capsule.dart';
import '../database/app_database.dart';
import '../database/daos/time_capsule_dao.dart';

/// Repository for time capsule data operations
class TimeCapsuleRepository {
  final TimeCapsuleDao _dao;
  final _uuid = const Uuid();

  TimeCapsuleRepository(AppDatabase db) : _dao = TimeCapsuleDao(db);

  /// Get all active (non-archived) time capsules
  Future<List<TimeCapsule>> getActiveCapsules() async {
    final entities = await _dao.getAllActive();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get all time capsules including archived
  Future<List<TimeCapsule>> getAllCapsules() async {
    final entities = await _dao.getAll();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get locked (pending) time capsules
  Future<List<TimeCapsule>> getLockedCapsules() async {
    final entities = await _dao.getLocked();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get unlocked but unread capsules
  Future<List<TimeCapsule>> getUnlockedUnreadCapsules() async {
    final entities = await _dao.getUnlockedUnread();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get unlocked and read capsules
  Future<List<TimeCapsule>> getUnlockedReadCapsules() async {
    final entities = await _dao.getUnlockedRead();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get archived capsules
  Future<List<TimeCapsule>> getArchivedCapsules() async {
    final entities = await _dao.getArchived();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get time capsule by ID
  Future<TimeCapsule?> getCapsuleById(int id) async {
    final entity = await _dao.getById(id);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get time capsule by UUID
  Future<TimeCapsule?> getCapsuleByUuid(String uuid) async {
    final entity = await _dao.getByUuid(uuid);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get capsules that are ready to unlock
  Future<List<TimeCapsule>> getReadyToUnlockCapsules() async {
    final entities = await _dao.getReadyToUnlock();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get capsules unlocking soon
  Future<List<TimeCapsule>> getCapsuleUnlockingSoon({int withinDays = 7}) async {
    final entities = await _dao.getUnlockingSoon(withinDays: withinDays);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get capsules by persona
  Future<List<TimeCapsule>> getCapsulesByPersona(int personaId) async {
    final entities = await _dao.getByPersona(personaId);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get capsules by occasion
  Future<List<TimeCapsule>> getCapsulesByOccasion(CapsuleOccasion occasion) async {
    final entities = await _dao.getByOccasion(occasion.id);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Watch all active capsules (stream)
  Stream<List<TimeCapsule>> watchActiveCapsules() {
    return _dao.watchAllActive().map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch locked capsules
  Stream<List<TimeCapsule>> watchLockedCapsules() {
    return _dao.watchLocked().map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch unlocked unread capsules
  Stream<List<TimeCapsule>> watchUnlockedUnreadCapsules() {
    return _dao.watchUnlockedUnread().map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch single capsule by ID
  Stream<TimeCapsule?> watchCapsuleById(int id) {
    return _dao.watchById(id).map(
          (entity) => entity != null ? _mapEntityToDomain(entity) : null,
        );
  }

  /// Create a new time capsule
  Future<int> createCapsule({
    String? title,
    int? personaId,
    required String content,
    CapsuleOccasion? occasion,
    required DateTime unlockAt,
  }) async {
    final companion = TimeCapsuleCompanion.insert(
      uuid: _uuid.v4(),
      title: Value(title),
      personaId: Value(personaId),
      content: content,
      occasion: Value(occasion?.id),
      unlockAt: unlockAt,
    );
    return _dao.insertCapsule(companion);
  }

  /// Create time capsule from domain entity
  Future<int> createCapsuleFromEntity(TimeCapsule capsule) async {
    final companion = TimeCapsuleCompanion.insert(
      uuid: capsule.uuid,
      title: Value(capsule.title),
      personaId: Value(capsule.personaId),
      content: capsule.content,
      occasion: Value(capsule.occasion?.id),
      unlockAt: capsule.unlockAt,
    );
    return _dao.insertCapsule(companion);
  }

  /// Update time capsule
  Future<bool> updateCapsule(TimeCapsule capsule) async {
    if (capsule.id == null) return false;
    final entity = _mapDomainToEntity(capsule);
    return _dao.updateCapsule(entity);
  }

  /// Unlock a capsule
  Future<void> unlockCapsule(int id) {
    return _dao.unlock(id);
  }

  /// Mark capsule as read
  Future<void> markCapsuleAsRead(int id) {
    return _dao.markAsRead(id);
  }

  /// Archive capsule
  Future<void> archiveCapsule(int id) {
    return _dao.setArchived(id, true);
  }

  /// Unarchive capsule
  Future<void> unarchiveCapsule(int id) {
    return _dao.setArchived(id, false);
  }

  /// Delete capsule permanently
  Future<int> deleteCapsule(int id) {
    return _dao.deleteCapsule(id);
  }

  /// Get count of locked capsules
  Future<int> getLockedCount() {
    return _dao.getLockedCount();
  }

  /// Get count of unread capsules
  Future<int> getUnreadCount() {
    return _dao.getUnreadCount();
  }

  /// Get next capsule to unlock
  Future<TimeCapsule?> getNextToUnlock() async {
    final entity = await _dao.getNextToUnlock();
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Unlock all capsules that are ready
  Future<int> unlockAllReady() {
    return _dao.unlockAllReady();
  }

  // ============================================================================
  // Mapping Methods
  // ============================================================================

  TimeCapsule _mapEntityToDomain(TimeCapsuleEntity entity) {
    return TimeCapsule(
      id: entity.id,
      uuid: entity.uuid,
      title: entity.title,
      personaId: entity.personaId,
      content: entity.content,
      occasion: CapsuleOccasion.fromId(entity.occasion),
      createdAt: entity.createdAt,
      unlockAt: entity.unlockAt,
      isUnlocked: entity.isUnlocked,
      isRead: entity.isRead,
      isArchived: entity.isArchived,
    );
  }

  TimeCapsuleEntity _mapDomainToEntity(TimeCapsule capsule) {
    return TimeCapsuleEntity(
      id: capsule.id!,
      uuid: capsule.uuid,
      title: capsule.title,
      personaId: capsule.personaId,
      content: capsule.content,
      occasion: capsule.occasion?.id,
      createdAt: capsule.createdAt,
      unlockAt: capsule.unlockAt,
      isUnlocked: capsule.isUnlocked,
      isRead: capsule.isRead,
      isArchived: capsule.isArchived,
    );
  }
}
