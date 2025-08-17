import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static final Map<String, Timer> _timers = {};

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@drawable/notification_icon',
    );
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> showTaskAddedNotification(String taskTitle) async {
    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'Notifications for task operations',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/notification_icon',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      1,
      'Task Added',
      'New task "$taskTitle" has been added',
      details,
    );
  }

  static Future<void> showTaskDeletedNotification(String taskTitle) async {
    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'Notifications for task operations',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/notification_icon',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      2,
      'Task Deleted',
      'Task "$taskTitle" has been deleted',
      details,
    );
  }

  static Future<void> scheduleTaskReminder(
    String taskId,
    String taskTitle,
    DateTime reminderTime,
  ) async {
    final duration = reminderTime.difference(DateTime.now());
    if (duration.isNegative) return;

    _timers[taskId] = Timer(duration, () async {
      const androidDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Task Reminders',
        channelDescription: 'Scheduled reminders for tasks',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@drawable/notification_icon',
      );
      const iosDetails = DarwinNotificationDetails();
      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        taskId.hashCode,
        'Task Reminder',
        'Reminder: $taskTitle',
        details,
      );
      _timers.remove(taskId);
    });
  }

  static Future<void> cancelTaskReminder(String taskId) async {
    _timers[taskId]?.cancel();
    _timers.remove(taskId);
    await _notifications.cancel(taskId.hashCode);
  }
}
