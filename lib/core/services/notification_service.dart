import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    // Default to Asia/Jakarta, will be updated based on system or location if needed
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // For iOS if needed
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );

    _isInitialized = true;
  }

  Future<bool> requestPermissions() async {
    var notifStatus = await Permission.notification.status;
    if (notifStatus.isDenied) {
      notifStatus = await Permission.notification.request();
    }

    var scheduleStatus = await Permission.scheduleExactAlarm.status;
    if (scheduleStatus.isDenied) {
      scheduleStatus = await Permission.scheduleExactAlarm.request();
    }

    return notifStatus.isGranted && scheduleStatus.isGranted;
  }

  Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required bool playAzanSound,
    String soundName = 'azan_1',
  }) async {
    // Only schedule if time is in the future
    if (scheduledTime.isBefore(DateTime.now())) return;

    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    AndroidNotificationDetails androidDetails;
    
    if (playAzanSound) {
      androidDetails = AndroidNotificationDetails(
        'azan_channel_$soundName',
        'Azan Notifications',
        channelDescription: 'Pemberitahuan Adzan waktu shalat',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(soundName), 
        playSound: true,
      );
    } else {
      androidDetails = const AndroidNotificationDetails(
        'silent_channel',
        'Prayer Updates',
        channelDescription: 'Pemberitahuan senyap batas waktu shalat',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: false,
      );
    }

    final NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
