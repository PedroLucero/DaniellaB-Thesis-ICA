import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class TestNoti {
  static Future initialize(
      {bool initScheduled = false,
      required FlutterLocalNotificationsPlugin
          flutterLocalNotificationsPlugin}) async {
    var androidInitialize = AndroidInitializationSettings('mipmap/ic_launcher');
    // This here doesn't work, but... I'm working android so, ...
    // var iOSInitialize = new IOSInitializationSettings();
    // Maybe this? ↓
    // var iOSInitialize = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitialize,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'my_channel_id',
      'Glucose notification',
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
      // showWhen: false,
    );

    var notDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: DarwinNotificationDetails(),
    );
    await fln.show(0, title, body, notDetails, payload: payload);
  }

// This will not work for some reason.
  static Future scheduledNotification(
      {var id = 1,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'my_channel_id',
      'Glucose notification',
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
      // showWhen: false,
    );

    var notDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: DarwinNotificationDetails(),
    );
    var scheduledDate = DateTime.now().add(Duration(seconds: 10));
    var tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
    print(tzScheduledDate);
    await fln.zonedSchedule(
      1,
      title,
      body,
      tzScheduledDate,
      notDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
