import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'affirmations_service.dart';
import '../models/user_preferences.dart';
import 'streak_service.dart';
import 'dart:convert';


class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(); // Use Darwin for iOS, macOS
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  static void _onNotificationResponse(NotificationResponse response) async {
    if (response.actionId != null) {
      // Record reality check response
      final prefs = await UserPreferences.load();
      List history = jsonDecode(prefs.realityCheckHistory);
      history.add({
        'timestamp': DateTime.now().toIso8601String(),
        'action': response.actionId,
        'payload': response.payload,
      });
      
      // Also update streak on interaction
      await StreakService.updateStreak();

      final updatedPrefs = UserPreferences(
        persona: prefs.persona,
        tone: prefs.tone,
        themeMode: prefs.themeMode,
        fontFamily: prefs.fontFamily,
        colorTheme: prefs.colorTheme,
        language: prefs.language,
        systemLoad: prefs.systemLoad,
        batteryLevel: prefs.batteryLevel,
        bandwidth: prefs.bandwidth,
        likedAffirmations: prefs.likedAffirmations,
        notificationsEnabled: prefs.notificationsEnabled,
        notificationHour: prefs.notificationHour,
        notificationMinute: prefs.notificationMinute,
        sanityStreak: prefs.sanityStreak, // Will be updated by load if needed, but let's be safe
        lastInteractionDate: prefs.lastInteractionDate,
        realityCheckHistory: jsonEncode(history),
        firstRunDate: prefs.firstRunDate,
        seenAffirmations: prefs.seenAffirmations,
        seenRebuttals: prefs.seenRebuttals,
      );
      await UserPreferences.save(updatedPrefs);
    }
  }

  static Future<void> scheduleDailyPing() async {
    final prefs = await UserPreferences.load();
    if (!prefs.notificationsEnabled) {
      await _notifications.cancelAll();
      return;
    }

    final aff = await AffirmationsService.getDailyAffirmation();
    
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

    // Interactive Reality Check
    final bool isRealityCheck = DateTime.now().second % 2 == 0; // Simple heuristic for demo
    
    final List<AndroidNotificationAction> androidActions = isRealityCheck ? [
      const AndroidNotificationAction('rc_yes', 'YES', showsUserInterface: true),
      const AndroidNotificationAction('rc_no', 'NO', showsUserInterface: true),
    ] : [];

    await _notifications.zonedSchedule(
      0, // id
      isRealityCheck ? 'REALITY CHECK' : 'DOPERMATIONS', // title
      isRealityCheck ? 'Are you overthinking or just thinking?' : aff.getText(prefs.language), // body
      scheduledDate, // scheduledDate
      NotificationDetails( // notificationDetails
        android: AndroidNotificationDetails(
          'daily_pings',
          'Daily Pings',
          channelDescription: 'Daily sarcastic Dopermations',
          importance: Importance.high,
          priority: Priority.high,
          actions: androidActions,
        ),
        iOS: const DarwinNotificationDetails(), // Darwin for iOS
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: scheduleMode, // Android specific
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
