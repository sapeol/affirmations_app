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

  @override
  void initState() {
    super.initState();
    _prefsFuture = UserPreferences.load();
  }

  void _updatePreference(UserPreferences newPrefs) async {
    await UserPreferences.save(newPrefs);
    themeNotifier.value = newPrefs.themeMode;
    setState(() {
      _prefsFuture = Future.value(newPrefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preferences")),
      body: FutureBuilder<UserPreferences>(
        future: _prefsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final prefs = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection("Appearance"),
              _buildChips(ThemeMode.values, prefs.themeMode, (val) => _updatePreference(UserPreferences(
                leaning: prefs.leaning, focus: prefs.focus, lifeStage: prefs.lifeStage, gender: prefs.gender, themeMode: val as ThemeMode, notificationsEnabled: prefs.notificationsEnabled
              ))),
              const SizedBox(height: 16),
              _buildSection("Identity"),
              _buildChips(Gender.values, prefs.gender, (val) => _updatePreference(UserPreferences(
                leaning: prefs.leaning, focus: prefs.focus, lifeStage: prefs.lifeStage, gender: val as Gender, themeMode: prefs.themeMode, notificationsEnabled: prefs.notificationsEnabled
              ))),
              const SizedBox(height: 16),
              _buildSection("Life Stage"),
              _buildChips(LifeStage.values, prefs.lifeStage, (val) => _updatePreference(UserPreferences(
                leaning: prefs.leaning, focus: prefs.focus, lifeStage: val as LifeStage, gender: prefs.gender, themeMode: prefs.themeMode, notificationsEnabled: prefs.notificationsEnabled
              ))),
              const SizedBox(height: 16),
              _buildSection("Mindset Focus"),
              _buildChips(AppFocus.values, prefs.focus, (val) => _updatePreference(UserPreferences(
                leaning: prefs.leaning, focus: val as AppFocus, lifeStage: prefs.lifeStage, gender: prefs.gender, themeMode: prefs.themeMode, notificationsEnabled: prefs.notificationsEnabled
              ))),
              const SizedBox(height: 16),
              _buildSection("Spiritual Path"),
              _buildChips(SpiritualLeaning.values, prefs.leaning, (val) => _updatePreference(UserPreferences(
                leaning: val as SpiritualLeaning, focus: prefs.focus, lifeStage: prefs.lifeStage, gender: prefs.gender, themeMode: prefs.themeMode, notificationsEnabled: prefs.notificationsEnabled
              ))),
              const SizedBox(height: 24),
              _buildSection("Notifications"),
              SwitchListTile(
                title: const Text("Daily Reminders"),
                value: prefs.notificationsEnabled,
                onChanged: (val) => _updatePreference(UserPreferences(
                  focus: prefs.focus,
                  leaning: prefs.leaning,
                  lifeStage: prefs.lifeStage,
                  gender: prefs.gender,
                  themeMode: prefs.themeMode,
                  notificationsEnabled: val,
                )),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      )),
    );
  }

  Widget _buildChips(List options, dynamic selected, Function(dynamic) onSelected) {
    return Wrap(
      spacing: 8,
      children: options.map((opt) {
        final name = opt.toString().split('.').last;
        return ChoiceChip(
          label: Text(name[0].toUpperCase() + name.substring(1)),
          selected: selected == opt,
          onSelected: (val) => onSelected(opt),
        );
      }).toList(),
    );
  }
}
