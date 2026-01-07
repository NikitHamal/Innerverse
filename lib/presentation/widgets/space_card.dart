/// Space card widget for emotional spaces
library;

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/space_configs.dart';
import '../../core/theme/app_colors.dart';

/// Card widget for displaying an emotional space
class SpaceCard extends StatelessWidget {
  final SpaceConfig config;
  final VoidCallback? onTap;
  final bool isCompact;
  final bool showDescription;

  const SpaceCard({
    super.key,
    required this.config,
    this.onTap,
    this.isCompact = false,
    this.showDescription = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isCompact) {
      return _buildCompact(context, isDark);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                config.accentColor.withOpacity(isDark ? 0.3 : 0.15),
                config.accentColor.withOpacity(isDark ? 0.1 : 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(
              color: config.accentColor.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    config.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const Spacer(),
                  if (config.specialEffect != null)
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
                        config.specialEffect!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: config.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
              Text(
                config.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (showDescription) ...[
                const SizedBox(height: AppSizes.paddingXS),
                Text(
                  config.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: config.accentColor.withOpacity(isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(
              color: config.accentColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                config.emoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: AppSizes.paddingS),
              Text(
                config.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Large space card for featured display
class FeaturedSpaceCard extends StatelessWidget {
  final SpaceConfig config;
  final VoidCallback? onTap;
  final String? subtitle;

  const FeaturedSpaceCard({
    super.key,
    required this.config,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: config.gradientColors,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
            boxShadow: [
              BoxShadow(
                color: config.accentColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern (optional)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                  child: CustomPaint(
                    painter: _SpacePatternPainter(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.emoji,
                      style: const TextStyle(fontSize: 48),
                    ),
                    const Spacer(),
                    Text(
                      config.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingXS),
                    Text(
                      subtitle ?? config.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for space pattern background
class _SpacePatternPainter extends CustomPainter {
  final Color color;

  _SpacePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw some decorative circles
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      30,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.7),
      20,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.8),
      15,
      paint,
    );
  }

  @override
  bool shouldRepaint(_SpacePatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
