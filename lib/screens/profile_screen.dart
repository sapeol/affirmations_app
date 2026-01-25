import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../models/affirmation.dart';
import '../services/affirmations_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("USER PROFILE")),
      body: FutureBuilder<UserPreferences>(
        future: UserPreferences.load(),
        builder: (context, prefSnapshot) {
          return FutureBuilder<List<Affirmation>>(
            future: AffirmationsService.getAllAffirmations(),
            builder: (context, affSnapshot) {
              if (!prefSnapshot.hasData || !affSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final prefs = prefSnapshot.data!;
              final affirmations = affSnapshot.data!;

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildHeader(context, prefs),
                  const SizedBox(height: 40),
                  Text("SAVED PERSPECTIVES", style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 16),
                  ...affirmations.map((a) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2))),
                    child: ListTile(
                      leading: Icon(
                        a.isCustom ? Icons.edit_note_rounded : Icons.bolt_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(a.text, style: const TextStyle(fontSize: 14)),
                      subtitle: Text(a.persona?.name.toUpperCase() ?? "GENERAL", style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.outline)),
                    ),
                  )),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserPreferences prefs) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(Icons.bolt_rounded, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            prefs.persona.name.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1),
          ),
          const SizedBox(height: 4),
          Text(
            "VIBE: ${prefs.tone.name.toUpperCase()}",
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}