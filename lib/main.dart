import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'models/user_preferences.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
final ValueNotifier<String> fontNotifier = ValueNotifier('Lexend');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await UserPreferences.load();
  themeNotifier.value = prefs.themeMode;
  fontNotifier.value = prefs.fontFamily;
  
  final bool onboardingCompleted = await _checkOnboarding();

  runApp(MyApp(onboardingCompleted: onboardingCompleted));
}

Future<bool> _checkOnboarding() async {
  final prefs = await UserPreferences.load();
  return prefs.focus != AppFocus.general || prefs.leaning != SpiritualLeaning.secular;
}

class MyApp extends StatelessWidget {
  final bool onboardingCompleted;

  const MyApp({super.key, required this.onboardingCompleted});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder2<ThemeMode, String>(
      first: themeNotifier,
      second: fontNotifier,
      builder: (_, ThemeMode currentMode, String currentFont, __) {
        return MaterialApp(
          title: 'Daily Affirmations',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.createTheme(Brightness.light, currentFont),
          darkTheme: AppTheme.createTheme(Brightness.dark, currentFont),
          themeMode: currentMode,
          home: onboardingCompleted ? const HomeScreen() : const OnboardingScreen(),
        );
      },
    );
  }
}

// Simple helper to listen to two notifiers
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueNotifier<A> first;
  final ValueNotifier<B> second;
  final Widget Function(BuildContext, A, B, Widget?) builder;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, widget) {
            return builder(context, a, b, widget);
          },
        );
      },
    );
  }
}