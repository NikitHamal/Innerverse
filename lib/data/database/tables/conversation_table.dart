/// Conversation table definition for Drift database
library;

import 'package:drift/drift.dart';

/// Conversations table - stores conversation threads
@DataClassName('ConversationEntity')
class Conversations extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  /// UUID for external references
  TextColumn get uuid => text().withLength(min: 36, max: 36)();

  /// Title of the conversation (optional)
  TextColumn get title => text().nullable()();

  /// Comma-separated list of persona IDs participating
  TextColumn get personaIds => text()();

  /// Space type identifier (sanctuary, storm_room, etc.)
  TextColumn get spaceType => text().withLength(min: 1, max: 50)();

  /// Conversation mode (mirror, council, timeline, etc.)
  TextColumn get mode => text().withLength(min: 1, max: 50)();

  /// Whether vapor mode is enabled (auto-delete after 24 hours)
  BoolColumn get isVaporMode => boolean().withDefault(const Constant(false))();

  /// When vapor mode expires (message deletion time)
  DateTimeColumn get vaporExpiresAt => dateTime().nullable()();

  /// Whether conversation is archived
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  /// Whether conversation is starred/favorited
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last update timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {uuid}
      ];
}
