import 'dart:math';
import '../models/affirmation.dart';

class AffirmationsService {
  static final List<Affirmation> _affirmations = [
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

  static Affirmation getDailyAffirmation() {
    // In a real app, this could be based on the date
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return _affirmations[dayOfYear % _affirmations.length];
  }

  static Affirmation getRandomAffirmation() {
    return _affirmations[Random().nextInt(_affirmations.length)];
  }
}
