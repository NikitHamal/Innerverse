/// Persona repository for data access abstraction
library;

import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/persona.dart';
import '../database/app_database.dart';
import '../database/daos/persona_dao.dart';

/// Repository for persona data operations
class PersonaRepository {
  final PersonaDao _dao;
  final _uuid = const Uuid();

  PersonaRepository(AppDatabase db) : _dao = PersonaDao(db);

  /// Get all active (non-archived) personas
  Future<List<Persona>> getActivePersonas() async {
    final entities = await _dao.getAllActive();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get all personas including archived
  Future<List<Persona>> getAllPersonas() async {
    final entities = await _dao.getAll();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get archived personas
  Future<List<Persona>> getArchivedPersonas() async {
    final entities = await _dao.getArchived();
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Get persona by ID
  Future<Persona?> getPersonaById(int id) async {
    final entity = await _dao.getById(id);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get persona by UUID
  Future<Persona?> getPersonaByUuid(String uuid) async {
    final entity = await _dao.getByUuid(uuid);
    return entity != null ? _mapEntityToDomain(entity) : null;
  }

  /// Get personas by type
  Future<List<Persona>> getPersonasByType(PersonaType type) async {
    final entities = await _dao.getByType(type.id);
    return entities.map(_mapEntityToDomain).toList();
  }

  /// Watch all active personas (stream)
  Stream<List<Persona>> watchActivePersonas() {
    return _dao.watchAllActive().map(
          (entities) => entities.map(_mapEntityToDomain).toList(),
        );
  }

  /// Watch single persona by ID
  Stream<Persona?> watchPersonaById(int id) {
    return _dao.watchById(id).map(
          (entity) => entity != null ? _mapEntityToDomain(entity) : null,
        );
  }

  /// Create a new persona
  Future<int> createPersona({
    required PersonaType type,
    String? customName,
    int? customColor,
    String? notes,
  }) async {
    final companion = PersonasCompanion.insert(
      uuid: _uuid.v4(),
      name: customName ?? type.displayName,
      type: type.id,
      color: customColor ?? type.defaultColor.value,
      notes: Value(notes),
    );
    return _dao.insertPersona(companion);
  }

  /// Create persona from domain entity
  Future<int> createPersonaFromEntity(Persona persona) async {
    final companion = PersonasCompanion.insert(
      uuid: persona.uuid,
      name: persona.name,
      type: persona.type.id,
      color: persona.color.value,
      avatarAsset: Value(persona.avatarAsset),
      notes: Value(persona.notes),
    );
    return _dao.insertPersona(companion);
  }

  /// Update persona
  Future<bool> updatePersona(Persona persona) async {
    if (persona.id == null) return false;
    final entity = _mapDomainToEntity(persona);
    return _dao.updatePersona(entity);
  }

  /// Update persona's last active time
  Future<void> updateLastActive(int id) {
    return _dao.updateLastActive(id);
  }

  /// Archive persona
  Future<void> archivePersona(int id) {
    return _dao.setArchived(id, true);
  }

  /// Unarchive persona
  Future<void> unarchivePersona(int id) {
    return _dao.setArchived(id, false);
  }

  /// Delete persona permanently
  Future<int> deletePersona(int id) {
    return _dao.deletePersona(id);
  }

  /// Get count of active personas
  Future<int> getActiveCount() {
    return _dao.getActiveCount();
  }

  /// Search personas by name
  Future<List<Persona>> searchByName(String query) async {
    final entities = await _dao.searchByName(query);
    return entities.map(_mapEntityToDomain).toList();
  }

  // ============================================================================
  // Mapping Methods
  // ============================================================================

  Persona _mapEntityToDomain(PersonaEntity entity) {
    return Persona(
      id: entity.id,
      uuid: entity.uuid,
      name: entity.name,
      type: PersonaType.fromId(entity.type),
      color: Color(entity.color),
      avatarAsset: entity.avatarAsset,
      notes: entity.notes,
      isArchived: entity.isArchived,
      createdAt: entity.createdAt,
      lastActiveAt: entity.lastActiveAt,
    );
  }

  PersonaEntity _mapDomainToEntity(Persona persona) {
    return PersonaEntity(
      id: persona.id!,
      uuid: persona.uuid,
      name: persona.name,
      type: persona.type.id,
      color: persona.color.value,
      avatarAsset: persona.avatarAsset,
      notes: persona.notes,
      isArchived: persona.isArchived,
      createdAt: persona.createdAt,
      lastActiveAt: persona.lastActiveAt,
    );
  }
}

