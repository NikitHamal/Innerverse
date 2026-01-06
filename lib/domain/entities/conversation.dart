/// Conversation domain entity for Innerverse
library;

import 'package:equatable/equatable.dart';

import '../../core/constants/space_configs.dart';

/// Types of emotional spaces
enum SpaceType {
  sanctuary,
  theVoid,
  stormRoom,
  dreamGarden,
  memoryPalace,
  theShore;

  String get id => switch (this) {
        SpaceType.sanctuary => 'sanctuary',
        SpaceType.theVoid => 'the_void',
        SpaceType.stormRoom => 'storm_room',
        SpaceType.dreamGarden => 'dream_garden',
        SpaceType.memoryPalace => 'memory_palace',
        SpaceType.theShore => 'the_shore',
      };

  String get displayName => getSpaceName(id);

  String get emoji => getSpaceEmoji(id);

  SpaceConfig get config => getSpaceConfig(id);

  static SpaceType fromId(String id) {
    return SpaceType.values.firstWhere(
      (t) => t.id == id,
      orElse: () => SpaceType.sanctuary,
    );
  }
}

/// Conversation mode types
enum ConversationMode {
  mirror,
  council,
  timeline,
  roleReversal,
  socratic,
  prompt,
  stream;

  String get id => switch (this) {
        ConversationMode.mirror => 'mirror',
        ConversationMode.council => 'council',
        ConversationMode.timeline => 'timeline',
        ConversationMode.roleReversal => 'role_reversal',
        ConversationMode.socratic => 'socratic',
        ConversationMode.prompt => 'prompt',
        ConversationMode.stream => 'stream',
      };

  String get displayName => switch (this) {
        ConversationMode.mirror => 'Mirror Mode',
        ConversationMode.council => 'Council Mode',
        ConversationMode.timeline => 'Timeline Mode',
        ConversationMode.roleReversal => 'Role Reversal',
        ConversationMode.socratic => 'Socratic Mode',
        ConversationMode.prompt => 'Prompt Mode',
        ConversationMode.stream => 'Stream Mode',
      };

  String get description => switch (this) {
        ConversationMode.mirror =>
          'Classic two-sided self-talk between you and your observer self',
        ConversationMode.council =>
          'Multiple personas in one conversation thread',
        ConversationMode.timeline =>
          'Past, present, and future self dialogue',
        ConversationMode.roleReversal =>
          'Argue the opposite of what you believe',
        ConversationMode.socratic =>
          'Deep questions to answer, then respond to your own answer',
        ConversationMode.prompt =>
          'Daily thought-provoking prompts to reflect on',
        ConversationMode.stream =>
          'Unfiltered consciousness dump, no structure',
      };

  String get icon => switch (this) {
        ConversationMode.mirror => '\u{1FA9E}',
        ConversationMode.council => '\u{1F465}',
        ConversationMode.timeline => '\u{23F3}',
        ConversationMode.roleReversal => '\u{1F3AD}',
        ConversationMode.socratic => '\u{2753}',
        ConversationMode.prompt => '\u{1F3B2}',
        ConversationMode.stream => '\u{1F300}',
      };

  static ConversationMode fromId(String id) {
    return ConversationMode.values.firstWhere(
      (m) => m.id == id,
      orElse: () => ConversationMode.mirror,
    );
  }
}

/// Conversation domain model
class Conversation extends Equatable {
  final int? id;
  final String uuid;
  final String? title;
  final List<int> personaIds;
  final SpaceType spaceType;
  final ConversationMode mode;
  final bool isVaporMode;
  final DateTime? vaporExpiresAt;
  final bool isArchived;
  final bool isStarred;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Conversation({
    this.id,
    required this.uuid,
    this.title,
    required this.personaIds,
    required this.spaceType,
    required this.mode,
    this.isVaporMode = false,
    this.vaporExpiresAt,
    this.isArchived = false,
    this.isStarred = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new conversation
  factory Conversation.create({
    required String uuid,
    String? title,
    required List<int> personaIds,
    SpaceType spaceType = SpaceType.sanctuary,
    ConversationMode mode = ConversationMode.mirror,
    bool isVaporMode = false,
  }) {
    final now = DateTime.now();
    return Conversation(
      uuid: uuid,
      title: title,
      personaIds: personaIds,
      spaceType: spaceType,
      mode: mode,
      isVaporMode: isVaporMode,
      vaporExpiresAt:
          isVaporMode ? now.add(const Duration(hours: 24)) : null,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Check if vapor mode has expired
  bool get isVaporExpired {
    if (!isVaporMode || vaporExpiresAt == null) return false;
    return DateTime.now().isAfter(vaporExpiresAt!);
  }

  /// Get time until vapor expiration
  Duration? get timeUntilVaporExpires {
    if (!isVaporMode || vaporExpiresAt == null) return null;
    final remaining = vaporExpiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Parse persona IDs from comma-separated string
  static List<int> parsePersonaIds(String personaIdsStr) {
    if (personaIdsStr.isEmpty) return [];
    return personaIdsStr.split(',').map((e) => int.parse(e.trim())).toList();
  }

  /// Convert persona IDs to comma-separated string
  String get personaIdsString => personaIds.join(',');

  /// Create a copy with updated fields
  Conversation copyWith({
    int? id,
    String? uuid,
    String? title,
    List<int>? personaIds,
    SpaceType? spaceType,
    ConversationMode? mode,
    bool? isVaporMode,
    DateTime? vaporExpiresAt,
    bool? isArchived,
    bool? isStarred,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      personaIds: personaIds ?? this.personaIds,
      spaceType: spaceType ?? this.spaceType,
      mode: mode ?? this.mode,
      isVaporMode: isVaporMode ?? this.isVaporMode,
      vaporExpiresAt: vaporExpiresAt ?? this.vaporExpiresAt,
      isArchived: isArchived ?? this.isArchived,
      isStarred: isStarred ?? this.isStarred,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        uuid,
        title,
        personaIds,
        spaceType,
        mode,
        isVaporMode,
        vaporExpiresAt,
        isArchived,
        isStarred,
        createdAt,
        updatedAt,
      ];
}
