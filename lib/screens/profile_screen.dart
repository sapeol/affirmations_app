import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../models/affirmation.dart';
import '../services/affirmations_service.dart';
import 'streak_detail_screen.dart';
import 'weekly_report_screen.dart';
import '../locator.dart';
import '../widgets/swipe_card.dart';

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
                return affirmations.firstWhere(
                  (a) => a.getText(DopeLanguage.en) == id,
                  orElse: () => Affirmation(text: id, isCustom: true),
                );
              }).toList();

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildHeader(context, prefs),
                  const SizedBox(height: 24),
                  _buildReportTile(context),
                  const SizedBox(height: 40),
                  Text("SAVED PERSPECTIVES", style: _sectionStyle(context)),
                  const SizedBox(height: 16),
                  if (likedAffs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: Text(
                          "NO SAVED DATA. START LIKING TO BUILD YOUR SYSTEM.",
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w900),
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
      fontWeight: FontWeight.w900, 
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildAffirmationTile(BuildContext context, Affirmation a) {
    final displayText = a.getText(DopeLanguage.en);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => _showAffirmationCard(context, a),
        leading: Icon(
          a.isCustom ? Icons.edit_note_rounded : Icons.spa_rounded,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        title: Text(
          displayText, 
          maxLines: 2, 
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16, // Minimum 16px for body
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
      ),
    );
  }

  void _showAffirmationCard(BuildContext context, Affirmation a) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: FadeTransition(
            opacity: anim1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Hero(
                  tag: 'aff-${a.getText(DopeLanguage.en)}',
                  child: Material(
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        SwipeCard(
                          affirmation: a,
                          language: DopeLanguage.en,
                          onSwipe: (_) async => true,
                          isEnabled: false,
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportTile(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WeeklyReportScreen()),
        ),
        leading: Icon(Icons.auto_awesome_mosaic_rounded, color: Theme.of(context).colorScheme.primary),
        title: Text(
          "WEEKLY REFLECTION",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2, color: Theme.of(context).colorScheme.onSurface),
        ),
        subtitle: Text(
          "View your progress this week",
          style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.chevron_right_rounded, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
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
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 2, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 16),
          GestureDetector(
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
                      fontSize: 11,
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