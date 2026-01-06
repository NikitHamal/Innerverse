/// Route name constants for navigation
library;

/// All route names in the app
abstract class RouteNames {
  // Root routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String debug = '/debug';

  // Main tabs
  static const String home = '/home';
  static const String spaces = '/spaces';
  static const String selves = '/selves';
  static const String vault = '/vault';
  static const String insights = '/insights';

  // Sub-routes
  static const String conversation = 'conversation';
  static const String personaDetail = 'personaDetail';
  static const String createPersona = 'createPersona';
  static const String timeCapsuleDetail = 'timeCapsuleDetail';
  static const String createTimeCapsule = 'createTimeCapsule';

  // Settings & others
  static const String settings = '/settings';
  static const String archive = '/archive';
  static const String rituals = '/rituals';
}

/// Navigation tab indices
abstract class TabIndices {
  static const int home = 0;
  static const int spaces = 1;
  static const int selves = 2;
  static const int vault = 3;
  static const int insights = 4;
}

/// Get tab index from route
int getTabIndexFromRoute(String route) {
  if (route.startsWith(RouteNames.home)) return TabIndices.home;
  if (route.startsWith(RouteNames.spaces)) return TabIndices.spaces;
  if (route.startsWith(RouteNames.selves)) return TabIndices.selves;
  if (route.startsWith(RouteNames.vault)) return TabIndices.vault;
  if (route.startsWith(RouteNames.insights)) return TabIndices.insights;
  return TabIndices.home;
}

/// Get route from tab index
String getRouteFromTabIndex(int index) {
  switch (index) {
    case TabIndices.home:
      return RouteNames.home;
    case TabIndices.spaces:
      return RouteNames.spaces;
    case TabIndices.selves:
      return RouteNames.selves;
    case TabIndices.vault:
      return RouteNames.vault;
    case TabIndices.insights:
      return RouteNames.insights;
    default:
      return RouteNames.home;
  }
}
