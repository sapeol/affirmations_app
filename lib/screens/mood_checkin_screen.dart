import 'package:flutter/material.dart';
import '../models/user_mood.dart';
import '../models/user_preferences.dart';

class MoodCheckInScreen extends StatefulWidget {
  const MoodCheckInScreen({super.key});

  @override
  State<MoodCheckInScreen> createState() => _MoodCheckInScreenState();
}

class _MoodCheckInScreenState extends State<MoodCheckInScreen> {
  EmotionCategory? _selectedCategory;
  final TextEditingController _journalController = TextEditingController();
  bool _isRecording = false; // Placeholder for actual recording logic

  void _saveMood() async {
    if (_selectedCategory == null) return;

    final prefs = await UserPreferences.load();
    await UserPreferences.save(UserPreferences(
      leaning: prefs.leaning,
      focus: prefs.focus,
      lifeStage: prefs.lifeStage,
      gender: prefs.gender,
      themeMode: prefs.themeMode,
      fontFamily: prefs.fontFamily,
      colorTheme: prefs.colorTheme,
      userContext: prefs.userContext,
      tone: prefs.tone,
      lastMoodCategory: _selectedCategory!.name,
      notificationsEnabled: prefs.notificationsEnabled,
    ));

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("How are you truly?")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("The Emotion Wheel", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text("Select the state that matches your current energy.", 
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline)),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: emotionWheel.length,
              itemBuilder: (context, index) {
                final item = emotionWheel[index];
                final isSelected = _selectedCategory == item['category'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = item['category'] as EmotionCategory),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'] as IconData, 
                          color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface),
                        const SizedBox(height: 8),
                        Text(item['label'] as String, 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text("The Messy Middle", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _journalController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "What's happening in your world right now?",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _isRecording = !_isRecording),
                    icon: Icon(_isRecording ? Icons.stop_circle : Icons.mic_rounded),
                    label: Text(_isRecording ? "Recording..." : "Voice Note"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: FilledButton(
                onPressed: _selectedCategory == null ? null : _saveMood,
                child: const Text("Save Check-in", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}