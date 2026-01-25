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
      text: "Your worries are just fan fiction about your life. Stop reading it.",
      localizedText: {
        DopeLanguage.en: "Your worries are just fan fiction about your life. Stop reading it.",
        DopeLanguage.es: "Tus preocupaciones son solo fan fiction sobre tu vida. Deja de leerlo.",
        DopeLanguage.hi: "आपकी चिंताएं आपके जीवन के बारे में सिर्फ काल्पनिक कहानियाँ हैं। उन्हें पढ़ना बंद करें।",
        DopeLanguage.fr: "Tes inquiétudes ne sont que de la fan fiction sur ta vie. Arrête de les lire.",
        DopeLanguage.de: "Deine Sorgen sind nur Fan-Fiction über dein Leben. Hör auf sie zu lesen.",
      },
      persona: DopePersona.overthinker,
      tone: DopeTone.chill,
    ),
    Affirmation(
      text: "Your brain is an unreliable narrator. Fact-check it.",
      localizedText: {
        DopeLanguage.en: "Your brain is an unreliable narrator. Fact-check it.",
        DopeLanguage.es: "Tu cerebro es un narrador poco fiable. Verifícalo.",
        DopeLanguage.hi: "आपका दिमाग एक अविश्वसनीय कथावाचक है। इसकी जांच करें।",
        DopeLanguage.fr: "Ton cerveau est un narrateur peu fiable. Vérifie les faits.",
        DopeLanguage.de: "Dein Gehirn ist ein unzuverlässiger Erzähler. Mach mal einen Faktencheck.",
      },
      persona: DopePersona.overthinker,
      tone: DopeTone.deadpan,
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
      text: "Consistency is just being average for a long time. Try being average today.",
      localizedText: {
        DopeLanguage.en: "Consistency is just being average for a long time. Try being average today.",
        DopeLanguage.es: "La consistencia es solo ser promedio durante mucho tiempo. Intenta ser promedio hoy.",
        DopeLanguage.hi: "निरंतरता का मतलब लंबे समय तक औसत बने रहना है। आज औसत रहने की कोशिश करें।",
        DopeLanguage.fr: "La régularité, c'est juste être moyen pendant longtemps. Essaie d'être moyen aujourd'hui.",
        DopeLanguage.de: "Beständigkeit bedeutet nur, über einen langen Zeitraum durchschnittlich zu sein. Versuche es heute mal damit.",
      },
      persona: DopePersona.builder,
      tone: DopeTone.chill,
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
      localizedText: {
        DopeLanguage.en: "The world won't end if you take a nap. I checked.",
        DopeLanguage.es: "El mundo no se acabará si tomas una siesta. Lo comprobé.",
        DopeLanguage.hi: "अगर आप झपकी लेते हैं तो दुनिया खत्म नहीं होगी। मैंने चेक किया है।",
        DopeLanguage.fr: "Le monde ne s'arrêtera pas si tu fais une sieste. J'ai vérifié.",
        DopeLanguage.de: "Die Welt wird nicht untergehen, wenn du ein Schläfchen machst. Ich hab's geprüft.",
      },
      persona: DopePersona.burntOut,
      tone: DopeTone.chill,
    ),
    Affirmation(
      text: "Your value is not your productivity. You're not a forklift.",
      localizedText: {
        DopeLanguage.en: "Your value is not your productivity. You're not a forklift.",
        DopeLanguage.es: "Tu valor no es tu productividad. No eres un montacargas.",
        DopeLanguage.hi: "आपका मूल्य आपकी उत्पादकता नहीं है। आप फोर्कलिफ्ट नहीं हैं।",
        DopeLanguage.fr: "Ta valeur n'est pas ta productivität. Tu n'es pas un chariot élévateur.",
        DopeLanguage.de: "Dein Wert ist nicht deine Produktivität. Du bist kein Gabelstapler.",
      },
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
      localizedText: {
        DopeLanguage.en: "Momentum beats motivation. Just move one inch.",
        DopeLanguage.es: "El impulso vence a la motivación. Solo muévete un poco.",
        DopeLanguage.hi: "रफ्तार मोटिवेशन से बेहतर है। बस एक कदम आगे बढ़ें।",
        DopeLanguage.fr: "L'élan bat la motivation. Fais juste un petit pas.",
        DopeLanguage.de: "Schwung schlägt Motivation. Beweg dich einfach einen Zentimeter.",
      },
      persona: DopePersona.adhdBrain,
      tone: DopeTone.coach,
    ),
    Affirmation(
      text: "It's not a block. It's a lack of snacks or sleep.",
      localizedText: {
        DopeLanguage.en: "It's not a block. It's a lack of snacks or sleep.",
        DopeLanguage.es: "No es un bloqueo. Es falta de snacks o sueño.",
        DopeLanguage.hi: "यह कोई ब्लॉक नहीं है। यह बस भूख या नींद की कमी है।",
        DopeLanguage.fr: "Ce n'est pas un blocage. C'est un manque de snacks ou de sommeil.",
        DopeLanguage.de: "Es ist keine Blockade. Dir fehlen nur Snacks oder Schlaf.",
      },
      persona: DopePersona.adhdBrain,
      tone: DopeTone.chill,
    ),

    // --- STRIVER ---
    Affirmation(
      text: "Ambition is just hunger with a better wardrobe.",
      localizedText: {
        DopeLanguage.en: "Ambition is just hunger with a better wardrobe.",
        DopeLanguage.es: "La ambición es solo hambre con un mejor vestuario.",
        DopeLanguage.hi: "महत्वाकांक्षा सिर्फ बेहतर कपड़ों के साथ भूख है।",
        DopeLanguage.fr: "L'ambition n'est que de la faim avec une meilleure garde-robe.",
        DopeLanguage.de: "Ehrgeiz ist nur Hunger mit einer besseren Garderobe.",
      },
      persona: DopePersona.striver,
      tone: DopeTone.deadpan,
    ),
    Affirmation(
      text: "You aren't behind. You're just on a different lap.",
      localizedText: {
        DopeLanguage.en: "You aren't behind. You're just on a different lap.",
        DopeLanguage.es: "No estás atrasado. Solo estás en una vuelta diferente.",
        DopeLanguage.hi: "आप पीछे नहीं हैं। आप बस एक अलग लैप पर हैं।",
        DopeLanguage.fr: "Tu n'es pas en retard. Tu es juste sur un tour différent.",
        DopeLanguage.de: "Du bist nicht hintendran. Du bist nur in einer anderen Runde.",
      },
      persona: DopePersona.striver,
      tone: DopeTone.chill,
    ),
    Affirmation(
      text: "Your 'grind' looks a lot like doom-scrolling. Put the phone down.",
      localizedText: {
        DopeLanguage.en: "Your 'grind' looks a lot like doom-scrolling. Put the phone down.",
        DopeLanguage.es: "Tu 'esfuerzo' se parece mucho a doom-scrolling. Deja el teléfono.",
        DopeLanguage.hi: "आपका 'काम' काफी हद तक डूम-स्क्रॉलिंग जैसा लग रहा है। फोन रख दें।",
        DopeLanguage.fr: "Ton 'travail acharné' ressemble beaucoup à du doom-scrolling. Pose ton téléphone.",
        DopeLanguage.de: "Dein 'Grind' sieht verdammt nach Doomscrolling aus. Leg das Handy weg.",
      },
      persona: DopePersona.striver,
      tone: DopeTone.deadpan,
    ),

    // --- UNIVERSAL DEADPAN ---
    Affirmation(
      text: "It's fine. Everything is fine. Mostly.",
      localizedText: {
        DopeLanguage.en: "It's fine. Everything is fine. Mostly.",
        DopeLanguage.es: "Está bien. Todo está bien. Mayormente.",
        DopeLanguage.hi: "ठीक है। सब कुछ ठीक है। ज्यादातर।",
        DopeLanguage.fr: "Ça va. Tout va bien. Surtout.",
        DopeLanguage.de: "Passt schon. Alles ist gut. Meistens.",
      },
      tone: DopeTone.deadpan,
    ),
    Affirmation(
      text: "Reality called. It wants you to stop scrolling.",
      localizedText: {
        DopeLanguage.en: "Reality called. It wants you to stop scrolling.",
        DopeLanguage.es: "Llamó la realidad. Quiere que dejes de hacer scroll.",
        DopeLanguage.hi: "हकीकत का फोन आया था। वह चाहता है कि आप स्क्रॉल करना बंद करें।",
        DopeLanguage.fr: "La réalité a appelé. Elle veut que tu arrêtes de scroller.",
        DopeLanguage.de: "Die Realität hat angerufen. Sie will, dass du aufhörst zu scrollen.",
      },
      tone: DopeTone.deadpan,
    ),
    Affirmation(
      text: "Cringe is the price of admission for growth.",
      localizedText: {
        DopeLanguage.en: "Cringe is the price of admission for growth.",
        DopeLanguage.es: "La vergüenza ajena es el precio de la entrada para el crecimiento.",
        DopeLanguage.hi: "शर्मिंदगी विकास के लिए प्रवेश की कीमत है।",
        DopeLanguage.fr: "Le malaise est le prix d'entrée de la croissance.",
        DopeLanguage.de: "Fremdscham ist der Eintrittspreis für Wachstum.",
      },
      tone: DopeTone.straight,
    ),
    Affirmation(
      text: "Drink water. You're basically a plant with complicated emotions.",
      localizedText: {
        DopeLanguage.en: "Drink water. You're basically a plant with complicated emotions.",
        DopeLanguage.es: "Bebe agua. Eres básicamente una planta con emociones complicadas.",
        DopeLanguage.hi: "पानी पिएं। आप मूल रूप से जटिल भावनाओं वाले पौधे हैं।",
        DopeLanguage.fr: "Bois de l'eau. Tu es essentiellement une plante avec des émotions complexes.",
        DopeLanguage.de: "Trink Wasser. Du bist im Grunde eine Pflanze mit komplizierten Emotionen.",
      },
      tone: DopeTone.chill,
    ),
    Affirmation(
      text: "Nobody actually knows what they're doing. Some are just better at pretending.",
      localizedText: {
        DopeLanguage.en: "Nobody actually knows what they're doing. Some are just better at pretending.",
        DopeLanguage.es: "Nadie sabe realmente lo que está haciendo. Algunos solo fingen mejor.",
        DopeLanguage.hi: "वास्तव में किसी को नहीं पता कि वे क्या कर रहे हैं। कुछ लोग बस बेहतर नाटक करते हैं।",
        DopeLanguage.fr: "Personne ne sait vraiment ce qu'il fait. Certains font juste semblant mieux.",
        DopeLanguage.de: "Niemand weiß wirklich, was er tut. Manche können nur besser so tun als ob.",
      },
      tone: DopeTone.deadpan,
    ),
    Affirmation(
      text: "Yesterday is gone. Tomorrow is a problem for future-you.",
      localizedText: {
        DopeLanguage.en: "Yesterday is gone. Tomorrow is a problem for future-you.",
        DopeLanguage.es: "El ayer se fue. El mañana es un problema para tu yo del futuro.",
        DopeLanguage.hi: "बीता हुआ कल चला गया। कल की चिंता भविष्य वाले आप पर छोड़ दें।",
        DopeLanguage.fr: "Hier est parti. Demain est un problème pour ton futur toi.",
        DopeLanguage.de: "Gestern ist vorbei. Morgen ist ein Problem für dein Zukunfts-Ich.",
      },
      tone: DopeTone.chill,
    ),
    Affirmation(
      text: "Procrastination is just a credit card. Have fun when the bill comes.",
      localizedText: {
        DopeLanguage.en: "Procrastination is just a credit card. Have fun when the bill comes.",
        DopeLanguage.es: "La procrastinación es solo una tarjeta de crédito. Diviértete cuando llegue la cuenta.",
        DopeLanguage.hi: "टालमटोल सिर्फ एक क्रेडिट कार्ड है। जब बिल आएगा तब मज़ा आएगा।",
        DopeLanguage.fr: "La procrastination n'est qu'une carte de crédit. Amuse-toi quand la facture arrivera.",
        DopeLanguage.de: "Aufschieberitis ist wie eine Kreditkarte. Viel Spaß, wenn die Rechnung kommt.",
      },
      tone: DopeTone.deadpan,
    ),
    Affirmation(
      text: "Validation is a drug. Get sober.",
      localizedText: {
        DopeLanguage.en: "Validation is a drug. Get sober.",
        DopeLanguage.es: "La validación es una droga. Sobria.",
        DopeLanguage.hi: "वाहवाही पाना एक नशा है। होश में आएं।",
        DopeLanguage.fr: "La validation est une drogue. Désintoxique-toi.",
        DopeLanguage.de: "Bestätigung ist eine Droge. Werde clean.",
      },
      tone: DopeTone.straight,
    ),
  ];

  static Future<List<Affirmation>> getAllAffirmations() async {
    final prefs = await UserPreferences.load();
    final custom = await UserPreferences.getCustomAffirmations();
    
    List<MapEntry<Affirmation, int>> scored = _library.map((a) {
      int score = 0;
      if (a.persona == prefs.persona) score += 5;
      if (a.tone == prefs.tone) score += 3;
      if (prefs.systemLoad > 0.7 && a.persona == DopePersona.burntOut) score += 4;
      if (prefs.batteryLevel < 0.3 && a.persona == DopePersona.burntOut) score += 3;
      if (prefs.bandwidth < 0.3 && a.persona == DopePersona.adhdBrain) score += 4;
      return MapEntry(a, score);
    }).toList();

    scored.sort((a, b) => b.value.compareTo(a.value));
    List<Affirmation> filtered = scored.where((e) => e.value > 0).map((e) => e.key).toList();
    
    if (filtered.isEmpty) filtered = _library;

    return [...filtered, ...custom];
  }

  static Future<Affirmation> getDailyAffirmation() async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _library.first;
    final now = DateTime.now();
    final prefs = await UserPreferences.load();
    final seed = now.year + now.month + now.day + (prefs.systemLoad * 100).toInt() + prefs.persona.index;
    return all[seed % all.length];
  }

  static Future<Affirmation> getRandomAffirmation({String? excludeText}) async {
    final all = await getAllAffirmations();
    if (all.isEmpty) return _library.first;
    
    final pool = excludeText != null 
      ? all.where((a) => a.getText(DopeLanguage.en) != excludeText).toList()
      : all;
      
    final finalPool = pool.isEmpty ? all : pool;
    return finalPool[Random().nextInt(finalPool.length)];
  }
}
