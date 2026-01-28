import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/user_preferences.dart';
import '../models/affirmation.dart';
import '../services/affirmations_service.dart';
import 'streak_detail_screen.dart';
import 'weekly_report_screen.dart';
import 'affirmations_list_screen.dart';
import '../locator.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("MY PROFILE")),
      body: FutureBuilder<UserPreferences>(
        future: UserPreferences.load(),
        builder: (context, prefSnapshot) {
          final affirmationsService = locator<AffirmationsService>();
          
          return StreamBuilder<List<Affirmation>>(
            stream: affirmationsService.isar.affirmations.where().watch(fireImmediately: true),
            builder: (context, affSnapshot) {
              if (!prefSnapshot.hasData || !affSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final prefs = prefSnapshot.data!;
              final affirmations = affSnapshot.data!;
              
              final likedAffs = affirmations.where((a) => 
                prefs.likedAffirmations.contains(a.getText(DopeLanguage.en))
              ).toList();

              final customAffs = affirmations.where((a) => a.isCustom).toList();

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildHeader(context, prefs),
                  const SizedBox(height: 24),
                  _buildReportTile(context),
                  const SizedBox(height: 24),
                  _buildCategoryTile(
                    context,
                    "SAVED PERSPECTIVES",
                    "Your library of lies you liked.",
                    Icons.favorite_rounded,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AffirmationsListScreen(
                          title: "Saved Perspectives",
                          affirmations: likedAffs,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryTile(
                    context,
                    "PERSONAL WRITE-UPS",
                    "Your own custom delusions.",
                    Icons.edit_note_rounded,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AffirmationsListScreen(
                          title: "Personal Write-ups",
                          affirmations: customAffs,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      child: Semantics(
        button: true,
        label: title,
        hint: 'Double tap to view',
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right_rounded, size: 16),
        ),
      ),
    );
  }

  Widget _buildReportTile(BuildContext context) {
    return _buildCategoryTile(
      context,
      "WEEKLY REFLECTION",
      "View your progress this week",
      Icons.auto_awesome_mosaic_rounded,
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WeeklyReportScreen()),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserPreferences prefs) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.blur_on_rounded, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            _formatName(prefs.persona.name).toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 2),
          ),
          const SizedBox(height: 16),
          Semantics(
            button: true,
            label: 'System uptime: ${prefs.sanityStreak} days',
            hint: 'Double tap to view streak details',
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StreakDetailScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      "SYSTEM UPTIME: ${prefs.sanityStreak} DAYS",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatName(String name) {
    if (name == 'adhdBrain') return 'ADHD Brain';
    if (name == 'burntOut') return 'Burned Out';
    return name;
  }
}
