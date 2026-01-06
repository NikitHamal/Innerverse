/// Main Drift database configuration for Innerverse
library;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/tables.dart';

part 'app_database.g.dart';

/// Main application database
@DriftDatabase(
  tables: [
    Personas,
    Conversations,
    Messages,
    TimeCapsules,
    Rituals,
    UserProfiles,
    SpaceStatistics,
    Echoes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Initialize default user profile
        await _initializeDefaults();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
      },
    );
  }

  /// Initialize default data on first run
  Future<void> _initializeDefaults() async {
    // Create default user profile
    await into(userProfiles).insert(
      UserProfilesCompanion.insert(
        name: 'Explorer',
      ),
    );

    // Initialize space statistics for all spaces
    final spaceTypes = [
      'sanctuary',
      'the_void',
      'storm_room',
      'dream_garden',
      'memory_palace',
      'the_shore',
    ];

    for (final space in spaceTypes) {
      await into(spaceStatistics).insert(
        SpaceStatisticsCompanion.insert(
          spaceType: space,
        ),
      );
    }
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'innerverse_db');
  }
}
