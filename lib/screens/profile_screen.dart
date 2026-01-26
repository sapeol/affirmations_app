import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../models/affirmation.dart';
import '../services/affirmations_service.dart';
import '../services/receipt_service.dart';
import 'streak_detail_screen.dart';
import '../locator.dart';

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
            future: locator<AffirmationsService>().getAllAffirmations(),
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
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final data = await locator<ReceiptService>().generateWeeklyReceipt();
                      final text = locator<ReceiptService>().formatReceipt(data);
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            content: Text(
                              text, 
                              style: const TextStyle(
                                fontFamily: 'Courier', 
                                color: Colors.black, 
                                fontWeight: FontWeight.bold
                              )
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE")),
                            ],
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.receipt_long_rounded),
                    label: const Text("VIEW WEEKLY RECEIPT"),
                  ),
                  const SizedBox(height: 40),
                  Text("SAVED PERSPECTIVES", style: _sectionStyle(context)),
                  const SizedBox(height: 16),
                  if (likedAffs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: Text(
                          "NO SAVED DATA. START LIKING TO BUILD YOUR SYSTEM.",
                          style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 10, letterSpacing: 1),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ...likedAffs.map((a) => _buildAffirmationTile(context, a)),
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
            _formatName(prefs.persona.name).toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StreakDetailScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
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
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
                ],
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