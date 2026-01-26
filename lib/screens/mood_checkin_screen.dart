import 'package:flutter/material.dart';
import '../models/user_preferences.dart';

class MoodCheckInScreen extends StatefulWidget {
  const MoodCheckInScreen({super.key});

  @override
  State<MoodCheckInScreen> createState() => _MoodCheckInScreenState();
}

class _MoodCheckInScreenState extends State<MoodCheckInScreen> {
  double _systemLoad = 0.5;
  double _batteryLevel = 0.5;
  double _bandwidth = 0.5;
  final TextEditingController _journalController = TextEditingController();

  void _saveScan() async {
    final prefs = await UserPreferences.load();
    await UserPreferences.save(UserPreferences(
      persona: prefs.persona,
      tone: prefs.tone,
      themeMode: prefs.themeMode,
      fontFamily: prefs.fontFamily,
      colorTheme: prefs.colorTheme,
      language: prefs.language,
      systemLoad: _systemLoad,
      batteryLevel: _batteryLevel,
      bandwidth: _bandwidth,
      likedAffirmations: prefs.likedAffirmations,
      notificationsEnabled: prefs.notificationsEnabled,
      notificationHour: prefs.notificationHour,
      notificationMinute: prefs.notificationMinute,
      sanityStreak: prefs.sanityStreak,
      lastInteractionDate: prefs.lastInteractionDate,
      firstRunDate: prefs.firstRunDate,
    ));
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BRAIN SCAN")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDiagnosticSection(
              title: "PRESSURE (STRESS)",
              value: _systemLoad,
              icon: Icons.speed_rounded,
              onChanged: (v) => setState(() => _systemLoad = v),
              lowLabel: "COOL",
              highLabel: "OVERHEATING",
            ),
            const SizedBox(height: 32),
            _buildDiagnosticSection(
              title: "FUEL (ENERGY)",
              value: _batteryLevel,
              icon: Icons.battery_charging_full_rounded,
              onChanged: (v) => setState(() => _batteryLevel = v),
              lowLabel: "EMPTY",
              highLabel: "FULL TANK",
            ),
            const SizedBox(height: 32),
            _buildDiagnosticSection(
              title: "CAPACITY (FOCUS)",
              value: _bandwidth,
              icon: Icons.lan_rounded,
              onChanged: (v) => setState(() => _bandwidth = v),
              lowLabel: "LIMITED",
              highLabel: "MAXED OUT",
            ),
            const SizedBox(height: 48),
            Text("RAW THOUGHTS", style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 12),
            TextField(
              controller: _journalController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Dump what's on your mind...",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: FilledButton(
                onPressed: _saveScan,
                style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text("GET PERSPECTIVE", style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticSection({
    required String title,
    required double value,
    required IconData icon,
    required ValueChanged<double> onChanged,
    required String lowLabel,
    required String highLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const Spacer(),
            Text("${(value * 100).toInt()}%", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lowLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 9, color: Theme.of(context).colorScheme.outline)),
            Text(highLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 9, color: Theme.of(context).colorScheme.outline)),
          ],
        ),
      ],
    );
  }
}