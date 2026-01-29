import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'models/user_preferences.dart';
import 'services/notification_service.dart';
import 'services/affirmations_service.dart';
import 'services/auth_service.dart';
import 'locator.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
final fontFamilyProvider = StateProvider<String>((ref) => 'Roboto');
final colorThemeExProvider = StateProvider<AppColorTheme>((ref) => AppColorTheme.brutalist);

// Premium provider - loads from Firestore if user is signed in
final premiumProvider = StateProvider<bool>((ref) => false);
final authServiceProvider = Provider<AuthService>((ref) => locator<AuthService>());
final userProvider = StateProvider<User?>((ref) => null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Firebase
  await Firebase.initializeApp();
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  // Initialize Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordError(
      errorDetails.exception,
      errorDetails.stack,
      fatal: true,
    );
  };

  // Catch all async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  setupLocator();
  await locator<NotificationService>().init();
  await locator<AffirmationsService>().init();

  final prefs = await UserPreferences.load();

  final bool onboardingCompleted = await _checkOnboarding();

  // Create provider container for auth listener
  final container = ProviderScope(
    overrides: [
      themeModeProvider.overrideWith((ref) => prefs.themeMode),
      fontFamilyProvider.overrideWith((ref) => prefs.fontFamily),
      colorThemeExProvider.overrideWith((ref) => prefs.colorTheme),
    ],
    child: MyApp(onboardingCompleted: onboardingCompleted),
  );

  runApp(container);

  // Initialize auth listener after first frame
  // Note: We'll handle this in the widget's initState instead
}

Future<bool> _checkOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('persona');
}

class MyApp extends ConsumerStatefulWidget {
  final bool onboardingCompleted;

  const MyApp({super.key, required this.onboardingCompleted});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize auth state listener
    _initAuthListener();
  }

  Future<void> _initAuthListener() async {
    final authService = locator<AuthService>();

    // Listen to auth state changes
    authService.authStateChanges.listen((User? user) async {
      if (mounted) {
        ref.read(userProvider.notifier).state = user;

        // Load premium status from Firestore
        if (user != null) {
          final isPremium = await authService.isPremium();
          ref.read(premiumProvider.notifier).state = isPremium;
        } else {
          ref.read(premiumProvider.notifier).state = false;
        }
      }
    });

    // Initial check
    if (authService.currentUser != null) {
      final isPremium = await authService.isPremium();
      if (mounted) {
        ref.read(premiumProvider.notifier).state = isPremium;
        ref.read(userProvider.notifier).state = authService.currentUser;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final fontFamily = ref.watch(fontFamilyProvider);
    final colorTheme = ref.watch(colorThemeExProvider);

    return MaterialApp(
      title: 'Delusions: Anti-Affirmations',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.createTheme(Brightness.light, fontFamily, colorTheme),
      darkTheme: AppTheme.createTheme(Brightness.dark, fontFamily, colorTheme),
      themeMode: themeMode,
      home: widget.onboardingCompleted ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
