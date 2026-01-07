/// Rituals screen - Daily rituals and practices
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/ritual.dart';

/// Rituals screen for daily practices
class RitualsScreen extends ConsumerStatefulWidget {
  const RitualsScreen({super.key});

  @override
  ConsumerState<RitualsScreen> createState() => _RitualsScreenState();
}

class _RitualsScreenState extends ConsumerState<RitualsScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rituals'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? AppColors.twilightGradient
                : [
                    AppColors.backgroundLight,
                    AppColors.primaryContainer.withOpacity(0.2),
                  ],
          ),
        ),
        child: Column(
          children: [
            // Tab bar
            _buildTabBar(context, isDark),

            // Content
            Expanded(
              child: _selectedTabIndex == 0
                  ? _buildDailyRituals(context, isDark)
                  : _buildAllRituals(context, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Today',
              isSelected: _selectedTabIndex == 0,
              onTap: () => setState(() => _selectedTabIndex = 0),
              isDark: isDark,
            ),
          ),
          const SizedBox(width: AppSizes.paddingS),
          Expanded(
            child: _TabButton(
              label: 'All Rituals',
              isSelected: _selectedTabIndex == 1,
              onTap: () => setState(() => _selectedTabIndex = 1),
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyRituals(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    // Mock today's rituals status
    final todayRituals = [
      _RitualStatus(
        type: RitualType.morningIntention,
        isCompleted: false,
        completedAt: null,
      ),
      _RitualStatus(
        type: RitualType.eveningReflection,
        isCompleted: false,
        completedAt: null,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Daily Rituals',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            'Start and end your day with intention',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),

          // Ritual cards
          ...todayRituals.map((ritual) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingM),
                child: _DailyRitualCard(
                  status: ritual,
                  onStart: () => _startRitual(ritual.type),
                  isDark: isDark,
                ),
              )),

          const SizedBox(height: AppSizes.paddingL),

          // Weekly ritual
          _buildWeeklyRitualCard(context, isDark),
        ],
      ),
    );
  }

  Widget _buildWeeklyRitualCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final isSunday = DateTime.now().weekday == DateTime.sunday;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(isDark ? 0.3 : 0.1),
            AppColors.secondary.withOpacity(isDark ? 0.2 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                RitualType.weeklyCouncil.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      RitualType.weeklyCouncil.displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      isSunday
                          ? 'Available today'
                          : 'Available on Sundays',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSunday
                            ? AppColors.success
                            : (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            RitualType.weeklyCouncil.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          FilledButton.tonal(
            onPressed: isSunday ? () => _startRitual(RitualType.weeklyCouncil) : null,
            child: const Text('Start Council'),
          ),
        ],
      ),
    );
  }

  Widget _buildAllRituals(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Rituals',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            'Sacred practices for your journey',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),

          // All ritual types
          ...RitualType.values
              .where((t) => t != RitualType.custom)
              .map((type) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.paddingM),
                    child: _RitualTypeCard(
                      type: type,
                      onTap: () => _startRitual(type),
                      isDark: isDark,
                    ),
                  )),
        ],
      ),
    );
  }

  void _startRitual(RitualType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RitualSheet(
        type: type,
        onComplete: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${type.displayName} completed!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}

/// Tab button widget
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(isDark ? 0.3 : 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primary : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// Ritual status model
class _RitualStatus {
  final RitualType type;
  final bool isCompleted;
  final DateTime? completedAt;

  _RitualStatus({
    required this.type,
    required this.isCompleted,
    this.completedAt,
  });
}

/// Daily ritual card widget
class _DailyRitualCard extends StatelessWidget {
  final _RitualStatus status;
  final VoidCallback onStart;
  final bool isDark;

  const _DailyRitualCard({
    required this.status,
    required this.onStart,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: status.isCompleted
            ? AppColors.success.withOpacity(isDark ? 0.2 : 0.1)
            : (isDark
                ? AppColors.surfaceContainerDark
                : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: status.isCompleted
              ? AppColors.success.withOpacity(0.5)
              : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
        ),
      ),
      child: Row(
        children: [
          // Emoji
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: status.isCompleted
                  ? AppColors.success.withOpacity(0.2)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Center(
              child: Text(
                status.isCompleted ? '\u{2705}' : status.type.emoji,
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
                  status.type.displayName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration:
                        status.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXS),
                Text(
                  status.isCompleted
                      ? 'Completed'
                      : '${status.type.suggestedDuration} min',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: status.isCompleted
                        ? AppColors.success
                        : (isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                  ),
                ),
              ],
            ),
          ),

          // Button
          if (!status.isCompleted)
            FilledButton(
              onPressed: onStart,
              child: const Text('Start'),
            ),
        ],
      ),
    );
  }
}

/// Ritual type card widget
class _RitualTypeCard extends StatelessWidget {
  final RitualType type;
  final VoidCallback onTap;
  final bool isDark;

  const _RitualTypeCard({
    required this.type,
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
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Container(
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
          child: Row(
            children: [
              Text(type.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.displayName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingXS),
                    Text(
                      type.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ritual sheet for performing rituals
class _RitualSheet extends StatelessWidget {
  final RitualType type;
  final VoidCallback onComplete;

  const _RitualSheet({
    required this.type,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
            decoration: BoxDecoration(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Column(
              children: [
                Text(type.emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: AppSizes.paddingM),
                Text(
                  type.displayName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingS),
                Text(
                  type.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.paddingXL),

                // Text field for reflection
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: _getPromptForType(type),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSizes.paddingL),

                // Complete button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onComplete,
                    child: const Text('Complete Ritual'),
                  ),
                ),
                const SizedBox(height: AppSizes.paddingL),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPromptForType(RitualType type) {
    switch (type) {
      case RitualType.morningIntention:
        return 'What is your intention for today?';
      case RitualType.eveningReflection:
        return 'What did you learn today?';
      case RitualType.weeklyCouncil:
        return 'What wisdom does your council share?';
      case RitualType.birthdayLetter:
        return 'Write to your future self...';
      case RitualType.burningCeremony:
        return 'What do you want to release?';
      default:
        return 'Share your thoughts...';
    }
  }
}
