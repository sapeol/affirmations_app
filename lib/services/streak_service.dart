import '../models/user_preferences.dart';

class StreakService {
  String getStreakMessage(int streak, bool justBroken) {
    if (justBroken) {
      return "Streak broke. Character didn’t.";
    }
    
    if (streak == 0) return "Day 0. The bar is on the floor.";
    if (streak == 1) return "Day 1. You showed up. Weird.";
    if (streak == 3) return "Still here. Not quitting. Respect.";
    if (streak == 7) return "One week. Don't let it go to your head.";
    if (streak == 14) return "At this point, you’re consistent whether you like it or not.";
    if (streak == 30) return "30 days. You're officially a creature of habit.";
    
    return "Day $streak. Still going.";
  }

  Future<Map<String, dynamic>> updateStreak() async {
    final prefs = await UserPreferences.load();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (prefs.lastInteractionDate == null) {
      final updatedPrefs = _copyPrefsWith(prefs, 
        sanityStreak: 1, 
        lastInteractionDate: today.toIso8601String()
      );
      await UserPreferences.save(updatedPrefs);
      return {'streak': 1, 'justBroken': false};
    }

    final lastDate = DateTime.parse(prefs.lastInteractionDate!);
    final difference = today.difference(lastDate).inDays;

    if (difference == 0) {
      return {'streak': prefs.sanityStreak, 'justBroken': false};
    } else if (difference == 1) {
      final newStreak = prefs.sanityStreak + 1;
      final updatedPrefs = _copyPrefsWith(prefs, 
        sanityStreak: newStreak, 
        lastInteractionDate: today.toIso8601String()
      );
      await UserPreferences.save(updatedPrefs);
      return {'streak': newStreak, 'justBroken': false};
    } else {
      // Streak broken
      final updatedPrefs = _copyPrefsWith(prefs, 
        sanityStreak: 1, 
        lastInteractionDate: today.toIso8601String()
      );
      await UserPreferences.save(updatedPrefs);
      return {'streak': 1, 'justBroken': true};
    }
  }

  UserPreferences _copyPrefsWith(UserPreferences p, {
    int? sanityStreak,
    String? lastInteractionDate,
  }) {
    return UserPreferences(
      persona: p.persona,
      themeMode: p.themeMode,
      fontFamily: p.fontFamily,
      colorTheme: p.colorTheme,
      language: p.language,
      likedAffirmations: p.likedAffirmations,
      notificationsEnabled: p.notificationsEnabled,
      notificationHour: p.notificationHour,
      notificationMinute: p.notificationMinute,
      sanityStreak: sanityStreak ?? p.sanityStreak,
      lastInteractionDate: lastInteractionDate ?? p.lastInteractionDate,
      firstRunDate: p.firstRunDate,
    );
  }
}
