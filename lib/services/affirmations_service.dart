import 'dart:math';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';

class AffirmationsService {
  static final List<Affirmation> _library = [
    // --- OVERTHINKER ---
    Affirmation(
      text: "Congrats on winning the argument you had with yourself in the shower.",
      localizedText: {
        DopeLanguage.en: "Congrats on winning the argument you had with yourself in the shower.",
        DopeLanguage.es: "Felicidades por ganar la discusión que tuviste contigo mismo en la ducha.",
        DopeLanguage.hi: "शावर में खुद से हुई बहस जीतने के लिए बधाई।",
        DopeLanguage.fr: "Félicitations pour avoir gagné la dispute que tu as eue avec toi-même sous la douche.",
        DopeLanguage.de: "Glückwunsch zum Sieg im Streit, den du unter der Dusche mit dir selbst geführt hast.",
      },
      persona: DopePersona.overthinker,
      tone: DopeTone.deadpan,
    ),
    Affirmation(
      text: "Thinking about it for the 10th time won't change the outcome.",
      localizedText: {
        DopeLanguage.en: "Thinking about it for the 10th time won't change the outcome.",
        DopeLanguage.es: "Pensarlo por décima vez no cambiará el resultado.",
        DopeLanguage.hi: "10वीं बार इसके बारे में सोचने से परिणाम नहीं बदलेगा।",
        DopeLanguage.fr: "Y penser pour la 10ème fois ne changera pas le résultat.",
        DopeLanguage.de: "Zum zehnten Mal darüber nachzudenken wird das Ergebnis nicht ändern.",
      },
      persona: DopePersona.overthinker,
      tone: DopeTone.straight,
    ),
    Affirmation(
      text: "Your mind is a haunted house. Maybe stop giving yourself a guided tour.",
      localizedText: {
        DopeLanguage.en: "Your mind is a haunted house. Maybe stop giving yourself a guided tour.",
        DopeLanguage.es: "Tu mente es una casa embrujada. Quizás deja de darte un tour guiado.",
        DopeLanguage.hi: "आपका मन एक भूतिया घर है। शायद खुद को वहां की सैर कराना बंद करें।",
        DopeLanguage.fr: "Ton esprit est une maison hantée. Arrête peut-être de te faire visiter.",
        DopeLanguage.de: "Dein Verstand ist ein Geisterhaus. Hör vielleicht auf, dir selbst eine Führung zu geben.",
      },
      persona: DopePersona.overthinker,
      tone: DopeTone.deadpan,
    ),
    Affirmation(
      text: "Doubt is just your brain trying to be helpful and failing.",
      persona: DopePersona.overthinker,
      tone: DopeTone.chill,
    ),

    // --- BUILDER ---
    Affirmation(
      text: "Ship the ugly version. No one is looking anyway.",
      localizedText: {
        DopeLanguage.en: "Ship the ugly version. No one is looking anyway.",
        DopeLanguage.es: "Lanza la versión fea. Nadie está mirando de todos modos.",
        DopeLanguage.hi: "बदसूरत वर्शन ही भेज दो। वैसे भी कोई नहीं देख रहा है।",
        DopeLanguage.fr: "Lance la version moche. Personne ne regarde de toute façon.",
        DopeLanguage.de: "Veröffentliche die hässliche Version. Es sieht sowieso keiner hin.",
      },
      persona: DopePersona.builder,
      tone: DopeTone.coach,
    ),
    Affirmation(
      text: "The perfect moment is a myth invented by people who don't build.",
      localizedText: {
        DopeLanguage.en: "The perfect moment is a myth invented by people who don't build.",
        DopeLanguage.es: "El momento perfecto es un mito inventado por personas que no construyen.",
        DopeLanguage.hi: "परफेक्ट मोमेंट एक मिथक है जिसे उन लोगों ने बनाया है जो कुछ नहीं बनाते।",
        DopeLanguage.fr: "Le moment parfait est un mythe inventé par des gens qui ne construisent rien.",
        DopeLanguage.de: "Der perfekte Moment ist ein Mythos, erfunden von Leuten, die nichts bauen.",
      },
      persona: DopePersona.builder,
      tone: DopeTone.straight,
    ),
    Affirmation(
      text: "Action creates clarity. Sitting there creates dust.",
      persona: DopePersona.builder,
      tone: DopeTone.coach,
    ),
    Affirmation(
      text: "Your unfinished project isn't a failure, it's an expensive lesson.",
      persona: DopePersona.builder,
      tone: DopeTone.deadpan,
    ),

    // --- BURNT OUT ---
    Affirmation(
      text: "Resting isn't a reward, it's maintenance.",
      localizedText: {
        DopeLanguage.en: "Resting isn't a reward, it's maintenance.",
        DopeLanguage.es: "Descansar no es una recompensa, es mantenimiento.",
        DopeLanguage.hi: "आराम करना कोई इनाम नहीं है, यह रखरखाव है।",
        DopeLanguage.fr: "Se reposer n'est pas une récompense, c'est de l'entretien.",
        DopeLanguage.de: "Ausruhen ist keine Belohnung, es ist Wartung.",
      },
      persona: DopePersona.burntOut,
      tone: DopeTone.straight,
    ),
    Affirmation(
      text: "The world won't end if you take a nap. I checked.",
      persona: DopePersona.burntOut,
      tone: DopeTone.chill,
    ),
    Affirmation(
      text: "Your value is not your productivity. You're not a forklift.",
      persona: DopePersona.burntOut,
      tone: DopeTone.deadpan,
    ),
    Affirmation(
      text: "That 'urgent' email can wait until you're a person again.",
      persona: DopePersona.burntOut,
      tone: DopeTone.deadpan,
    ),

    // --- ADHD BRAIN ---
    Affirmation(
      text: "Your brain has 47 tabs open. Close the one playing music.",
      localizedText: {
        DopeLanguage.en: "Your brain has 47 tabs open. Close the one playing music.",
        DopeLanguage.es: "Tu cerebro tiene 47 pestañas abiertas. Cierra la que está reproduciendo música.",
        DopeLanguage.hi: "आपके दिमाग में 47 टैब खुले हैं। संगीत बजाने वाले को बंद करें।",
        DopeLanguage.fr: "Ton cerveau a 47 onglets ouverts. Ferme celui qui joue de la musique.",
        DopeLanguage.de: "Dein Gehirn hat 47 Tabs offen. Schließ den, der Musik spielt.",
      },
      persona: DopePersona.adhdBrain,
      tone: DopeTone.deadpan,
    ),
    Affirmation(
      text: "Momentum beats motivation. Just move one inch.",
      persona: DopePersona.adhdBrain,
      tone: DopeTone.coach,
    ),
    Affirmation(
      text: "Hyperfocus is a superpower until it's 3 am and you're learning about plumbing.",
      persona: DopePersona.adhdBrain,
      tone: DopeTone.deadpan,
    ),
    Affirmation(
      text: "Five minutes of focus is better than zero minutes of perfection.",
      persona: DopePersona.adhdBrain,
      tone: DopeTone.coach,
    ),

    // --- STRIVER ---
    Affirmation(
      text: "Ambition is just hunger with a better wardrobe.",
      persona: DopePersona.striver,
      tone: DopeTone.deadpan,
    ),
    Affirmation(
      text: "You aren't behind. You're just on a different lap.",
      persona: DopePersona.striver,
      tone: DopeTone.chill,
    ),
    Affirmation(
      text: "The goalpost will always move. Enjoy the grass for a second.",
      persona: DopePersona.striver,
      tone: DopeTone.coach,
    ),
    Affirmation(
      text: "High standards are fine. Self-sabotage is just extra work.",
      persona: DopePersona.striver,
      tone: DopeTone.straight,
    ),

    // --- UNIVERSAL (Accessible to all personas) ---
    Affirmation(text: "Reality called. It wants you to stop scrolling.", tone: DopeTone.deadpan),
    Affirmation(text: "Drink water. You're basically a plant with complicated emotions.", tone: DopeTone.chill),
    Affirmation(text: "Validation is a drug. Get sober.", tone: DopeTone.straight),
    Affirmation(text: "Nobody actually knows what they're doing.", tone: DopeTone.deadpan),
    Affirmation(text: "Cringe is the price of admission for growth.", tone: DopeTone.straight),
    
    // --- TIME-BASED (Morning 7-10) ---
    Affirmation(text: "You woke up. That’s discipline.", tone: DopeTone.coach),
    Affirmation(text: "Sun's up. Unfortunately, so are you.", tone: DopeTone.deadpan),
    Affirmation(text: "Coffee first. Existential dread second.", tone: DopeTone.chill),

    // --- TIME-BASED (Late Night 0-2) ---
    Affirmation(text: "You don’t need answers tonight. Sleep is allowed.", tone: DopeTone.chill),
    Affirmation(text: "Nothing good happens after 2 AM. Go to bed.", tone: DopeTone.straight),
    Affirmation(text: "Your brain is offline. Stop refreshing.", tone: DopeTone.deadpan),
  ];

