import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
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
  
  AudioRecorder? _audioRecorder;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _audioRecorder?.dispose();
    _journalController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final recorder = _audioRecorder;
    if (recorder == null) return;
    try {
      if (await recorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = p.join(directory.path, 'dope_note_${DateTime.now().millisecondsSinceEpoch}.m4a');
        const config = RecordConfig();
        await recorder.start(config, path: path);
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("FAIL: $e")));
    }
  }

  Future<void> _stopRecording() async {
    final recorder = _audioRecorder;
    if (recorder == null) return;
    try {
      await recorder.stop();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("FAIL: $e")));
    }
  }

  void _saveMood() async {
    if (_selectedCategory == null) return;
    final prefs = await UserPreferences.load();
    await UserPreferences.save(UserPreferences(
      persona: prefs.persona,
      tone: prefs.tone,
      themeMode: prefs.themeMode,
      fontFamily: prefs.fontFamily,
      colorTheme: prefs.colorTheme,
      lastMoodCategory: _selectedCategory!.name,
      notificationsEnabled: prefs.notificationsEnabled,
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
            Text("CURRENT BRAIN STATE", style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: emotionWheel.length,
              itemBuilder: (context, index) {
                final item = emotionWheel[index];
                final isSelected = _selectedCategory == item['category'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = item['category'] as EmotionCategory),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'] as IconData, color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface),
                        const SizedBox(height: 8),
                        Text(item['label'].toString().toUpperCase(), textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal, color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text("RAW LOG", style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 12),
            TextField(
              controller: _journalController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Dump your thoughts here...",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isRecording ? _stopRecording : _startRecording,
                    icon: Icon(_isRecording ? Icons.stop_circle : Icons.mic_rounded, color: _isRecording ? Colors.red : null),
                    label: Text(_isRecording ? "STOPPING..." : "VOICE DUMP"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text("SAVE THIS VIBE", style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}