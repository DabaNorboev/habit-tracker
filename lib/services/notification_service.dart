import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  Future<void> init() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    // Инициализировать базу данных временных зон
    tzdata.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  // Отправить уведомление в конкретное время
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      // Конвертировать DateTime в TZDateTime для zonedSchedule
      final location = tz.getLocation('UTC');
      final tzScheduledTime = tz.TZDateTime(
        location,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
      );

      const androidDetails = AndroidNotificationDetails(
        'habit_channel',
        'Habit Notifications',
        channelDescription: 'Notifications for habit reminders',
        importance: Importance.max,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  // Отправить уведомление об отметке привычки на 20:00
  Future<void> scheduleHabitReminder({
    required String habitName,
    required int habitId,
  }) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 20, 0);

    // Если уже прошло 20:00, запланировать на завтра
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await scheduleNotification(
      id: habitId.hashCode,
      title: 'Напоминание о привычке',
      body: 'Не забудь отметить "$habitName" сегодня! 🎯',
      scheduledTime: scheduledTime,
    );
  }

  // Отменить уведомление
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Отменить все уведомления
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
