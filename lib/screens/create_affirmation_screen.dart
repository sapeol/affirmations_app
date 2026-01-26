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
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CREATE DELUSION"),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(
                "SAVE", 
                style: TextStyle(
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 1,
                  color: Theme.of(context).colorScheme.primary,
                )
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What lie do you need to tell yourself today?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w300,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Write an excuse that resonates with your current spiral.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _controller,
              maxLines: 5,
              maxLength: 200,
              autofocus: true,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: "I am probably going to be fine...",
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
                contentPadding: const EdgeInsets.all(32),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 48),
            if (_controller.text.isNotEmpty) ...[
              Text(
                "PREVIEW",
                style: TextStyle(
                  fontSize: 10, 
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 4,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).cardTheme.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: Text(
                      _controller.text,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
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
