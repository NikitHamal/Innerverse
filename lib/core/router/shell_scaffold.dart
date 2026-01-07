/// Shell scaffold with responsive navigation for Innerverse
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import 'route_names.dart';

/// Shell scaffold that provides responsive navigation
/// - Bottom navigation bar on mobile
/// - Navigation rail on tablet/desktop
class ShellScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const ShellScaffold({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends ConsumerState<ShellScaffold> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < AppBreakpoints.mobile;
    final isExpanded = screenWidth >= AppBreakpoints.tablet;

    return Scaffold(
      body: Row(
        children: [
          // Side navigation rail for larger screens
          if (!isCompact)
            _NavigationRail(
              extended: isExpanded,
              selectedIndex: _getCurrentIndex(context),
              onDestinationSelected: (index) => _onTabSelected(context, index),
            ),

          // Main content
          Expanded(
            child: widget.child,
          ),
        ],
      ),

      // Bottom navigation for mobile
      bottomNavigationBar: isCompact
          ? _BottomNavigation(
              selectedIndex: _getCurrentIndex(context),
              onDestinationSelected: (index) => _onTabSelected(context, index),
            )
          : null,
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return getTabIndexFromRoute(location);
  }

  void _onTabSelected(BuildContext context, int index) {
    HapticFeedback.selectionClick();
    final route = getRouteFromTabIndex(index);
    context.go(route);
  }
}

/// Bottom navigation bar for mobile screens
class _BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _BottomNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          animationDuration: AppDurations.fast,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: _buildDestinations(context),
        ),
      ),
    );
  }

  List<NavigationDestination> _buildDestinations(BuildContext context) {
    return const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
        tooltip: 'Universe Dashboard',
      ),
      NavigationDestination(
        icon: Icon(Icons.chat_bubble_outline),
        selectedIcon: Icon(Icons.chat_bubble),
        label: 'Talk',
        tooltip: 'Enter Spaces',
      ),
      NavigationDestination(
        icon: Icon(Icons.people_outline),
        selectedIcon: Icon(Icons.people),
        label: 'Selves',
        tooltip: 'Your Personas',
      ),
      NavigationDestination(
        icon: Icon(Icons.lock_clock_outlined),
        selectedIcon: Icon(Icons.lock_clock),
        label: 'Vault',
        tooltip: 'Time Capsules',
      ),
      NavigationDestination(
        icon: Icon(Icons.insights_outlined),
        selectedIcon: Icon(Icons.insights),
        label: 'Insights',
        tooltip: 'Patterns & Analytics',
      ),
    ];
  }
}

/// Navigation rail for tablet/desktop screens
class _NavigationRail extends StatelessWidget {
  final bool extended;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _NavigationRail({
    required this.extended,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: NavigationRail(
        extended: extended,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        minWidth: AppSizes.sideNavWidth,
        minExtendedWidth: AppSizes.sideNavExpandedWidth,
        useIndicator: true,
        leading: _buildLeading(context),
        trailing: _buildTrailing(context),
        destinations: _buildDestinations(context),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // App icon/logo
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: colorScheme.onPrimary,
              size: 28,
            ),
          ),
          if (extended) ...[
            const SizedBox(height: 8),
            Text(
              AppMetadata.appName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              const SizedBox(height: 8),
              // Settings button
              _RailAction(
                extended: extended,
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () => context.push(RouteNames.settings),
              ),
              const SizedBox(height: 8),
              // Archive button
              _RailAction(
                extended: extended,
                icon: Icons.archive_outlined,
                label: 'Archive',
                onTap: () => context.push(RouteNames.archive),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<NavigationRailDestination> _buildDestinations(BuildContext context) {
    return const [
      NavigationRailDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: Text('Home'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.chat_bubble_outline),
        selectedIcon: Icon(Icons.chat_bubble),
        label: Text('Talk'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.people_outline),
        selectedIcon: Icon(Icons.people),
        label: Text('Selves'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.lock_clock_outlined),
        selectedIcon: Icon(Icons.lock_clock),
        label: Text('Vault'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.insights_outlined),
        selectedIcon: Icon(Icons.insights),
        label: Text('Insights'),
      ),
    ];
  }
}

/// Action button for navigation rail
class _RailAction extends StatelessWidget {
  final bool extended;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RailAction({
    required this.extended,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (extended) {
      return ListTile(
        leading: Icon(icon, color: colorScheme.onSurfaceVariant),
        title: Text(label),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
      );
    }

    return IconButton(
      icon: Icon(icon),
      tooltip: label,
      onPressed: onTap,
      style: IconButton.styleFrom(
        foregroundColor: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
