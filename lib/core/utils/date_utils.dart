/// Date and time utilities for Innerverse
library;

import 'package:intl/intl.dart';

/// Date formatting and manipulation utilities
class AppDateUtils {
  AppDateUtils._();

  // Common date formats
  static final DateFormat _fullDate = DateFormat('MMMM d, yyyy');
  static final DateFormat _shortDate = DateFormat('MMM d, yyyy');
  static final DateFormat _monthDay = DateFormat('MMM d');
  static final DateFormat _time = DateFormat('h:mm a');
  static final DateFormat _shortTime = DateFormat('h:mm');
  static final DateFormat _dayOfWeek = DateFormat('EEEE');
  static final DateFormat _shortDayOfWeek = DateFormat('EEE');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');
  static final DateFormat _yearOnly = DateFormat('yyyy');
  static final DateFormat _iso = DateFormat('yyyy-MM-dd');
  static final DateFormat _isoWithTime = DateFormat('yyyy-MM-dd HH:mm:ss');

  /// Format date as full date (e.g., "January 15, 2024")
  static String formatFullDate(DateTime date) => _fullDate.format(date);

  /// Format date as short date (e.g., "Jan 15, 2024")
  static String formatShortDate(DateTime date) => _shortDate.format(date);

  /// Format date as month and day (e.g., "Jan 15")
  static String formatMonthDay(DateTime date) => _monthDay.format(date);

  /// Format time (e.g., "3:30 PM")
  static String formatTime(DateTime date) => _time.format(date);

  /// Format short time (e.g., "3:30")
  static String formatShortTime(DateTime date) => _shortTime.format(date);

  /// Format day of week (e.g., "Monday")
  static String formatDayOfWeek(DateTime date) => _dayOfWeek.format(date);

  /// Format short day of week (e.g., "Mon")
  static String formatShortDayOfWeek(DateTime date) => _shortDayOfWeek.format(date);

  /// Format month and year (e.g., "January 2024")
  static String formatMonthYear(DateTime date) => _monthYear.format(date);

  /// Format year only (e.g., "2024")
  static String formatYear(DateTime date) => _yearOnly.format(date);

  /// Format as ISO date (e.g., "2024-01-15")
  static String formatIso(DateTime date) => _iso.format(date);

  /// Format as ISO with time
  static String formatIsoWithTime(DateTime date) => _isoWithTime.format(date);

  /// Get relative time string (e.g., "5 minutes ago", "Yesterday", "3 months ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Get time until date (e.g., "in 5 days", "in 2 weeks")
  static String getTimeUntil(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return getRelativeTime(date);
    }

    if (difference.inSeconds < 60) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'In $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'In $hours ${hours == 1 ? 'hour' : 'hours'}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return 'In ${difference.inDays} days';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'In $weeks ${weeks == 1 ? 'week' : 'weeks'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'In $months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'In $years ${years == 1 ? 'year' : 'years'}';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is this month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Check if date is this year
  static bool isThisYear(DateTime date) {
    return date.year == DateTime.now().year;
  }

  /// Get smart date string (contextual formatting)
  static String getSmartDate(DateTime date) {
    if (isToday(date)) {
      return 'Today at ${formatTime(date)}';
    } else if (isYesterday(date)) {
      return 'Yesterday at ${formatTime(date)}';
    } else if (isThisWeek(date)) {
      return '${formatDayOfWeek(date)} at ${formatTime(date)}';
    } else if (isThisYear(date)) {
      return formatMonthDay(date);
    } else {
      return formatShortDate(date);
    }
  }

  /// Get the start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get the start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    return startOfDay(date.subtract(Duration(days: date.weekday - 1)));
  }

  /// Get the end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    return endOfDay(date.add(Duration(days: 7 - date.weekday)));
  }

  /// Get the start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Get exactly one year ago
  static DateTime oneYearAgo() {
    final now = DateTime.now();
    return DateTime(now.year - 1, now.month, now.day);
  }

  /// Get the same day X years ago
  static DateTime yearsAgo(int years) {
    final now = DateTime.now();
    return DateTime(now.year - years, now.month, now.day);
  }

  /// Get the same day X months ago
  static DateTime monthsAgo(int months) {
    final now = DateTime.now();
    int year = now.year;
    int month = now.month - months;
    while (month <= 0) {
      month += 12;
      year -= 1;
    }
    return DateTime(year, month, now.day);
  }

  /// Get the same day in the future
  static DateTime futureDate({
    int days = 0,
    int weeks = 0,
    int months = 0,
    int years = 0,
  }) {
    DateTime result = DateTime.now();
    result = result.add(Duration(days: days + (weeks * 7)));
    result = DateTime(
      result.year + years,
      result.month + months,
      result.day,
      result.hour,
      result.minute,
    );
    return result;
  }

  /// Check if it's morning (5 AM - 12 PM)
  static bool isMorning([DateTime? date]) {
    final hour = (date ?? DateTime.now()).hour;
    return hour >= 5 && hour < 12;
  }

  /// Check if it's afternoon (12 PM - 5 PM)
  static bool isAfternoon([DateTime? date]) {
    final hour = (date ?? DateTime.now()).hour;
    return hour >= 12 && hour < 17;
  }

  /// Check if it's evening (5 PM - 9 PM)
  static bool isEvening([DateTime? date]) {
    final hour = (date ?? DateTime.now()).hour;
    return hour >= 17 && hour < 21;
  }

  /// Check if it's night (9 PM - 5 AM)
  static bool isNight([DateTime? date]) {
    final hour = (date ?? DateTime.now()).hour;
    return hour >= 21 || hour < 5;
  }

  /// Get time of day greeting
  static String getGreeting([DateTime? date]) {
    if (isMorning(date)) return 'Good morning';
    if (isAfternoon(date)) return 'Good afternoon';
    if (isEvening(date)) return 'Good evening';
    return 'Good night';
  }
}
