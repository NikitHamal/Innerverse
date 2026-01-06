/// Persona table definition for Drift database
library;

import 'package:drift/drift.dart';

/// Personas table - stores user's inner personas
@DataClassName('PersonaEntity')
class Personas extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  /// UUID for external references
  TextColumn get uuid => text().withLength(min: 36, max: 36)();

  /// Display name of the persona
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Persona type identifier (inner_child, shadow_self, etc.)
  TextColumn get type => text().withLength(min: 1, max: 50)();

  /// Color as hex integer
  IntColumn get color => integer()();

  /// Optional avatar asset path
  TextColumn get avatarAsset => text().nullable()();

  /// User notes about this persona
  TextColumn get notes => text().nullable()();

  /// Whether persona is archived
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last activity timestamp
  DateTimeColumn get lastActiveAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {uuid}
      ];
}
