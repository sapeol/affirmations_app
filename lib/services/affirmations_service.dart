import 'dart:math';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';

class AffirmationsService {
  static final List<Affirmation> _library = [
    // CAREER & PROFESSIONAL
    Affirmation(text: "My worth is not defined by my productivity, but by my presence.", context: UserContext.career, tone: AffirmationTone.gentle, focus: AppFocus.improvement),
    Affirmation(text: "I am a powerful creator, and I have the skills to overcome any professional hurdle.", context: UserContext.career, tone: AffirmationTone.empowering, focus: AppFocus.motivation),
    Affirmation(text: "In the midst of chaos, I find my focus and my purpose.", context: UserContext.career, tone: AffirmationTone.philosophical, leaning: SpiritualLeaning.stoic),
    
    // RELATIONSHIPS
    Affirmation(text: "I am worthy of healthy, supportive, and nourishing connections.", context: UserContext.relationships, tone: AffirmationTone.gentle),
    Affirmation(text: "I set clear boundaries because I value my peace and my energy.", context: UserContext.relationships, tone: AffirmationTone.empowering),
    Affirmation(text: "To love is to accept the impermanence of all things.", context: UserContext.relationships, tone: AffirmationTone.philosophical, leaning: SpiritualLeaning.buddhist),

    // ANXIETY & UNCERTAINTY
    Affirmation(text: "I let go of the need to know what happens next. I am safe here.", context: UserContext.uncertainty, tone: AffirmationTone.gentle, focus: AppFocus.anxiety),
    Affirmation(text: "I have survived every 'worst day' of my life so far. I am resilient.", context: UserContext.uncertainty, tone: AffirmationTone.empowering, focus: AppFocus.anxiety),
    Affirmation(text: "Nature does not hurry, yet everything is accomplished.", context: UserContext.uncertainty, tone: AffirmationTone.philosophical, leaning: SpiritualLeaning.spiritual),

    // SELF IMAGE
    Affirmation(text: "I treat myself with the same kindness I offer to a dear friend.", context: UserContext.selfImage, tone: AffirmationTone.gentle, focus: AppFocus.general),
    Affirmation(text: "I am the architect of my self-belief, and I choose to build strength.", context: UserContext.selfImage, tone: AffirmationTone.empowering, focus: AppFocus.improvement),
    Affirmation(text: "The body is the instrument, not the masterpiece.", context: UserContext.selfImage, tone: AffirmationTone.philosophical),

    // HEALTH
    Affirmation(text: "My body is a temple, and I listen to its quiet wisdom.", context: UserContext.health, tone: AffirmationTone.gentle),
    Affirmation(text: "Every breath I take is an opportunity to heal and renew.", context: UserContext.health, tone: AffirmationTone.empowering),

    // STOIC / PHILOSOPHICAL (General)
    Affirmation(text: "Amor Fati: I love my fate, for it is the fire that tempers my soul.", leaning: SpiritualLeaning.stoic, tone: AffirmationTone.philosophical),
    Affirmation(text: "The soul becomes dyed with the color of its thoughts.", leaning: SpiritualLeaning.stoic, tone: AffirmationTone.philosophical),
  ];

  static Future<List<Affirmation>> getAllAffirmations() async {
    final prefs = await UserPreferences.load();
    final custom = await UserPreferences.getCustomAffirmations();
    
    // Scoring engine for contextual relevance
    List<MapEntry<Affirmation, int>> scored = _library.map((a) {
      int score = 0;
      if (a.context == prefs.userContext) score += 5;
      if (a.focus == prefs.focus) score += 3;
      if (a.tone == prefs.tone) score += 2;
      if (a.leaning == prefs.leaning) score += 4;
      return MapEntry(a, score);
    }).toList();

    // Sort by score and take top matches
    scored.sort((a, b) => b.value.compareTo(a.value));
    
    // Take affirmations with a score > 0, or at least some results
    List<Affirmation> filtered = scored.where((e) => e.value > 0).map((e) => e.key).toList();
    
    if (filtered.length < 5) filtered = _library;

    return [...filtered, ...custom];
  }

  static Future<Affirmation> getDailyAffirmation() async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _library.first;
    final now = DateTime.now();
    final prefs = await UserPreferences.load();
    final seed = now.year + now.month + now.day + prefs.userContext.index + prefs.tone.index;
    return all[seed % all.length];
  }

  static Future<Affirmation> getRandomAffirmation() async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _library.first;
    return all[Random().nextInt(all.length)];
  }
}
