import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../services/affirmations_service.dart';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'create_affirmation_screen.dart';
import '../locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  Affirmation? _currentAffirmation;
  bool _isLoading = true;
  final ScreenshotController _screenshotController = ScreenshotController();
  List<String> _likedIds = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final prefs = await UserPreferences.load();
    setState(() {
      _likedIds = prefs.likedAffirmations;
    });
    _loadInitialAffirmation();
  }

  Future<void> _loadInitialAffirmation() async {
    setState(() => _isLoading = true);
    final aff = await locator<AffirmationsService>().getDailyAffirmation();
    await locator<AffirmationsService>().markAffirmationAsSeen(aff.getText(DopeLanguage.en));
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      setState(() {
        _currentAffirmation = aff;
        _isLoading = false;
      });
      _updateWidget(aff);
    }
  }

  void _updateWidget(Affirmation aff) {
    HomeWidget.saveWidgetData<String>('affirmation_text', aff.getText(DopeLanguage.en));
    HomeWidget.updateWidget(
      name: 'AffirmationWidgetProvider',
      androidName: 'AffirmationWidgetProvider',
      iOSName: 'AffirmationWidget',
    );
  }

  void _refreshAffirmation() async {
    final currentText = _currentAffirmation?.getText(DopeLanguage.en);
    setState(() => _isLoading = true);
    final aff = await locator<AffirmationsService>().getRandomAffirmation(excludeText: currentText);
    await locator<AffirmationsService>().markAffirmationAsSeen(aff.getText(DopeLanguage.en));
    
    final prefs = await UserPreferences.load();
    if (!prefs.notificationsEnabled && mounted) {
      _showNotificationPrompt();
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (mounted) {
      setState(() {
        _currentAffirmation = aff;
        _isLoading = false;
      });
      _updateWidget(aff);
    }
  }

  void _toggleLike() async {
    if (_currentAffirmation == null) return;
    final id = _currentAffirmation!.getText(DopeLanguage.en);
    
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });

    final prefs = await UserPreferences.load();
    await UserPreferences.save(UserPreferences(
      persona: prefs.persona,
      themeMode: prefs.themeMode,
      fontFamily: prefs.fontFamily,
      colorTheme: prefs.colorTheme,
      language: prefs.language,
      likedAffirmations: _likedIds,
      notificationsEnabled: prefs.notificationsEnabled,
      notificationHour: prefs.notificationHour,
      notificationMinute: prefs.notificationMinute,
      sanityStreak: prefs.sanityStreak,
      lastInteractionDate: prefs.lastInteractionDate,
      firstRunDate: prefs.firstRunDate,
    ));
  }

  Future<void> _shareAsImage() async {
    if (_currentAffirmation == null) return;
    
    final image = await _screenshotController.captureFromWidget(
      _buildShareCard(_currentAffirmation!),
      delay: const Duration(milliseconds: 10),
    );

    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/dopermation.png').create();
    await imagePath.writeAsBytes(image);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(imagePath.path)],
        text: 'Check this Dopermation.',
      ),
    );
  }

  Widget _buildShareCard(Affirmation aff) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(40),
      color: const Color(0xFF0D0D0D),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, color: Colors.greenAccent, size: 48),
          const SizedBox(height: 32),
          Text(
            aff.getText(DopeLanguage.en),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            "DOPERMATIONS",
            style: TextStyle(color: Colors.greenAccent, fontSize: 10, letterSpacing: 4, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showNotificationPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.notifications_active_outlined),
        title: const Text("Daily Inspiration?"),
        content: const Text("Would you like to receive a gentle affirmation every morning to start your day with light?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Later")),
          FilledButton.tonal(
            onPressed: () async {
              final prefs = await UserPreferences.load();
              await UserPreferences.save(UserPreferences(
                persona: prefs.persona,
                themeMode: prefs.themeMode,
                fontFamily: prefs.fontFamily,
                colorTheme: prefs.colorTheme,
                language: prefs.language,
                likedAffirmations: prefs.likedAffirmations,
                notificationsEnabled: true,
                notificationHour: prefs.notificationHour,
                notificationMinute: prefs.notificationMinute,
                sanityStreak: prefs.sanityStreak,
                lastInteractionDate: prefs.lastInteractionDate,
                firstRunDate: prefs.firstRunDate,
              ));
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Notifications enabled"),
                  behavior: SnackBarBehavior.fixed,
                ),
              );
            },
            child: const Text("Enable"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final aff = _currentAffirmation;

    return FutureBuilder<UserPreferences>(
      future: UserPreferences.load(),
      builder: (context, prefSnapshot) {
        final lang = prefSnapshot.data?.language ?? DopeLanguage.en;
        final displayText = aff?.getText(lang) ?? "";
        final isLiked = _likedIds.contains(aff?.getText(DopeLanguage.en));

        return Scaffold(
          appBar: AppBar(
            title: const Text("DOPERMATIONS", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.bolt_rounded, color: Theme.of(context).colorScheme.primary),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
            ),
            actions: [
              if (prefSnapshot.hasData)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "STREAK",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        Text(
                          "${prefSnapshot.data!.sanityStreak}D",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                ).then((_) => _loadInitialAffirmation()),
              ),
            ],
          ),
          body: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        child: _isLoading
                            ? const ExpressiveLoader(key: ValueKey('loading'))
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Card(
                                    key: ValueKey(displayText),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            displayText,
                                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                  fontWeight: FontWeight.w800,
                                                  height: 1.3,
                                                  letterSpacing: -0.5,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 24),
                                          if (aff?.persona != null)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                aff!.persona!.name.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).colorScheme.primary,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: _toggleLike,
                                        icon: Icon(
                                          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                          color: isLiked ? Colors.redAccent : Theme.of(context).colorScheme.outline,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        onPressed: _shareAsImage,
                                        icon: Icon(Icons.share_rounded, color: Theme.of(context).colorScheme.outline),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
                                    ),
                                    onPressed: () async {
                                      String msg;
                                      final useSystemRebuttal = DateTime.now().millisecond % 2 == 0;
                                      
                                      if (useSystemRebuttal) {
                                        await UserPreferences.load(); // Load ensures DB init if needed, though usually already loaded
                                        msg = await locator<AffirmationsService>().getRebuttal();
                                      } else {
                                        final msgs = [
                                          "Cool. This isn’t one. It’s just a reminder you’re not trash.",
                                          "You don’t have to believe this. Just don’t spiral.",
                                          "Skepticism noted. You're still doing fine.",
                                          "Hate away. The system doesn't mind.",
                                          "It's just text on a screen. Breathe.",
                                        ];
                                        msg = msgs[DateTime.now().second % msgs.length];
                                      }
                                      
                                      if (context.mounted) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: const Color(0xFF1A0505),
                                            title: const Text("RECEIVED", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                            content: Text(msg, style: const TextStyle(color: Colors.white70)),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text("FINE"),
                                              ),
                                            ],
                                          ),
                                        );
                                        _refreshAffirmation();
                                      }
                                    },
                                    child: const Text("I DON'T THINK SO", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'add',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateAffirmationScreen()),
              );
              if (result == true) _refreshAffirmation();
            },
            icon: const Icon(Icons.add),
            label: const Text("OWN PERSPECTIVE"),
          ),
        );
      },
    );
  }
}

class ExpressiveLoader extends StatefulWidget {
  const ExpressiveLoader({super.key});

  @override
  State<ExpressiveLoader> createState() => _ExpressiveLoaderState();
}

class _ExpressiveLoaderState extends State<ExpressiveLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _TerminalPainter(
                  progress: _controller.value,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
        Text(
          "GETTING REAL...",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _TerminalPainter extends CustomPainter {
  final double progress;
  final Color color;

  _TerminalPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double cursorWidth = size.width * 0.6;
    final double cursorHeight = 8.0;
    
    if (progress < 0.5) {
      canvas.drawRect(
        Rect.fromLTWH((size.width - cursorWidth)/2, size.height/2 - 4, cursorWidth, cursorHeight),
        paint
      );
    }
  }

  @override
  bool shouldRepaint(_TerminalPainter oldDelegate) => true;
}