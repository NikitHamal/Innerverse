/// Ritual domain entity for Innerverse
library;

import 'package:equatable/equatable.dart';

/// Types of rituals available
enum RitualType {
  morningIntention,
  eveningReflection,
  weeklyCouncil,
  birthdayLetter,
  burningCeremony,
  custom;

  String get id => switch (this) {
        RitualType.morningIntention => 'morning_intention',
        RitualType.eveningReflection => 'evening_reflection',
        RitualType.weeklyCouncil => 'weekly_council',
        RitualType.birthdayLetter => 'birthday_letter',
        RitualType.burningCeremony => 'burning_ceremony',
        RitualType.custom => 'custom',
      };

  String get displayName => switch (this) {
        RitualType.morningIntention => 'Morning Intention',
        RitualType.eveningReflection => 'Evening Reflection',
        RitualType.weeklyCouncil => 'Weekly Council',
        RitualType.birthdayLetter => 'Birthday Letter',
        RitualType.burningCeremony => 'Burning Ceremony',
        RitualType.custom => 'Custom Ritual',
      };

  String get description => switch (this) {
        RitualType.morningIntention =>
          'Set your intention for the day, talk to your Future Self',
        RitualType.eveningReflection =>
          'Wind down, reflect on what you learned, release what no longer serves',
        RitualType.weeklyCouncil =>
          'Sunday ritual where all personas meet to review the week',
        RitualType.birthdayLetter =>
          'Annual letter from your Past Self, write next year\'s letter',
        RitualType.burningCeremony =>
          'Monthly review of Storm Room entries, choose to keep or release',
        RitualType.custom => 'A personal ritual you\'ve created',
      };

  String get emoji => switch (this) {
        RitualType.morningIntention => '\u{1F305}',
        RitualType.eveningReflection => '\u{1F319}',
        RitualType.weeklyCouncil => '\u{1F4C6}',
        RitualType.birthdayLetter => '\u{1F382}',
        RitualType.burningCeremony => '\u{1F525}',
        RitualType.custom => '\u{2728}',
      };

  /// Suggested duration in minutes
  int get suggestedDuration => switch (this) {
        RitualType.morningIntention => 5,
        RitualType.eveningReflection => 3,
        RitualType.weeklyCouncil => 15,
        RitualType.birthdayLetter => 20,
        RitualType.burningCeremony => 10,
        RitualType.custom => 5,
      };

  /// Whether this is a daily ritual
  bool get isDaily => switch (this) {
        RitualType.morningIntention => true,
        RitualType.eveningReflection => true,
        RitualType.weeklyCouncil => false,
        RitualType.birthdayLetter => false,
        RitualType.burningCeremony => false,
        RitualType.custom => false,
      };

  static RitualType fromId(String id) {
    return RitualType.values.firstWhere(
      (t) => t.id == id,
      orElse: () => RitualType.custom,
    );
  }
}

/// Ritual completion domain model
class Ritual extends Equatable {
  final int? id;
  final String uuid;
  final RitualType type;
  final String? customName;
  final DateTime completedAt;
  final String? notes;
  final int? durationSeconds;
  final int? moodRating;

  const Ritual({
    this.id,
    required this.uuid,
    required this.type,
    this.customName,
    required this.completedAt,
    this.notes,
    this.durationSeconds,
    this.moodRating,
  });

  /// Create a new ritual completion
  factory Ritual.create({
    required String uuid,
    required RitualType type,
    String? customName,
    String? notes,
    int? durationSeconds,
    int? moodRating,
  }) {
    return Ritual(
      uuid: uuid,
      type: type,
      customName: customName,
      completedAt: DateTime.now(),
      notes: notes,
      durationSeconds: durationSeconds,
      moodRating: moodRating,
    );
  }

  /// Get display name
  String get displayName {
    if (type == RitualType.custom && customName != null) {
      return customName!;
    }
    return type.displayName;
  }

  /// Get emoji
  String get emoji => type.emoji;

  /// Get duration as a formatted string
  String get durationText {
    if (durationSeconds == null) return '';
    final minutes = durationSeconds! ~/ 60;
    final seconds = durationSeconds! % 60;
    if (minutes > 0) {
      return '$minutes min ${seconds > 0 ? '$seconds sec' : ''}';
    }
    return '$seconds sec';
  }

  /// Get mood rating as emoji
  String? get moodEmoji {
    if (moodRating == null) return null;
    return switch (moodRating) {
      1 => '\u{1F61E}',
      2 => '\u{1F615}',
      3 => '\u{1F610}',
      4 => '\u{1F60A}',
      5 => '\u{1F604}',
      _ => '\u{1F610}',
    };
  }

  /// Create a copy with updated fields
  Ritual copyWith({
    int? id,
    String? uuid,
    RitualType? type,
    String? customName,
    DateTime? completedAt,
    String? notes,
    int? durationSeconds,
    int? moodRating,
  }) {
    return Ritual(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      customName: customName ?? this.customName,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      moodRating: moodRating ?? this.moodRating,
    );
  }

  @override
  List<Object?> get props => [
        id,
        uuid,
        type,
        customName,
        completedAt,
        notes,
        durationSeconds,
        moodRating,
      ];
}

/// Ritual status for today
class TodayRitualStatus extends Equatable {
  final RitualType type;
  final bool isCompleted;
  final Ritual? lastCompletion;

  const TodayRitualStatus({
    required this.type,
    required this.isCompleted,
    this.lastCompletion,
  });

  @override
  List<Object?> get props => [type, isCompleted, lastCompletion];
}
