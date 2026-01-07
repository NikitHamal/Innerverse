/// Main entry point for Innerverse
/// A revolutionary self-dialogue and inner exploration platform
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'core/errors/error_handler.dart';
import 'data/database/app_database.dart';
import 'presentation/providers/app_providers.dart';
import 'services/audio_service.dart';

/// Main entry point
Future<void> main() async {
  await ErrorHandler.runGuarded(_initializeApp);
}

/// Initialize the application
Future<void> _initializeApp() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI
  await _configureSystemUI();

  // Initialize storage
  await _initializeStorage();

  // Initialize database
  final database = AppDatabase();

  // Initialize shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize audio service
  final audioService = AudioService();
  await audioService.initialize();

  // Create provider overrides
  final overrides = [
    databaseProvider.overrideWithValue(database),
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    audioServiceProvider.overrideWithValue(audioService),
  ];

  // Run the app with Riverpod
  runApp(
    ProviderScope(
      overrides: overrides,
      child: const InnerverseApp(),
    ),
  );
}

/// Configure system UI overlays and orientation
Future<void> _configureSystemUI() async {
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Configure system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Enable edge-to-edge mode on Android
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
}

/// Initialize local storage (Hive)
Future<void> _initializeStorage() async {
  await Hive.initFlutter();

  // Register Hive adapters if needed
  // Hive.registerAdapter(SomeAdapter());

  // Open boxes for complex objects
  await Hive.openBox<Map>(StorageKeys.preferences);
  await Hive.openBox<Map>(StorageKeys.cache);
}

/// Extended storage keys for Hive boxes
extension StorageKeysExtended on StorageKeys {
  static const String preferences = 'preferences';
  static const String cache = 'cache';
}

/// Debug print helper for development
void debugLog(String message, {String? tag}) {
  if (kDebugMode) {
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('$prefix$message');
  }
}
