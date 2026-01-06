/// Space statistics table definition for Drift database
library;

import 'package:drift/drift.dart';

/// Space statistics table - tracks usage per emotional space
@DataClassName('SpaceStatisticsEntity')
class SpaceStatistics extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  /// Space type identifier (sanctuary, storm_room, etc.)
  TextColumn get spaceType => text().withLength(min: 1, max: 50)();

  /// Number of times the space has been visited
  IntColumn get visitCount => integer().withDefault(const Constant(0))();

  /// Total time spent in seconds
  IntColumn get totalTimeSpent => integer().withDefault(const Constant(0))();

  /// Number of messages written in this space
  IntColumn get messageCount => integer().withDefault(const Constant(0))();

  /// Number of conversations started in this space
  IntColumn get conversationCount => integer().withDefault(const Constant(0))();

  /// Last time the space was visited
  DateTimeColumn get lastVisitedAt => dateTime().nullable()();

  /// First time the space was visited
  DateTimeColumn get firstVisitedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {spaceType}
      ];
}
