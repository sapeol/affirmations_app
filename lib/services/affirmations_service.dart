import 'dart:math';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';
import '../models/user_mood.dart';

class AffirmationsService {
  static final List<Affirmation> _library = [
    // MESSY MIDDLE (Progress with Anxiety)
    Affirmation(text: "I am allowed to feel anxious while I move forward. Courage is doing it scared.", context: UserContext.general),
    Affirmation(text: "My anxiety is a part of my growth, not a sign of failure.", context: UserContext.uncertainty),
    
    // OVERWHELMED (Reframing)
    Affirmation(text: "I don't have to carry the whole world today. I only need to take the next small breath.", context: UserContext.general),
    Affirmation(text: "When things feel like too much, I am allowed to rest without guilt.", context: UserContext.health),

    // SEARCHING
    Affirmation(text: "Being 'lost' is just the first step of being 'found' in a new way.", context: UserContext.uncertainty),
    Affirmation(text: "I trust the timing of my life, even when I don't understand the path.", context: UserContext.uncertainty),

    // GROUNDED / PEACEFUL
    Affirmation(text: "I am a calm center in a busy world.", context: UserContext.general),
    Affirmation(text: "I have everything I need within me to stay steady.", context: UserContext.general),

    // RESILIENT
    Affirmation(text: "I have survived 100% of my hardest days. I am built of strong stuff.", context: UserContext.selfImage),
    Affirmation(text: "My setbacks are just setup for my comeback.", context: UserContext.career),
  ];

  static final Map<EmotionCategory, List<Affirmation>> _moodLibrary = {
    EmotionCategory.messyMiddle: [
      Affirmation(text: "My trembling hands are still capable of building great things."),
      Affirmation(text: "I am expanding, and growth often feels like pressure."),
    ],
    EmotionCategory.overwhelmed: [
      Affirmation(text: "I am not my productivity. I am the peace beneath the noise."),
      Affirmation(text: "I choose to do one thing today: be kind to myself."),
    ],
    EmotionCategory.searching: [
      Affirmation(text: "Not knowing the answer is an invitation to explore, not a reason to panic."),
      Affirmation(text: "I am exactly where I need to be to learn what I need to know."),
    ],
  };

  static Future<List<Affirmation>> getAllAffirmations() async {
    final prefs = await UserPreferences.load();
    final custom = await UserPreferences.getCustomAffirmations();
    
    List<Affirmation> filtered = List.from(_library);

    // Add mood-specific affirmations if a mood is set
    if (prefs.lastMoodCategory != null) {
      final category = EmotionCategory.values.byName(prefs.lastMoodCategory!);
      if (_moodLibrary.containsKey(category)) {
        filtered.addAll(_moodLibrary[category]!);
      }
    }

    // Scoring engine for contextual relevance
    List<MapEntry<Affirmation, int>> scored = filtered.map((a) {
      int score = 0;
      if (a.context == prefs.userContext) score += 5;
      if (a.focus == prefs.focus) score += 3;
      if (a.tone == prefs.tone) score += 2;
      if (a.leaning == prefs.leaning) score += 4;
      return MapEntry(a, score);
    }).toList();

    scored.sort((a, b) => b.value.compareTo(a.value));
    List<Affirmation> finalFiltered = scored.where((e) => e.value > 0).map((e) => e.key).toList();
    
    if (finalFiltered.length < 5) finalFiltered = _library;

    return [...finalFiltered, ...custom];
  }

  static Future<Affirmation> getDailyAffirmation() async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _library.first;
    final now = DateTime.now();
    final prefs = await UserPreferences.load();
    final seed = now.year + now.month + now.day + prefs.userContext.index + (prefs.lastMoodCategory?.length ?? 0);
    return all[seed % all.length];
  }

  static Future<Affirmation> getRandomAffirmation() async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _library.first;
    return all[Random().nextInt(all.length)];
  }
}