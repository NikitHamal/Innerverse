/// Vault screen - Time capsules management
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';

/// Vault screen for viewing and managing time capsules
class VaultScreen extends ConsumerWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Mock capsules for demo
    final capsules = _getMockCapsules();
    final lockedCapsules = capsules.where((c) => !c.isUnlocked).toList();
    final unlockedCapsules = capsules.where((c) => c.isUnlocked).toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.cosmicPurple,
                    AppColors.deepSpace,
                  ]
                : [
                    AppColors.backgroundLight,
                    AppColors.tertiaryContainer.withOpacity(0.3),
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

              // Locked capsules section
              if (lockedCapsules.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: _buildSectionHeader(context, 'Waiting to Open', isDark),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingL,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _CapsuleCard(
                          capsule: lockedCapsules[index],
                          onTap: () {
                            // Show locked message or navigate to detail
                          },
                          isDark: isDark,
                        );
                      },
                      childCount: lockedCapsules.length,
                    ),
                  ),
                ),
              ],

              // Unlocked capsules section
              if (unlockedCapsules.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: _buildSectionHeader(context, 'Ready to Read', isDark),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingL,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _CapsuleCard(
                          capsule: unlockedCapsules[index],
                          onTap: () {
                            context.push(
                              '${RouteNames.vault}/capsule/${unlockedCapsules[index].id}',
                            );
                          },
                          isDark: isDark,
                        );
                      },
                      childCount: unlockedCapsules.length,
                    ),
                  ),
                ),
              ],

              // Empty state
              if (capsules.isEmpty)
                SliverFillRemaining(
                  child: _buildEmptyState(context, isDark),
                ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('${RouteNames.vault}/create'),
        icon: const Icon(Icons.add),
        label: const Text('Create Capsule'),
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
          Row(
            children: [
              const Text(
                '\u{1F48E}',
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Text(
                'Time Vault',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            'Messages to your future self, waiting to be discovered',
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

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingL,
        AppSizes.paddingL,
        AppSizes.paddingL,
        AppSizes.paddingS,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '\u{1F48C}',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              'Your vault is empty',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              'Create a time capsule to send a message to your future self',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<_MockCapsule> _getMockCapsules() {
    return [
      _MockCapsule(
        id: '1',
        title: 'Letter to My Future Self',
        occasion: 'new_year',
        emoji: '\u{1F389}',
        unlockDate: DateTime.now().add(const Duration(days: 30)),
        isUnlocked: false,
      ),
      _MockCapsule(
        id: '2',
        title: 'Birthday Reflection',
        occasion: 'birthday',
        emoji: '\u{1F382}',
        unlockDate: DateTime.now().add(const Duration(days: 90)),
        isUnlocked: false,
      ),
      _MockCapsule(
        id: '3',
        title: 'Last Year\'s Hopes',
        occasion: 'new_year',
        emoji: '\u{2728}',
        unlockDate: DateTime.now().subtract(const Duration(days: 10)),
        isUnlocked: true,
        isRead: false,
      ),
    ];
  }
}

/// Mock capsule model
class _MockCapsule {
  final String id;
  final String title;
  final String occasion;
  final String emoji;
  final DateTime unlockDate;
  final bool isUnlocked;
  final bool isRead;

  _MockCapsule({
    required this.id,
    required this.title,
    required this.occasion,
    required this.emoji,
    required this.unlockDate,
    required this.isUnlocked,
    this.isRead = false,
  });

  String get timeUntilUnlock {
    if (isUnlocked) return 'Ready to open';

    final diff = unlockDate.difference(DateTime.now());
    if (diff.inDays > 30) {
      final months = (diff.inDays / 30).round();
      return 'Opens in $months ${months == 1 ? 'month' : 'months'}';
    } else if (diff.inDays > 0) {
      return 'Opens in ${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'}';
    } else {
      return 'Opens soon';
    }
  }
}

/// Time capsule card widget
class _CapsuleCard extends StatelessWidget {
  final _MockCapsule capsule;
  final VoidCallback onTap;
  final bool isDark;

  const _CapsuleCard({
    required this.capsule,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingM),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceContainerDark.withOpacity(0.5)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              border: Border.all(
                color: capsule.isUnlocked
                    ? AppColors.tertiary.withOpacity(0.5)
                    : (isDark
                        ? AppColors.dividerDark
                        : AppColors.dividerLight),
                width: capsule.isUnlocked ? 2 : 1,
              ),
              boxShadow: capsule.isUnlocked
                  ? [
                      BoxShadow(
                        color: AppColors.tertiary.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: capsule.isUnlocked
                        ? AppColors.tertiary.withOpacity(0.2)
                        : (isDark
                            ? AppColors.surfaceContainerHighDark
                            : AppColors.surfaceContainerHighLight),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                  child: Center(
                    child: Text(
                      capsule.isUnlocked ? capsule.emoji : '\u{1F512}',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capsule.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingXS),
                      Text(
                        capsule.timeUntilUnlock,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: capsule.isUnlocked
                              ? AppColors.tertiary
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight),
                          fontWeight: capsule.isUnlocked
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow or new badge
                if (capsule.isUnlocked && !capsule.isRead)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingS,
                      vertical: AppSizes.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                    child: Text(
                      'NEW',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
