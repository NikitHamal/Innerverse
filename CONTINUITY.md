# Innerverse - Session Continuity Ledger

## Goal (incl. success criteria):
Build a production-ready, cross-platform (Android, iOS, Web) Flutter app called "Innerverse" - a self-dialogue and inner exploration platform with:
- Material 3 design with cosmic/ethereal aesthetic
- Local-first architecture (Drift database)
- Full security layer (PIN, biometrics)
- All 12 screens fully functional
- GitHub Actions for Android APK and Web deployment

## Constraints/Assumptions:
- No cloud/external databases - 100% local storage
- No AI integrations for now (insights show placeholder data)
- Modular code: 300-500 lines per file maximum
- Production-grade quality only
- Riverpod for state management (chosen over Bloc)
- Drift for database (chosen over Isar)
- GoRouter for navigation

## Key Decisions:
1. **Drift** for database - better web support via IndexedDB
2. **Riverpod** for state management - modern, type-safe, generator support
3. **GoRouter** for navigation - official, supports deep linking
4. **Repository pattern** - clean separation of concerns
5. **Shell scaffold** - responsive bottom nav (mobile) / side rail (desktop)

## State:

### Done:
- pubspec.yaml with all dependencies
- Core constants (app_constants.dart)
- Theme system (app_colors.dart, app_theme.dart, app_typography.dart)
- Router configuration (app_router.dart, route_names.dart)
- Platform utilities (platform_utils.dart)
- Error handling (error_handler.dart, app_exception.dart)
- Persona defaults configuration
- Space configurations
- Context and string extensions
- Date utilities
- CLAUDE.md documentation

### Now:
- Creating CONTINUITY.md
- Building database layer with Drift

### Next:
1. Create Drift database schema (all 8 tables)
2. Create domain entities
3. Implement repository pattern
4. Set up Riverpod providers
5. Build main.dart and app.dart
6. Create ShellScaffold
7. Build all screens (Splash -> Onboarding -> Main screens)
8. Implement services (Audio, Security, Export, Notifications)
9. Create reusable widgets
10. Set up GitHub Actions workflows
11. Configure PWA

## Open Questions (UNCONFIRMED if needed):
- None at this time

## Working Set (files/ids/commands):
- `/workspace/repo-5e99951e-db73-48c7-9297-4919471ecce5/`
- Key files: pubspec.yaml, lib/core/*, lib/data/*, lib/presentation/*
- Branch: tembo/innerverse-initial-setup-1
