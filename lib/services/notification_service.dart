/// Notification service for rituals and time capsules in Innerverse
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../core/errors/error_handler.dart';
import '../core/utils/platform_utils.dart';

/// Notification channels
class NotificationChannels {
  static const String rituals = 'rituals';
  static const String timeCapsules = 'time_capsules';
  static const String echoes = 'echoes';
  static const String reminders = 'reminders';
}

/// Notification IDs
class NotificationIds {
  static const int morningRitual = 1000;
  static const int eveningRitual = 1001;
  static const int weeklyCouncil = 1002;
  static const int timeCapsuleBase = 2000;
  static const int echoBase = 3000;
  static const int reminderBase = 4000;
}

/// Notification service for local notifications
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Whether the service is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;
    if (!PlatformUtils.isMobile) {
      _isInitialized = true;
      return;
    }

    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Android settings
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channels for Android
      await _createChannels();

      _isInitialized = true;
    } catch (e, stack) {
      ErrorHandler.instance.logError(
        message: 'Failed to initialize notifications: $e',
        stackTrace: stack.toString(),
        type: ErrorType.custom,
      );
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (!PlatformUtils.isMobile) return false;

    try {
      if (PlatformUtils.isIOS) {
        final result = await _notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        return result ?? false;
      }

      if (PlatformUtils.isAndroid) {
        final result = await _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
        return result ?? false;
      }

      return false;
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
      return false;
    }
  }

  /// Create Android notification channels
  Future<void> _createChannels() async {
    if (!PlatformUtils.isAndroid) return;

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    // Rituals channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.rituals,
        'Rituals',
        description: 'Notifications for daily rituals',
        importance: Importance.high,
      ),
    );

    // Time capsules channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.timeCapsules,
        'Time Capsules',
        description: 'Notifications for unlocked time capsules',
        importance: Importance.high,
      ),
    );

    // Echoes channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.echoes,
        'Memory Echoes',
        description: 'Notifications for past memories',
        importance: Importance.defaultImportance,
      ),
    );

    // Reminders channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.reminders,
        'Reminders',
        description: 'General reminders',
        importance: Importance.defaultImportance,
      ),
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification navigation based on payload
    final payload = response.payload;
    if (payload == null) return;

    debugPrint('Notification tapped: $payload');
    // Navigation will be handled by the app
  }

  // ============================================================================
  // Ritual Notifications
  // ============================================================================

  /// Schedule morning ritual notification
  Future<void> scheduleMorningRitual(TimeOfDay time) async {
    await _scheduleDailyNotification(
      id: NotificationIds.morningRitual,
      title: 'Good morning, Explorer',
      body: 'Set your intention for today. What do you want to bring into this day?',
      time: time,
      channel: NotificationChannels.rituals,
      payload: 'ritual:morning',
    );
  }

  /// Schedule evening ritual notification
  Future<void> scheduleEveningRitual(TimeOfDay time) async {
    await _scheduleDailyNotification(
      id: NotificationIds.eveningRitual,
      title: 'Evening reflection',
      body: 'Take a moment to reflect. What did you learn today? What can you release?',
      time: time,
      channel: NotificationChannels.rituals,
      payload: 'ritual:evening',
    );
  }

  /// Schedule weekly council notification
  Future<void> scheduleWeeklyCouncil(TimeOfDay time) async {
    if (!PlatformUtils.isMobile || !_isInitialized) return;

    try {
      await _notifications.zonedSchedule(
        NotificationIds.weeklyCouncil,
        'Weekly Council',
        'Your inner selves gather for the weekly review. Join them?',
        _nextWeekday(DateTime.sunday, time),
        _getNotificationDetails(NotificationChannels.rituals),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'ritual:weekly_council',
      );
    } catch (e) {
      debugPrint('Error scheduling weekly council: $e');
    }
  }

  /// Cancel ritual notifications
  Future<void> cancelRitualNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all ritual notifications
  Future<void> cancelAllRitualNotifications() async {
    await _notifications.cancel(NotificationIds.morningRitual);
    await _notifications.cancel(NotificationIds.eveningRitual);
    await _notifications.cancel(NotificationIds.weeklyCouncil);
  }

  // ============================================================================
  // Time Capsule Notifications
  // ============================================================================

  /// Schedule time capsule unlock notification
  Future<void> scheduleTimeCapsuleUnlock({
    required int capsuleId,
    required DateTime unlockDate,
    String? title,
  }) async {
    if (!PlatformUtils.isMobile || !_isInitialized) return;
    if (unlockDate.isBefore(DateTime.now())) return;

    try {
      await _notifications.zonedSchedule(
        NotificationIds.timeCapsuleBase + capsuleId,
        title ?? 'Time capsule unlocked',
        'A message from your past is ready to be read.',
        tz.TZDateTime.from(unlockDate, tz.local),
        _getNotificationDetails(NotificationChannels.timeCapsules),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'capsule:$capsuleId',
      );
    } catch (e) {
      debugPrint('Error scheduling time capsule notification: $e');
    }
  }

  /// Cancel time capsule notification
  Future<void> cancelTimeCapsuleNotification(int capsuleId) async {
    await _notifications.cancel(NotificationIds.timeCapsuleBase + capsuleId);
  }

  // ============================================================================
  // Echo Notifications
  // ============================================================================

  /// Show echo notification
  Future<void> showEchoNotification({
    required int echoId,
    required String preview,
    required DateTime originalDate,
  }) async {
    if (!PlatformUtils.isMobile || !_isInitialized) return;

    try {
      final timeAgo = _formatTimeAgo(originalDate);
      await _notifications.show(
        NotificationIds.echoBase + echoId,
        'Remember when you wrote this?',
        '$timeAgo: "$preview"',
        _getNotificationDetails(NotificationChannels.echoes),
        payload: 'echo:$echoId',
      );
    } catch (e) {
      debugPrint('Error showing echo notification: $e');
    }
  }

  // ============================================================================
  // Reminder Notifications
  // ============================================================================

  /// Show persona reminder
  Future<void> showPersonaReminder({
    required int personaId,
    required String personaName,
    required int daysSinceLastActive,
  }) async {
    if (!PlatformUtils.isMobile || !_isInitialized) return;

    try {
      await _notifications.show(
        NotificationIds.reminderBase + personaId,
        'Missing your $personaName',
        "You haven't talked to your $personaName in $daysSinceLastActive days.",
        _getNotificationDetails(NotificationChannels.reminders),
        payload: 'persona:$personaId',
      );
    } catch (e) {
      debugPrint('Error showing persona reminder: $e');
    }
  }

  // ============================================================================
  // Private Helpers
  // ============================================================================

  /// Schedule a daily notification
  Future<void> _scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required String channel,
    String? payload,
  }) async {
    if (!PlatformUtils.isMobile || !_isInitialized) return;

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfTime(time),
        _getNotificationDetails(channel),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error scheduling daily notification: $e');
    }
  }

  /// Get notification details for a channel
  NotificationDetails _getNotificationDetails(String channel) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel,
        _getChannelName(channel),
        channelDescription: _getChannelDescription(channel),
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  String _getChannelName(String channel) {
    return switch (channel) {
      NotificationChannels.rituals => 'Rituals',
      NotificationChannels.timeCapsules => 'Time Capsules',
      NotificationChannels.echoes => 'Memory Echoes',
      NotificationChannels.reminders => 'Reminders',
      _ => 'General',
    };
  }

  String _getChannelDescription(String channel) {
    return switch (channel) {
      NotificationChannels.rituals => 'Notifications for daily rituals',
      NotificationChannels.timeCapsules =>
        'Notifications for unlocked time capsules',
      NotificationChannels.echoes => 'Notifications for past memories',
      NotificationChannels.reminders => 'General reminders',
      _ => 'General notifications',
    };
  }

  /// Get next instance of a time
  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Get next specific weekday
  tz.TZDateTime _nextWeekday(int weekday, TimeOfDay time) {
    var scheduledDate = _nextInstanceOfTime(time);

    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Format time ago
  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return 'Today';
    }
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
