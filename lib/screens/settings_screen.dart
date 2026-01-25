import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../models/user_preferences.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<UserPreferences> _prefsFuture;

  final Map<String, List<String>> _fontCategories = {
    'Modern': ['Lexend', 'Montserrat', 'Outfit', 'Plus Jakarta Sans'],
    'Elegant': ['Playfair Display', 'Lora', 'Merriweather', 'EB Garamond'],
    'Playful': ['Caveat', 'Patrick Hand', 'Dancing Script'],
    'Clean': ['Fira Code', 'Roboto Mono', 'Space Mono', 'Ubuntu Mono'],
  };

  @override
  void initState() {
    super.initState();
    _prefsFuture = UserPreferences.load();
  }

  void _updatePreference(UserPreferences newPrefs) async {
    await UserPreferences.save(newPrefs);
    themeNotifier.value = newPrefs.themeMode;
    fontNotifier.value = newPrefs.fontFamily;
    colorThemeNotifier.value = newPrefs.colorTheme;
    setState(() {
      _prefsFuture = Future.value(newPrefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: FutureBuilder<UserPreferences>(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final prefs = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _buildGroupHeader("Appearance"),
              _buildSettingTile(
                icon: Icons.brightness_6_outlined,
                title: "Dark Mode",
                subtitle: _formatEnum(prefs.themeMode),
                onTap: () => _showSelectionDialog(context, "Select Theme Mode", ThemeMode.values, prefs.themeMode, (val) => _updatePreference(_copy(prefs, themeMode: val as ThemeMode))),
              ),
              _buildSettingTile(
                icon: Icons.palette_outlined,
                title: "Pastel Theme",
                subtitle: _formatEnum(prefs.colorTheme),
                onTap: () => _showSelectionDialog(context, "Select Color Palette", AppColorTheme.values, prefs.colorTheme, (val) => _updatePreference(_copy(prefs, colorTheme: val as AppColorTheme))),
              ),
              _buildSettingTile(
                icon: Icons.font_download_outlined,
                title: "Font Family",
                subtitle: prefs.fontFamily,
                onTap: () => _showFontDialog(context, prefs),
              ),
              if (Theme.of(context).platform == TargetPlatform.android)
                _buildSettingTile(
                  icon: Icons.add_to_home_screen_rounded,
                  title: "Pin Widget",
                  subtitle: "Add to home screen",
                  onTap: () async {
                    await HomeWidget.requestPinWidget(
                      name: 'AffirmationWidgetProvider',
                      androidName: 'com.example.affirmations_app.AffirmationWidgetProvider',
                    );
                  },
                ),
              const Divider(height: 32),
              _buildGroupHeader("Personalization"),
              _buildSettingTile(
                icon: Icons.bubble_chart_outlined,
                title: "Current Context",
                subtitle: _formatEnum(prefs.userContext),
                onTap: () => _showSelectionDialog(context, "What's on your mind?", UserContext.values, prefs.userContext, (val) => _updatePreference(_copy(prefs, userContext: val as UserContext))),
              ),
              _buildSettingTile(
                icon: Icons.record_voice_over_outlined,
                title: "Desired Tone",
                subtitle: _formatEnum(prefs.tone),
                onTap: () => _showSelectionDialog(context, "Affirmation Tone", AffirmationTone.values, prefs.tone, (val) => _updatePreference(_copy(prefs, tone: val as AffirmationTone))),
              ),
              _buildSettingTile(
                icon: Icons.psychology_outlined,
                title: "Core Focus",
                subtitle: _formatEnum(prefs.focus),
                onTap: () => _showSelectionDialog(context, "Main Focus", AppFocus.values, prefs.focus, (val) => _updatePreference(_copy(prefs, focus: val as AppFocus))),
              ),
              _buildSettingTile(
                icon: Icons.spa_outlined,
                title: "Spiritual Path",
                subtitle: _formatEnum(prefs.leaning),
                onTap: () => _showSelectionDialog(context, "Spiritual Leaning", SpiritualLeaning.values, prefs.leaning, (val) => _updatePreference(_copy(prefs, leaning: val as SpiritualLeaning))),
              ),
              const Divider(height: 32),
              _buildGroupHeader("Identity"),
              _buildSettingTile(
                icon: Icons.fingerprint_outlined,
                title: "Gender",
                subtitle: _formatEnum(prefs.gender),
                onTap: () => _showSelectionDialog(context, "Identity", Gender.values, prefs.gender, (val) => _updatePreference(_copy(prefs, gender: val as Gender))),
              ),
              _buildSettingTile(
                icon: Icons.auto_awesome_outlined,
                title: "Life Stage",
                subtitle: _formatEnum(prefs.lifeStage),
                onTap: () => _showSelectionDialog(context, "Life Stage", LifeStage.values, prefs.lifeStage, (val) => _updatePreference(_copy(prefs, lifeStage: val as LifeStage))),
              ),
              const Divider(height: 32),
              _buildGroupHeader("Notifications"),
              SwitchListTile(
                secondary: Icon(Icons.notifications_active_outlined, color: Theme.of(context).colorScheme.primary),
                title: const Text("Morning Reminders"),
                value: prefs.notificationsEnabled,
                onChanged: (val) => _updatePreference(_copy(prefs, notificationsEnabled: val)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      )),
    );
  }

  Widget _buildSettingTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  void _showSelectionDialog(BuildContext context, String title, List options, dynamic current, Function(dynamic) onSelected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...options.map((opt) => ListTile(
              title: Text(_formatEnum(opt)),
              trailing: current == opt ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary) : null,
              onTap: () {
                onSelected(opt);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showFontDialog(BuildContext context, UserPreferences prefs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Choose Typography", style: Theme.of(context).textTheme.titleLarge),
            ),
            Expanded(
              child: ListView(
                children: _fontCategories.entries.map((entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(entry.key, style: Theme.of(context).textTheme.labelLarge),
                    ),
                    ...entry.value.map((font) => ListTile(
                      title: Text(font, style: TextStyle(fontFamily: font)),
                      trailing: prefs.fontFamily == font ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary) : null,
                      onTap: () {
                        _updatePreference(_copy(prefs, fontFamily: font));
                        Navigator.pop(context);
                      },
                    )),
                  ],
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatEnum(dynamic e) {
    final name = e.toString().split('.').last;
    return name[0].toUpperCase() + name.substring(1);
  }

  UserPreferences _copy(UserPreferences p, {SpiritualLeaning? leaning, AppFocus? focus, LifeStage? lifeStage, Gender? gender, ThemeMode? themeMode, String? fontFamily, AppColorTheme? colorTheme, UserContext? userContext, AffirmationTone? tone, bool? notificationsEnabled}) {
    return UserPreferences(
      leaning: leaning ?? p.leaning, focus: focus ?? p.focus, lifeStage: lifeStage ?? p.lifeStage, gender: gender ?? p.gender, themeMode: themeMode ?? p.themeMode, fontFamily: fontFamily ?? p.fontFamily, colorTheme: colorTheme ?? p.colorTheme, userContext: userContext ?? p.userContext, tone: tone ?? p.tone, notificationsEnabled: notificationsEnabled ?? p.notificationsEnabled,
    );
  }
}
