import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'models/user_preferences.dart';
import 'services/notification_service.dart';
import 'services/affirmations_service.dart';
import 'locator.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
final fontFamilyProvider = StateProvider<String>((ref) => 'Roboto');
final colorThemeExProvider = StateProvider<AppColorTheme>((ref) => AppColorTheme.brutalist);
final premiumProvider = StateProvider<bool>((ref) => false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  setupLocator();
  await locator<NotificationService>().init();
  await locator<AffirmationsService>().init();
  
  final prefs = await UserPreferences.load();
  
  final bool onboardingCompleted = await _checkOnboarding();

  runApp(
    ProviderScope(
      overrides: [
        themeModeProvider.overrideWith((ref) => prefs.themeMode),
        fontFamilyProvider.overrideWith((ref) => prefs.fontFamily),
        colorThemeExProvider.overrideWith((ref) => prefs.colorTheme),
      ],
      child: MyApp(onboardingCompleted: onboardingCompleted),
    ),
  );
}

Future<bool> _checkOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('persona');
}

class MyApp extends ConsumerWidget {
  final bool onboardingCompleted;

  const MyApp({super.key, required this.onboardingCompleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontFamily = ref.watch(fontFamilyProvider);
    final colorTheme = ref.watch(colorThemeExProvider);

    return MaterialApp(
      title: 'Dopermations',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.createTheme(Brightness.light, fontFamily, colorTheme),
      darkTheme: AppTheme.createTheme(Brightness.dark, fontFamily, colorTheme),
      themeMode: themeMode,
      home: onboardingCompleted ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
