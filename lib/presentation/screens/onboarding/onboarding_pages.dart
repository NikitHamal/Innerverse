/// Individual onboarding page widgets for Innerverse
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/space_configs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../domain/entities/persona.dart';

/// Welcome page - "Your mind is a universe"
class OnboardingWelcomePage extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingWelcomePage({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Cosmic icon
          Icon(
            Icons.auto_awesome,
            size: 80,
            color: AppColors.cosmicTeal,
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.5, 0.5)),

          const SizedBox(height: 48),

          // Title
          Text(
            'Your mind is a universe',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            "Let's explore it together",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 500.ms, duration: 600.ms),

          const Spacer(),

          // Begin button
          FilledButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Begin Journey'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.cosmicTeal,
              foregroundColor: AppColors.deepSpace,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ).animate().fadeIn(delay: 800.ms, duration: 600.ms),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

/// Selves concept page
class OnboardingSelvesPage extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingSelvesPage({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return _OnboardingContentPage(
      icon: Icons.people_outline,
      title: 'Meet Your Inner Selves',
      description:
          'Within you live many voices — your inner child, your critic, your dreamer, your protector. Here, you can give each a name, a face, and a conversation.',
      features: const [
        'Talk to your past and future self',
        'Challenge your inner critic',
        'Nurture your inner child',
      ],
      onNext: onNext,
    );
  }
}

/// Time Travel concept page
class OnboardingTimeTravelPage extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingTimeTravelPage({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return _OnboardingContentPage(
      icon: Icons.schedule,
      title: 'Travel Through Time',
      description:
          'Write letters to your future self. Send messages to be unlocked on special dates. Revisit echoes of past thoughts when you need them most.',
      features: const [
        'Time capsules that unlock later',
        'Letters to your future self',
        'Memory echoes from your past',
      ],
      onNext: onNext,
    );
  }
}

/// Spaces concept page
class OnboardingSpacesPage extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingSpacesPage({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return _OnboardingContentPage(
      icon: Icons.landscape_outlined,
      title: 'Emotional Spaces',
      description:
          'Different emotions need different environments. Visit The Void when overwhelmed, The Storm Room when angry, The Shore when grieving, or The Garden when grateful.',
      features: const [
        'Each space has unique visuals',
        'Calming ambient sounds',
        'Special interactions per mood',
      ],
      onNext: onNext,
    );
  }
}

/// Privacy emphasis page
class OnboardingPrivacyPage extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPrivacyPage({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return _OnboardingContentPage(
      icon: Icons.lock_outline,
      title: 'Your Sacred Space',
      description:
          'This is YOUR space. Everything stays on your device. No cloud. No sharing. No one reads your thoughts but you. Ever.',
      features: const [
        '100% local storage',
        'PIN and biometric protection',
        'Panic button for privacy',
      ],
      onNext: onNext,
      buttonText: 'I understand',
    );
  }
}

/// Name collection page
class OnboardingNamePage extends StatefulWidget {
  final String initialName;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onNext;

  const OnboardingNamePage({
    super.key,
    required this.initialName,
    required this.onNameChanged,
    required this.onNext,
  });

  @override
  State<OnboardingNamePage> createState() => _OnboardingNamePageState();
}

