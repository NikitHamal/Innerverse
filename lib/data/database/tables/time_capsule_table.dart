/// Time capsule table definition for Drift database
library;

import 'package:drift/drift.dart';

import 'persona_table.dart';

/// Time capsules table - stores messages scheduled for future delivery
@DataClassName('TimeCapsuleEntity')
class TimeCapsules extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  /// UUID for external references
  TextColumn get uuid => text().withLength(min: 36, max: 36)();

  /// Optional title for the capsule
  TextColumn get title => text().nullable()();

  /// Foreign key to personas table (optional - who wrote it)
  IntColumn get personaId => integer().nullable().references(Personas, #id)();

  /// Message content
  TextColumn get content => text()();

  /// Optional occasion/reason for the capsule
  TextColumn get occasion => text().nullable()();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// When the capsule should unlock
  DateTimeColumn get unlockAt => dateTime()();

  /// Whether the capsule has been unlocked (time has passed)
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();

  /// Whether the user has read the unlocked capsule
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  /// Whether the capsule is archived after reading
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {uuid}
      ];
}
