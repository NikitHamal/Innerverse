/// Archive screen - Past conversations library
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/space_configs.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';

/// Archive screen for browsing past conversations
class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Mock conversations
    final conversations = _getMockConversations();
    final filteredConversations = _filterConversations(conversations);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
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
        child: Column(
          children: [
            // Filter chips
            _buildFilterChips(context, isDark),

            // Conversation list
            Expanded(
              child: filteredConversations.isEmpty
                  ? _buildEmptyState(context, isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      itemCount: filteredConversations.length,
                      itemBuilder: (context, index) {
                        return _ConversationTile(
                          conversation: filteredConversations[index],
                          isDark: isDark,
                          onTap: () {
                            // Navigate to conversation
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, bool isDark) {
    final filters = [
      ('all', 'All', null),
      (SpaceTypeIds.sanctuary, 'Sanctuary', '\u{1F33F}'),
      (SpaceTypeIds.stormRoom, 'Storm', '\u{1F327}\u{FE0F}'),
      (SpaceTypeIds.dreamGarden, 'Dreams', '\u{1F338}'),
      (SpaceTypeIds.theShore, 'Shore', '\u{1F30A}'),
      (SpaceTypeIds.theVoid, 'Void', '\u{1F311}'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter.$1 == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.paddingS),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filter.$3 != null) ...[
                    Text(filter.$3!),
                    const SizedBox(width: 4),
                  ],
                  Text(filter.$2),
                ],
              ),
              onSelected: (selected) {
                setState(() => _selectedFilter = filter.$1);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '\u{1F4DA}',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No matches found'
                  : 'No conversations yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try a different search term'
                  : 'Start a conversation to see it here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Archive'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search conversations...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = '');
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  List<_MockConversation> _filterConversations(
    List<_MockConversation> conversations,
  ) {
    var filtered = conversations;

    // Filter by space
    if (_selectedFilter != 'all') {
      filtered =
          filtered.where((c) => c.spaceId == _selectedFilter).toList();
    }

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((c) {
        return c.preview.toLowerCase().contains(query) ||
            c.spaceName.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  List<_MockConversation> _getMockConversations() {
    return [
      _MockConversation(
        id: '1',
        spaceId: SpaceTypeIds.sanctuary,
        spaceName: 'Sanctuary',
        spaceEmoji: '\u{1F33F}',
        preview: 'I\'ve been thinking about my goals for the new year...',
        date: DateTime.now().subtract(const Duration(hours: 3)),
        messageCount: 12,
      ),
      _MockConversation(
        id: '2',
        spaceId: SpaceTypeIds.stormRoom,
        spaceName: 'Storm Room',
        spaceEmoji: '\u{1F327}\u{FE0F}',
        preview: 'Sometimes I feel so overwhelmed by everything...',
        date: DateTime.now().subtract(const Duration(days: 1)),
        messageCount: 8,
      ),
      _MockConversation(
        id: '3',
        spaceId: SpaceTypeIds.dreamGarden,
        spaceName: 'Dream Garden',
        spaceEmoji: '\u{1F338}',
        preview: 'I dreamed of a beautiful garden where everything was...',
        date: DateTime.now().subtract(const Duration(days: 2)),
        messageCount: 15,
      ),
      _MockConversation(
        id: '4',
        spaceId: SpaceTypeIds.theShore,
        spaceName: 'The Shore',
        spaceEmoji: '\u{1F30A}',
        preview: 'Letting go of what no longer serves me...',
        date: DateTime.now().subtract(const Duration(days: 5)),
        messageCount: 6,
      ),
      _MockConversation(
        id: '5',
        spaceId: SpaceTypeIds.sanctuary,
        spaceName: 'Sanctuary',
        spaceEmoji: '\u{1F33F}',
        preview: 'Today I want to focus on gratitude...',
        date: DateTime.now().subtract(const Duration(days: 7)),
        messageCount: 10,
      ),
    ];
  }
}

/// Mock conversation model
class _MockConversation {
  final String id;
  final String spaceId;
  final String spaceName;
  final String spaceEmoji;
  final String preview;
  final DateTime date;
  final int messageCount;

  _MockConversation({
    required this.id,
    required this.spaceId,
    required this.spaceName,
    required this.spaceEmoji,
    required this.preview,
    required this.date,
    required this.messageCount,
  });

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inHours < 24) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return DateFormat.MMMd().format(date);
    }
  }
}

/// Conversation tile widget
class _ConversationTile extends StatelessWidget {
  final _MockConversation conversation;
  final bool isDark;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spaceConfig = getSpaceConfig(conversation.spaceId);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingS),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Row(
            children: [
              // Space icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: spaceConfig.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
                child: Center(
                  child: Text(
                    conversation.spaceEmoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          conversation.spaceName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          conversation.formattedDate,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.paddingXS),
                    Text(
                      conversation.preview,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.paddingXS),
                    Text(
                      '${conversation.messageCount} messages',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight,
                      ),
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
