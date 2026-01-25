import 'package:shared_preferences/shared_preferences.dart';

enum SpiritualLeaning { secular, spiritual, religious, stoic, buddhist }

enum AppFocus { anxiety, motivation, grief, improvement, general }

class UserPreferences {
  final SpiritualLeaning leaning;
  final AppFocus focus;
  final bool notificationsEnabled;
  final String? userName;

  UserPreferences({
    required this.leaning,
    required this.focus,
    this.notificationsEnabled = true,
    this.userName,
  });

  static Future<void> save(UserPreferences prefs) async {
    final s = await SharedPreferences.getInstance();
    await s.setString('leaning', prefs.leaning.name);
    await s.setString('focus', prefs.focus.name);
    await s.setBool('notifications', prefs.notificationsEnabled);
    if (prefs.userName != null) await s.setString('user_name', prefs.userName!);
  }

  static Future<UserPreferences> load() async {
    final s = await SharedPreferences.getInstance();
    return UserPreferences(
      leaning: SpiritualLeaning.values.byName(s.getString('leaning') ?? 'secular'),
      focus: AppFocus.values.byName(s.getString('focus') ?? 'general'),
      notificationsEnabled: s.getBool('notifications') ?? true,
      userName: s.getString('user_name'),
    );
  }
}
