/// Onboarding screen with premium flow for Innerverse
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/persona.dart';
import '../../providers/app_providers.dart';
import 'onboarding_pages.dart';

/// Main onboarding screen with page view
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // User input data
  String _userName = '';
  final Set<PersonaType> _selectedPersonas = {};
  String _selectedSpace = 'sanctuary';
  String _pin = '';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          _buildBackground(),

          // Page content
          SafeArea(
            child: Column(
              children: [
                // Skip button (only on first few pages)
                if (_currentPage < 5)
                  _buildSkipButton()
                else
                  const SizedBox(height: 48),

                // Page view
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                    },
                    children: _buildPages(),
                  ),
                ),

                // Page indicator and navigation
                _buildBottomNavigation(),
              ],
            ),
          ),
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

  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: TextButton(
          onPressed: _skipToNamePage,
          child: Text(
            'Skip',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPages() {
    return [
      // Page 0: Welcome
      OnboardingWelcomePage(
        onNext: _nextPage,
      ),

      // Page 1: The Selves concept
      OnboardingSelvesPage(
        onNext: _nextPage,
      ),

      // Page 2: Time Travel concept
      OnboardingTimeTravelPage(
        onNext: _nextPage,
      ),

      // Page 3: Spaces concept
      OnboardingSpacesPage(
        onNext: _nextPage,
      ),

      // Page 4: Privacy emphasis
      OnboardingPrivacyPage(
        onNext: _nextPage,
      ),

      // Page 5: Name collection
      OnboardingNamePage(
        initialName: _userName,
        onNameChanged: (name) => _userName = name,
        onNext: () {
          if (_userName.trim().isNotEmpty) {
            _nextPage();
          }
        },
      ),

      // Page 6: Persona selection
      OnboardingPersonaSelectionPage(
        selectedPersonas: _selectedPersonas,
        onPersonaToggled: (persona) {
          setState(() {
            if (_selectedPersonas.contains(persona)) {
              _selectedPersonas.remove(persona);
            } else {
              _selectedPersonas.add(persona);
            }
          });
        },
        onNext: () {
          if (_selectedPersonas.length >= 2) {
            _nextPage();
          }
        },
      ),

      // Page 7: Space selection
      OnboardingSpaceSelectionPage(
        selectedSpace: _selectedSpace,
        onSpaceSelected: (space) {
          setState(() => _selectedSpace = space);
        },
        onNext: _nextPage,
      ),

      // Page 8: Security setup
      OnboardingSecurityPage(
        onPinSet: (pin) {
          _pin = pin;
          _nextPage();
        },
        onSkip: _nextPage,
      ),

      // Page 9: Welcome home
      OnboardingCompletePage(
        userName: _userName,
        onComplete: _completeOnboarding,
      ),
    ];
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        children: [
          // Page indicator
          _buildPageIndicator(),

          const SizedBox(height: 24),

          // Navigation buttons
          if (_currentPage > 0 && _currentPage < 9)
            Row(
              children: [
                // Back button
                IconButton(
                  onPressed: _previousPage,
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white.withOpacity(0.7),
                  ),
                ),

                const Spacer(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(10, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: AppDurations.fast,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.cosmicTeal
                : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  void _nextPage() {
    if (_currentPage < 9) {
      _pageController.nextPage(
        duration: AppDurations.pageTransition,
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: AppDurations.pageTransition,
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToNamePage() {
    _pageController.animateToPage(
      5,
      duration: AppDurations.pageTransition,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _completeOnboarding() async {
    // Save user data
    final prefs = ref.read(sharedPreferencesProvider);

    await prefs.setString(StorageKeys.userName, _userName);
    await prefs.setBool(StorageKeys.hasCompletedOnboarding, true);
    await prefs.setString(StorageKeys.currentSpace, _selectedSpace);

    // Set up PIN if provided
    if (_pin.isNotEmpty) {
      final securityService = ref.read(securityServiceProvider);
      await securityService.setupPin(_pin);
    }

    // Update providers
    ref.read(hasCompletedOnboardingProvider.notifier).state = true;
    ref.read(userNameProvider.notifier).state = _userName;
    ref.read(isAuthenticatedProvider.notifier).state = true;

    // Navigate to home
    if (mounted) {
      context.go(RouteNames.home);
    }
  }
}
