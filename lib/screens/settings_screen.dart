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
    'Modern': ['Plus Jakarta Sans', 'Montserrat', 'Outfit'],
    'Clean': ['Fira Code', 'Roboto Mono', 'Space Mono'],
    'Classic': ['Playfair Display', 'Lora'],
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
      appBar: AppBar(title: const Text("VIBE SETTINGS")),
      body: FutureBuilder<UserPreferences>(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final prefs = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _buildGroupHeader("CUSTOMIZATION"),
              _buildSettingTile(
                icon: Icons.face_retouching_natural_rounded,
                title: "Your Persona",
                subtitle: _formatEnum(prefs.persona),
                onTap: () => _showSelectionDialog(context, "Select Persona", DopePersona.values, prefs.persona, (val) => _updatePreference(_copy(prefs, persona: val as DopePersona))),
              ),
              _buildSettingTile(
                icon: Icons.tune_rounded,
                title: "Affirmation Tone",
                subtitle: _formatEnum(prefs.tone),
                onTap: () => _showSelectionDialog(context, "Select Tone vibe", DopeTone.values, prefs.tone, (val) => _updatePreference(_copy(prefs, tone: val as DopeTone))),
              ),
              _buildSettingTile(
                icon: Icons.palette_rounded,
                title: "Color Palette",
                subtitle: _formatEnum(prefs.colorTheme),
                onTap: () => _showSelectionDialog(context, "Select Theme", AppColorTheme.values, prefs.colorTheme, (val) => _updatePreference(_copy(prefs, colorTheme: val as AppColorTheme))),
              ),
              _buildSettingTile(
                icon: Icons.font_download_rounded,
                title: "Typography",
                subtitle: prefs.fontFamily,
                onTap: () => _showFontDialog(context, prefs),
              ),
              _buildSettingTile(
                icon: Icons.language_rounded,
                title: "System Language",
                subtitle: _formatLang(prefs.language),
                onTap: () => _showSelectionDialog(context, "Select Language", DopeLanguage.values, prefs.language, (val) => _updatePreference(_copy(prefs, language: val as DopeLanguage))),
              ),
              const Divider(height: 32),
              _buildGroupHeader("PREFERENCES"),
              _buildSettingTile(
                icon: Icons.brightness_6_rounded,
                title: "Dark Mode",
                subtitle: _formatEnum(prefs.themeMode),
                onTap: () => _showSelectionDialog(context, "Select Theme Mode", ThemeMode.values, prefs.themeMode, (val) => _updatePreference(_copy(prefs, themeMode: val as ThemeMode))),
              ),
              if (Theme.of(context).platform == TargetPlatform.android)
                _buildSettingTile(
                  icon: Icons.add_to_home_screen_rounded,
                  title: "Pin Widget",
                  subtitle: "Add to home screen",
                  onTap: () async {
                    await HomeWidget.requestPinWidget(
                      name: 'AffirmationWidgetProvider',
                      androidName: 'AffirmationWidgetProvider',
                    );
                  },
                ),
              const Divider(height: 32),
              _buildGroupHeader("PUSH NOTIFICATIONS"),
              SwitchListTile(
                secondary: Icon(Icons.bolt_rounded, color: Theme.of(context).colorScheme.primary),
                title: const Text("Daily Pings"),
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
      child: Text(title, style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      )),
    );
  }

  Widget _buildSettingTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle.toUpperCase(), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, letterSpacing: 1)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  void _showSelectionDialog(BuildContext context, String title, List options, dynamic current, Function(dynamic) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 16),
            ...options.map((opt) => ListTile(
              title: Text(_formatEnum(opt).toUpperCase(), style: const TextStyle(fontSize: 14)),
              trailing: current == opt ? Icon(Icons.bolt_rounded, color: Theme.of(context).colorScheme.primary) : null,
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("TYPOGRAPHY", style: TextStyle(fontWeight: FontWeight.w900)),
            ),
            Expanded(
              child: ListView(
                children: _fontCategories.entries.map((entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(entry.key.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
                    ),
                    ...entry.value.map((font) => ListTile(
                      title: Text(font, style: TextStyle(fontFamily: font)),
                      trailing: prefs.fontFamily == font ? Icon(Icons.bolt_rounded, color: Theme.of(context).colorScheme.primary) : null,
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

  String _formatLang(DopeLanguage l) {
    switch (l) {
      case DopeLanguage.en: return "English";
      case DopeLanguage.es: return "Español";
      case DopeLanguage.hi: return "हिन्दी";
      case DopeLanguage.fr: return "Français";
      case DopeLanguage.de: return "Deutsch";
    }
  }

  String _formatEnum(dynamic e) {
    if (e is DopeLanguage) return _formatLang(e);
    final name = e.toString().split('.').last;
    if (name == 'adhdBrain') return 'ADHD Brain';
    if (name == 'burntOut') return 'Burned Out';
    return name[0].toUpperCase() + name.substring(1);
  }

  UserPreferences _copy(UserPreferences p, {DopePersona? persona, DopeTone? tone, ThemeMode? themeMode, String? fontFamily, AppColorTheme? colorTheme, DopeLanguage? language, bool? notificationsEnabled}) {
    return UserPreferences(
      persona: persona ?? p.persona,
      tone: tone ?? p.tone,
      themeMode: themeMode ?? p.themeMode,
      fontFamily: fontFamily ?? p.fontFamily,
      colorTheme: colorTheme ?? p.colorTheme,
      language: language ?? p.language,
      systemLoad: p.systemLoad,
      batteryLevel: p.batteryLevel,
      bandwidth: p.bandwidth,
      notificationsEnabled: notificationsEnabled ?? p.notificationsEnabled,
    );
  }
}