/// Cosmic background widget with animated stars
library;

import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Animated cosmic background with stars
class CosmicBackground extends StatefulWidget {
  final Widget? child;
  final bool animate;
  final int starCount;
  final List<Color>? gradientColors;

  const CosmicBackground({
    super.key,
    this.child,
    this.animate = true,
    this.starCount = 50,
    this.gradientColors,
  });

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    if (widget.animate) {
      _controller.repeat();
    }

    _generateStars();
  }

  void _generateStars() {
    final random = Random();
    _stars = List.generate(widget.starCount, (index) {
      return _Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2 + 0.5,
        opacity: random.nextDouble() * 0.5 + 0.3,
        twinkleSpeed: random.nextDouble() * 2 + 1,
        twinkleOffset: random.nextDouble() * pi * 2,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = widget.gradientColors ??
        (isDark ? AppColors.twilightGradient : AppColors.dawnGradient);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Stars layer
          if (widget.animate)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _StarsPainter(
                    stars: _stars,
                    animationValue: _controller.value,
                  ),
                  size: Size.infinite,
                );
              },
            )
          else
            CustomPaint(
              painter: _StarsPainter(
                stars: _stars,
                animationValue: 0,
              ),
              size: Size.infinite,
            ),

          // Child content
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

/// Star data model
class _Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double twinkleSpeed;
  final double twinkleOffset;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
    required this.twinkleOffset,
  });
}

/// Custom painter for stars
class _StarsPainter extends CustomPainter {
  final List<_Star> stars;
  final double animationValue;

  _StarsPainter({
    required this.stars,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle =
          sin(animationValue * pi * 2 * star.twinkleSpeed + star.twinkleOffset);
      final currentOpacity = star.opacity * (0.5 + twinkle * 0.5);

      final paint = Paint()
        ..color = Colors.white.withOpacity(currentOpacity.clamp(0.1, 1.0))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Static cosmic gradient (no animation)
class CosmicGradient extends StatelessWidget {
  final Widget? child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const CosmicGradient({
    super.key,
    this.child,
    this.colors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ??
              (isDark ? AppColors.twilightGradient : AppColors.dawnGradient),
        ),
      ),
      child: child,
    );
  }
}
