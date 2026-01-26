import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';
import '../theme.dart';

class SwipeCard extends StatelessWidget {
  final Affirmation affirmation;
  final DopeLanguage language;
  final Future<bool> Function(dynamic direction) onSwipe;
  final bool isEnabled;

  const SwipeCard({
    super.key,
    required this.affirmation,
    required this.language,
    required this.onSwipe,
    this.isEnabled = true,
  });

  static List<Color> getGradientForAffirmation(String text, AppColorTheme theme) {
    final palette = AppTheme.palettes[theme] ?? AppTheme.palettes[AppColorTheme.brutalist]!;
    final gradients = palette.cardGradients;
    final index = text.length % gradients.length;
    return gradients[index];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserPreferences>(
      future: UserPreferences.load(),
      builder: (context, snapshot) {
        final theme = snapshot.data?.colorTheme ?? AppColorTheme.brutalist;
        final displayText = affirmation.getText(language);
        final gradient = getGradientForAffirmation(displayText, theme);
        
        final isSystemDark = Theme.of(context).brightness == Brightness.dark;
        final palette = AppTheme.palettes[theme] ?? AppTheme.palettes[AppColorTheme.brutalist]!;
        final bool effectiveIsDark = palette.isAlwaysDark || isSystemDark;
        
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: effectiveIsDark ? 0.4 : 0.05),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: effectiveIsDark 
                        ? gradient.map((c) => Color.lerp(c, Colors.black, 0.7)!).toList()
                        : gradient,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.spa_rounded, 
                        color: effectiveIsDark ? Colors.white10 : Colors.black26, 
                        size: 32
                      ),
                      const Spacer(),
                      Text(
                        displayText,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: effectiveIsDark ? Colors.white : Colors.black,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Text(
                        "FROM ${affirmation.persona.name.toUpperCase()}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: effectiveIsDark ? Colors.white24 : Colors.black38,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().shimmer(delay: 2.seconds, duration: 2.seconds, color: Colors.white10);
      },
    );
  }
}
