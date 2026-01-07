/// Time capsule detail screen for viewing/creating capsules
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/time_capsule.dart';

/// Time capsule detail/create screen
class TimeCapsuleDetailScreen extends ConsumerStatefulWidget {
  final String? capsuleId;

  const TimeCapsuleDetailScreen({
    super.key,
    required this.capsuleId,
  });

  @override
  ConsumerState<TimeCapsuleDetailScreen> createState() =>
      _TimeCapsuleDetailScreenState();
}

class _TimeCapsuleDetailScreenState
    extends ConsumerState<TimeCapsuleDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  DateTime _unlockDate = DateTime.now().add(const Duration(days: 365));
  CapsuleOccasion _selectedOccasion = CapsuleOccasion.none;

  bool get isCreating => widget.capsuleId == null;
  bool get isViewing => widget.capsuleId != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();

    if (isViewing) {
      _loadCapsule();
    }
  }

  void _loadCapsule() {
    // Mock data - would load from repository
    _titleController.text = 'Last Year\'s Hopes';
    _contentController.text = '''Dear Future Me,

I hope this message finds you well. As I write this, I'm filled with hope for what the coming year will bring.

Remember to be kind to yourself and to celebrate the small victories. Growth isn't always visible, but it's always happening.

With love,
Your Past Self''';
    _selectedOccasion = CapsuleOccasion.newYear;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isViewing) {
      return _buildViewMode(context, theme, isDark);
    } else {
      return _buildCreateMode(context, theme, isDark);
    }
  }

  Widget _buildViewMode(BuildContext context, ThemeData theme, bool isDark) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.cosmicPurple, AppColors.deepSpace]
                : [
                    AppColors.tertiaryContainer,
                    AppColors.backgroundLight,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _showDeleteDialog,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Opened capsule animation
                      const Text(
                        '\u{2728}',
                        style: TextStyle(fontSize: 64),
                      ),
                      const SizedBox(height: AppSizes.paddingL),

                      Text(
                        _titleController.text,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.paddingS),

                      Text(
                        'Written on ${DateFormat.yMMMd().format(DateTime.now().subtract(const Duration(days: 365)))}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingXL),

                      // Letter content
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSizes.paddingL),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceContainerDark
                              : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          _contentController.text,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateMode(BuildContext context, ThemeData theme, bool isDark) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Time Capsule'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Occasion selector
            Text(
              'Occasion',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            _buildOccasionSelector(theme, isDark),
            const SizedBox(height: AppSizes.paddingL),

            // Title
            Text(
              'Title',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Give your capsule a name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Unlock date
            Text(
              'Unlock Date',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            _buildDateSelector(context, theme, isDark),
            const SizedBox(height: AppSizes.paddingL),

            // Content
            Text(
              'Your Message',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Write a message to your future self...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Quick prompts
            Text(
              'Need inspiration?',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            Wrap(
              spacing: AppSizes.paddingS,
              runSpacing: AppSizes.paddingS,
              children: [
                _PromptChip(
                  label: 'Current goals',
                  onTap: () => _addPrompt('What are your current goals?'),
                ),
                _PromptChip(
                  label: 'Grateful for',
                  onTap: () => _addPrompt('What are you grateful for today?'),
                ),
                _PromptChip(
                  label: 'Advice',
                  onTap: () =>
                      _addPrompt('What advice would you give your future self?'),
                ),
                _PromptChip(
                  label: 'Dreams',
                  onTap: () => _addPrompt('What dreams are you pursuing?'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: FilledButton(
            onPressed: _saveCapsule,
            child: const Text('Seal Time Capsule'),
          ),
        ),
      ),
    );
  }

  Widget _buildOccasionSelector(ThemeData theme, bool isDark) {
    return Wrap(
      spacing: AppSizes.paddingS,
      runSpacing: AppSizes.paddingS,
      children: CapsuleOccasion.values.map((occasion) {
        final isSelected = occasion == _selectedOccasion;
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(occasion.emoji),
              const SizedBox(width: 4),
              Text(occasion.displayName),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() => _selectedOccasion = occasion);
              _updateUnlockDateForOccasion(occasion);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: AppSizes.paddingM),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(_unlockDate),
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  _getTimeUntilText(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.tertiary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.edit),
          ],
        ),
      ),
    );
  }

  String _getTimeUntilText() {
    final diff = _unlockDate.difference(DateTime.now());
    if (diff.inDays > 365) {
      final years = (diff.inDays / 365).round();
      return 'Opens in $years ${years == 1 ? 'year' : 'years'}';
    } else if (diff.inDays > 30) {
      final months = (diff.inDays / 30).round();
      return 'Opens in $months ${months == 1 ? 'month' : 'months'}';
    } else {
      return 'Opens in ${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'}';
    }
  }

  void _updateUnlockDateForOccasion(CapsuleOccasion occasion) {
    final now = DateTime.now();
    switch (occasion) {
      case CapsuleOccasion.birthday:
        // Next birthday (assume 1 year from now as placeholder)
        setState(() => _unlockDate = DateTime(now.year + 1, now.month, now.day));
        break;
      case CapsuleOccasion.newYear:
        // Next new year
        setState(() => _unlockDate = DateTime(now.year + 1, 1, 1));
        break;
      case CapsuleOccasion.anniversary:
        setState(() => _unlockDate = DateTime(now.year + 1, now.month, now.day));
        break;
      case CapsuleOccasion.graduation:
        setState(
            () => _unlockDate = DateTime(now.year + 1, 6, 1)); // June next year
        break;
      case CapsuleOccasion.custom:
      case CapsuleOccasion.none:
        // Keep current date
        break;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _unlockDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
    );

    if (date != null) {
      setState(() => _unlockDate = date);
    }
  }

  void _addPrompt(String prompt) {
    final currentText = _contentController.text;
    final newText = currentText.isEmpty
        ? prompt
        : '$currentText\n\n$prompt';
    _contentController.text = newText;
    _contentController.selection = TextSelection.fromPosition(
      TextPosition(offset: _contentController.text.length),
    );
  }

  void _saveCapsule() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a message')),
      );
      return;
    }

    // Save capsule (mock)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Time capsule sealed! It will unlock on the selected date.'),
      ),
    );

    context.pop();
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Time Capsule?'),
        content: const Text(
          'This will permanently delete this time capsule. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
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

/// Prompt chip widget
class _PromptChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PromptChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
    );
  }
}
