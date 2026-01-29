import 'dart:math';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';

class AffirmationsService {
  late Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [AffirmationSchema],
      directory: dir.path,
    );

    // Initial data seed if empty
    if (await isar.affirmations.count() == 0) {
      await _seedData();
    }
  }

  Future<void> _seedData() async {
    await isar.writeTxn(() async {
      await isar.affirmations.putAll(_library);
    });
  }

  Future<List<Affirmation>> getAllAffirmations() async {
    final prefs = await UserPreferences.load();
    // Filter by persona or general
    return await isar.affirmations
        .filter()
        .personaEqualTo(prefs.persona)
        .or()
        .personaEqualTo(DopePersona.general)
        .findAll();
  }

  Future<void> addCustomAffirmation(Affirmation aff) async {
    await isar.writeTxn(() async {
      await isar.affirmations.put(aff);
    });
  }

  Future<Affirmation> getDailyAffirmation() async {
    final all = await getAllAffirmations();
    if (all.isEmpty) {
      return Affirmation.create(text: "You have no delusions left. Create some.");
    }
    return all[Random().nextInt(all.length)];
  }

  final List<Affirmation> _library = [
    // --- OVERTHINKER ---
    Affirmation.create(
      text: "Congrats on winning the argument you had with yourself in the shower.",
      localizedText: {
        DopeLanguage.en: "Congrats on winning the argument you had with yourself in the shower.",
        DopeLanguage.es: "Felicidades por ganar la discusión que tuviste contigo mismo en la ducha.",
        DopeLanguage.hi: "शावर में खुद से हुई बहस जीतने के लिए बधाई।",
        DopeLanguage.fr: "Félicitations pour avoir gagné la dispute que tu as eue avec toi-même sous la douche.",
        DopeLanguage.de: "Glückwunsch zum Sieg im Streit, den du unter der Dusche mit dir selbst geführt hast.",
      },
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Thinking about it for the 10th time won't change the outcome.",
      localizedText: {
        DopeLanguage.en: "Thinking about it for the 10th time won't change the outcome.",
        DopeLanguage.es: "Pensarlo por décima vez no cambiará el resultado.",
        DopeLanguage.hi: "10वीं बार इसके बारे में सोचने से परिणाम नहीं बदलेगा।",
        DopeLanguage.fr: "Y penser pour la 10ème fois ne changera pas le résultat.",
        DopeLanguage.de: "Zum zehnten Mal darüber nachzudenken wird das Ergebnis nicht ändern.",
      },
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your mind is a haunted house. Maybe stop giving yourself a guided tour.",
      localizedText: {
        DopeLanguage.en: "Your mind is a haunted house. Maybe stop giving yourself a guided tour.",
        DopeLanguage.es: "Tu mente es una casa embrujada. Quizás deja de darte un tour guiado.",
        DopeLanguage.hi: "आपका मन एक भूतिया घर है। शायद खुद को वहां की सैर कराना बंद करें।",
        DopeLanguage.fr: "Ton esprit est une maison hantée. Arrête peut-être de te faire visiter.",
        DopeLanguage.de: "Dein Verstand ist ein Geisterhaus. Hör vielleicht auf, dir selbst eine Führung zu geben.",
      },
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Doubt is just your brain trying to be helpful and failing.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER ---
    Affirmation.create(
      text: "Ship the ugly version. No one is looking anyway.",
      localizedText: {
        DopeLanguage.en: "Ship the ugly version. No one is looking anyway.",
        DopeLanguage.es: "Lanza la versión fea. Nadie está mirando de todos modos.",
        DopeLanguage.hi: "बदसूरत वर्शन ही भेज दो। वैसे भी कोई नहीं देख रहा है।",
        DopeLanguage.fr: "Lance la version moche. Personne ne regarde de toute façon.",
        DopeLanguage.de: "Veröffentliche die hässliche Version. Es sieht sowieso keiner hin.",
      },
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The perfect moment is a myth invented by people who don't build.",
      localizedText: {
        DopeLanguage.en: "The perfect moment is a myth invented by people who don't build.",
        DopeLanguage.es: "El momento perfecto es un mito inventado por personas que no construyen.",
        DopeLanguage.hi: "परफेक्ट मोमेंट एक मिथक है जिसे उन लोगों ने बनाया है जो कुछ नहीं बनाते।",
        DopeLanguage.fr: "Le moment parfait est un mythe inventé par des gens qui ne construisent rien.",
        DopeLanguage.de: "Der perfekte Moment ist ein Mythos, erfunden von Leuten, die nichts bauen.",
      },
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Action creates clarity. Sitting there creates dust.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your unfinished project isn't a failure, it's an expensive lesson.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT ---
    Affirmation.create(
      text: "Resting isn't a reward, it's maintenance.",
      localizedText: {
        DopeLanguage.en: "Resting isn't a reward, it's maintenance.",
        DopeLanguage.es: "Descansar no es una recompensa, es mantenimiento.",
        DopeLanguage.hi: "आराम करना कोई इनाम नहीं है, यह रखरखाव है।",
        DopeLanguage.fr: "Se reposer n'est pas une récompense, c'est de l'entretien.",
        DopeLanguage.de: "Ausruhen ist keine Belohnung, es ist Wartung.",
      },
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't end if you take a nap. I checked.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your value is not your productivity. You're not a forklift.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "That 'urgent' email can wait until you're a person again.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN ---
    Affirmation.create(
      text: "Your brain has 47 tabs open. Close the one playing music.",
      localizedText: {
        DopeLanguage.en: "Your brain has 47 tabs open. Close the one playing music.",
        DopeLanguage.es: "Tu cerebro tiene 47 pestañas abiertas. Cierra la que está reproduciendo música.",
        DopeLanguage.hi: "आपके दिमाग में 47 टैब खुले हैं। संगीत बजाने वाले को बंद करें।",
        DopeLanguage.fr: "Ton cerveau a 47 onglets ouverts. Ferme celui qui joue de la musique.",
        DopeLanguage.de: "Dein Gehirn hat 47 Tabs offen. Schließ den, der Musik spielt.",
      },
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Momentum beats motivation. Just move one inch.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Hyperfocus is a superpower until it's 3 am and you're learning about plumbing.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Five minutes of focus is better than zero minutes of perfection.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER ---
    Affirmation.create(
      text: "Ambition is just hunger with a better wardrobe.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You aren't behind. You're just on a different lap.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "The goalpost will always move. Enjoy the grass for a second.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "High standards are fine. Self-sabotage is just extra work.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 1) ---
    Affirmation.create(
      text: "Worrying about tomorrow only ruins today. And tomorrow.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "You can't solve a problem that hasn't happened yet.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is lying to you. It's just bored.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Analyzing the text message won't change what it says.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop rehearsing arguments for scenarios that have a 0% probability.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 1) ---
    Affirmation.create(
      text: "Code that works is better than code that is perfect.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop planning the empire. Lay one brick.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your 'great idea' is worthless until you execute it.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Failure is just data collection. Collect more data.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Optimizing prematurely is just procrastination with a fancy name.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 1) ---
    Affirmation.create(
      text: "Grinding until you break isn't a strategy, it's self-harm.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world will keep spinning if you close your eyes for an hour.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Productivity is not a personality trait.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You are allowed to be useless for a while.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 1) ---
    Affirmation.create(
      text: "You don't need a new planner. You need to use the one you have.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Do the thing for 5 minutes. If you hate it, stop. (You won't stop).",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop researching the perfect tool. The perfect tool is doing the work.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Close the tabs. All of them. Start fresh.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your potential is irrelevant if you never finish anything.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 1) ---
    Affirmation.create(
      text: "Comparison is the thief of joy and also your time.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Nobody cares about your resume as much as you do.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Success is a lagging indicator. Focus on the habits.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You are not your achievements. You are the person who achieved them.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Climbing the ladder is pointless if it's leaning against the wrong wall.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 2) ---
    Affirmation.create(
      text: "If overthinking burned calories, you'd be a supermodel.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The worst-case scenario usually requires more energy than the actual event.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "You are not a fortune teller. Stop predicting doom.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your anxiety is not intuition. It's just noise.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Maybe the silence doesn't mean they hate you. Maybe they're just busy.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 2) ---
    Affirmation.create(
      text: "Version 1 is supposed to suck. That's why it's Version 1.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "You don't need funding. You need a prototype.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Talking about your idea releases the same dopamine as doing it. Stop talking.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Constraints are not blockers. They are instructions.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "If you're not embarrassed by your first release, you launched too late.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 2) ---
    Affirmation.create(
      text: "Saying 'no' is a complete sentence. Try it.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your inbox is not a bomb. It won't explode if you ignore it.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Self-care isn't a bath bomb. It's setting boundaries.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You can't pour from an empty cup. Or a broken one.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Being busy is not the same as being important.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 2) ---
    Affirmation.create(
      text: "Multitasking is just screwing up several things at once.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Put the phone down. The dopamine hit isn't worth the time suck.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Write it down. You will not remember it. I promise.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Body doubling works. Find a nerd and sit next to them.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Forgive yourself for the lost hours. Start the next hour better.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 2) ---
    Affirmation.create(
      text: "Hustle culture is a pyramid scheme. Don't be the bottom layer.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Rest is not the enemy of ambition. Burnout is.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You don't have to be the best. You just have to be consistent.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your title is not your identity. Titles are rented.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Don't climb a mountain just so people can see you.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 3) ---
    Affirmation.create(
      text: "You are not the protagonist of everyone else's movie. They aren't watching you.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Replaying the conversation won't unlock a secret ending.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your gut feeling is probably just hunger. Eat something.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop trying to read minds. You're bad at it.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Perfection is a defense mechanism. Be messy.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 3) ---
    Affirmation.create(
      text: "Ideas are cheap. Execution is expensive.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Don't fall in love with your solution. Fall in love with the problem.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "If it's not broken, you haven't tested it enough.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Ship it. Fix it. Repeat.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your roadmap is a suggestion, not a religion.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 3) ---
    Affirmation.create(
      text: "Rest is a biological requirement. Even a failed system needs a reboot.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world is on fire. You don't have to be the extinguisher.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Disconnect to reconnect. Seriously, turn it off.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Surviving is enough for today. Barely.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 3) ---
    Affirmation.create(
      text: "Done is better than perfect and unfinished.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your brain is a Ferrari with bicycle brakes. Pump them gently.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Focus on one thing. Just one. For 10 minutes.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "You are not lazy. You just need a different gear.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Make a list. Lose the list. Make another list.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 3) ---
    Affirmation.create(
      text: "Don't let your ambition kill your joy.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "The finish line keeps moving. Enjoy the run.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You can have it all, just not all at once.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Be as kind to yourself as you are to your resume.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Impact over impression.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 4) ---
    Affirmation.create(
      text: "The monster under your bed is just a pile of laundry you haven't folded. Face it.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Overthinking is just a creative way to make yourself miserable. Stop being so artistic.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The 'what if' game always ends in a loss. Why play?",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is not a CPU. It doesn't need to process 100% of the data.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes it really is that simple. Don't add layers.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 4) ---
    Affirmation.create(
      text: "If you don't build it, someone dumber than you will.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your 'vision' is just a hallucination until there's a git commit.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Feedback is a gift. Even when it's wrapped in a insult.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Don't polish the bottom of the drawer. Ship it.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "A weekend of building is worth a month of reading.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 4) ---
    Affirmation.create(
      text: "The 'grind' is just a slow way to turn into dust.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You are not a machine. Even machines need downtime.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Exhaustion is not a status symbol. It's a failure of management.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Take a day off. The corporation doesn't love you back.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Doing nothing is a skill. Practice it.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 4) ---
    Affirmation.create(
      text: "Your novelty-seeking brain is a toddler. Give it a boring toy and get to work.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The 'spark' is a lie. Discipline is the only real light.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. No music. No snacks. Just 15 minutes.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'productive' distraction is still a distraction.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Forget the system. Just do the most obvious thing.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 4) ---
    Affirmation.create(
      text: "Success doesn't have a final level. It's just more work.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your ego is writing checks your health can't cash.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop networking and start working. Your value will attract the network.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "The path to the top is lonely because most people are smart enough to stay down.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Don't mistake motion for progress.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 5) ---
    Affirmation.create(
      text: "You're solving problems that only exist in your head. Try solving some in reality.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The past is a graveyard. Stop digging up old bones to see if they're still dead.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is an echo chamber. Open a window.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Worrying is like a rocking chair. It gives you something to do but gets you nowhere.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Shut the noise. The 'truth' doesn't need analysis.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 5) ---
    Affirmation.create(
      text: "Architecture is for people who are afraid to build. Start coding.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your masterpiece is waiting for you to stop being lazy.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "A broken product is better than a perfect imagination.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Don't build for the world. Build for the one person who cares. Probably you.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Iteration is the only way to avoid absolute failure.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 5) ---
    Affirmation.create(
      text: "Your 'best' changes day to day. Today, your best is just showing up.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The candles are out. Stop trying to light the wick with your own soul.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Burnout is not a badge. It's a bill you can't pay.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You are more than the tasks you complete.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Give yourself permission to be average for a week.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 5) ---
    Affirmation.create(
      text: "Your brain is a pinball machine. Control the flippers.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The project you started today is just a distraction from the one you should have finished yesterday.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Hyperfocus is just obsession with a better PR team.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One page. One paragraph. One sentence. Just start.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop fighting your brain. Work around it.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 5) ---
    Affirmation.create(
      text: "Status is a drug. You're addicted.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "If success was easy, the view from the top would be crowded with idiots.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop chasing the 'win' and start enjoying the game.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your ambition is a double-edged sword. Don't cut yourself.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Legacy is for dead people. Live now.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 6) ---
    Affirmation.create(
      text: "Thinking doesn't equate to doing. You're just spinning wheels in the mud.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The 'truth' doesn't have as many footnotes as your brain thinks it does.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop narrating your life and start living it.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "You are over-analyzing the silence. It just means nothing was said.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your mind is a heavy place. Put it down for a second.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 6) ---
    Affirmation.create(
      text: "A demo is worth a thousand meetings.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop optimizing for scale you don't have yet.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your tech stack is a vanity project. Build the value first.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The hard parts are the only parts that matter.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Don't ask for permission. Build it and see who tries to stop you.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 6) ---
    Affirmation.create(
      text: "The pressure you feel is mostly imaginary. Let it pop.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "It's okay to let people down if it saves your sanity.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your worth is not tied to your output. You're a person, not a factory.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Rest is a requirement, not a suggestion.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 6) ---
    Affirmation.create(
      text: "Your 'rabbit hole' is just a sophisticated form of hiding.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The routine isn't boring. Your inability to stick to it is the problem.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Simplify the task until it's stupidly easy. Then do it.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop waiting for the 'vibe' to be right. The vibe is work.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your brain is a crowded room. Exit the conversation.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 6) ---
    Affirmation.create(
      text: "The view from the top is still just dirt and rocks. Be here.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You're winning at games that don't matter.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Ambition without direction is just frantic movement.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You are replaceable at work. You are not replaceable at home.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop trying to win. Start trying to contribute.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 7) ---
    Affirmation.create(
      text: "You're predicting outcomes based on fears, not facts.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The loop in your head isn't a strategy. It's a cage.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop over-engineering your happiness.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is making a mountain out of a molehill. Step over it.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Worrying doesn't empty tomorrow of its sorrow, it empties today of its strength. (And also makes you annoying).",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 7) ---
    Affirmation.create(
      text: "Stop watching tutorials and start making mistakes.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best time to plant a tree was 20 years ago. The second best time is to stop complaining and dig a hole.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Simplicity is the ultimate sophistication. Your current code is just a mess.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Don't build features. Solve problems.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "A project is finished when there's nothing left to take away.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 7) ---
    Affirmation.create(
      text: "Your productivity is zero if you're dead. Rest.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Stop trying to light everyone else's path while you're freezing.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The 'hustle' is just a pretty word for exhaustion.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You don't owe the world your mental health.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Close the laptop. The simulated world will wait.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 7) ---
    Affirmation.create(
      text: "Your brain is a high-speed train with no tracks. Build some rails.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The distraction isn't more interesting. It's just newer.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop waiting for the 'right moment' to be focused. It doesn't exist.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One thing at a time. No, really. Just one.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your to-do list is a wishlist. Pick two and do them.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 7) ---
    Affirmation.create(
      text: "Your worth is not a number on a screen.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "The goal is progress, not perfection. (But try to be good).",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop chasing ghosts of success.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You're competing against a version of yourself that doesn't exist.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Success is just failing until you don't.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 8) ---
    Affirmation.create(
      text: "You're overthinking the solution to a problem you don't even have yet. Efficient.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The voices in your head are just you talking to yourself. And you're being a jerk.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Analyzing every word of that email won't reveal a hidden map to treasure.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is a high-performance engine running on low-quality fuel. Stop.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "It is what it is. No matter how much you think about it.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 8) ---
    Affirmation.create(
      text: "Don't build for tomorrow's scale. Build for today's user.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your 'master plan' is just a fancy way to avoid doing the hard work.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best product is the one that's finished.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop bikeshedding the color of the button. Fix the backend.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Code is a liability. Only build what you need.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 8) ---
    Affirmation.create(
      text: "You're not 'pushing through', you're just dragging a dead weight. Rest.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The light at the end of the tunnel is a train. Move.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Resting is not a sign of weakness. It's a sign of intelligence.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You've done enough. Seriously.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't collapse if you take a nap. I checked the physics.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 8) ---
    Affirmation.create(
      text: "Your brain is a browser with too many windows open. Force quit.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The 'perfect flow' is a myth. Just do the work while you're distracted.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the magic pill. The magic is in the effort.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. Complete it. Then move on. (Try really hard).",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just procrastination in a costume.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 8) ---
    Affirmation.create(
      text: "You're sacrificing your present for a future that might never happen.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Ambition is fine. Obsession is a disease.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You're not behind. You're just on a path you didn't plan.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "The ladder to success is leaning against a wall that's going to crumble.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop measuring your worth by your bank account.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 9) ---
    Affirmation.create(
      text: "You're writing a script for a play that will never be performed. Stop.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The voices in your head are just you echoing your own fears. Shhh.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Analyzing the tone of that text message won't tell you how they feel.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is an expert at finding problems where none exist. Don't listen to it.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes 'okay' just means 'okay'. Not 'it's over'.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 9) ---
    Affirmation.create(
      text: "Stop building things nobody asked for. Talk to a human.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your 'next big thing' is just a distraction from the 'current big thing' you're ignoring.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "A simple solution that works is better than a complex one that doesn't.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop obsessing over the technology. Start obsessing over the problem.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Build something ugly. It's the only way to build something beautiful eventually.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 9) ---
    Affirmation.create(
      text: "You're not a hero for suffering in silence. You're just exhausted.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The 'hustle' is a lie. Balance is the only real wealth.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You don't need another coffee. You need a nap. And a week off.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your brain is fried. Stop trying to cook with it.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Permission to be completely average granted. Just for today.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 9) ---
    Affirmation.create(
      text: "Your brain is a carnival. Enjoy the ride, but don't lose your wallet.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new thing is just a shiny old thing in a new costume. Focus.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the 'perfect system'. The system is doing the work.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One thing. Just one. Don't look at anything else.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just your brain trying to avoid the boring parts.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 9) ---
    Affirmation.create(
      text: "You're trying to win a race that has no finish line. Slow down.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Success is not a destination. it's a treadmill you can't get off.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop trying to prove yourself to people who don't care.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your 'dream' is just a high-pressure job with better branding.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You don't have to be the best. You just have to be good enough.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 10) ---
    Affirmation.create(
      text: "You're predicting the future based on your worst-case scenarios. Boring.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The past is a prison you're building yourself. Unlock the door.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop analyzing the 'vibes'. The vibes are just your anxiety.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is a complicated machine. Sometimes it just needs a reset. (Go to sleep).",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes 'maybe' just means 'no'. Accept it.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 10) ---
    Affirmation.create(
      text: "Architecture is just drawing pictures if nobody's building it. Start drawing with code.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your tech stack is a vanity project. Your users don't care.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best product is the one that solves a real problem. Even if it's ugly.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop over-engineering the solution to a simple problem. Simple is better.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Build something that matters. Even if it's small.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 10) ---
    Affirmation.create(
      text: "You're not 'lazy', you're depleted. There's a difference.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't end if you take a day off. It really won't.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your worth is not measured by the number of hours you work.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Take a break. Your sanity depends on it.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Permission to be completely human granted. Just for today.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 10) ---
    Affirmation.create(
      text: "Your brain is a superpower if you can control the throttle. Slow down.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new thing is just a distraction from the important thing. Focus.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the 'magic pill'. The magic is in the effort.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. Complete it. Then move on. (Try really hard).",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just your brain trying to avoid the boring parts.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 10) ---
    Affirmation.create(
      text: "You're trying to win a race that has no finish line. Slow down.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Success is not a destination. it's a treadmill you can't get off.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop trying to prove yourself to people who don't care.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your 'dream' is just a high-pressure job with better branding.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You don't have to be the best. You just have to be good enough.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 11) ---
    Affirmation.create(
      text: "Stop analyzing the 'vibes'. The vibes are just your anxiety wearing a costume.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "You're writing a script for a drama that's never going to air. Cancel the series.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The past is a finished book. Stop trying to edit the previous chapters.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is an overactive child. Give it a boring task and it'll shut up.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Thinking about it for the 100th time is just an expensive way to stay stuck.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 11) ---
    Affirmation.create(
      text: "Stop bikeshedding the CSS and fix the broken logic. Users like things that work.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your tech stack is a vanity project until someone actually pays for it.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best feature is the one you deleted because it was useless.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Ship early, ship often, ship ugly.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Iteration is the only path to competence. Stop being afraid of Version 0.1.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 11) ---
    Affirmation.create(
      text: "You're not a hero for working through your lunch break. You're just hungry and tired.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The 'hustle' is just a slow form of self-destruction. Take a day off.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The corporation will replace you in a week. Your family won't. Prioritize accordingly.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "It's okay to be unproductive. You are a person, not a spreadsheet.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 11) ---
    Affirmation.create(
      text: "The 'perfect system' is the one you actually use. Even if it's just a sticky note.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the magic productivity pill. The magic is in just starting.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One thing at a time. No, really. Just one.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your potential is a heavy burden. Drop it and just do the work.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your brain is a high-speed train with no tracks. Build some rails.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 11) ---
    Affirmation.create(
      text: "Success is a treadmill. You're running fast, but the scenery never changes. Hop off.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You're competing against a ghost of a version of yourself that doesn't exist.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your worth is not tied to your bank account or your title.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Ambition is fine, but don't let it turn you into a person you hate.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop chasing the 'win' and start enjoying the game.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 12) ---
    Affirmation.create(
      text: "You're predicting disaster with 0% data. That's just creative writing with a bad plot.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The voices in your head aren't experts. They're just echoing your fears. Mute the tab.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Analyzing every word of that email won't reveal a hidden message. It really is that boring.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes it's not a sign from the universe. It's just a coincidence. Get over it.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop rehearsals for scenarios that have a 0% probability of happening.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 12) ---
    Affirmation.create(
      text: "Don't build for tomorrow's scale. Build for today's single user. (Who is probably you).",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your 'master plan' is just a fancy way to avoid doing the hard work. Lay one brick.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best product is the one that exists. Everything else is a hallucination.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Feedback is a gift. Even if it's a gift-wrapped insult. Open it.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Code is a liability. Only build the essential. Every line is a potential bug.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 12) ---
    Affirmation.create(
      text: "You're not 'pushing through', you're just dragging a dead weight. That weight is you. Rest.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The light at the end of the tunnel might be an oncoming train. Step off the tracks for a while.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Resting is not a sign of weakness. It's a sign of intelligence. Only idiots work until they break.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You've done enough for today. And probably for the rest of the week. Log off.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't collapse if you take a nap. I checked the physics. You're fine.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 12) ---
    Affirmation.create(
      text: "Your brain is a high-speed engine running on low-quality fuel. Stop. Refuel with focus.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new project is just a distraction from the important thing you're ignoring. Go back.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the 'magic pill'. The magic is in the effort of starting. Just start.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. Complete it. Then move on. No, don't look at that other thing. FOCUS.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just procrastination in a pretty costume. Don't fall for it.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 12) ---
    Affirmation.create(
      text: "You're sacrificing your present for a future that might never happen. Is it worth it?",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Ambition is fine. Obsession is a disease. Know the difference before you're sick.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You're not behind. You're just on a path you didn't plan. Stop comparing.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "The ladder to success is leaning against a wall that's going to crumble eventually. Be careful.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop measuring your worth by your bank account. It's a shallow metric.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 13) ---
    Affirmation.create(
      text: "You're trying to solve a puzzle with pieces from three different boxes. Give up and go to sleep.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The 'what-if' game is a race to the bottom. Congratulations, you're winning.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is an expert at creating problems out of thin air. It's not a superpower.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Analyzing the tone of that text message won't change the fact that they're just busy.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes 'fine' actually means 'fine'. Stop looking for the hidden meaning.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 13) ---
    Affirmation.create(
      text: "Stop building monuments to your potential and start building tools for your survival.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your 'next big project' is just an excuse to avoid finishing the current one.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "A simple solution that works is infinitely better than a complex one that doesn't.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop obsessing over the technology and start obsessing over the problem you're solving.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Build something ugly. It's the only way to eventually build something beautiful.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 13) ---
    Affirmation.create(
      text: "You're not a hero for suffering in silence. You're just a person who needs a nap.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The 'hustle' is just a pretty word for 'unresolved trauma'. Take a day off.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You don't need another productivity hack. You need to do less. A lot less.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your brain is fried. Stop trying to cook with it and let it cool down.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Permission to be completely average granted for the next 24 hours.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 13) ---
    Affirmation.create(
      text: "Your brain is a carnival. It's fun, but eventually you need to leave the fairground.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new thing is just a shiny old thing in a new costume. Stay focused.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop searching for the 'perfect system'. The system is just doing the work.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One thing. Just one thing. Don't look at anything else until it's done.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just your brain trying to avoid the boring parts. Discipline them.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 13) ---
    Affirmation.create(
      text: "You're running a race where the finish line is just a mirage. Slow down and drink water.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Success is not a destination, it's just a treadmill you can't get off easily.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop trying to prove yourself to people who will never be impressed anyway.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your 'dream' is just a high-pressure job with better marketing. Re-evaluate.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You don't have to be the best. You just have to be good enough to not hate yourself.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 14) ---
    Affirmation.create(
      text: "You're writing a script for a play that will never be performed. Cancel the show.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The past is a finished book. Stop trying to re-edit previous chapters. Move on.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is an echo chamber of your own insecurities. Open a window.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop analyzing the 'energy'. The energy is just your blood sugar dropping. Eat.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes it's not deep. It's just a shallow pool. Stop diving.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 14) ---
    Affirmation.create(
      text: "Stop bikeshedding the color of the button and fix the broken logic underneath.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your tech stack is a vanity project until someone actually pays for the output.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best feature is the one you deleted because it added no value. Simplify.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Ship early, ship often, ship ugly. Perfection is the enemy of progress.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Iteration is the only path to competence. Stop being afraid of Version 0.1.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 14) ---
    Affirmation.create(
      text: "You're not a hero for working through your lunch break. You're just hungry.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The 'hustle' is just a slow form of self-destruction. Take a day off. Or three.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The corporation will replace you in a week. Your family won't. Prioritize.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "It's okay to be unproductive. You are a person, not a human-shaped spreadsheet.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 14) ---
    Affirmation.create(
      text: "The 'perfect system' is the one you actually use. Even if it's just a sticky note.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the magic productivity pill. The magic is in the first 5 minutes.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. Complete it. Then move on. Don't look at the other 47 things.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your potential is a heavy burden. Drop it and just do the work in front of you.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your brain is a high-speed train with no tracks. Start building some rails.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 14) ---
    Affirmation.create(
      text: "Success is a treadmill. You're running fast, but the scenery never changes.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You're competing against a ghost of a version of yourself that doesn't exist.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your worth is not tied to your bank account or the title on your business card.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Ambition is fine, but don't let it turn you into someone you'd hate to meet.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop chasing the 'win' and start actually enjoying the game you're playing.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 15) ---
    Affirmation.create(
      text: "You're trying to solve a puzzle with pieces from three different boxes. Give up and go to sleep. It's not happening tonight.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The 'what-if' game is a race to the bottom. Congratulations, you're currently in the lead. Quit while you're ahead.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is an expert at creating problems out of thin air. It's not a gift, it's just a bug in your software.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Analyzing the tone of that text message won't change the fact that they're just busy living their life while you're stuck in yours.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes 'fine' actually means 'fine'. Stop looking for the hidden tragedy in every syllable.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 15) ---
    Affirmation.create(
      text: "Stop building monuments to your potential and start building tools for your survival. Potential doesn't pay the bills.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your 'next big project' is just an excuse to avoid finishing the current one. Finish something. Anything.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "A simple solution that works is infinitely better than a complex one that lives in your head. Put down the whiteboard.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop obsessing over the technology and start obsessing over the problem you're supposedly solving. The stack doesn't matter if the value is zero.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Build something ugly. It's the only way to eventually build something beautiful. Perfection is for people who don't actually build.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 15) ---
    Affirmation.create(
      text: "You're not a hero for suffering in silence. You're just a person who desperately needs a nap. Go find a pillow.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The 'hustle' is just a pretty word for 'unresolved burnout'. Take a day off before the system forces one on you.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You don't need another productivity hack. You need to do less. A lot less. Start by doing nothing for ten minutes.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your brain is fried. Stop trying to cook with it and let it cool down before you burn the whole house down.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Permission to be completely average granted for the next 24 hours. No expectations, no pressure, no guilt.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 15) ---
    Affirmation.create(
      text: "Your brain is a carnival. It's fun for a while, but eventually, you need to leave the fairground and go home to reality.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new thing is just a shiny old thing in a new costume. Stay focused on the boring task. It's the only one that matters.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop searching for the 'perfect system'. The system is just a distraction from the actual work. Do the work.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One thing. Just one thing. Don't look at anything else until it's done. I'm serious. Close the other tabs.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just your brain trying to avoid the parts that aren't fun. Discipline them. They need it.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 15) ---
    Affirmation.create(
      text: "You're running a race where the finish line is just a mirage. Slow down and drink some water before you collapse from dehydration.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Success is not a destination, it's just a treadmill you can't get off easily once you've started running. Check your pace.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop trying to prove yourself to people who will never be impressed anyway. Their approval is a ghost. Stop chasing it.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your 'dream' is just a high-pressure job with better marketing. Re-evaluate what you're actually sacrificing for it.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You don't have to be the best. You just have to be good enough to not hate yourself when you look in the mirror.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 16) ---
    Affirmation.create(
      text: "Analyzing your past failures won't prevent future ones. It just ruins your present. Put the telescope down.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The universe isn't testing you. It's not even looking at you. Stop looking for signs in the static.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is a haunted house. Maybe stop giving yourself a guided tour of the cellar every night.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Doubt is just a lazy way of being careful. Be brave instead. Or at least be decisive.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "You can't think your way into a new way of acting. You have to act your way into a new way of thinking. Move your legs.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 16) ---
    Affirmation.create(
      text: "The 'perfect' tech stack is the one that allows you to ship tomorrow. Everything else is just bikeshedding.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Code is a liability. The best feature is the one you had the courage to delete. Kill your darlings.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop waiting for inspiration. Inspiration is for amateurs. Pros just show up and build through the boredom.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your competition isn't the guy with the big funding. It's the guy who builds more in a weekend than you do in a month.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "A demo that crashes is still better than a slideshow that works perfectly. Show me the code.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 16) ---
    Affirmation.create(
      text: "The feeling of being 'behind' is a marketing tactic designed to keep you working. Ignore the ads.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Saying 'no' to others is saying 'yes' to yourself. Start being selfish. Your sanity depends on it.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "If you don't pick a day to rest, your body will pick one for you. And it'll be a lot less convenient.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Working hard is overrated. Working sustainably is the only way to not turn into a husk.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 16) ---
    Affirmation.create(
      text: "Your brain is a browser with 40 tabs open and music playing somewhere you can't find. Mute the whole thing.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Novelty is a drug. You're chasing the high of a new project. Finish the old one instead. It's better for the soul.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The hardest part is the transition between tasks. Stop thinking about the next thing and just finish this one.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Time is linear, even if your brain thinks it's a circle. You only have so many minutes today. Use them wisely.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Hyperfocus is a superpower until it's 3 AM and you're researching the history of spoons. Go to bed.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 16) ---
    Affirmation.create(
      text: "Ambition is just hunger with a better wardrobe. Don't let it starve you of your humanity.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "The top of the mountain is just a place where it's harder to breathe. Enjoy the oxygen down here while you can.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You're trying to win at a game that you didn't even sign up for. Check the rules. They might be stupid.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Status is a currency that's only valuable to people who are as insecure as you are. Get a new bank.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Don't burn your life to keep your resume warm. Resumes don't have feelings.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 17) ---
    Affirmation.create(
      text: "The reason you're stuck is that you're trying to calculate the trajectory of a footstep before taking it. Just trip and see where you land.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "You are not a detective. Stop trying to find the hidden 'meaning' behind a two-word text from 2019.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Thinking is just a way to delay the inevitable. The inevitable doesn't care how long you wait.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is a loop of bad news. Break the circuit and go do something physical. Fold a sock.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The script you're writing in your head is a tragedy. Why not write a comedy instead? Or better yet, don't write anything.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 17) ---
    Affirmation.create(
      text: "If you spent half as much time building as you do reading about building, you'd be a billionaire by now. Log off.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your users don't care about your clean code. They care about their problems being solved. Ship the mess.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "A project is never 'finished', only abandoned. Abandon this version and move to the next one.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The hard part isn't the code. The hard part is the discipline to keep working when the novelty is gone.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Don't build for 'everyone'. Everyone is a ghost. Build for someone specific. Even if it's your dog.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 17) ---
    Affirmation.create(
      text: "You're trying to win a game that has no prize for the most exhausted player. Slow down.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't end if you're not the one fixing it. It's been around for billions of years without your help.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Rest is not a biological requirement.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your inbox will never be empty. Your soul, however, is currently dangerously close. Take a nap.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Being busy is a choice. A bad one. Choose something else today.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 17) ---
    Affirmation.create(
      text: "Your brain is a scattered desk. You don't need a new desk. You need to pick up one piece of paper.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The 'zone' is a myth. Most productive work happens when you're slightly bored and very annoyed. Just do it.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One thing. Just one. For the next five minutes. Don't look at the phone. Don't look at the clock.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your potential is a theoretical concept. Your results are the only reality. Focus on the reality.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Forget the 'perfect' way to do it. The 'stupid' way that gets done is infinitely better.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 17) ---
    Affirmation.create(
      text: "You're competing against people who are running toward a finish line that doesn't exist. Hop off the track.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Ambition is fine, but don't let it become your only personality trait. It's boring.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You're not behind. You're just exactly where you've been working to be. Own it.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop looking at the 'top' and start looking at the 'now'. The top is just more stairs.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your legacy is not your LinkedIn profile. No one reads that at funerals.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 18) ---
    Affirmation.create(
      text: "You're writing a script for a play that will never be performed. Cancel the series and go outside.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The reason you're so tired is because you're fighting battles that only exist in your head. Put down the sword.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is an expert at finding the one thing wrong in a field of things right. Don't let it win today.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Analyzing the tone of that email won't reveal a hidden truth. It really is just a poorly written email.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes 'maybe' just means 'no'. Accept it and move on before you waste another hour.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 18) ---
    Affirmation.create(
      text: "Architecture is just drawing pictures until someone actually builds something. Start drawing with code.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your tech stack is a vanity project. Your users don't care about the tools, they care about the result. Build the result.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best product is the one that solves a real problem. Even if it's ugly and barely works. Ship it.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop over-engineering the solution to a simple problem. Simple is better. Complex is just extra work.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Build something that matters. Even if it's only to you. Especially if it's only to you.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 18) ---
    Affirmation.create(
      text: "You're not 'lazy', you're depleted. There's a difference. One needs motivation, the other needs a nap. Go sleep.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't end if you take a day off. It really won't. I checked the manual. You're fine.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your worth is not measured by the number of hours you work or the number of emails you send. You're more than a metric.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Take a break. Your sanity depends on it. The work will still be there when you get back. Unfortunately.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Permission to be completely human granted. Just for today. No deadlines, no pressure, just being.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 18) ---
    Affirmation.create(
      text: "Your brain is a superpower if you can control the throttle. Slow down and focus on one thing for five minutes.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new thing is just a distraction from the important thing you're avoiding. Go back to the important thing.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the 'magic pill'. The magic is in the effort of starting. Just start. Anywhere.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. Complete it. Then move on. Don't look at anything else until it's done. I'm serious.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just your brain trying to avoid the boring parts of the job. Discipline the child.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 18) ---
    Affirmation.create(
      text: "You're trying to win a race that has no finish line. Slow down and enjoy the scenery before you collapse.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Success is not a destination, it's a treadmill you can't get off easily. Check your pace before you burn out.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop trying to prove yourself to people who don't care. Their approval won't fill the void.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your 'dream' is just a high-pressure job with better branding. Re-evaluate what you're actually working for.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You don't have to be the best. You just have to be good enough to not hate your life.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 19) ---
    Affirmation.create(
      text: "You're trying to decode a message that was never even coded. It's just a simple sentence. Relax.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The reason you're stuck is that you're trying to solve for 'x' when 'x' doesn't even exist in this equation.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is a filter that only lets the bad news through. Clean the filter.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop analyzing the 'vibes'. The vibes are just your own internal monologue projecting outwards.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes it's just a bad day. It doesn't mean your entire life is a failure. Chill.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 19) ---
    Affirmation.create(
      text: "Stop talking about 'disrupting the industry' and start fixing your CSS. One step at a time.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your 'scaling problem' is a fantasy. You have zero users. Build for one.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best tech stack is the one you already know. Everything else is just a distraction from building.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Code that isn't shipped doesn't exist. It's just a waste of electricity.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Build something that solves your own problem first. At least you'll have one user.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 19) ---
    Affirmation.create(
      text: "You're not 'lazy', you're just out of fuel. You can't run an engine on fumes. Go refuel. (Sleep).",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't end if you don't check your email for 12 hours. I promise.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your worth is not tied to your productivity. You are a person, not a human-shaped factory.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Take a break. Your brain needs to cool down before it melts completely.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Permission to be completely unproductive granted. Go do something useless.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 19) ---
    Affirmation.create(
      text: "Your brain is a browser with too many windows open. Force quit and start fresh.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new thing is just a shiny old thing in a new costume. Focus on the task at hand.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the 'perfect system'. The system is just a distraction from the work. Do the work.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One thing at a time. No, really. Just one thing. Don't look at anything else.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just your brain trying to avoid the boring parts of the job. Discipline it.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 19) ---
    Affirmation.create(
      text: "You're running a race where the finish line is just a mirage. Slow down and enjoy the run.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Success is not a destination, it's just a treadmill you can't get off easily. Check your pace.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop trying to prove yourself to people who will never be impressed anyway. Their opinion is irrelevant.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your 'dream' is just a high-pressure job with better branding. Re-evaluate what you're working for.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You don't have to be the best. You just have to be good enough to not hate your life.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 20) ---
    Affirmation.create(
      text: "You're trying to solve a problem that only exists because you're bored. Find a hobby.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The past is a graveyard. Stop digging up old bones to see if they're still dead. They are.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is an echo chamber of your own fears. Open a window and let some fresh reality in.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop analyzing the 'energy' of the room. It's just a room. Sit down.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes 'no' just means 'no'. It doesn't mean you're a failure. Stop the drama.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 20) ---
    Affirmation.create(
      text: "Stop talking about 'scaling' and start talking to your first customer. If you have one.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your tech stack is a vanity project. Your users don't care if it's Rust or Ruby. They care if it works.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best product is the one that actually gets used. Everything else is just a hobby.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop over-engineering the solution to a simple problem. Simple is better. Complex is just extra work.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Build something that matters. Even if it's small. Especially if it's small.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 20) ---
    Affirmation.create(
      text: "You're not 'lazy', you're depleted. There's a biological limit to your output. You hit it yesterday.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't end if you take a day off. It really won't. I checked the logs.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your worth is not measured by the number of hours you work or the number of bugs you fix.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Take a break. Your sanity is worth more than any deadline.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Permission to be completely human granted. Just for today. No expectations.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 20) ---
    Affirmation.create(
      text: "Your brain is a superpower if you can control the throttle. Slow down and focus for five minutes.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new thing is just a shiny old thing in a new costume. Focus on the task at hand.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the 'magic system'. The system is just doing the work. Do the work.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. Complete it. Then move on. Don't look at anything else until it's done.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just your brain trying to avoid the boring parts of the job. Discipline it.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 20) ---
    Affirmation.create(
      text: "You're trying to win a race that has no finish line. Slow down and enjoy the run.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Success is not a destination, it's just a treadmill you can't get off easily. Check your pace.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop trying to prove yourself to people who don't care. Their opinion is irrelevant.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your 'dream' is just a high-pressure job with better branding. Re-evaluate what you're working for.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You don't have to be the best. You just have to be good enough to not hate your life.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 21) ---
    Affirmation.create(
      text: "You're trying to solve a problem that only exists because you're bored. Find something else to do.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The past is dead. Stop trying to perform CPR on it. Let it go.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is a filter that only lets the negative through. Clean the filter today.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop analyzing the 'energy' of the room. Just sit down and exist.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes 'no' is just a 'no'. It's not a commentary on your entire existence.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 21) ---
    Affirmation.create(
      text: "Stop talking about 'scaling' and start talking to your first user. If you have one.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your tech stack is a vanity project. Your users only care if the thing works.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best product is the one that actually gets used. Everything else is a hobby.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop over-engineering the solution to a simple problem. Simple is better for everyone.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Build something that matters. Even if it's small. Especially if it's small and works.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 21) ---
    Affirmation.create(
      text: "You're not 'lazy', you're depleted. There's a biological limit to your output. Respect it.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't end if you take a day off. It really won't. I checked the logs.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your worth is not measured by the number of hours you work or the number of bugs you fix.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Take a break. Your sanity is worth more than any deadline you're stressing about.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Permission to be completely human granted. Just for today. No expectations, no pressure.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 21) ---
    Affirmation.create(
      text: "Your brain is a superpower if you can control the throttle. Slow down and focus for five minutes.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new thing is just a distraction from the important thing you're avoiding.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the 'magic system'. The system is just doing the work. Start doing.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. Complete it. Then move on. Don't look at anything else until it's done.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just your brain trying to avoid the boring parts of the job.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 21) ---
    Affirmation.create(
      text: "You're trying to win a race that has no finish line. Slow down and enjoy the run.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Success is not a destination, it's just a treadmill you can't get off easily. Check your pace.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop trying to prove yourself to people who don't care. Their opinion is irrelevant.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your 'dream' is just a high-pressure job with better branding. Re-evaluate your goals.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You don't have to be the best. You just have to be good enough to not hate your life.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 22) ---
    Affirmation.create(
      text: "You're trying to solve for 'x' when 'x' doesn't even exist in this equation. Chill out.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The reason you're stuck is because you're trying to calculate the trajectory of a step before taking it.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is a loop of bad news. Break the circuit and go fold a sock. Just one.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Analyzing your past failures won't prevent future ones. It just ruins your present.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The 'what-if' game is a race to the bottom. congratulations, you're currently winning.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 22) ---
    Affirmation.create(
      text: "Version 1 is supposed to suck. That's why it's Version 1. Ship it anyway.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "You don't need another course. You need a prototype. Put down the book and build.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Talking about your idea releases the same dopamine as doing it. Stop talking and start doing.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Constraints are not blockers. They are the rules of the game. Play better.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "If you're not embarrassed by your first release, you launched too late. Go now.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 22) ---
    Affirmation.create(
      text: "Saying 'no' is a complete sentence. You should try using it more often.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your inbox is not a ticking bomb. It won't explode if you ignore it for an hour.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Self-care is not a bath bomb. It's setting boundaries that make people slightly annoyed.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You can't pour from an empty cup. Or a cup that's currently on fire. Stop.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Being busy is not a personality trait. It's just a failure of prioritization.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 22) ---
    Affirmation.create(
      text: "Multitasking is just an efficient way to screw up several things at once. Do one thing.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Put the phone down. The dopamine hit you're looking for isn't in that app.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Write it down. You will not remember it. Your brain is a sieve, not a vault.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Body doubling works. Find someone to sit near you while you do the boring stuff.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Forgive yourself for the lost hours. Start the next hour fresh. It's all you can do.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 22) ---
    Affirmation.create(
      text: "Hustle culture is a pyramid scheme. Don't be the foundation. Be the one who left.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Rest is not the enemy of ambition. Burnout is the enemy of survival. Choose wisely.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You don't have to be the best in the room. You just have to be the one who didn't quit.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your job title is rented. Your health is owned. Spend your energy where it counts.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Don't climb a mountain just so the world can see you. Climb it so you can see the world.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 23) ---
    Affirmation.create(
      text: "You are not the main character in everyone else's mind. They're too busy thinking about themselves.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Replaying that conversation won't unlock a secret ending. It's over. Move on.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your gut feeling is probably just indigestion. Eat a vegetable and stop worrying.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop trying to read between the lines. There's nothing there but blank space.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Perfection is a defense mechanism. Stop protecting yourself from being human.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 23) ---
    Affirmation.create(
      text: "Ideas are easy. Execution is the only thing that's actually hard. Get to work.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Don't fall in love with your solution. Fall in love with the problem. Or just fix it.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "If it's not broken, you haven't tested it with real people yet. Go find some.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Ship it. Fix it. Repeat. This is the only way anyone actually builds anything.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your roadmap is a work of fiction. Start building the reality.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 23) ---
    Affirmation.create(
      text: "The world is on fire. You don't have to be the extinguisher.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Disconnect from the noise to reconnect with your own heartbeat. Turn it off.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Surviving another day in the system is enough of an achievement. Well done.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 23) ---
    Affirmation.create(
      text: "Done is better than 'perfect but only in my head'. Close the file.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your brain is a high-speed train with no tracks. Build somerails with a timer.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Focus on one thing. Just one. For the next ten minutes. I'm watching you.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "You are not lazy. You just have a brain that's easily bored. Give it a toy.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Make a list. Lose it. Make another one. It's the process that counts, I guess.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 23) ---
    Affirmation.create(
      text: "Ambition is fine, but don't let it become a person you'd hate to have a drink with.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "The finish line is a mirage. Enjoy the grass under your feet while you're running.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You can have everything you want, but probably not all at the same time. Relax.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Be as patient with your progress as you are demanding of your potential.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Impact is more important than impression. Focus on the work, not the applause.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 24) ---
    Affirmation.create(
      text: "The reason you can't find the answer is that you're asking the wrong question. Stop asking.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is a filter that only lets the worst case scenarios through. Clean the filter.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Analyzing the tone of that text message won't change the fact that they're just busy.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes it's not a sign from the universe. It's just a coincidence. Get over it.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The loop in your head isn't a strategy. It's a cage. Break it and go for a walk.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 24) ---
    Affirmation.create(
      text: "Don't build for the world. Build for the one person who cares. (Probably just you).",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your tech stack is a vanity project. Your users don't care if it's Rust or Ruby. Build it.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best feature is the one you had the courage to delete. Kill your darlings and ship.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop over-engineering the solution to a simple problem. Simple is better for everyone.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "A weekend of building is worth a month of reading about building. Put the book down.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 24) ---
    Affirmation.create(
      text: "You're not 'lazy', you're depleted. There's a biological limit to your output. Respect it.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't end if you take a day off. It really won't. I checked the logs.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your worth is not measured by the number of hours you work or the number of bugs you fix.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Take a break. Your sanity is worth more than any deadline you're currently stressing about.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Permission to be completely human granted. Just for today. No expectations, no pressure.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 24) ---
    Affirmation.create(
      text: "Your brain is a carnival. It's fun, but eventually you have to go home. Go home now.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new thing is just a shiny old thing in a new costume. Focus on the work.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the 'perfect system'. The system is just doing the work. Start doing.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. Complete it. Then move on. Don't look at anything else until it's done.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just your brain trying to avoid the boring parts of the job.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 24) ---
    Affirmation.create(
      text: "Success is a treadmill. You're running fast, but the scenery never changes. Hop off.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You're competing against a version of yourself that doesn't exist. Stop it.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your worth is not tied to your bank account or the title on your business card.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Ambition is fine, but don't let it turn you into someone you'd hate to meet.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop chasing the 'win' and start enjoying the game you're actually playing.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 25) ---
    Affirmation.create(
      text: "You're trying to solve a problem that only exists because you're bored. Find a hobby. Seriously.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The past is a graveyard. Stop digging up old bones to see if they're still dead. They are. Move on.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is an echo chamber of your own fears. Open a window and let some fresh reality in for once.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop analyzing the 'energy' of the room. It's just a room. Sit down and exist without a theory.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes 'no' just means 'no'. It doesn't mean you're a failure. Stop the internal drama.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 25) ---
    Affirmation.create(
      text: "Stop talking about 'scaling' and start talking to your first customer. If you actually have one.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your tech stack is a vanity project. Your users don't care if it's Rust or Ruby. They care if it works.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best product is the one that actually gets used by someone other than you. Everything else is a hobby.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Stop over-engineering the solution to a simple problem. Simple is better. Complex is just extra work.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Build something that matters. Even if it's small. Especially if it's small. Big things start small.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 25) ---
    Affirmation.create(
      text: "You're not 'lazy', you're depleted. There's a biological limit to your output. You hit it yesterday. Rest.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't end if you take a day off. It really won't. I checked the system logs. You're fine.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your worth is not measured by the number of hours you work or the number of bugs you fix today.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Take a break. Your sanity is worth more than any deadline. The work will wait. You might not.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Permission to be completely human granted. Just for today. No expectations, no pressure, just being.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 25) ---
    Affirmation.create(
      text: "Your brain is a superpower if you can control the throttle. Slow down and focus for just five minutes.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new thing is just a shiny old thing in a new costume. Focus on the task you started.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the 'magic system'. The system is just doing the work. The work is the system. Do it.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. Complete it. Then move on. Don't look at anything else until it's done. I'm serious this time.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just your brain trying to avoid the boring parts of the job. Discipline the child.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 25) ---
    Affirmation.create(
      text: "You're trying to win a race that has no finish line. Slow down and enjoy the run before you drop.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Success is not a destination, it's just a treadmill you can't get off easily. Check your heart rate.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop trying to prove yourself to people who don't care. Their opinion won't fill your bank account.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your 'dream' is just a high-pressure job with better branding. Re-evaluate what you're actually chasing.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You don't have to be the best. You just have to be good enough to not hate your reflection.",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 26) ---
    Affirmation.create(
      text: "You're building a fortress out of 'what-ifs'. It's impressive, but you're still living in a pile of rocks. Step outside.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Analyzing your anxiety won't make it disappear. It just gives it more attention. Ignore the brat.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes 'no' just means 'no'. It's not a secret code for your total inadequacy. Get over yourself.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Your brain is a filter that only lets the negative through. It's time for a deep clean.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop rehearsals for scenarios that have a zero percent chance of happening. It's a waste of mental RAM.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 26) ---
    Affirmation.create(
      text: "Stop bikeshedding the CSS and fix the broken logic underneath. Users like things that actually work.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your tech stack is a vanity project until someone actually pays for the output. Build the value first.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best feature is the one you had the courage to delete because it was useless clutter. Simplify.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Ship early, ship often, ship ugly. Perfection is just a fancy word for being afraid to fail.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Iteration is the only path to competence. Stop being afraid of Version 0.1 and just launch.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 26) ---
    Affirmation.create(
      text: "You're not a hero for working through your lunch break. You're just hungry, tired, and making mistakes.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The 'hustle' is just a slow form of self-destruction with better marketing. Take a day off before you break.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The corporation will replace you in a heartbeat. Your family won't. Prioritize the people who actually matter.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "It's okay to be unproductive. You are a human being, not a spreadsheet or a factory.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 26) ---
    Affirmation.create(
      text: "The 'perfect system' is the one you actually use. Even if it's just a messy pile of sticky notes. Use it.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the magic productivity pill. The magic is in the first five minutes of effort.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. Complete it. Then move on. Don't look at the other 47 things screaming for your attention.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your potential is a heavy burden. Drop it and just do the work that's right in front of you.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your brain is a high-speed train with no tracks. Start building some rails before you derail again.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 26) ---
    Affirmation.create(
      text: "Success is a treadmill. You're running fast, but the scenery never changes. Hop off and look around.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You're competing against a ghost of a version of yourself that doesn't exist. Stop fighting shadows.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Your worth is not tied to your bank account or the title on your business card. You're more than a metric.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Ambition is fine, but don't let it turn you into a person you would hate to have a conversation with.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop chasing the 'win' and start actually enjoying the game you're playing. Otherwise, what's the point?",
      persona: DopePersona.striver,
    ),

    // --- OVERTHINKER (Iteration 27) ---
    Affirmation.create(
      text: "You're predicting disaster with zero data points. That's just creative writing with a bad plot. Change the genre.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "The voices in your head aren't experts. They're just echoing your deepest fears. Mute the tab and move on.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Analyzing every word of that email won't reveal a hidden map to treasure. It really is just a poorly written email.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Sometimes it's not a sign from the universe. It's just a random coincidence. Get over it and stop searching.",
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Stop rehearsals for scenarios that have a 0% probability. You're wasting precious mental RAM on fiction.",
      persona: DopePersona.overthinker,
    ),

    // --- BUILDER (Iteration 27) ---
    Affirmation.create(
      text: "Don't build for tomorrow's scale. Build for today's single user. (Who is currently just you, let's be honest).",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Your 'master plan' is just a fancy way to avoid doing the hard, boring work. Put the plan down and lay one brick.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "The best product is the one that actually exists in reality. Everything else is just a collective hallucination.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Feedback is a gift. Even if it's a gift-wrapped insult. Open it, read it, and use it to build something better.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Code is a liability. Only build what is absolutely essential. Every extra line is just another potential bug.",
      persona: DopePersona.builder,
    ),

    // --- BURNT OUT (Iteration 27) ---
    Affirmation.create(
      text: "You're not 'pushing through', you're just dragging a dead weight behind you. That weight is your soul. Rest.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The light at the end of the tunnel might be an oncoming train. Step off the tracks for a while and find some grass.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Resting is not a sign of weakness. It's a sign of high intelligence. Idiots work until they break. Don't be one.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "You've done enough for today. And probably for the rest of the week. Log off and go be a person again.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "The world won't collapse if you take a nap. I checked the physics. You're fine. The sun will still rise.",
      persona: DopePersona.burntOut,
    ),

    // --- ADHD BRAIN (Iteration 27) ---
    Affirmation.create(
      text: "Your brain is a high-speed engine running on low-quality fuel. Stop and refuel with some actual focus today.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "The shiny new project is just a distraction from the important thing you're currently ignoring. Go back to the grind.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Stop looking for the 'magic pill'. The magic is in the messy effort of just starting. Anywhere. Just start.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "One task. Complete it. Then move on. No, don't look at that other thing. I see you. FOCUS.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Your 'inspiration' is just procrastination wearing a pretty costume. Don't fall for its lies. Do the boring stuff.",
      persona: DopePersona.adhdBrain,
    ),

    // --- STRIVER (Iteration 27) ---
    Affirmation.create(
      text: "You're sacrificing your present for a future that might never even happen. Ask yourself if it's actually worth it.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Ambition is fine. Obsession is a disease. Know the difference before you're too sick to enjoy the results.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "You're not behind. You're just on a path you didn't plan for. Stop comparing your map to everyone else's.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "The ladder to success is leaning against a wall that's going to crumble eventually. Be careful how high you climb.",
      persona: DopePersona.striver,
    ),
    Affirmation.create(
      text: "Stop measuring your worth by your bank account. It's a shallow metric for a deep human being. Re-evaluate.",
      persona: DopePersona.striver,
    ),

    // --- UNIVERSAL (Accessible to all personas) ---
    Affirmation.create(text: "Reality called. It wants you to stop scrolling."),
    Affirmation.create(text: "Drink water. You're basically a plant with complicated emotions."),
    Affirmation.create(text: "Validation is a drug. Get sober."),
    Affirmation.create(text: "Nobody actually knows what they're doing."),
    Affirmation.create(text: "Cringe is the price of admission for growth."),
    
    // --- TIME-BASED (Morning 7-10) ---
    Affirmation.create(text: "You woke up. That’s discipline."),
    Affirmation.create(text: "Sun's up. Unfortunately, so are you."),
    Affirmation.create(text: "Coffee first. Existential dread second."),

    // --- TIME-BASED (Late Night 0-2) ---
    Affirmation.create(text: "You don't need answers tonight. Sleep is allowed."),
    Affirmation.create(text: "Nothing good happens after 2 AM. Go to bed."),
    Affirmation.create(text: "Your brain is offline. Stop refreshing."),
  ];
}
