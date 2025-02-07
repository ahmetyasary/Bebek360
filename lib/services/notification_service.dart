import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  NotificationService._() {
    _init();
  }

  Future<void> _init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(settings);
    tz.initializeTimeZones();
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'bebek360_channel',
      'Bebek360 Bildirimleri',
      channelDescription: 'Bebek360 uygulaması bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'bebek360_channel',
      'Bebek360 Bildirimleri',
      channelDescription: 'Bebek360 uygulaması bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> scheduleNextFeeding({
    required DateTime lastFeedingTime,
    required Duration interval,
  }) async {
    final nextFeeding = lastFeedingTime.add(interval);
    if (nextFeeding.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: 1,
        title: 'Beslenme Zamanı',
        body: 'Bebeğinizin beslenme zamanı geldi',
        scheduledDate: nextFeeding,
      );
    }
  }

  Future<void> scheduleSleepReminder({
    required DateTime wakeTime,
    required Duration awakeWindow,
  }) async {
    final nextSleep = wakeTime.add(awakeWindow);
    if (nextSleep.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: 2,
        title: 'Uyku Zamanı',
        body: 'Bebeğinizin uyku zamanı yaklaşıyor',
        scheduledDate: nextSleep.subtract(const Duration(minutes: 15)),
      );
    }
  }

  Future<void> scheduleDiaperReminder({
    required DateTime lastChange,
    required Duration interval,
  }) async {
    final nextChange = lastChange.add(interval);
    if (nextChange.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: 3,
        title: 'Bez Kontrolü',
        body: 'Bebeğinizin bezini kontrol etme zamanı geldi',
        scheduledDate: nextChange,
      );
    }
  }
}
