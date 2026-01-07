/// Selves screen - Council of Selves constellation view
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/persona_defaults.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';

/// Selves screen displaying the Council of Selves
class SelvesScreen extends ConsumerStatefulWidget {
  const SelvesScreen({super.key});

  @override
  ConsumerState<SelvesScreen> createState() => _SelvesScreenState();
}

class _SelvesScreenState extends ConsumerState<SelvesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? AppColors.cosmicGradient
                : [
                    AppColors.backgroundLight,
                    AppColors.primaryContainer.withOpacity(0.3),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, isDark),

              // Constellation view
              Expanded(
                child: _buildConstellationView(context, isDark),
              ),

              // Persona list
              _buildPersonaList(context, isDark),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('${RouteNames.selves}/create'),
        child: const Icon(Icons.add),
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
            'Council of Selves',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            'Your inner personas, here to guide you',
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

  Widget _buildConstellationView(BuildContext context, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerX = constraints.maxWidth / 2;
        final centerY = constraints.maxHeight / 2;
        final radius = math.min(centerX, centerY) * 0.7;

        return AnimatedBuilder(
          animation: _orbitController,
          builder: (context, child) {
            return Stack(
              children: [
                // Center - You
                Positioned(
                  left: centerX - 40,
                  top: centerY - 40,
                  child: _buildCenterSelf(isDark),
                ),

                // Orbiting personas
                ...List.generate(defaultPersonas.length, (index) {
                  final angle = (2 * math.pi / defaultPersonas.length) * index +
                      (_orbitController.value * 2 * math.pi * 0.1);
                  final x = centerX + radius * math.cos(angle) - 30;
                  final y = centerY + radius * math.sin(angle) - 30;

                  return Positioned(
                    left: x,
                    top: y,
                    child: _PersonaOrb(
                      config: defaultPersonas[index],
                      onTap: () {
                        context.push(
                          '${RouteNames.selves}/persona/${defaultPersonas[index].typeId}',
                        );
                      },
                    ),
                  );
                }),

                // Connection lines
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _ConstellationPainter(
                    center: Offset(centerX, centerY),
                    radius: radius,
                    personaCount: defaultPersonas.length,
                    rotation: _orbitController.value * 2 * math.pi * 0.1,
                    color: isDark
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCenterSelf(bool isDark) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'You',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPersonaList(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
            child: Text(
              'Your Selves',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
              itemCount: defaultPersonas.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.paddingM),
              itemBuilder: (context, index) {
                final persona = defaultPersonas[index];
                return _PersonaListItem(
                  config: persona,
                  onTap: () {
                    context.push(
                      '${RouteNames.selves}/persona/${persona.typeId}',
                    );
                  },
                  isDark: isDark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Orbiting persona orb widget
class _PersonaOrb extends StatelessWidget {
  final PersonaConfig config;
  final VoidCallback onTap;

  const _PersonaOrb({
    required this.config,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(config.defaultColor),
          boxShadow: [
            BoxShadow(
              color: Color(config.defaultColor).withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            config.defaultEmoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

/// Persona list item widget
class _PersonaListItem extends StatelessWidget {
  final PersonaConfig config;
  final VoidCallback onTap;
  final bool isDark;

  const _PersonaListItem({
    required this.config,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(AppSizes.paddingS),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceContainerDark
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: Color(config.defaultColor).withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(config.defaultColor).withOpacity(0.2),
              ),
              child: Center(
                child: Text(
                  config.defaultEmoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingXS),
            Text(
              config.displayName,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Constellation line painter
class _ConstellationPainter extends CustomPainter {
  final Offset center;
  final double radius;
  final int personaCount;
  final double rotation;
  final Color color;

  _ConstellationPainter({
    required this.center,
    required this.radius,
    required this.personaCount,
    required this.rotation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw lines from center to each persona
    for (var i = 0; i < personaCount; i++) {
      final angle = (2 * math.pi / personaCount) * i + rotation;
      final endX = center.dx + radius * math.cos(angle);
      final endY = center.dy + radius * math.sin(angle);

      canvas.drawLine(center, Offset(endX, endY), paint);
    }

    // Draw circle connecting all personas
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
