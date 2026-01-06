/// App router configuration using GoRouter
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/archive/archive_screen.dart';
import '../../presentation/screens/conversation/conversation_screen.dart';
import '../../presentation/screens/debug/debug_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/insights/insights_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/rituals/rituals_screen.dart';
import '../../presentation/screens/selves/persona_detail_screen.dart';
import '../../presentation/screens/selves/selves_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/spaces/spaces_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/vault/time_capsule_detail_screen.dart';
import '../../presentation/screens/vault/vault_screen.dart';
import 'route_names.dart';
import 'shell_scaffold.dart';

/// App router configuration
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  /// Create the router
  static GoRouter createRouter({
    required bool hasCompletedOnboarding,
    required bool isAuthenticated,
  }) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: _getInitialLocation(
        hasCompletedOnboarding: hasCompletedOnboarding,
        isAuthenticated: isAuthenticated,
      ),
      debugLogDiagnostics: true,
      routes: [
        // Splash screen
        GoRoute(
          path: RouteNames.splash,
          name: RouteNames.splash,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SplashScreen(),
            transitionsBuilder: _fadeTransition,
          ),
        ),

        // Onboarding
        GoRoute(
          path: RouteNames.onboarding,
          name: RouteNames.onboarding,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const OnboardingScreen(),
            transitionsBuilder: _fadeTransition,
          ),
        ),

        // Debug screen (accessible from anywhere)
        GoRoute(
          path: RouteNames.debug,
          name: RouteNames.debug,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const DebugScreen(),
            transitionsBuilder: _slideUpTransition,
          ),
        ),

        // Main shell with bottom navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => ShellScaffold(child: child),
          routes: [
            // Home tab
            GoRoute(
              path: RouteNames.home,
              name: RouteNames.home,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const HomeScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // Talk/Spaces tab
            GoRoute(
              path: RouteNames.spaces,
              name: RouteNames.spaces,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const SpacesScreen(),
                transitionsBuilder: _fadeTransition,
              ),
              routes: [
                // Conversation screen (child of spaces)
                GoRoute(
                  path: 'conversation/:spaceId',
                  name: RouteNames.conversation,
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) {
                    final spaceId = state.pathParameters['spaceId']!;
                    final conversationId =
                        state.uri.queryParameters['conversationId'];
                    final mode = state.uri.queryParameters['mode'];
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: ConversationScreen(
                        spaceId: spaceId,
                        conversationId: conversationId,
                        mode: mode,
                      ),
                      transitionsBuilder: _slideTransition,
                    );
                  },
                ),
              ],
            ),

            // Selves tab
            GoRoute(
              path: RouteNames.selves,
              name: RouteNames.selves,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const SelvesScreen(),
                transitionsBuilder: _fadeTransition,
              ),
              routes: [
                // Persona detail screen
                GoRoute(
                  path: 'persona/:personaId',
                  name: RouteNames.personaDetail,
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) {
                    final personaId = state.pathParameters['personaId']!;
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: PersonaDetailScreen(personaId: personaId),
                      transitionsBuilder: _slideTransition,
                    );
                  },
                ),
                // Create persona screen
                GoRoute(
                  path: 'create',
                  name: RouteNames.createPersona,
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const PersonaDetailScreen(personaId: null),
                    transitionsBuilder: _slideUpTransition,
                  ),
                ),
              ],
            ),

            // Vault tab
            GoRoute(
              path: RouteNames.vault,
              name: RouteNames.vault,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const VaultScreen(),
                transitionsBuilder: _fadeTransition,
              ),
              routes: [
                // Time capsule detail
                GoRoute(
                  path: 'capsule/:capsuleId',
                  name: RouteNames.timeCapsuleDetail,
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) {
                    final capsuleId = state.pathParameters['capsuleId']!;
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: TimeCapsuleDetailScreen(capsuleId: capsuleId),
                      transitionsBuilder: _slideTransition,
                    );
                  },
                ),
                // Create time capsule
                GoRoute(
                  path: 'create',
                  name: RouteNames.createTimeCapsule,
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const TimeCapsuleDetailScreen(capsuleId: null),
                    transitionsBuilder: _slideUpTransition,
                  ),
                ),
              ],
            ),

            // Insights tab
            GoRoute(
              path: RouteNames.insights,
              name: RouteNames.insights,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const InsightsScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),
          ],
        ),

        // Settings (outside shell)
        GoRoute(
          path: RouteNames.settings,
          name: RouteNames.settings,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),

        // Archive (outside shell)
        GoRoute(
          path: RouteNames.archive,
          name: RouteNames.archive,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ArchiveScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),

        // Rituals (outside shell)
        GoRoute(
          path: RouteNames.rituals,
          name: RouteNames.rituals,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const RitualsScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
      ],
      errorPageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Page not found',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(state.uri.toString()),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.go(RouteNames.home),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _getInitialLocation({
    required bool hasCompletedOnboarding,
    required bool isAuthenticated,
  }) {
    if (!hasCompletedOnboarding) {
      return RouteNames.onboarding;
    }
    if (!isAuthenticated) {
      return RouteNames.splash;
    }
    return RouteNames.home;
  }

  // Transition builders
  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: child,
    );
  }

  static Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeInOut));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  static Widget _slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeInOut));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
