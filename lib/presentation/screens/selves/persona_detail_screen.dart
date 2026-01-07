/// Persona detail screen for viewing/editing a persona
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/persona_defaults.dart';
import '../../../core/theme/app_colors.dart';

/// Persona detail/edit screen
class PersonaDetailScreen extends ConsumerStatefulWidget {
  final String? personaId;

  const PersonaDetailScreen({
    super.key,
    required this.personaId,
  });

  @override
  ConsumerState<PersonaDetailScreen> createState() =>
      _PersonaDetailScreenState();
}

class _PersonaDetailScreenState extends ConsumerState<PersonaDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _selectedEmoji = '\u{2728}';
  int _selectedColor = AppColors.primary.value;

  bool get isCreating => widget.personaId == null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();

    if (!isCreating) {
      _loadPersona();
    }
  }

  void _loadPersona() {
    // Find persona config
    final config = defaultPersonas.firstWhere(
      (p) => p.typeId == widget.personaId,
      orElse: () => defaultPersonas.first,
    );

    _nameController.text = config.displayName;
    _descriptionController.text = config.description;
    _selectedEmoji = config.defaultEmoji;
    _selectedColor = config.defaultColor;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isCreating ? 'Create Persona' : 'Edit Persona'),
        actions: [
          if (!isCreating)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showDeleteDialog,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar preview
            Center(
              child: _buildAvatarPreview(isDark),
            ),
            const SizedBox(height: AppSizes.paddingXL),

            // Name field
            Text(
              'Name',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter persona name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Description field
            Text(
              'Description',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'What does this part of you represent?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Emoji selector
            Text(
              'Choose an Emoji',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            _buildEmojiSelector(),
            const SizedBox(height: AppSizes.paddingL),

            // Color selector
            Text(
              'Choose a Color',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            _buildColorSelector(),
            const SizedBox(height: AppSizes.paddingXL),

            // Conversation prompts section
            if (!isCreating) ...[
              Text(
                'Conversation Starters',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.paddingS),
              _buildPromptsList(isDark),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: FilledButton(
            onPressed: _savePersona,
            child: Text(isCreating ? 'Create Persona' : 'Save Changes'),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPreview(bool isDark) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(_selectedColor).withOpacity(0.2),
        border: Border.all(
          color: Color(_selectedColor),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(_selectedColor).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          _selectedEmoji,
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }

  Widget _buildEmojiSelector() {
    const emojis = [
      '\u{1F476}', // Inner Child
      '\u{1F47B}', // Shadow
      '\u{2728}', // Ideal
      '\u{1F9D0}', // Critic
      '\u{1F308}', // Dreamer
      '\u{1F6E1}\u{FE0F}', // Protector
      '\u{23F3}', // Past
      '\u{1F680}', // Future
      '\u{1F441}\u{FE0F}', // Observer
      '\u{1F3AD}', // Custom
      '\u{1F31F}', // Star
      '\u{1F525}', // Fire
      '\u{1F33B}', // Sunflower
      '\u{1F98B}', // Butterfly
      '\u{1F43A}', // Wolf
    ];

    return Wrap(
      spacing: AppSizes.paddingS,
      runSpacing: AppSizes.paddingS,
      children: emojis.map((emoji) {
        final isSelected = emoji == _selectedEmoji;
        return GestureDetector(
          onTap: () => setState(() => _selectedEmoji = emoji),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorSelector() {
    final colors = [
      AppColors.innerChildPink.value,
      AppColors.shadowSelfPurple.value,
      AppColors.idealSelfGold.value,
      AppColors.criticRed.value,
      AppColors.dreamerViolet.value,
      AppColors.protectorBlue.value,
      AppColors.pastSelfLavender.value,
      AppColors.futureSelfCyan.value,
      AppColors.observerSelfGray.value,
      AppColors.primary.value,
      AppColors.secondary.value,
      AppColors.tertiary.value,
    ];

    return Wrap(
      spacing: AppSizes.paddingS,
      runSpacing: AppSizes.paddingS,
      children: colors.map((color) {
        final isSelected = color == _selectedColor;
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = color),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Color(color).withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPromptsList(bool isDark) {
    final config = defaultPersonas.firstWhere(
      (p) => p.typeId == widget.personaId,
      orElse: () => defaultPersonas.first,
    );

    return Column(
      children: config.conversationStarters.map((prompt) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingS),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceContainerDark
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(prompt),
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  // Start conversation with this prompt
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _savePersona() {
    // Validate
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    // Save persona (mock - would use repository)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCreating ? 'Persona created!' : 'Persona saved!'),
      ),
    );

    context.pop();
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Persona?'),
        content: const Text(
          'This will permanently delete this persona and all associated conversations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete persona
              context.pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
