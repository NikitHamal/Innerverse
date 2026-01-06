/// String extensions for Innerverse
library;

/// Extensions on String for common operations
extension StringExtensions on String {
  /// Capitalize the first letter
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalized).join(' ');
  }

  /// Convert to snake_case
  String get snakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst('_', '');
  }

  /// Convert to camelCase
  String get camelCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[_\s-]'));
    return words.first.toLowerCase() +
        words.skip(1).map((w) => w.capitalized).join();
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// Check if string contains only numbers
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Check if string is a valid PIN (4-6 digits)
  bool get isValidPin {
    return RegExp(r'^[0-9]{4,6}$').hasMatch(this);
  }

  /// Remove all whitespace
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Normalize whitespace (multiple spaces to single)
  String get normalizeWhitespace {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Get initials from name
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].substring(0, words[0].length.clamp(0, 2)).toUpperCase();
    }
    return words
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();
  }

  /// Count words in string
  int get wordCount {
    if (trim().isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }

  /// Get reading time estimate in minutes
  int get readingTimeMinutes {
    const wordsPerMinute = 200;
    return (wordCount / wordsPerMinute).ceil().clamp(1, 999);
  }

  /// Check if string is null or empty or whitespace
  bool get isBlank {
    return trim().isEmpty;
  }

  /// Check if string has content
  bool get isNotBlank {
    return !isBlank;
  }

  /// Convert string to nullable (null if empty)
  String? get nullIfEmpty {
    return isEmpty ? null : this;
  }

  /// Safe substring that won't throw
  String safeSubstring(int start, [int? end]) {
    if (start >= length) return '';
    return substring(start, end != null ? end.clamp(0, length) : null);
  }

  /// Reverse the string
  String get reversed {
    return split('').reversed.join();
  }

  /// Remove HTML tags
  String get stripHtml {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Escape HTML entities
  String get escapeHtml {
    return replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#039;');
  }
}

/// Extensions on nullable String
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Return this string or default if null/empty
  String orDefault(String defaultValue) {
    return isNullOrEmpty ? defaultValue : this!;
  }

  /// Return null if empty, otherwise return trimmed value
  String? get trimmedOrNull {
    if (isNullOrEmpty) return null;
    final trimmed = this!.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
