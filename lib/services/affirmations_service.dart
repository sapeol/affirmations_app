import 'dart:math';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';

class AffirmationsService {
  static final List<Affirmation> _library = [
    // WHEN OVERWHELMED / BURNT OUT
    Affirmation(text: "you don’t need to win today. just don’t quit.", persona: DopePersona.burntOut, tone: DopeTone.chill),
    Affirmation(text: "this feels heavy because it matters.", persona: DopePersona.overthinker, tone: DopeTone.straight),
    Affirmation(text: "slow is still forward.", persona: DopePersona.striver, tone: DopeTone.deadpan),
    Affirmation(text: "rest is part of the system.", persona: DopePersona.builder, tone: DopeTone.coach),
    Affirmation(text: "you’re tired, not broken.", persona: DopePersona.burntOut, tone: DopeTone.chill),
    Affirmation(text: "pressure isn’t proof.", persona: DopePersona.striver, tone: DopeTone.straight),

    // IMPOSTER SYNDROME / BUILDER
    Affirmation(text: "doubt doesn’t mean you’re wrong.", persona: DopePersona.overthinker, tone: DopeTone.straight),
    Affirmation(text: "if it were easy, you wouldn’t be here.", persona: DopePersona.builder, tone: DopeTone.coach),
    Affirmation(text: "competence grows quietly.", persona: DopePersona.striver, tone: DopeTone.deadpan),
    Affirmation(text: "build anyway.", persona: DopePersona.builder, tone: DopeTone.deadpan),

    // FOCUS / ADHD
    Affirmation(text: "start ugly. fix later.", persona: DopePersona.adhdBrain, tone: DopeTone.coach),
    Affirmation(text: "five minutes counts.", persona: DopePersona.adhdBrain, tone: DopeTone.chill),
    Affirmation(text: "momentum beats motivation.", persona: DopePersona.adhdBrain, tone: DopeTone.straight),
    
    // DEADPAN (Universal)
    Affirmation(text: "your brain is lying to you again.", tone: DopeTone.deadpan),
    Affirmation(text: "cringe is part of the process.", tone: DopeTone.deadpan),
    Affirmation(text: "it's fine.", tone: DopeTone.deadpan),
    Affirmation(text: "don't let your inner child run the budget.", tone: DopeTone.deadpan),
  ];

  static Future<List<Affirmation>> getAllAffirmations() async {
    final prefs = await UserPreferences.load();
    final custom = await UserPreferences.getCustomAffirmations();
    
    // Scoring engine for Dope Relevance
    List<MapEntry<Affirmation, int>> scored = _library.map((a) {
      int score = 0;
      if (a.persona == prefs.persona) score += 5;
      if (a.tone == prefs.tone) score += 3;
      return MapEntry(a, score);
    }).toList();

    scored.sort((a, b) => b.value.compareTo(a.value));
    List<Affirmation> filtered = scored.where((e) => e.value > 0).map((e) => e.key).toList();
    
    if (filtered.length < 5) filtered = _library;

    return [...filtered, ...custom];
  }

  static Future<Affirmation> getDailyAffirmation() async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _library.first;
    final now = DateTime.now();
    final prefs = await UserPreferences.load();
    final seed = now.year + now.month + now.day + prefs.persona.index + prefs.tone.index;
    return all[seed % all.length];
  }

  static Future<Affirmation> getRandomAffirmation() async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _library.first;
    return all[Random().nextInt(all.length)];
  }
}
