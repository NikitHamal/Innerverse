/// Splash screen with cosmic animation for Innerverse
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

/// Splash screen with breathing cosmic animation
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _breathingController;
  late final AnimationController _starsController;

  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
      vsync: this,
      duration: AppDurations.breathingCycle,
    )..repeat(reverse: true);

    _starsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(AppDurations.splash);

    if (!mounted) return;

    final hasCompletedOnboarding = ref.read(hasCompletedOnboardingProvider);

    if (hasCompletedOnboarding) {
      // Show PIN/biometric authentication
      _showAuthenticationSheet();
    } else {
      context.go(RouteNames.onboarding);
    }
  }

  void _showAuthenticationSheet() {
    // For now, skip authentication and go to home
    // In production, show PIN input or biometric prompt
    ref.read(isAuthenticatedProvider.notifier).state = true;
    context.go(RouteNames.home);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          _buildBackground(),

          // Animated stars
          _buildStars(),

          // Central breathing orb
          _buildBreathingOrb(),

          // App name and tagline
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.twilightGradient,
        ),
      ),
    );
  }

  Widget _buildStars() {
    return AnimatedBuilder(
      animation: _starsController,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarsPainter(
            progress: _starsController.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildBreathingOrb() {
    return Center(
      child: AnimatedBuilder(
        animation: _breathingController,
        builder: (context, child) {
          final scale = 1.0 + (_breathingController.value * 0.1);
          final opacity = 0.3 + (_breathingController.value * 0.2);

          return Transform.scale(
            scale: scale,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.cosmicTeal.withOpacity(opacity),
                    AppColors.primary.withOpacity(opacity * 0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cosmicTeal.withOpacity(0.3),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),

          // App icon
          _buildAppIcon(),

          const SizedBox(height: 32),

          // App name
          Text(
            AppMetadata.appName,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 300.ms)
              .slideY(begin: 0.2, end: 0, duration: 800.ms, delay: 300.ms),

          const SizedBox(height: 16),

          // Tagline
          Text(
            AppMetadata.appTagline,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 1,
                ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 600.ms)
              .slideY(begin: 0.2, end: 0, duration: 800.ms, delay: 600.ms),

          const Spacer(flex: 2),

          // Loading indicator
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.5),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 1000.ms),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildAppIcon() {
    return Container(
      width: 100,
      height: 100,
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
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(
        Icons.auto_awesome,
        color: Colors.white,
        size: 48,
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), duration: 600.ms);
  }
}

/// Custom painter for animated stars
class _StarsPainter extends CustomPainter {
  final double progress;
  final List<_Star> _stars;

  _StarsPainter({required this.progress})
      : _stars = List.generate(100, (index) => _Star(index));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (final star in _stars) {
      final twinkle = (math.sin(progress * 2 * math.pi + star.phase) + 1) / 2;
      final opacity = 0.2 + (twinkle * 0.6);

      paint.color = Colors.white.withOpacity(opacity);

      final x = star.x * size.width;
      final y = star.y * size.height;
      final radius = star.size * (0.8 + twinkle * 0.4);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_StarsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Individual star data
class _Star {
  late final double x;
  late final double y;
  late final double size;
  late final double phase;

  _Star(int seed) {
    final random = math.Random(seed);
    x = random.nextDouble();
    y = random.nextDouble();
    size = 0.5 + random.nextDouble() * 1.5;
    phase = random.nextDouble() * 2 * math.pi;
  }
}
