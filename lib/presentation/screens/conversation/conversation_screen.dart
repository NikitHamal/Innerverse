/// Conversation screen - Immersive chat interface
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/space_configs.dart';
import '../../../core/theme/app_colors.dart';

/// Immersive conversation screen
class ConversationScreen extends ConsumerStatefulWidget {
  final String spaceId;
  final String? conversationId;
  final String? mode;

  const ConversationScreen({
    super.key,
    required this.spaceId,
    this.conversationId,
    this.mode,
  });

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  late SpaceConfig _spaceConfig;
  bool _isVaporMode = false;
  bool _showModeSelector = false;

  // Mock messages for demo
  final List<_MockMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _spaceConfig = getSpaceConfig(widget.spaceId);
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(_MockMessage(
      content: _getWelcomeMessage(),
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  String _getWelcomeMessage() {
    switch (widget.spaceId) {
      case SpaceTypeIds.theVoid:
        return 'You are in The Void. Speak into the emptiness. What weighs on you?';
      case SpaceTypeIds.stormRoom:
        return 'Welcome to The Storm Room. Let the thunder drown out your frustrations. What angers you?';
      case SpaceTypeIds.dreamGarden:
        return 'Welcome to The Dream Garden. What dreams are blooming in your heart?';
      case SpaceTypeIds.memoryPalace:
        return 'Welcome to the Memory Palace. Which room of your past shall we explore?';
      case SpaceTypeIds.theShore:
        return 'Welcome to The Shore. Let the waves carry your thoughts. What do you need to release?';
      default:
        return 'Welcome to your Sanctuary. What\'s on your mind today?';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveConfig = isDark ? getDarkVariant(_spaceConfig) : _spaceConfig;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: effectiveConfig.gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, effectiveConfig),

              // Mode selector (if shown)
              if (_showModeSelector) _buildModeSelector(effectiveConfig),

              // Messages
              Expanded(
                child: _buildMessageList(effectiveConfig),
              ),

              // Input area
              _buildInputArea(context, effectiveConfig),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SpaceConfig config) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back,
              color: config.textColor,
            ),
          ),

