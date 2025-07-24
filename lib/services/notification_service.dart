import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _notifications.initialize(settings);
    
    // Request notification permission for Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showTaskAddedNotification(String taskTitle) async {
    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'Notifications for task operations',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

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
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(
      2,
      'Task Deleted',
      'Task "$taskTitle" has been deleted',
      details,
    );
  }
}