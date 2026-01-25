import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../models/affirmation.dart';
import '../services/affirmations_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MY PROFILE")),
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
              final likedIds = prefs.likedAffirmations;

              final likedAffs = likedIds.map((id) {
                // Find in library or custom
                return affirmations.firstWhere(
                  (a) => a.getText(DopeLanguage.en) == id,
                  orElse: () => Affirmation(text: id, isCustom: true), // Fallback for custom ones
                );
              }).toList();

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildHeader(context, prefs),
                  const SizedBox(height: 40),
                  if (likedAffs.isNotEmpty) ...[
                    Text("LIKED PERSPECTIVES", style: _sectionStyle(context)),
                    const SizedBox(height: 16),
                    ...likedAffs.map((a) => _buildAffirmationTile(context, a)),
                    const SizedBox(height: 32),
                  ],
                  Text("ALL AVAILABLE", style: _sectionStyle(context)),
                  const SizedBox(height: 16),
                  ...affirmations.map((a) => _buildAffirmationTile(context, a)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  TextStyle _sectionStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
      letterSpacing: 2, 
      fontWeight: FontWeight.bold, 
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildAffirmationTile(BuildContext context, Affirmation a) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), 
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        leading: Icon(
          a.isCustom ? Icons.edit_note_rounded : Icons.bolt_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(a.getText(DopeLanguage.en), style: const TextStyle(fontSize: 14)),
        subtitle: Text(a.persona?.name.toUpperCase() ?? "GENERAL", style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.outline)),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat("PRESSURE", prefs.systemLoad),
              _buildStat("FUEL", prefs.batteryLevel),
              _buildStat("CAPACITY", prefs.bandwidth),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStat(String label, double value) {
    return Column(
      children: [
        Text("${(value * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 8, letterSpacing: 1)),
      ],
    );
  }
}