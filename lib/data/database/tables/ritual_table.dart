/// Ritual table definition for Drift database
library;

import 'package:drift/drift.dart';

/// Rituals table - stores completed ritual entries
@DataClassName('RitualEntity')
class Rituals extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  /// UUID for external references
  TextColumn get uuid => text().withLength(min: 36, max: 36)();

  /// Ritual type identifier (morning_intention, evening_reflection, etc.)
  TextColumn get type => text().withLength(min: 1, max: 50)();

  /// Optional custom name for custom rituals
  TextColumn get customName => text().nullable()();

  /// When the ritual was completed
  DateTimeColumn get completedAt => dateTime().withDefault(currentDateAndTime)();

  /// User's notes/content for the ritual
  TextColumn get notes => text().nullable()();

  /// Duration in seconds (how long the ritual took)
  IntColumn get durationSeconds => integer().nullable()();

  /// Mood rating (1-5) after completing
  IntColumn get moodRating => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {uuid}
      ];
}
