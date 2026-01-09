/// Time Capsule domain entity for Innerverse
library;

import 'package:equatable/equatable.dart';

/// Preset occasions for time capsules
enum CapsuleOccasion {
  none,
  birthday,
  newYear,
  anniversary,
  graduation,
  milestone,
  reminder,
  letter,
  custom;

  String get id => name;

  String get displayName => switch (this) {
        CapsuleOccasion.none => 'None',
        CapsuleOccasion.birthday => 'Birthday',
        CapsuleOccasion.newYear => 'New Year',
        CapsuleOccasion.anniversary => 'Anniversary',
        CapsuleOccasion.graduation => 'Graduation',
        CapsuleOccasion.milestone => 'Milestone',
        CapsuleOccasion.reminder => 'Reminder',
        CapsuleOccasion.letter => 'Future Letter',
        CapsuleOccasion.custom => 'Custom',
      };

  String get emoji => switch (this) {
        CapsuleOccasion.none => '\u{1F4C5}',
        CapsuleOccasion.birthday => '\u{1F382}',
        CapsuleOccasion.newYear => '\u{1F386}',
        CapsuleOccasion.anniversary => '\u{1F495}',
        CapsuleOccasion.graduation => '\u{1F393}',
        CapsuleOccasion.milestone => '\u{1F3C6}',
        CapsuleOccasion.reminder => '\u{23F0}',
        CapsuleOccasion.letter => '\u{1F48C}',
        CapsuleOccasion.custom => '\u{1F4E6}',
      };

  static CapsuleOccasion? fromId(String? id) {
    if (id == null) return null;
    return CapsuleOccasion.values.firstWhere(
      (o) => o.id == id,
      orElse: () => CapsuleOccasion.custom,
    );
  }
}

/// Time Capsule domain model
class TimeCapsule extends Equatable {
  final int? id;
  final String uuid;
  final String? title;
  final int? personaId;
  final String content;
  final CapsuleOccasion? occasion;
  final DateTime createdAt;
  final DateTime unlockAt;
  final bool isUnlocked;
  final bool isRead;
  final bool isArchived;

  const TimeCapsule({
    this.id,
    required this.uuid,
    this.title,
    this.personaId,
    required this.content,
    this.occasion,
    required this.createdAt,
    required this.unlockAt,
    this.isUnlocked = false,
    this.isRead = false,
    this.isArchived = false,
  });

  /// Create a new time capsule
  factory TimeCapsule.create({
    required String uuid,
    String? title,
    int? personaId,
    required String content,
    CapsuleOccasion? occasion,
    required DateTime unlockAt,
  }) {
    return TimeCapsule(
      uuid: uuid,
      title: title,
      personaId: personaId,
      content: content,
      occasion: occasion,
      createdAt: DateTime.now(),
      unlockAt: unlockAt,
    );
  }

  /// Check if capsule is ready to unlock
  bool get isReadyToUnlock {
    if (isUnlocked) return false;
    return DateTime.now().isAfter(unlockAt);
  }

  /// Get time remaining until unlock
  Duration get timeUntilUnlock {
    if (isUnlocked) return Duration.zero;
    final remaining = unlockAt.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Get days until unlock
  int get daysUntilUnlock {
    return timeUntilUnlock.inDays;
  }

  /// Get human-readable time until unlock
  String get timeUntilUnlockText {
    final duration = timeUntilUnlock;
    if (duration == Duration.zero) return 'Ready to open';

    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    if (days > 365) {
      final years = (days / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'}';
    } else if (days > 30) {
      final months = (days / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else if (days > 0) {
      return '$days ${days == 1 ? 'day' : 'days'}';
    } else if (hours > 0) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'}';
    } else {
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    }
  }

  /// Get display title (or fallback)
  String get displayTitle {
    if (title != null && title!.isNotEmpty) return title!;
    if (occasion != null) return '${occasion!.emoji} ${occasion!.displayName}';
    return '\u{1F48C} Time Capsule';
  }

  /// Get preview of content
  String get preview {
    final firstLine = content.split('\n').first;
    if (firstLine.length <= 100) return firstLine;
    return '${firstLine.substring(0, 97)}...';
  }

  /// Create a copy with updated fields
  TimeCapsule copyWith({
    int? id,
    String? uuid,
    String? title,
    int? personaId,
    String? content,
    CapsuleOccasion? occasion,
    DateTime? createdAt,
    DateTime? unlockAt,
    bool? isUnlocked,
    bool? isRead,
    bool? isArchived,
  }) {
    return TimeCapsule(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      personaId: personaId ?? this.personaId,
      content: content ?? this.content,
      occasion: occasion ?? this.occasion,
      createdAt: createdAt ?? this.createdAt,
      unlockAt: unlockAt ?? this.unlockAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isRead: isRead ?? this.isRead,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [
        id,
        uuid,
        title,
        personaId,
        content,
        occasion,
        createdAt,
        unlockAt,
        isUnlocked,
        isRead,
        isArchived,
      ];
}
