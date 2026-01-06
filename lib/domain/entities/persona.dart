/// Persona domain entity for Innerverse
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/constants/persona_defaults.dart';

/// Types of personas available
enum PersonaType {
  innerChild,
  shadowSelf,
  idealSelf,
  critic,
  dreamer,
  protector,
  pastSelf,
  futureSelf,
  observerSelf,
  custom;

  String get id => switch (this) {
        PersonaType.innerChild => 'inner_child',
        PersonaType.shadowSelf => 'shadow_self',
        PersonaType.idealSelf => 'ideal_self',
        PersonaType.critic => 'critic',
        PersonaType.dreamer => 'dreamer',
        PersonaType.protector => 'protector',
        PersonaType.pastSelf => 'past_self',
        PersonaType.futureSelf => 'future_self',
        PersonaType.observerSelf => 'observer_self',
        PersonaType.custom => 'custom',
      };

  String get displayName => switch (this) {
        PersonaType.innerChild => 'Inner Child',
        PersonaType.shadowSelf => 'Shadow Self',
        PersonaType.idealSelf => 'Ideal Self',
        PersonaType.critic => 'The Critic',
        PersonaType.dreamer => 'The Dreamer',
        PersonaType.protector => 'The Protector',
        PersonaType.pastSelf => 'Past Self',
        PersonaType.futureSelf => 'Future Self',
        PersonaType.observerSelf => 'Observer Self',
        PersonaType.custom => 'Custom',
      };

  String get emoji => getPersonaEmoji(id);

  Color get defaultColor => getPersonaColor(id);

  String get description => switch (this) {
        PersonaType.innerChild =>
          'Reconnect with innocence, process childhood experiences',
        PersonaType.shadowSelf =>
          'Explore fears, hidden desires, unspoken thoughts',
        PersonaType.idealSelf => 'The version of you that you\'re working toward',
        PersonaType.critic =>
          'Your inner judge \u2014 give it a voice, then challenge it',
        PersonaType.dreamer =>
          'Wild ideas, fantasies, "what ifs" without judgment',
        PersonaType.protector =>
          'The voice that defends you from harsh self-talk',
        PersonaType.pastSelf => 'Write as who you were 1 year ago, 5 years ago',
        PersonaType.futureSelf =>
          'Write from your imagined future (1 year, 10 years ahead)',
        PersonaType.observerSelf =>
          'The neutral witness who sees without judgment',
        PersonaType.custom => 'A unique aspect of your inner world',
      };

  static PersonaType fromId(String id) {
    return PersonaType.values.firstWhere(
      (t) => t.id == id,
      orElse: () => PersonaType.custom,
    );
  }
}

/// Persona domain model
class Persona extends Equatable {
  final int? id;
  final String uuid;
  final String name;
  final PersonaType type;
  final Color color;
  final String? avatarAsset;
  final String? notes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  const Persona({
    this.id,
    required this.uuid,
    required this.name,
    required this.type,
    required this.color,
    this.avatarAsset,
    this.notes,
    this.isArchived = false,
    required this.createdAt,
    required this.lastActiveAt,
  });

  /// Create a new persona with defaults from type
  factory Persona.create({
    required String uuid,
    required PersonaType type,
    String? customName,
    Color? customColor,
    String? notes,
  }) {
    final now = DateTime.now();
    return Persona(
      uuid: uuid,
      name: customName ?? type.displayName,
      type: type,
      color: customColor ?? type.defaultColor,
      notes: notes ?? getPersonaDefaultNotes(type.id),
      createdAt: now,
      lastActiveAt: now,
    );
  }

  /// Get the emoji for this persona
  String get emoji => type.emoji;

  /// Check if this is a custom persona
  bool get isCustom => type == PersonaType.custom;

  /// Create a copy with updated fields
  Persona copyWith({
    int? id,
    String? uuid,
    String? name,
    PersonaType? type,
    Color? color,
    String? avatarAsset,
    String? notes,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return Persona(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      type: type ?? this.type,
      color: color ?? this.color,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      notes: notes ?? this.notes,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        uuid,
        name,
        type,
        color.value,
        avatarAsset,
        notes,
        isArchived,
        createdAt,
        lastActiveAt,
      ];
}
