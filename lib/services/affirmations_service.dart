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
      await isar.affirmations.putAll(_initialLibrary);
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

  final List<Affirmation> _initialLibrary = [
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
      persona: DopePersona.overthinker,
    ),
    Affirmation.create(
      text: "Ship the ugly version. No one is looking anyway.",
      persona: DopePersona.builder,
    ),
    Affirmation.create(
      text: "Resting isn't a reward, it's maintenance.",
      persona: DopePersona.burntOut,
    ),
    Affirmation.create(
      text: "Your brain has 47 tabs open. Close the one playing music.",
      persona: DopePersona.adhdBrain,
    ),
    Affirmation.create(
      text: "Ambition is just hunger with a better wardrobe.",
      persona: DopePersona.striver,
    ),
  ];
}
