import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'affirmations_service.dart';
import '../models/user_preferences.dart';
import 'streak_service.dart';
import '../locator.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  void _onNotificationResponse(NotificationResponse response) async {
    if (response.actionId != null) {
      // Logic for interaction can be added here
      await locator<StreakService>().updateStreak();

      final prefs = await UserPreferences.load();
      await UserPreferences.save(prefs);
    }
  }

  Future<void> scheduleDailyPing() async {
    final prefs = await UserPreferences.load();
    if (!prefs.notificationsEnabled) {
      await _notifications.cancelAll();
      return;
    }

    final aff = await locator<AffirmationsService>().getDailyAffirmation();
    
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      prefs.notificationHour,
      prefs.notificationMinute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    AndroidScheduleMode scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;

    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      final bool? granted = await androidImplementation.requestExactAlarmsPermission();
      if (granted != true) {
        scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
      }
    }

    final bool isRealityCheck = DateTime.now().second % 2 == 0;
    
    final List<AndroidNotificationAction> androidActions = isRealityCheck ? [
      const AndroidNotificationAction('rc_yes', 'YES', showsUserInterface: true),
      const AndroidNotificationAction('rc_no', 'NO', showsUserInterface: true),
    ] : [];

    await _notifications.zonedSchedule(
      0,
      isRealityCheck ? 'REALITY CHECK' : 'DOPERMATIONS',
      isRealityCheck ? 'Are you overthinking or just thinking?' : aff.getText(prefs.language),
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_pings',
          'Daily Pings',
          channelDescription: 'Daily sarcastic Dopermations',
          importance: Importance.high,
          priority: Priority.high,
          actions: androidActions,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
