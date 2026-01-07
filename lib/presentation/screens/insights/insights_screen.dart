/// Insights screen - Analytics and statistics dashboard
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/space_configs.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

/// Insights screen showing user statistics and patterns
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentStreak = ref.watch(currentStreakProvider);
    final longestStreak = ref.watch(longestStreakProvider);
    final totalReflections = ref.watch(totalReflectionsProvider);

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
                    AppColors.secondaryContainer.withOpacity(0.3),
                  ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(context, isDark),
              ),

              // Stats cards
              SliverToBoxAdapter(
                child: _buildStatsCards(
                  context,
                  currentStreak,
                  longestStreak,
                  totalReflections,
                  isDark,
                ),
              ),

              // Space usage chart
              SliverToBoxAdapter(
                child: _buildSpaceUsageSection(context, isDark),
              ),

              // Recent activity
              SliverToBoxAdapter(
                child: _buildRecentActivitySection(context, isDark),
              ),

              // Mood trends
              SliverToBoxAdapter(
                child: _buildMoodTrendsSection(context, isDark),
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

  Widget _buildHeader(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insights',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            'Your journey at a glance',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(
    BuildContext context,
    int currentStreak,
    int longestStreak,
    int totalReflections,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              emoji: '\u{1F525}',
              value: currentStreak.toString(),
              label: 'Current\nStreak',
              color: AppColors.tertiary,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: _StatCard(
              emoji: '\u{1F3C6}',
              value: longestStreak.toString(),
              label: 'Longest\nStreak',
              color: AppColors.secondary,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: _StatCard(
              emoji: '\u{1F4DD}',
              value: totalReflections.toString(),
              label: 'Total\nReflections',
              color: AppColors.primary,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpaceUsageSection(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    // Mock data
    final spaceUsage = [
      (SpaceTypeIds.sanctuary, 42, 'Sanctuary'),
      (SpaceTypeIds.stormRoom, 25, 'Storm Room'),
      (SpaceTypeIds.dreamGarden, 18, 'Dream Garden'),
      (SpaceTypeIds.theShore, 10, 'The Shore'),
      (SpaceTypeIds.theVoid, 5, 'The Void'),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Space Visits',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceContainerDark
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              border: Border.all(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
            ),
            child: Column(
              children: spaceUsage.map((data) {
                final config = getSpaceConfig(data.$1);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.paddingS,
                  ),
                  child: Row(
                    children: [
                      Text(config.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: AppSizes.paddingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.$3,
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: data.$2 / 100,
                              backgroundColor: config.accentColor.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation(config.accentColor),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      Text(
                        '${data.$2}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    // Mock activity data
    final activities = [
      ('Evening Reflection', '\u{1F319}', '2 hours ago'),
      ('Sanctuary conversation', '\u{1F33F}', 'Yesterday'),
      ('Morning Intention', '\u{1F305}', 'Yesterday'),
      ('Storm Room release', '\u{1F327}\u{FE0F}', '2 days ago'),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceContainerDark
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              border: Border.all(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
            ),
            child: Column(
              children: activities.asMap().entries.map((entry) {
                final index = entry.key;
                final activity = entry.value;
                final isLast = index == activities.length - 1;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.paddingS,
                      ),
                      child: Row(
                        children: [
                          Text(activity.$2, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: AppSizes.paddingM),
                          Expanded(
                            child: Text(
                              activity.$1,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            activity.$3,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        color: isDark
                            ? AppColors.dividerDark
                            : AppColors.dividerLight,
                        height: 1,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTrendsSection(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    // Mock mood data
    final moods = [
      ('\u{1F604}', 'Happy', 35),
      ('\u{1F914}', 'Thoughtful', 28),
      ('\u{1F60C}', 'Peaceful', 22),
      ('\u{1F622}', 'Sad', 10),
      ('\u{1F621}', 'Frustrated', 5),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Trends',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            'Based on your reflections this month',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Wrap(
            spacing: AppSizes.paddingS,
            runSpacing: AppSizes.paddingS,
            children: moods.map((mood) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                  vertical: AppSizes.paddingS,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceContainerDark
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
                  border: Border.all(
                    color:
                        isDark ? AppColors.dividerDark : AppColors.dividerLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(mood.$1, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: AppSizes.paddingS),
                    Text(
                      '${mood.$3}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