          // Space info
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  config.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: AppSizes.paddingS),
                Text(
                  config.name,
                  style: TextStyle(
                    color: config.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: config.fontFamily,
                    letterSpacing: config.letterSpacing,
                  ),
                ),
              ],
            ),
          ),

          // Options menu
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: config.textColor,
            ),
            onSelected: (value) {
              switch (value) {
                case 'vapor':
                  setState(() => _isVaporMode = !_isVaporMode);
                  break;
                case 'mode':
                  setState(() => _showModeSelector = !_showModeSelector);
                  break;
                case 'clear':
                  _showClearDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'vapor',
                child: Row(
                  children: [
                    Icon(
                      _isVaporMode
                          ? Icons.visibility_off
                          : Icons.visibility_off_outlined,
                    ),
                    const SizedBox(width: AppSizes.paddingS),
                    Text(_isVaporMode ? 'Disable Vapor Mode' : 'Vapor Mode'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'mode',
                child: Row(
                  children: [
                    Icon(Icons.psychology),
                    SizedBox(width: AppSizes.paddingS),
                    Text('Conversation Mode'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: AppSizes.paddingS),
                    Text('Clear Chat'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector(SpaceConfig config) {
    final modes = [
      ('Mirror', '\u{1F5E3}\u{FE0F}', 'Talk to yourself'),
      ('Council', '\u{1F3DB}\u{FE0F}', 'Consult your selves'),
      ('Timeline', '\u{23F3}', 'Message past/future'),
      ('Socratic', '\u{1F914}', 'Deep questioning'),
      ('Stream', '\u{1F4AD}', 'Free writing'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: modes.map((mode) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSizes.paddingS),
              child: ActionChip(
                avatar: Text(mode.$2),
                label: Text(mode.$1),
                backgroundColor: config.secondaryColor.withOpacity(0.3),
                labelStyle: TextStyle(
                  color: config.textColor,
                  fontSize: 12,
                ),
                onPressed: () {
                  // Select mode
                  setState(() => _showModeSelector = false);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMessageList(SpaceConfig config) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _MessageBubble(
          message: message,
          config: config,
          isVaporMode: _isVaporMode,
        );
      },
    );
  }

  Widget _buildInputArea(BuildContext context, SpaceConfig config) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: config.backgroundColor.withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: config.accentColor.withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Vapor mode indicator
            if (_isVaporMode)
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingS),
                margin: const EdgeInsets.only(right: AppSizes.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
                child: const Text(
                  '\u{1F32B}\u{FE0F}',
                  style: TextStyle(fontSize: 20),
                ),
              ),

            // Text input
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                maxLines: 4,
                minLines: 1,
                style: TextStyle(
                  color: config.textColor,
                  fontFamily: config.fontFamily,
                ),
                decoration: InputDecoration(
                  hintText: _getInputHint(),
                  hintStyle: TextStyle(
                    color: config.textColor.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: config.secondaryColor.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusL),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM,
                    vertical: AppSizes.paddingS,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.paddingS),

            // Send button
            IconButton.filled(
              onPressed: _sendMessage,
              style: IconButton.styleFrom(
                backgroundColor: config.accentColor,
              ),
              icon: Icon(
                Icons.send,
                color: _getContrastColor(config.accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInputHint() {
    if (_isVaporMode) {
      return 'This message will disappear in 24h...';
    }
    switch (widget.spaceId) {
      case SpaceTypeIds.theVoid:
        return 'Speak into the void...';
      case SpaceTypeIds.stormRoom:
        return 'Let it out...';
      case SpaceTypeIds.dreamGarden:
        return 'Plant a dream...';
      default:
        return 'Type your thoughts...';
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_MockMessage(
        content: text,
        isUser: true,
        timestamp: DateTime.now(),
        isVapor: _isVaporMode,
      ));
    });

    _messageController.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: AppDurations.normal,
        curve: Curves.easeOut,
      );
    });

    // Simulate response after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(_MockMessage(
            content: _getResponse(text),
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: AppDurations.normal,
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  String _getResponse(String userMessage) {
    // Simple reflection responses
    final responses = [
      'Tell me more about that.',
      'How does that make you feel?',
      'What do you think that means for you?',
      'That sounds significant. Can you explore that further?',
      'I hear you. What would your ideal self say about this?',
      'Take a moment to breathe. What comes up when you sit with that?',
    ];

    return responses[DateTime.now().millisecond % responses.length];
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Conversation?'),
        content: const Text(
          'This will delete all messages in this conversation. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
                _addWelcomeMessage();
              });
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Mock message model
class _MockMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isVapor;

  _MockMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isVapor = false,
  });
}

/// Message bubble widget
class _MessageBubble extends StatelessWidget {
  final _MockMessage message;
  final SpaceConfig config;
  final bool isVaporMode;

  const _MessageBubble({
    required this.message,
    required this.config,
    required this.isVaporMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.messageBubbleMaxWidth,
            ),
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: message.isUser
                  ? config.accentColor.withOpacity(0.9)
                  : config.secondaryColor.withOpacity(0.6),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(AppSizes.radiusL),
                topRight: const Radius.circular(AppSizes.radiusL),
                bottomLeft: Radius.circular(
                  message.isUser ? AppSizes.radiusL : AppSizes.radiusXS,
                ),
                bottomRight: Radius.circular(
                  message.isUser ? AppSizes.radiusXS : AppSizes.radiusL,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vapor mode indicator
                if (message.isVapor)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.paddingXS),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('\u{1F32B}\u{FE0F}', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          'Vapor',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: message.isUser
                                ? _getContrastColor(config.accentColor)
                                    .withOpacity(0.7)
                                : config.textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Message content
                Text(
                  message.content,
                  style: TextStyle(
                    color: message.isUser
                        ? _getContrastColor(config.accentColor)
                        : config.textColor,
                    fontFamily: config.fontFamily,
                    letterSpacing: config.letterSpacing,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
