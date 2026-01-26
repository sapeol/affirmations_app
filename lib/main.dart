import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'models/user_preferences.dart';

import 'services/notification_service.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
final ValueNotifier<String> fontNotifier = ValueNotifier('Plus Jakarta Sans');
final ValueNotifier<AppColorTheme> colorThemeNotifier = ValueNotifier(AppColorTheme.terminal);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  await NotificationService.init();
  
  final prefs = await UserPreferences.load();
  themeNotifier.value = prefs.themeMode;
  fontNotifier.value = prefs.fontFamily;
  colorThemeNotifier.value = prefs.colorTheme;
  
  // Schedule if enabled
  if (prefs.notificationsEnabled) {
    await NotificationService.scheduleDailyPing();
  }

  final bool onboardingCompleted = await _checkOnboarding();

  runApp(MyApp(onboardingCompleted: onboardingCompleted));
}

Future<bool> _checkOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('persona');
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
          title: 'Dopermations',
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
      builder: (_, _, _) => _buildRecursive(index + 1, context),
    );
  }
}
