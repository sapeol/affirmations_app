import 'dart:math';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';

class AffirmationsService {
  static final List<Affirmation> _defaultAffirmations = [
    Affirmation(text: "I am capable of achieving my goals."),
    Affirmation(text: "Every day is a fresh start."),
    Affirmation(text: "I am worthy of love and respect."),
    Affirmation(text: "I choose to be positive and happy."),
    Affirmation(text: "My potential is limitless."),
    Affirmation(text: "I am confident in my abilities."),
    Affirmation(text: "I focus on what I can control."),
    Affirmation(text: "I am growing and becoming better every day."),
    Affirmation(text: "I deserve all the good things in my life."),
    Affirmation(text: "I am enough exactly as I am."),
  ];

  static Future<List<Affirmation>> getAllAffirmations() async {
    final custom = await UserPreferences.getCustomAffirmations();
    return [..._defaultAffirmations, ...custom];
  }

  static Future<Affirmation> getDailyAffirmation() async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _defaultAffirmations.first;
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return all[dayOfYear % all.length];
  }

  static Future<Affirmation> getRandomAffirmation() async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _defaultAffirmations.first;
    return all[Random().nextInt(all.length)];
  }
}
