import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'affirmation.dart';

enum DopePersona { 
  overthinker, 
  builder, 
  burntOut, 
  striver, 
  adhdBrain,
  deadpanTherapist,
  softBullyFriend,
  tiredMonk,
  overqualifiedHater,
  corporateBurnoutSurvivor
}
enum DopeTone { chill, straight, coach, deadpan }
enum AppColorTheme { terminal, matrix, cyber, monochrome, dusk }
enum DopeLanguage { en, es, hi, fr, de }

class UserPreferences {
  final DopePersona persona;
  final DopeTone tone;
  final ThemeMode themeMode;
  final String fontFamily;
  final AppColorTheme colorTheme;
  final DopeLanguage language;
  
  final double systemLoad;
  final double batteryLevel;
  final double bandwidth;
  
  final List<String> likedAffirmations;
  final bool notificationsEnabled;
  final int notificationHour;
  final int notificationMinute;

  final int sanityStreak;
  final String? lastInteractionDate; // ISO format
  final String firstRunDate; // ISO format

  UserPreferences({
    required this.persona,
    required this.tone,
    this.themeMode = ThemeMode.dark,
    this.fontFamily = 'Plus Jakarta Sans',
    this.colorTheme = AppColorTheme.terminal,
    this.language = DopeLanguage.en,
    this.systemLoad = 0.5,
    this.batteryLevel = 0.5,
    this.bandwidth = 0.5,
    this.likedAffirmations = const [],
    this.notificationsEnabled = true,
    this.notificationHour = 8,
    this.notificationMinute = 0,
    this.sanityStreak = 0,
    this.lastInteractionDate,
    required this.firstRunDate,
  });

  static Future<void> save(UserPreferences prefs) async {
    final s = await SharedPreferences.getInstance();
    await s.setString('persona', prefs.persona.name);
    await s.setString('tone', prefs.tone.name);
    await s.setString('themeMode', prefs.themeMode.name);
    await s.setString('fontFamily', prefs.fontFamily);
    await s.setString('colorTheme', prefs.colorTheme.name);
    await s.setString('language', prefs.language.name);
    await s.setDouble('systemLoad', prefs.systemLoad);
    await s.setDouble('batteryLevel', prefs.batteryLevel);
    await s.setDouble('bandwidth', prefs.bandwidth);
    await s.setStringList('likedAffirmations', prefs.likedAffirmations);
    await s.setBool('notifications', prefs.notificationsEnabled);
    await s.setInt('notificationHour', prefs.notificationHour);
    await s.setInt('notificationMinute', prefs.notificationMinute);
    await s.setInt('sanityStreak', prefs.sanityStreak);
    if (prefs.lastInteractionDate != null) {
      await s.setString('lastInteractionDate', prefs.lastInteractionDate!);
    }
    await s.setString('firstRunDate', prefs.firstRunDate);
  }

  static T _enumFromString<T>(List<T> values, String? value, T defaultValue) {
    if (value == null) return defaultValue;
    return values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => defaultValue,
    );
  }

  static Future<UserPreferences> load() async {
    final s = await SharedPreferences.getInstance();
    
    // Set first run date if not present
    String? firstRun = s.getString('firstRunDate');
    if (firstRun == null) {
      firstRun = DateTime.now().toIso8601String();
      await s.setString('firstRunDate', firstRun);
    }

    return UserPreferences(
      persona: _enumFromString(DopePersona.values, s.getString('persona'), DopePersona.overthinker),
      tone: _enumFromString(DopeTone.values, s.getString('tone'), DopeTone.straight),
      themeMode: _enumFromString(ThemeMode.values, s.getString('themeMode'), ThemeMode.dark),
      fontFamily: s.getString('fontFamily') ?? 'Plus Jakarta Sans',
      colorTheme: _enumFromString(AppColorTheme.values, s.getString('colorTheme'), AppColorTheme.terminal),
      language: _enumFromString(DopeLanguage.values, s.getString('language'), DopeLanguage.en),
      systemLoad: s.getDouble('systemLoad') ?? 0.5,
      batteryLevel: s.getDouble('batteryLevel') ?? 0.5,
      bandwidth: s.getDouble('bandwidth') ?? 0.5,
      likedAffirmations: s.getStringList('likedAffirmations') ?? [],
      notificationsEnabled: s.getBool('notifications') ?? true,
      notificationHour: s.getInt('notificationHour') ?? 8,
      notificationMinute: s.getInt('notificationMinute') ?? 0,
      sanityStreak: s.getInt('sanityStreak') ?? 0,
      lastInteractionDate: s.getString('lastInteractionDate'),
      firstRunDate: firstRun,
    );
  }

  static Future<void> addCustomAffirmation(Affirmation aff) async {
    final s = await SharedPreferences.getInstance();
    List<String> current = s.getStringList('custom_affirmations') ?? [];
    current.add(jsonEncode(aff.toJson()));
    await s.setStringList('custom_affirmations', current);
  }

  static Future<List<Affirmation>> getCustomAffirmations() async {
    final s = await SharedPreferences.getInstance();
    List<String> current = s.getStringList('custom_affirmations') ?? [];
    return current.map((e) {
      try {
        return Affirmation.fromJson(jsonDecode(e));
      } catch (_) {
        return null;
      }
    }).whereType<Affirmation>().toList();
  }
}