/// Echo domain entity for Innerverse (Memory Echoes feature)
library;

import 'package:equatable/equatable.dart';

/// Reaction types for echoes
enum EchoReaction {
  grateful,
  surprised,
  proud,
  thoughtful,
  sad,
  motivated;

  String get id => name;

  String get emoji => switch (this) {
        EchoReaction.grateful => '\u{1F64F}',
        EchoReaction.surprised => '\u{1F62E}',
        EchoReaction.proud => '\u{1F60C}',
        EchoReaction.thoughtful => '\u{1F914}',
        EchoReaction.sad => '\u{1F622}',
        EchoReaction.motivated => '\u{1F4AA}',
      };

  String get displayName => switch (this) {
        EchoReaction.grateful => 'Grateful',
        EchoReaction.surprised => 'Surprised',
        EchoReaction.proud => 'Proud',
        EchoReaction.thoughtful => 'Thoughtful',
        EchoReaction.sad => 'Sad',
        EchoReaction.motivated => 'Motivated',
      };

  static EchoReaction? fromId(String? id) {
    if (id == null) return null;
    return EchoReaction.values.firstWhere(
      (r) => r.id == id,
      orElse: () => EchoReaction.thoughtful,
    );
  }
}

/// Echo domain model (surfaced past messages)
class Echo extends Equatable {
  final int? id;
  final int messageId;
  final DateTime surfacedAt;
  final bool wasViewed;
  final bool wasDismissed;
  final EchoReaction? reaction;

  const Echo({
    this.id,
    required this.messageId,
    required this.surfacedAt,
    this.wasViewed = false,
    this.wasDismissed = false,
    this.reaction,
  });

  /// Create a new echo
  factory Echo.create({
    required int messageId,
  }) {
    return Echo(
      messageId: messageId,
      surfacedAt: DateTime.now(),
    );
  }

  /// Get time since surfaced
  Duration get timeSinceSurfaced {
    return DateTime.now().difference(surfacedAt);
  }

  /// Get human-readable time since surfaced
  String get timeSinceSurfacedText {
    final duration = timeSinceSurfaced;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 24) {
      final days = duration.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (hours > 0) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (minutes > 0) {
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if echo is still active (not dismissed)
  bool get isActive => !wasDismissed;

  /// Create a copy with updated fields
  Echo copyWith({
    int? id,
    int? messageId,
    DateTime? surfacedAt,
    bool? wasViewed,
    bool? wasDismissed,
    EchoReaction? reaction,
  }) {
    return Echo(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      surfacedAt: surfacedAt ?? this.surfacedAt,
      wasViewed: wasViewed ?? this.wasViewed,
      wasDismissed: wasDismissed ?? this.wasDismissed,
      reaction: reaction ?? this.reaction,
    );
  }

  @override
  List<Object?> get props => [
        id,
        messageId,
        surfacedAt,
        wasViewed,
        wasDismissed,
        reaction,
      ];
}

/// Echo with associated message content for display
class EchoWithMessage extends Equatable {
  final Echo echo;
  final String messageContent;
  final DateTime messageCreatedAt;
  final String personaName;
  final String personaEmoji;
  final int personaColor;
  final String spaceName;

  const EchoWithMessage({
    required this.echo,
    required this.messageContent,
    required this.messageCreatedAt,
    required this.personaName,
    required this.personaEmoji,
    required this.personaColor,
    required this.spaceName,
  });

  /// Get time ago text for the original message
  String get messageTimeAgoText {
    final duration = DateTime.now().difference(messageCreatedAt);
    final days = duration.inDays;

    if (days > 365) {
      final years = (days / 365).floor();
      final months = ((days % 365) / 30).floor();
      if (months > 0) {
        return '$years ${years == 1 ? 'year' : 'years'} and $months ${months == 1 ? 'month' : 'months'} ago';
      }
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (days > 30) {
      final months = (days / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (days > 7) {
      final weeks = (days / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (days > 0) {
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return 'Today';
    }
  }

  /// Get display header text
  String get headerText => 'Remember when you wrote this $messageTimeAgoText?';

  @override
  List<Object?> get props => [
        echo,
        messageContent,
        messageCreatedAt,
        personaName,
        personaEmoji,
        personaColor,
        spaceName,
      ];
}
