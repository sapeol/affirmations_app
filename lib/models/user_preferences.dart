import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'affirmation.dart';

enum SpiritualLeaning { secular, spiritual, religious, stoic, buddhist }
enum AppFocus { anxiety, motivation, grief, improvement, general }
enum LifeStage { student, professional, parent, retired, other }
enum Gender { female, male, nonBinary, preferNotToSay }
enum AppColorTheme { sage, lavender, sky, rose, peach }

class UserPreferences {
  final SpiritualLeaning leaning;
  final AppFocus focus;
  final LifeStage lifeStage;
  final Gender gender;
  final ThemeMode themeMode;
  final String fontFamily;
  final AppColorTheme colorTheme;
  final bool notificationsEnabled;

  UserPreferences({
    required this.leaning,
    required this.focus,
    required this.lifeStage,
    required this.gender,
    this.themeMode = ThemeMode.system,
    this.fontFamily = 'Lexend',
    this.colorTheme = AppColorTheme.sage,
    this.notificationsEnabled = true,
  });

  static Future<void> save(UserPreferences prefs) async {
    final s = await SharedPreferences.getInstance();
    await s.setString('leaning', prefs.leaning.name);
    await s.setString('focus', prefs.focus.name);
    await s.setString('lifeStage', prefs.lifeStage.name);
    await s.setString('gender', prefs.gender.name);
    await s.setString('themeMode', prefs.themeMode.name);
    await s.setString('fontFamily', prefs.fontFamily);
    await s.setString('colorTheme', prefs.colorTheme.name);
    await s.setBool('notifications', prefs.notificationsEnabled);
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
    return UserPreferences(
      leaning: _enumFromString(SpiritualLeaning.values, s.getString('leaning'), SpiritualLeaning.secular),
      focus: _enumFromString(AppFocus.values, s.getString('focus'), AppFocus.general),
      lifeStage: _enumFromString(LifeStage.values, s.getString('lifeStage'), LifeStage.other),
      gender: _enumFromString(Gender.values, s.getString('gender'), Gender.preferNotToSay),
      themeMode: _enumFromString(ThemeMode.values, s.getString('themeMode'), ThemeMode.system),
      fontFamily: s.getString('fontFamily') ?? 'Lexend',
      colorTheme: _enumFromString(AppColorTheme.values, s.getString('colorTheme'), AppColorTheme.sage),
      notificationsEnabled: s.getBool('notifications') ?? true,
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