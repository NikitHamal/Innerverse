/// Spaces screen - Emotional spaces selection
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/space_configs.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

/// Spaces screen for selecting emotional environments
class SpacesScreen extends ConsumerWidget {
  const SpacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentSpace = ref.watch(currentSpaceProvider);

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
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(context, isDark),
              ),

              // Space cards grid
              SliverPadding(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisSpacing: AppSizes.paddingM,
                    crossAxisSpacing: AppSizes.paddingM,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final space = allSpaces[index];
                      return _SpaceCard(
                        config: space,
                        isSelected: space.id == currentSpace,
                        onTap: () {
                          ref.read(currentSpaceProvider.notifier).state =
                              space.id;
                          context.go(
                            '${RouteNames.spaces}/conversation/${space.id}',
                          );
                        },
                        isDark: isDark,
                      );
                    },
                    childCount: allSpaces.length,
                  ),
                ),
              ),

              // Info section
              SliverToBoxAdapter(
                child: _buildInfoSection(context, isDark),
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
            'Emotional Spaces',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            'Choose a space that matches how you feel',
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

  Widget _buildInfoSection(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceContainerDark.withOpacity(0.5)
              : AppColors.surfaceLight.withOpacity(0.8),
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                const SizedBox(width: AppSizes.paddingS),
                Text(
                  'About Spaces',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Each space offers a unique emotional atmosphere with ambient sounds, colors, and themes designed to support different kinds of reflection.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual space card widget
class _SpaceCard extends StatelessWidget {
  final SpaceConfig config;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _SpaceCard({
    required this.config,
    required this.isSelected,
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
        child: AnimatedContainer(
          duration: AppDurations.normal,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? config.gradientColors
                      .map((c) => _darken(c, 0.5))
                      .toList()
                  : config.gradientColors,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(
              color: isSelected
                  ? config.accentColor
                  : config.accentColor.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: config.accentColor.withOpacity(isSelected ? 0.3 : 0.1),
                blurRadius: isSelected ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emoji and selection indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      config.emoji,
                      style: const TextStyle(fontSize: 36),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: config.accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: _getContrastColor(config.accentColor),
                        ),
                      ),
                  ],
                ),
                const Spacer(),

                // Name
                Text(
                  config.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: config.textColor,
                    fontFamily: config.fontFamily,
                    letterSpacing: config.letterSpacing,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXS),

                // Description
                Text(
                  config.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: config.textColor.withOpacity(0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.paddingM),

                // Special features
                if (config.hasSpecialAnimation)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingS,
                      vertical: AppSizes.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: config.accentColor.withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusCircular),
                    ),
                    child: Text(
                      _getFeatureText(config.specialAnimationType),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: config.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getFeatureText(String animationType) {
    switch (animationType) {
      case 'dissolve':
        return 'Dissolve messages';
      case 'burn':
        return 'Burn messages';
      case 'bloom':
        return 'Bloom effect';
      case 'wash_away':
        return 'Wash away';
      default:
        return 'Special effect';
    }
  }

  Color _darken(Color color, double factor) {
    return Color.fromARGB(
      color.alpha,
      (color.red * (1 - factor)).round(),
      (color.green * (1 - factor)).round(),
      (color.blue * (1 - factor)).round(),
    );
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
