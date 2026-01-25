import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'models/user_preferences.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
final ValueNotifier<String> fontNotifier = ValueNotifier('Lexend');
final ValueNotifier<AppColorTheme> colorThemeNotifier = ValueNotifier(AppColorTheme.sage);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await UserPreferences.load();
  themeNotifier.value = prefs.themeMode;
  fontNotifier.value = prefs.fontFamily;
  colorThemeNotifier.value = prefs.colorTheme;
  
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
    return MultiValueListenableBuilder(
      notifiers: [themeNotifier, fontNotifier, colorThemeNotifier],
      builder: (context) {
        return MaterialApp(
          title: 'Daily Affirmations',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.createTheme(Brightness.light, fontNotifier.value, colorThemeNotifier.value),
          darkTheme: AppTheme.createTheme(Brightness.dark, fontNotifier.value, colorThemeNotifier.value),
          themeMode: themeNotifier.value,
          home: onboardingCompleted ? const HomeScreen() : const OnboardingScreen(),
        );
      },
    );
  }
}

class MultiValueListenableBuilder extends StatelessWidget {
  final List<ValueNotifier> notifiers;
  final WidgetBuilder builder;

  const MultiValueListenableBuilder({
    super.key,
    required this.notifiers,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return _buildRecursive(0, context);
  }

  Widget _buildRecursive(int index, BuildContext context) {
    if (index == notifiers.length) return builder(context);
    return ValueListenableBuilder(
      valueListenable: notifiers[index],
      builder: (_, __, ___) => _buildRecursive(index + 1, context),
    );
  }
}
