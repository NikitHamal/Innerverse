/// Message table definition for Drift database
library;

import 'package:drift/drift.dart';

import 'conversation_table.dart';
import 'persona_table.dart';

/// Messages table - stores individual messages in conversations
@DataClassName('MessageEntity')
class Messages extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  /// UUID for external references
  TextColumn get uuid => text().withLength(min: 36, max: 36)();

  /// Foreign key to conversations table
  IntColumn get conversationId => integer().references(Conversations, #id)();

  /// Foreign key to personas table - which persona "sent" this message
  IntColumn get personaId => integer().references(Personas, #id)();

  /// Message content (rich text as markdown)
  TextColumn get content => text()();

  /// Optional mood tag for sentiment tracking
  TextColumn get moodTag => text().nullable()();

  /// Whether this message was surfaced as an echo
  BoolColumn get isEcho => boolean().withDefault(const Constant(false))();

  /// Whether message is starred/favorited
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();

  /// Whether message has been deleted (soft delete for vapor mode)
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {uuid}
      ];
}
