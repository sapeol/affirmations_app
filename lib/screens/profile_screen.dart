import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../models/affirmation.dart';
import '../services/affirmations_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
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
                  const SizedBox(height: 32),
                  Text("All Affirmations", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  ...affirmations.map((a) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        a.isCustom ? Icons.edit_note_rounded : Icons.spa_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(a.text),
                      subtitle: a.isCustom ? const Text("Custom") : null,
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
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.spa_rounded, size: 40, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              prefs.lifeStage.name[0].toUpperCase() + prefs.lifeStage.name.substring(1),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "${prefs.gender.name} • ${prefs.leaning.name}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
