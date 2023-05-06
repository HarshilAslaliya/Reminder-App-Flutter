import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_app/modals/reminder.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  NotificationHelper._();

  static final NotificationHelper notificationHelper = NotificationHelper._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  scheduleNotification({required Reminder reminder}) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      icon: 'mipmap/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
      priority: Priority.max,
      importance: Importance.max,
    );
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    tz.initializeTimeZones();

    final startTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, reminder.hour, reminder.minute);

    final currentTime = DateTime.now();

    final day = currentTime.difference(startTime).inDays;
    final hour = currentTime.difference(startTime).inHours;
    final min = currentTime.difference(startTime).inMinutes;
    final sec = currentTime.difference(startTime).inSeconds;

    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      reminder.title,
      reminder.description,
      tz.TZDateTime.now(tz.local)
          .add(Duration(minutes: -min, hours: -hour, seconds: -sec)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: "Your Custom Data",
    );
  }
}
