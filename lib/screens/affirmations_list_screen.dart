import 'package:flutter/material.dart';
import '../models/affirmation.dart';
import '../widgets/swipe_card.dart';
import '../models/user_preferences.dart';
import 'dart:ui';

class AffirmationsListScreen extends StatelessWidget {
  final String title;
  final List<Affirmation> affirmations;

  const AffirmationsListScreen({
    super.key,
    required this.title,
    required this.affirmations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title.toUpperCase())),
      body: affirmations.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  "EMPTY. NOTHING TO SEE HERE.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 14,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: affirmations.length,
              itemBuilder: (context, index) {
                final a = affirmations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () => _showAffirmationCard(context, a),
                    leading: Icon(
                      a.isCustom ? Icons.edit_note_rounded : Icons.spa_rounded,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    title: Text(
                      a.getText(DopeLanguage.en),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 16),
                  ),
                );
              },
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
}
