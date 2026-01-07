/// Settings screen - App configuration and preferences
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/app_providers.dart';

/// Settings screen for app configuration
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.backgroundDark, AppColors.surfaceDark]
                : [AppColors.backgroundLight, AppColors.surfaceVariantLight],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          children: [
            // Appearance Section
            _buildSectionHeader(context, 'Appearance', isDark),
            _SettingsCard(
              isDark: isDark,
              children: [
                _ThemeModeTile(
                  themeMode: themeMode,
                  onChanged: (mode) {
                    ref.read(themeModeProvider.notifier).state = mode;
                  },
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Privacy & Security Section
            _buildSectionHeader(context, 'Privacy & Security', isDark),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.lock_outline,
                  title: 'App Lock',
                  subtitle: 'Secure with biometrics',
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      // TODO: Implement app lock
                    },
                  ),
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _SettingsTile(
                  icon: Icons.visibility_off_outlined,
                  title: 'Vapor Mode Default',
                  subtitle: 'Auto-delete messages after reading',
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      // TODO: Implement vapor mode default
                    },
                  ),
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _SettingsTile(
                  icon: Icons.delete_outline,
                  title: 'Clear All Data',
                  subtitle: 'Permanently delete all conversations',
                  onTap: () => _showClearDataDialog(context),
                  isDark: isDark,
                  isDestructive: true,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Data & Backup Section
            _buildSectionHeader(context, 'Data & Backup', isDark),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.backup_outlined,
                  title: 'Create Backup',
                  subtitle: 'Export your data locally',
                  onTap: () => _createBackup(context),
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _SettingsTile(
                  icon: Icons.restore_outlined,
                  title: 'Restore Backup',
                  subtitle: 'Import from backup file',
                  onTap: () => _restoreBackup(context),
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _SettingsTile(
                  icon: Icons.file_download_outlined,
                  title: 'Export Data',
                  subtitle: 'Download as JSON or PDF',
                  onTap: () => _showExportOptions(context),
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Notifications Section
            _buildSectionHeader(context, 'Notifications', isDark),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Daily Reminders',
                  subtitle: 'Gentle nudges for rituals',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Implement notifications toggle
                    },
                  ),
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _SettingsTile(
                  icon: Icons.access_time_outlined,
                  title: 'Morning Reminder',
                  subtitle: '8:00 AM',
                  onTap: () => _showTimePickerDialog(context, 'Morning'),
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _SettingsTile(
                  icon: Icons.nights_stay_outlined,
                  title: 'Evening Reminder',
                  subtitle: '9:00 PM',
                  onTap: () => _showTimePickerDialog(context, 'Evening'),
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingL),

            // About Section
            _buildSectionHeader(context, 'About', isDark),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'Version',
                  subtitle: AppMetadata.version,
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Privacy Policy',
                  onTap: () {
                    // TODO: Open privacy policy
                  },
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _SettingsTile(
                  icon: Icons.article_outlined,
                  title: 'Terms of Service',
                  onTap: () {
                    // TODO: Open terms of service
                  },
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _SettingsTile(
                  icon: Icons.bug_report_outlined,
                  title: 'Debug Info',
                  subtitle: 'View error logs',
                  onTap: () => context.pushNamed(RouteNames.debug),
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingXL),

            // App info footer
            Center(
              child: Column(
                children: [
                  const Text(
                    '✨',
                    style: TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    AppMetadata.appName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXS),
                  Text(
                    'Your inner universe awaits',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Text(
                    '100% Local • Your Data Stays Yours',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingXXL),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.paddingS,
        bottom: AppSizes.paddingS,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your conversations, personas, '
          'time capsules, and rituals. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _createBackup(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Creating backup...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: Implement backup creation
  }

  void _restoreBackup(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Select a backup file to restore'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: Implement backup restore
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Export as JSON'),
              subtitle: const Text('Machine-readable format'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Export JSON
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export as PDF'),
              subtitle: const Text('Human-readable document'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Export PDF
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePickerDialog(BuildContext context, String label) {
    showTimePicker(
      context: context,
      initialTime: label == 'Morning'
          ? const TimeOfDay(hour: 8, minute: 0)
          : const TimeOfDay(hour: 21, minute: 0),
    ).then((time) {
      if (time != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label reminder set to ${time.format(context)}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }
}

/// Settings card container
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;

  const _SettingsCard({
    required this.children,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceContainerDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

/// Settings tile widget
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDark;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.isDark,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : null,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: textColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            )
          : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}

/// Theme mode selector tile
class _ThemeModeTile extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;
  final bool isDark;

  const _ThemeModeTile({
    required this.themeMode,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.palette_outlined,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              const SizedBox(width: AppSizes.paddingM),
              Text(
                'Theme',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              _ThemeOption(
                icon: Icons.brightness_auto,
                label: 'System',
                isSelected: themeMode == ThemeMode.system,
                onTap: () => onChanged(ThemeMode.system),
                isDark: isDark,
              ),
              const SizedBox(width: AppSizes.paddingS),
              _ThemeOption(
                icon: Icons.light_mode,
                label: 'Light',
                isSelected: themeMode == ThemeMode.light,
                onTap: () => onChanged(ThemeMode.light),
                isDark: isDark,
              ),
              const SizedBox(width: AppSizes.paddingS),
              _ThemeOption(
                icon: Icons.dark_mode,
                label: 'Dark',
                isSelected: themeMode == ThemeMode.dark,
                onTap: () => onChanged(ThemeMode.dark),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Theme option button
class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.paddingM,
            ),
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
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : null,
                ),
                const SizedBox(height: AppSizes.paddingXS),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected ? AppColors.primary : null,
                    fontWeight: isSelected ? FontWeight.w600 : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
