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
import '../widgets/swipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<Affirmation> _affirmations = [];
  bool _isLoading = true;
  final ScreenshotController _screenshotController = ScreenshotController();
  List<String> _likedIds = [];
  final List<Affirmation> _history = [];

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
    _loadAffirmations();
  }

  Future<void> _loadAffirmations() async {
    setState(() => _isLoading = true);
    final service = locator<AffirmationsService>();
    final all = await service.getAllAffirmations();
    all.shuffle();
    
    if (mounted) {
      setState(() {
        _affirmations = all;
        _isLoading = false;
      });
      if (_affirmations.isNotEmpty) {
        _updateWidget(_affirmations.first);
      }
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

  void _onSwipe(bool isLike) {
    if (_affirmations.isEmpty) return;
    
    final removed = _affirmations.removeAt(0);
    _history.add(removed);
    if (_history.length > 10) _history.removeAt(0);

    if (isLike) {
      _toggleLike(removed);
    }

    if (_affirmations.isNotEmpty) {
      _updateWidget(_affirmations.first);
    } else {
      _loadAffirmations();
    }
    
    setState(() {});
  }

  void _undoSwipe() {
    if (_history.isEmpty) return;
    
    setState(() {
      final last = _history.removeLast();
      _affirmations.insert(0, last);
    });
    _updateWidget(_affirmations.first);
  }

  void _toggleLike(Affirmation aff) async {
    final id = aff.getText(DopeLanguage.en);
    
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
    if (_affirmations.isEmpty) return;
    final current = _affirmations.first;
    
    final image = await _screenshotController.captureFromWidget(
      _buildShareCard(current),
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserPreferences>(
      future: UserPreferences.load(),
      builder: (context, prefSnapshot) {
        final lang = prefSnapshot.data?.language ?? DopeLanguage.en;

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
                ).then((_) => _loadAffirmations()),
              ),
            ],
          ),
          body: Stack(
            children: [
              if (_isLoading)
                const Center(child: ExpressiveLoader())
              else if (_affirmations.isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No more affirmations for now."),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAffirmations,
                        child: const Text("Reload"),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: _affirmations
                            .take(3)
                            .toList()
                            .reversed
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                          final reversedIndex = entry.key; // 0 is bottom, 2 is top
                          final aff = entry.value;
                          final isTop = reversedIndex == _affirmations.take(3).length - 1;

                          return Positioned(
                            top: 100.0 - (reversedIndex * 10),
                            child: SwipeCard(
                              key: ValueKey(aff.getText(DopeLanguage.en)),
                              affirmation: aff,
                              language: lang,
                              onSwipe: isTop ? _onSwipe : (_) {},
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filledTonal(
                          onPressed: _history.isEmpty ? null : _undoSwipe,
                          icon: const Icon(Icons.undo_rounded),
                          tooltip: "Undo Swipe",
                        ),
                        const SizedBox(width: 24),
                        IconButton.filledTonal(
                          onPressed: _shareAsImage,
                          icon: const Icon(Icons.share_rounded),
                          tooltip: "Share current",
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
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
              if (result == true) _loadAffirmations();
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