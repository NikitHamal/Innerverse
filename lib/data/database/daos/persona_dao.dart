/// Persona Data Access Object for database operations
library;

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/persona_table.dart';

part 'persona_dao.g.dart';

/// DAO for Persona operations
@DriftAccessor(tables: [Personas])
class PersonaDao extends DatabaseAccessor<AppDatabase> with _$PersonaDaoMixin {
  PersonaDao(super.db);

  /// Get all non-archived personas ordered by last active
  Future<List<PersonaEntity>> getAllActive() {
    return (select(personas)
          ..where((p) => p.isArchived.equals(false))
          ..orderBy([(p) => OrderingTerm.desc(p.lastActiveAt)]))
        .get();
  }

  /// Get all personas including archived
  Future<List<PersonaEntity>> getAll() {
    return (select(personas)
          ..orderBy([(p) => OrderingTerm.desc(p.lastActiveAt)]))
        .get();
  }

  /// Get archived personas
  Future<List<PersonaEntity>> getArchived() {
    return (select(personas)
          ..where((p) => p.isArchived.equals(true))
          ..orderBy([(p) => OrderingTerm.desc(p.lastActiveAt)]))
        .get();
  }

  /// Get persona by ID
  Future<PersonaEntity?> getById(int id) {
    return (select(personas)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  /// Get persona by UUID
  Future<PersonaEntity?> getByUuid(String uuid) {
    return (select(personas)..where((p) => p.uuid.equals(uuid)))
        .getSingleOrNull();
  }

  /// Get personas by type
  Future<List<PersonaEntity>> getByType(String type) {
    return (select(personas)
          ..where((p) => p.type.equals(type) & p.isArchived.equals(false)))
        .get();
  }

  /// Watch all active personas (stream)
  Stream<List<PersonaEntity>> watchAllActive() {
    return (select(personas)
          ..where((p) => p.isArchived.equals(false))
          ..orderBy([(p) => OrderingTerm.desc(p.lastActiveAt)]))
        .watch();
  }

  /// Watch single persona by ID
  Stream<PersonaEntity?> watchById(int id) {
    return (select(personas)..where((p) => p.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Insert new persona
  Future<int> insertPersona(PersonasCompanion persona) {
    return into(personas).insert(persona);
  }

  /// Update existing persona
  Future<bool> updatePersona(PersonaEntity persona) {
    return update(personas).replace(persona);
  }

  /// Update persona's last active time
  Future<void> updateLastActive(int id) {
    return (update(personas)..where((p) => p.id.equals(id))).write(
      PersonasCompanion(
        lastActiveAt: Value(DateTime.now()),
      ),
    );
  }

  /// Archive/unarchive persona
  Future<void> setArchived(int id, bool archived) {
    return (update(personas)..where((p) => p.id.equals(id))).write(
      PersonasCompanion(
        isArchived: Value(archived),
      ),
    );
  }

  /// Delete persona permanently
  Future<int> deletePersona(int id) {
    return (delete(personas)..where((p) => p.id.equals(id))).go();
  }

  /// Get persona count (active only)
  Future<int> getActiveCount() async {
    final count = countAll();
    final query = selectOnly(personas)
      ..where(personas.isArchived.equals(false))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Search personas by name
  Future<List<PersonaEntity>> searchByName(String query) {
    return (select(personas)
          ..where((p) =>
              p.name.like('%$query%') & p.isArchived.equals(false)))
        .get();
  }
}
