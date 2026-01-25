import 'package:flutter/material.dart';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';

class CreateAffirmationScreen extends StatefulWidget {
  const CreateAffirmationScreen({super.key});

  @override
  State<CreateAffirmationScreen> createState() => _CreateAffirmationScreenState();
}

class _CreateAffirmationScreenState extends State<CreateAffirmationScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;

  void _save() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isSaving = true);
    final newAff = Affirmation(
      text: _controller.text.trim(),
      isCustom: true,
    );

    await UserPreferences.addCustomAffirmation(newAff);
    
    if (mounted) {
      Navigator.pop(context, true); // Return true to indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Affirmation"),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What do you need to hear today?",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              "Write an affirmation that resonates with your current journey.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _controller,
              maxLines: 5,
              maxLength: 200,
              autofocus: true,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: InputDecoration(
                hintText: "I am...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                contentPadding: const EdgeInsets.all(24),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 40),
            if (_controller.text.isNotEmpty) ...[
              Text(
                "Preview",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      _controller.text,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
