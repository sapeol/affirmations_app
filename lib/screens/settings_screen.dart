import 'package:flutter/material.dart';
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
    'Playful': ['Caveat', 'Patrick Hand', 'Indie Flower', 'Dancing Script'],
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
    setState(() {
      _prefsFuture = Future.value(newPrefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings & Style")),
      body: FutureBuilder<UserPreferences>(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final prefs = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              _buildSectionHeader(Icons.palette_outlined, "Appearance"),
              _buildModernSelection(ThemeMode.values, prefs.themeMode, (val) => _updatePreference(_copy(prefs, themeMode: val as ThemeMode))),
              
              const SizedBox(height: 32),
              _buildSectionHeader(Icons.font_download_outlined, "Typography"),
              ..._fontCategories.entries.map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(entry.key, style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    )),
                  ),
                  _buildModernSelection(entry.value, prefs.fontFamily, (val) => _updatePreference(_copy(prefs, fontFamily: val as String))),
                ],
              )),

              const SizedBox(height: 32),
              _buildSectionHeader(Icons.fingerprint_outlined, "Identity"),
              _buildModernSelection(Gender.values, prefs.gender, (val) => _updatePreference(_copy(prefs, gender: val as Gender))),
              
              const SizedBox(height: 16),
              _buildSectionHeader(Icons.auto_awesome_outlined, "Life Stage"),
              _buildModernSelection(LifeStage.values, prefs.lifeStage, (val) => _updatePreference(_copy(prefs, lifeStage: val as LifeStage))),

              const SizedBox(height: 16),
              _buildSectionHeader(Icons.psychology_outlined, "Mindset Focus"),
              _buildModernSelection(AppFocus.values, prefs.focus, (val) => _updatePreference(_copy(prefs, focus: val as AppFocus))),

              const SizedBox(height: 32),
              _buildSectionHeader(Icons.notifications_active_outlined, "Daily Reminders"),
              SwitchListTile(
                title: const Text("Morning Affirmations"),
                subtitle: const Text("Receive a gentle notification every day."),
                value: prefs.notificationsEnabled,
                onChanged: (val) => _updatePreference(_copy(prefs, notificationsEnabled: val)),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
    );
  }

  Widget _buildModernSelection(List options, dynamic selected, Function(dynamic) onSelected) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final name = opt.toString().split('.').last;
        final isSelected = selected == opt;
        return ChoiceChip(
          label: Text(name[0].toUpperCase() + name.substring(1)),
          selected: isSelected,
          onSelected: (val) => onSelected(opt),
          showCheckmark: false,
          labelStyle: TextStyle(
            color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          selectedColor: Theme.of(context).colorScheme.primary,
        );
      }).toList(),
    );
  }

  UserPreferences _copy(UserPreferences p, {SpiritualLeaning? leaning, AppFocus? focus, LifeStage? lifeStage, Gender? gender, ThemeMode? themeMode, String? fontFamily, bool? notificationsEnabled}) {
    return UserPreferences(
      leaning: leaning ?? p.leaning,
      focus: focus ?? p.focus,
      lifeStage: lifeStage ?? p.lifeStage,
      gender: gender ?? p.gender,
      themeMode: themeMode ?? p.themeMode,
      fontFamily: fontFamily ?? p.fontFamily,
      notificationsEnabled: notificationsEnabled ?? p.notificationsEnabled,
    );
  }
}