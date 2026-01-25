import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'models/user_preferences.dart';

// Global notifier for theme switching
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await UserPreferences.load();
  themeNotifier.value = prefs.themeMode;
  
  // Check if onboarding completed (using 'leaning' as a proxy)
  final bool onboardingCompleted = await _checkOnboarding();

  runApp(MyApp(onboardingCompleted: onboardingCompleted));
}

Future<bool> _checkOnboarding() async {
  final prefs = await UserPreferences.load();
  // If we have a focus area set, onboarding is likely done
  return prefs.focus != AppFocus.general || prefs.leaning != SpiritualLeaning.secular;
}

class MyApp extends StatelessWidget {
  final bool onboardingCompleted;

  const MyApp({super.key, required this.onboardingCompleted});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Daily Affirmations',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: onboardingCompleted ? const HomeScreen() : const OnboardingScreen(),
        );
      },
    );
  }
}
