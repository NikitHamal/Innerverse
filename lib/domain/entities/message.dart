/// Message domain entity for Innerverse
library;

import 'package:equatable/equatable.dart';

/// Mood tags for messages
enum MoodTag {
  happy,
  sad,
  anxious,
  angry,
  peaceful,
  confused,
  hopeful,
  grateful,
  neutral;

  String get id => name;

  String get displayName => switch (this) {
        MoodTag.happy => 'Happy',
        MoodTag.sad => 'Sad',
        MoodTag.anxious => 'Anxious',
        MoodTag.angry => 'Angry',
        MoodTag.peaceful => 'Peaceful',
        MoodTag.confused => 'Confused',
        MoodTag.hopeful => 'Hopeful',
        MoodTag.grateful => 'Grateful',
        MoodTag.neutral => 'Neutral',
      };

  String get emoji => switch (this) {
        MoodTag.happy => '\u{1F60A}',
        MoodTag.sad => '\u{1F622}',
        MoodTag.anxious => '\u{1F630}',
        MoodTag.angry => '\u{1F621}',
        MoodTag.peaceful => '\u{1F60C}',
        MoodTag.confused => '\u{1F615}',
        MoodTag.hopeful => '\u{1F31F}',
        MoodTag.grateful => '\u{1F64F}',
        MoodTag.neutral => '\u{1F610}',
      };

  static MoodTag? fromId(String? id) {
    if (id == null) return null;
    return MoodTag.values.firstWhere(
      (m) => m.id == id,
      orElse: () => MoodTag.neutral,
    );
  }
}

/// Message domain model
class Message extends Equatable {
  final int? id;
  final String uuid;
  final int conversationId;
  final int personaId;
  final String content;
  final MoodTag? moodTag;
  final bool isEcho;
  final bool isStarred;
  final bool isDeleted;
  final DateTime createdAt;

  const Message({
    this.id,
    required this.uuid,
    required this.conversationId,
    required this.personaId,
    required this.content,
    this.moodTag,
    this.isEcho = false,
    this.isStarred = false,
    this.isDeleted = false,
    required this.createdAt,
  });

  /// Create a new message
  factory Message.create({
    required String uuid,
    required int conversationId,
    required int personaId,
    required String content,
    MoodTag? moodTag,
  }) {
    return Message(
      uuid: uuid,
      conversationId: conversationId,
      personaId: personaId,
      content: content,
      moodTag: moodTag,
      createdAt: DateTime.now(),
    );
  }

  /// Check if message is empty or whitespace only
  bool get isEmpty => content.trim().isEmpty;

  /// Get preview text (first line or truncated)
  String get preview {
    final firstLine = content.split('\n').first;
    if (firstLine.length <= 50) return firstLine;
    return '${firstLine.substring(0, 47)}...';
  }

  /// Get word count
  int get wordCount {
    if (isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }

  /// Get character count (excluding whitespace)
  int get characterCount {
    return content.replaceAll(RegExp(r'\s'), '').length;
  }

  /// Create a copy with updated fields
  Message copyWith({
    int? id,
    String? uuid,
    int? conversationId,
    int? personaId,
    String? content,
    MoodTag? moodTag,
    bool? isEcho,
    bool? isStarred,
    bool? isDeleted,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      conversationId: conversationId ?? this.conversationId,
      personaId: personaId ?? this.personaId,
      content: content ?? this.content,
      moodTag: moodTag ?? this.moodTag,
      isEcho: isEcho ?? this.isEcho,
      isStarred: isStarred ?? this.isStarred,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        uuid,
        conversationId,
        personaId,
        content,
        moodTag,
        isEcho,
        isStarred,
        isDeleted,
        createdAt,
      ];
}

/// Message with associated persona info for display
class MessageWithPersona extends Equatable {
  final Message message;
  final String personaName;
  final String personaEmoji;
  final int personaColor;

  const MessageWithPersona({
    required this.message,
    required this.personaName,
    required this.personaEmoji,
    required this.personaColor,
  });

  @override
  List<Object?> get props => [message, personaName, personaEmoji, personaColor];
}