class _OnboardingNamePageState extends State<OnboardingNamePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Title
          Text(
            'What should we call you?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 16),

          Text(
            'This is just for you. Make it personal.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

          const SizedBox(height: 48),

          // Name input
          TextField(
            controller: _controller,
            onChanged: widget.onNameChanged,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Your name',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 24,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.cosmicTeal,
                  width: 2,
                ),
              ),
            ),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

          const Spacer(),

          // Continue button
          FilledButton.icon(
            onPressed: _controller.text.trim().isNotEmpty ? widget.onNext : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Continue'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.cosmicTeal,
              foregroundColor: AppColors.deepSpace,
              disabledBackgroundColor: Colors.white.withOpacity(0.1),
              disabledForegroundColor: Colors.white.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

/// Persona selection page
class OnboardingPersonaSelectionPage extends StatelessWidget {
  final Set<PersonaType> selectedPersonas;
  final ValueChanged<PersonaType> onPersonaToggled;
  final VoidCallback onNext;

  const OnboardingPersonaSelectionPage({
    super.key,
    required this.selectedPersonas,
    required this.onPersonaToggled,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final personas = PersonaType.values.where((p) => p != PersonaType.custom).toList();

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        children: [
          const SizedBox(height: 24),

          Text(
            'Which voices resonate with you?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Select at least 2 to start',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
          ),

          const SizedBox(height: 24),

          // Persona grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: personas.length,
              itemBuilder: (context, index) {
                final persona = personas[index];
                final isSelected = selectedPersonas.contains(persona);

                return _PersonaCard(
                  persona: persona,
                  isSelected: isSelected,
                  onTap: () => onPersonaToggled(persona),
                ).animate(delay: (50 * index).ms).fadeIn().slideY(begin: 0.1);
              },
            ),
          ),

          const SizedBox(height: 16),

          // Continue button
          FilledButton.icon(
            onPressed: selectedPersonas.length >= 2 ? onNext : null,
            icon: const Icon(Icons.arrow_forward),
            label: Text('Continue (${selectedPersonas.length}/2+)'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.cosmicTeal,
              foregroundColor: AppColors.deepSpace,
              disabledBackgroundColor: Colors.white.withOpacity(0.1),
              disabledForegroundColor: Colors.white.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonaCard extends StatelessWidget {
  final PersonaType persona;
  final bool isSelected;
  final VoidCallback onTap;

  const _PersonaCard({
    required this.persona,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? persona.defaultColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? persona.defaultColor : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              persona.emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              persona.displayName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Space selection page
class OnboardingSpaceSelectionPage extends StatelessWidget {
  final String selectedSpace;
  final ValueChanged<String> onSpaceSelected;
  final VoidCallback onNext;

  const OnboardingSpaceSelectionPage({
    super.key,
    required this.selectedSpace,
    required this.onSpaceSelected,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        children: [
          const SizedBox(height: 24),

          Text(
            'Where would you like to begin?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Space list
          Expanded(
            child: ListView.builder(
              itemCount: allSpaces.length,
              itemBuilder: (context, index) {
                final space = allSpaces[index];
                final isSelected = selectedSpace == space.id;

                return _SpaceCard(
                  space: space,
                  isSelected: isSelected,
                  onTap: () => onSpaceSelected(space.id),
                ).animate(delay: (50 * index).ms).fadeIn().slideX(begin: 0.1);
              },
            ),
          ),

          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Continue'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.cosmicTeal,
              foregroundColor: AppColors.deepSpace,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpaceCard extends StatelessWidget {
  final SpaceConfig space;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpaceCard({
    required this.space,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: AppDurations.fast,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: space.gradientColors)
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? space.accentColor : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              space.emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    space.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? space.textColor : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    space.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? space.textColor.withOpacity(0.7)
                              : Colors.white.withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: space.accentColor,
              ),
          ],
        ),
      ),
    );
  }
}

/// Security setup page
class OnboardingSecurityPage extends StatefulWidget {
  final ValueChanged<String> onPinSet;
  final VoidCallback onSkip;

  const OnboardingSecurityPage({
    super.key,
    required this.onPinSet,
    required this.onSkip,
  });

  @override
  State<OnboardingSecurityPage> createState() => _OnboardingSecurityPageState();
}

class _OnboardingSecurityPageState extends State<OnboardingSecurityPage> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          Icon(
            Icons.lock_outline,
            size: 64,
            color: AppColors.cosmicTeal,
          ).animate().fadeIn(),

          const SizedBox(height: 32),

          Text(
            _isConfirming ? 'Confirm your PIN' : 'Set up a PIN',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            _isConfirming
                ? 'Enter the same PIN again'
                : 'Protect your innerverse with a PIN',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 48),

          // PIN dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              final pin = _isConfirming ? _confirmPin : _pin;
              final isFilled = index < pin.length;
              final isError = _showError && _isConfirming;

              return AnimatedContainer(
                duration: AppDurations.fast,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled
                      ? (isError ? AppColors.error : AppColors.cosmicTeal)
                      : Colors.white.withOpacity(0.2),
                  border: Border.all(
                    color: isError
                        ? AppColors.error
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
              );
            }),
          ),

          if (_showError)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                "PINs don't match. Try again.",
                style: TextStyle(color: AppColors.error),
              ),
            ),

          const SizedBox(height: 48),

          // Number pad
          _buildNumberPad(),

          const Spacer(),

          // Skip button
          TextButton(
            onPressed: widget.onSkip,
            child: Text(
              'Skip for now',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 80, height: 60),
            _buildNumberButton('0'),
            _buildDeleteButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        width: 80,
        height: 60,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _onDeletePressed,
      child: Container(
        width: 80,
        height: 60,
        margin: const EdgeInsets.all(4),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  void _onNumberPressed(String number) {
    HapticFeedback.lightImpact();
    setState(() {
      _showError = false;
      if (_isConfirming) {
        if (_confirmPin.length < 6) {
          _confirmPin += number;
          if (_confirmPin.length == 6) {
            _validatePins();
          }
        }
      } else {
        if (_pin.length < 6) {
          _pin += number;
          if (_pin.length == 6) {
            _isConfirming = true;
          }
        }
      }
    });
  }

  void _onDeletePressed() {
    HapticFeedback.lightImpact();
    setState(() {
      _showError = false;
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  void _validatePins() {
    if (_pin == _confirmPin) {
      widget.onPinSet(_pin);
    } else {
      setState(() {
        _showError = true;
        _confirmPin = '';
      });
      HapticFeedback.heavyImpact();
    }
  }
}

/// Welcome home page
class OnboardingCompletePage extends StatelessWidget {
  final String userName;
  final VoidCallback onComplete;

  const OnboardingCompletePage({
    super.key,
    required this.userName,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          Icon(
            Icons.celebration_outlined,
            size: 80,
            color: AppColors.starGold,
          ).animate().fadeIn().scale(begin: const Offset(0.5, 0.5)),

          const SizedBox(height: 32),

          Text(
            'Welcome home, $userName',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 16),

          Text(
            'Your inner universe is ready to explore.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 500.ms),

          const SizedBox(height: 16),

          Text(
            'Remember: This is your sacred space.\nNo one enters but you.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 700.ms),

          const Spacer(),

          FilledButton.icon(
            onPressed: onComplete,
            icon: const Icon(Icons.rocket_launch),
            label: const Text('Enter Your Universe'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.starGold,
              foregroundColor: AppColors.deepSpace,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

/// Reusable content page template
class _OnboardingContentPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String> features;
  final VoidCallback onNext;
  final String buttonText;

  const _OnboardingContentPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
    required this.onNext,
    this.buttonText = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          Icon(
            icon,
            size: 72,
            color: AppColors.cosmicTeal,
          ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),

          const SizedBox(height: 32),

          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 16),

          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 32),

          // Feature list
          ...features.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.cosmicTeal,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (600 + entry.key * 100).ms).slideX(begin: 0.1);
          }),

          const Spacer(),

          FilledButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward),
            label: Text(buttonText),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.cosmicTeal,
              foregroundColor: AppColors.deepSpace,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ).animate().fadeIn(delay: 1000.ms),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
