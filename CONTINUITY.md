# Innerverse - Session Continuity Ledger

## Goal (incl. success criteria):
Build a production-ready, cross-platform (Android, iOS, Web) Flutter app called "Innerverse" - a self-dialogue and inner exploration platform with:
- Material 3 design with cosmic/ethereal aesthetic
- Local-first architecture (Drift database)
- Full security layer (PIN, biometrics)
- All 12 screens fully functional
- GitHub Actions for Android APK and Web deployment to GitHub Pages

## Constraints/Assumptions:
- No cloud/external databases - 100% local storage
- No AI integrations for now (insights show placeholder data)
- Modular code: 300-500 lines per file maximum
- Production-grade quality only
- Riverpod for state management (chosen over Bloc)
- Drift for database (chosen over Isar)
- GoRouter for navigation
- Package name: com.inner.verse
- No TODOs in code - all implementations must be complete

## Key Decisions:
1. **Drift** for database - better web support via IndexedDB
2. **Riverpod** for state management - modern, type-safe, generator support
3. **GoRouter** for navigation - official, supports deep linking
4. **Repository pattern** - clean separation of concerns
5. **Shell scaffold** - responsive bottom nav (mobile) / side rail (desktop)
6. **Manual project structure** - Flutter CLI not available, created configs manually

## State:

### Done:
- **Core Infrastructure**
  - pubspec.yaml with all dependencies
  - Core constants (app_constants.dart, persona_defaults.dart, space_configs.dart, prompts_data.dart)
  - Theme system (app_colors.dart, app_theme.dart, app_typography.dart)
  - Router configuration (app_router.dart, route_names.dart, shell_scaffold.dart)
  - Platform utilities (platform_utils.dart)
  - Error handling (error_handler.dart, app_exception.dart)
  - Context and string extensions
  - Date utilities

- **Database Layer (Drift)**
  - app_database.dart with all 8 tables defined
  - All table definitions (personas, conversations, messages, time_capsules, rituals, user_profiles, space_statistics, echoes)
  - All DAOs (persona_dao, conversation_dao, message_dao, time_capsule_dao, ritual_dao, user_profile_dao, space_statistics_dao, echo_dao)
  - All repositories implementing repository pattern

- **Domain Entities**
  - Persona (with PersonaType enum)
  - Conversation
  - Message (with MoodType, AttachmentType)
  - TimeCapsule
  - Ritual (with RitualType, RitualFrequency)
  - UserProfile
  - SpaceStatistics
  - Echo (with EchoType)

- **App Entry**
  - main.dart with initialization and provider overrides
  - app.dart with InnerverseApp, lifecycle management

- **Presentation Layer**
  - app_providers.dart with all Riverpod providers
  - All 12 screens implemented:
    - splash_screen.dart
    - onboarding_screen.dart, onboarding_pages.dart
    - home_screen.dart
    - conversation_screen.dart
    - selves_screen.dart, persona_detail_screen.dart
    - spaces_screen.dart
    - vault_screen.dart, time_capsule_detail_screen.dart
    - insights_screen.dart
    - archive_screen.dart
    - rituals_screen.dart
    - settings_screen.dart
    - debug_screen.dart
  - Reusable widgets (cosmic_background.dart, space_card.dart)

- **Services**
  - audio_service.dart (ambient sound management)
  - security_service.dart (PIN, biometrics, screenshot blocking)
  - notification_service.dart (local notifications)
  - export_service.dart (PDF/JSON export)
  - backup_service.dart (database backup/restore)

- **Platform Configuration**
  - Android: build.gradle, app/build.gradle, AndroidManifest.xml, MainActivity.kt, styles.xml
  - iOS: Info.plist, AppDelegate.swift, Podfile
  - Web: index.html, manifest.json (PWA ready)

- **CI/CD**
  - .github/workflows/build-deploy.yml (Android APK + GitHub Pages)
  - keystore/README.md with generation instructions
  - android/key.properties configured

- **Assets**
  - assets/ directory structure created
  - assets/icons/app_icon.svg
  - README.md files for fonts and audio explaining required files

- **Documentation**
  - CLAUDE.md with comprehensive development guide
  - CONTINUITY.md (this file)

### Now:
- Project infrastructure complete
- Awaiting Flutter environment to run `flutter pub get` and `build_runner`

### Next (when Flutter available):
1. Run `flutter pub get` to fetch dependencies
2. Run `dart run build_runner build --delete-conflicting-outputs` to generate:
   - app_database.g.dart (Drift generated code)
   - Any Riverpod generated providers
3. Download and add Poppins font files to assets/fonts/
4. Add ambient audio files to assets/audio/
5. Generate app icons using flutter_launcher_icons
6. Test build on Android, iOS, and Web
7. Create actual keystore for release builds

## Open Questions:
- None at this time

## Working Set (files/ids/commands):
- Repository root: `/workspace/repo-638762d6-8c46-4d3c-b51b-38cb82806b59/`
- Branch: tembo/innerverse-initial-setup
- Key directories:
  - `lib/` - All Dart source code
  - `android/` - Android platform configuration
  - `ios/` - iOS platform configuration
  - `web/` - Web platform configuration
  - `assets/` - Fonts, audio, icons, images
  - `.github/workflows/` - CI/CD pipelines

## File Count Summary:
- Core: 12 files
- Data/Database: 18 files (tables, DAOs, repositories)
- Domain/Entities: 8 files
- Presentation: 17 files (providers, screens, widgets)
- Services: 5 files
- Platform configs: ~15 files
- **Total Dart files: ~60 files**
