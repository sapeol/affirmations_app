import 'package:flutter/material.dart';
import '../models/user_preferences.dart';

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
              _buildSection("Mindset Focus"),
              _buildFocusChips(prefs),
              const SizedBox(height: 24),
              _buildSection("Spiritual Path"),
              _buildLeaningChips(prefs),
              const SizedBox(height: 24),
              _buildSection("Notifications"),
              SwitchListTile(
                title: const Text("Daily Reminders"),
                value: prefs.notificationsEnabled,
                onChanged: (val) => _updatePreference(UserPreferences(
                  focus: prefs.focus,
                  leaning: prefs.leaning,
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

  Widget _buildFocusChips(UserPreferences prefs) {
    return Wrap(
      spacing: 8,
      children: AppFocus.values.map((f) => ChoiceChip(
        label: Text(f.name),
        selected: prefs.focus == f,
        onSelected: (val) => _updatePreference(UserPreferences(
          focus: f,
          leaning: prefs.leaning,
          notificationsEnabled: prefs.notificationsEnabled,
        )),
      )).toList(),
    );
  }

  Widget _buildLeaningChips(UserPreferences prefs) {
    return Wrap(
      spacing: 8,
      children: SpiritualLeaning.values.map((l) => ChoiceChip(
        label: Text(l.name),
        selected: prefs.leaning == l,
        onSelected: (val) => _updatePreference(UserPreferences(
          focus: prefs.focus,
          leaning: l,
          notificationsEnabled: prefs.notificationsEnabled,
        )),
      )).toList(),
    );
  }
}