  static Future<List<Affirmation>> getAllAffirmations() async {
    final prefs = await UserPreferences.load();
    final custom = await UserPreferences.getCustomAffirmations();
    
    // STRICT FILTERING: Match persona OR universal (null persona)
    // Users will NEVER see an affirmation belonging to another specific persona.
    final filtered = _library.where((a) {
      return a.persona == prefs.persona || a.persona == null;
    }).toList();

    // Evolving Affirmations Logic
    final firstRun = DateTime.parse(prefs.firstRunDate);
    final daysSinceStart = DateTime.now().difference(firstRun).inDays;
    
    String evolvingText;
    if (daysSinceStart < 14) {
      evolvingText = "You’re not behind.";
    } else if (daysSinceStart < 60) {
      evolvingText = "You’re not behind. You just stopped comparing.";
    } else {
      evolvingText = "You were never behind. You were building quietly.";
    }
    
    filtered.add(Affirmation(text: evolvingText, tone: DopeTone.coach));

    return [...filtered, ...custom];
  }

  static Future<Affirmation> getDailyAffirmation() async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _library.first;
    final now = DateTime.now();
    final prefs = await UserPreferences.load();
    // Unique seed ensuring consistency for the day within the filtered pool
    final seed = now.year + now.month + now.day + (prefs.systemLoad * 100).toInt() + prefs.persona.index;
    return all[seed % all.length];
  }

  static Future<Affirmation> getRandomAffirmation({String? excludeText}) async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _library.first;
    
    final now = DateTime.now();
    final hour = now.hour;
    List<Affirmation> priorityPool = [];

    // Morning Window: 7 AM - 10 AM
    if (hour >= 7 && hour < 10) {
      final morningTexts = [
        "You woke up. That’s discipline.",
        "Sun's up. Unfortunately, so are you.",
        "Coffee first. Existential dread second.",
      ];
      priorityPool = all.where((a) => morningTexts.contains(a.getText(DopeLanguage.en))).toList();
    }
    // Late Night Window: 12 AM - 2 AM
    else if (hour >= 0 && hour < 2) {
      final nightTexts = [
        "You don’t need answers tonight. Sleep is allowed.",
        "Nothing good happens after 2 AM. Go to bed.",
        "Your brain is offline. Stop refreshing.",
      ];
      priorityPool = all.where((a) => nightTexts.contains(a.getText(DopeLanguage.en))).toList();
    }

    // 60% chance to pick a time-relevant message if available
    if (priorityPool.isNotEmpty && Random().nextDouble() < 0.6) {
      final pool = excludeText != null 
        ? priorityPool.where((a) => a.getText(DopeLanguage.en) != excludeText).toList()
        : priorityPool;
      if (pool.isNotEmpty) {
        return pool[Random().nextInt(pool.length)];
      }
    }
    
    final pool = excludeText != null 
      ? all.where((a) => a.getText(DopeLanguage.en) != excludeText).toList()
      : all;
      
    final finalPool = pool.isEmpty ? all : pool;
    return finalPool[Random().nextInt(finalPool.length)];
  }

  static String getRebuttal(DopeTone tone) {
    final rebuttals = {
      DopeTone.chill: [
        "Cool. Still doesn't make you a failure though.",
        "Fair enough. Just checking.",
        "Okay. But the point stands.",
        "Whatever you say. You're the boss.",
        "Heard. We'll try again tomorrow.",
      ],
      DopeTone.straight: [
        "Noted. But facts don't care about your denial.",
        "Denial is a river in Egypt.",
        "You can say no, but the logic holds.",
        "Your disagreement has been logged.",
        "Objectively speaking, I'm still right.",
      ],
      DopeTone.coach: [
        "Is that a real 'no' or just fear talking?",
        "Pushing back? Good. Use that energy.",
        "I expected resistance. Keep moving.",
        "Don't let the doubt win.",
        "Prove me wrong then. I'll wait.",
      ],
      DopeTone.deadpan: [
        "Wow. Such rebellion.",
        "Riveting counter-argument.",
        "Okay. Do you feel better now?",
        "Your opinion is noted and ignored.",
        "Sarcasm won't save you from the truth.",
      ],
    };

    final list = rebuttals[tone] ?? rebuttals[DopeTone.chill]!;
    return list[Random().nextInt(list.length)];
  }
}