/// Echo table definition for Drift database
library;

import 'package:drift/drift.dart';

import 'message_table.dart';

/// Echoes table - tracks surfaced past messages (Memory Echoes feature)
@DataClassName('EchoEntity')
class Echoes extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to messages table - which message was surfaced
  IntColumn get messageId => integer().references(Messages, #id)();

  /// When the message was surfaced as an echo
  DateTimeColumn get surfacedAt => dateTime().withDefault(currentDateAndTime)();

  /// Whether the user viewed this echo
  BoolColumn get wasViewed => boolean().withDefault(const Constant(false))();

  /// Whether the user dismissed/closed the echo
  BoolColumn get wasDismissed => boolean().withDefault(const Constant(false))();

  /// Optional user reaction to the echo
  TextColumn get reaction => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
