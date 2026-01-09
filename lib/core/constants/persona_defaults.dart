/// Default persona configurations for Innerverse
library;

import 'package:flutter/material.dart';

/// Default persona configuration data
class PersonaDefault {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final Color color;
  final String notes;
  final List<String> conversationStarters;

  const PersonaDefault({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.color,
    required this.notes,
    required this.conversationStarters,
  });

  String get typeId => id;
  String get displayName => name;
  String get defaultEmoji => emoji;
  int get defaultColor => color.value;
}

/// All default personas available in Innerverse
const List<PersonaDefault> defaultPersonas = [
  PersonaDefault(
    id: 'inner_child',
    name: 'Inner Child',
    description: 'Reconnect with innocence, process childhood experiences',
    emoji: '\u{1F9D2}',
    color: Color(0xFFFFC1E3),
    notes: 'The part of you that remembers what it felt like to see the world with wonder. '
        'Speaks with curiosity, playfulness, and sometimes vulnerability.',
    conversationStarters: [
      'What made you happiest as a child?',
      'Is there a toy or game you miss?',
      'What did you want to be when you grew up?',
      'Who was your childhood best friend?',
    ],
  ),
  PersonaDefault(
    id: 'shadow_self',
    name: 'Shadow Self',
    description: 'Explore fears, hidden desires, unspoken thoughts',
    emoji: '\u{1F464}',
    color: Color(0xFF4A4A6A),
    notes: 'The parts of yourself you hide from others and sometimes from yourself. '
        'Honest, raw, and unfiltered. A space for what cannot be said elsewhere.',
    conversationStarters: [
      'What emotion do you avoid the most?',
      'What do you secretly desire but won\'t admit?',
      'What fears have you never shared?',
      'What about yourself disappoints you?',
    ],
  ),
  PersonaDefault(
    id: 'ideal_self',
    name: 'Ideal Self',
    description: 'The version of you that you\'re working toward',
    emoji: '\u{2728}',
    color: Color(0xFFFFD700),
    notes: 'Your highest potential realized. Speaks with confidence, wisdom, and compassion. '
        'Reminds you of who you\'re becoming.',
    conversationStarters: [
      'What would your ideal day look like?',
      'What habits would your ideal self have?',
      'How does your ideal self handle stress?',
      'What would your ideal self say to you right now?',
    ],
  ),
  PersonaDefault(
    id: 'critic',
    name: 'The Critic',
    description: 'Your inner judge — give it a voice, then challenge it',
    emoji: '\u{2696}\u{FE0F}',
    color: Color(0xFF8B0000),
    notes: 'The voice that judges, questions, and holds you to standards. '
        'By giving it a voice, you can examine its validity and respond.',
    conversationStarters: [
      'What did you do wrong today?',
      'What could you have done better?',
      'Why do you feel inadequate?',
      'What are you not good enough at?',
    ],
  ),
  PersonaDefault(
    id: 'dreamer',
    name: 'The Dreamer',
    description: 'Wild ideas, fantasies, "what ifs" without judgment',
    emoji: '\u{1F3A8}',
    color: Color(0xFF9B59B6),
    notes: 'The part of you that imagines possibilities without limits. '
        'Creative, hopeful, and unbounded by reality\'s constraints.',
    conversationStarters: [
      'If you could do anything, what would you do?',
      'What\'s a wild idea you\'ve had recently?',
      'What would you attempt if you knew you couldn\'t fail?',
      'What does your wildest fantasy look like?',
    ],
  ),
  PersonaDefault(
    id: 'protector',
    name: 'The Protector',
    description: 'The voice that defends you from harsh self-talk',
    emoji: '\u{1F6E1}\u{FE0F}',
    color: Color(0xFF2E86AB),
    notes: 'Your inner guardian and advocate. Speaks with warmth and fierce love. '
        'Counters criticism with compassion and truth.',
    conversationStarters: [
      'What do you need protection from right now?',
      'How can you be kinder to yourself?',
      'What boundary do you need to set?',
      'What would you tell a friend in your situation?',
    ],
  ),
  PersonaDefault(
    id: 'past_self',
    name: 'Past Self',
    description: 'Write as who you were 1 year ago, 5 years ago',
    emoji: '\u{1F4C5}',
    color: Color(0xFF7B68EE),
    notes: 'A perspective from a younger version of yourself. '
        'Useful for processing growth, giving advice to who you were, or understanding patterns.',
    conversationStarters: [
      'What would you tell your past self?',
      'What have you learned since then?',
      'What would your past self think of you now?',
      'What advice would your past self give you?',
    ],
  ),
  PersonaDefault(
    id: 'future_self',
    name: 'Future Self',
    description: 'Write from your imagined future (1 year, 10 years ahead)',
    emoji: '\u{1F52E}',
    color: Color(0xFF00CED1),
    notes: 'The you that exists in a future you\'re creating. '
        'Speaks with hindsight, encouragement, and long-term perspective.',
    conversationStarters: [
      'What will you be grateful for in the future?',
      'What do you hope your future self has accomplished?',
      'What message does your future self have for you?',
      'What small step can you take toward your future?',
    ],
  ),
  PersonaDefault(
    id: 'observer_self',
    name: 'Observer Self',
    description: 'The neutral witness who sees without judgment',
    emoji: '\u{1FA9E}',
    color: Color(0xFF708090),
    notes: 'Pure awareness and presence. Observes without reaction, '
        'describes without evaluating. The calm center in any storm.',
    conversationStarters: [
      'What thoughts are passing through your mind?',
      'What sensations do you notice in your body?',
      'What emotions are present without judgment?',
      'What would you observe if you were a neutral witness?',
    ],
  ),
];

/// Get persona default by ID
PersonaDefault? getPersonaDefaultById(String id) {
  try {
    return defaultPersonas.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}

/// Get persona emoji by type ID
String getPersonaEmoji(String typeId) {
  final persona = getPersonaDefaultById(typeId);
  return persona?.emoji ?? '\u{1F464}';
}

/// Get persona color by type ID
Color getPersonaColor(String typeId) {
  final persona = getPersonaDefaultById(typeId);
  return persona?.color ?? const Color(0xFF6366F1);
}

/// Get persona default name by type ID
String getPersonaDefaultName(String typeId) {
  final persona = getPersonaDefaultById(typeId);
  return persona?.name ?? 'Custom Self';
}

/// Get persona default notes by type ID
String getPersonaDefaultNotes(String typeId) {
  final persona = getPersonaDefaultById(typeId);
  return persona?.notes ?? 'A unique aspect of your inner world.';
}
