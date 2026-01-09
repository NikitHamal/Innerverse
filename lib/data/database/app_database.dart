/// Main Drift database configuration for Innerverse
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'innerverse_db.sqlite'));
      return NativeDatabase(file);
    });
  }
}
