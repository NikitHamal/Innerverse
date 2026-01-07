/// Home screen - Universe dashboard for Innerverse
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/space_configs.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

/// Home screen with universe dashboard
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userName = ref.watch(userNameProvider);
    final currentStreak = ref.watch(currentStreakProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? AppColors.twilightGradient
                : [
                    AppColors.backgroundLight,
                    AppColors.surfaceVariantLight,
                  ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header with greeting
              SliverToBoxAdapter(
                child: _buildHeader(context, userName, currentStreak, isDark),
              ),

              // Quick actions
              SliverToBoxAdapter(
                child: _buildQuickActions(context),
              ),

              // Spaces preview
              SliverToBoxAdapter(
                child: _buildSpacesSection(context),
              ),

              // Recent activity / Today's rituals
              SliverToBoxAdapter(
                child: _buildTodaySection(context, isDark),
              ),

              // Memory echo card (if any)
              SliverToBoxAdapter(
                child: _buildEchoCard(context, isDark),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSizes.paddingXXL),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String userName,
    int streak,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final greeting = _getGreeting();

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingXS),
                    Text(
                      userName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Settings button
              IconButton(
                onPressed: () => context.push(RouteNames.settings),
                icon: Icon(
                  Icons.settings_outlined,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          // Streak indicator
          if (streak > 0) _buildStreakBadge(streak, isDark),
        ],
      ),
    );
  }

  Widget _buildStreakBadge(int streak, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.tertiary.withOpacity(0.2),
            AppColors.tertiary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
        border: Border.all(
          color: AppColors.tertiary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('\u{1F525}', style: TextStyle(fontSize: 18)),
          const SizedBox(width: AppSizes.paddingS),
          Text(
            '$streak day streak',
            style: TextStyle(
              color: isDark ? AppColors.tertiaryLight : AppColors.tertiaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Start',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  emoji: '\u{1F4AC}',
                  title: 'New Chat',
                  subtitle: 'Start a conversation',
                  onTap: () => context.go(RouteNames.spaces),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: _QuickActionCard(
                  emoji: '\u{2728}',
                  title: 'Rituals',
                  subtitle: 'Daily reflection',
                  onTap: () => context.push(RouteNames.rituals),
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpacesSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Emotional Spaces',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => context.go(RouteNames.spaces),
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allSpaces.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.paddingM),
              itemBuilder: (context, index) {
                final space = allSpaces[index];
                return _SpacePreviewCard(
                  config: space,
                  onTap: () {
                    context.go(
                      '${RouteNames.spaces}/conversation/${space.id}',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySection(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          _TodayRitualCard(
            title: 'Morning Intention',
            emoji: '\u{1F305}',
            isCompleted: false,
            onTap: () => context.push(RouteNames.rituals),
            isDark: isDark,
          ),
          const SizedBox(height: AppSizes.paddingS),
          _TodayRitualCard(
            title: 'Evening Reflection',
            emoji: '\u{1F319}',
            isCompleted: false,
            onTap: () => context.push(RouteNames.rituals),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildEchoCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    // Mock echo data - in real app, this would come from a provider
    const hasEcho = true;

    if (!hasEcho) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.primary.withOpacity(0.2),
                    AppColors.secondary.withOpacity(0.1),
                  ]
                : [
                    AppColors.primaryContainer.withOpacity(0.5),
                    AppColors.secondaryContainer.withOpacity(0.3),
                  ],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingS),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  ),
                  child: const Text(
                    '\u{1F4AB}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Text(
                  'Memory Echo',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              '"I realized today that growth isn\'t always visible..."',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              'From 3 months ago',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Dismiss echo
                  },
                  child: Text(
                    'Dismiss',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingS),
                FilledButton.tonal(
                  onPressed: () {
                    // View full echo
                  },
                  child: const Text('Reflect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

/// Quick action card widget
class _QuickActionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const _QuickActionCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: isDark
                ? color.withOpacity(0.15)
                : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(
              color: color.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: AppSizes.paddingS),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Space preview card widget
class _SpacePreviewCard extends StatelessWidget {
  final SpaceConfig config;
  final VoidCallback onTap;

  const _SpacePreviewCard({
    required this.config,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: config.gradientColors,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            boxShadow: [
              BoxShadow(
                color: config.accentColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                config.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: AppSizes.paddingS),
              Text(
                config.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: config.textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Today's ritual card widget
class _TodayRitualCard extends StatelessWidget {
  final String title;
  final String emoji;
  final bool isCompleted;
  final VoidCallback onTap;
  final bool isDark;

  const _TodayRitualCard({
    required this.title,
    required this.emoji,
    required this.isCompleted,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceContainerDark
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(
              color: isDark
                  ? AppColors.dividerDark
                  : AppColors.dividerLight,
            ),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    Text(
                      isCompleted ? 'Completed' : 'Not yet completed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isCompleted
                            ? AppColors.success
                            : (isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isCompleted
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: isCompleted
                    ? AppColors.success
                    : (isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
