import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../services/affirmations_service.dart';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'create_affirmation_screen.dart';
import 'mood_checkin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  Affirmation? _currentAffirmation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialAffirmation();
  }

  Future<void> _loadInitialAffirmation() async {
    setState(() => _isLoading = true);
    final aff = await AffirmationsService.getDailyAffirmation();
    await Future.delayed(const Duration(milliseconds: 1200));
    
    if (mounted) {
      setState(() {
        _currentAffirmation = aff;
        _isLoading = false;
      });
      _updateWidget(aff);
    }
  }

  void _updateWidget(Affirmation aff) {
    HomeWidget.saveWidgetData<String>('affirmation_text', aff.text);
    HomeWidget.updateWidget(
      name: 'AffirmationWidgetProvider',
      androidName: 'AffirmationWidgetProvider',
      iOSName: 'AffirmationWidget',
    );
  }

  void _refreshAffirmation() async {
    setState(() => _isLoading = true);
    final aff = await AffirmationsService.getRandomAffirmation();
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (mounted) {
      setState(() {
        _currentAffirmation = aff;
        _isLoading = false;
      });
      _updateWidget(aff);
    }
  }

  @override
  Widget build(BuildContext context) {
    final aff = _currentAffirmation;

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
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ).then((_) => _loadInitialAffirmation()),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMoodPrompt(),
              const SizedBox(height: 48),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                child: _isLoading
                    ? const ExpressiveLoader(key: ValueKey('loading'))
                    : Card(
                        key: ValueKey(aff?.text ?? 'none'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                aff?.text ?? "",
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
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'refresh',
            mini: true,
            onPressed: _isLoading ? null : _refreshAffirmation,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
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
        ],
      ),
    );
  }

  Widget _buildMoodPrompt() {
    return FutureBuilder<UserPreferences>(
      future: UserPreferences.load(),
      builder: (context, snapshot) {
        final mood = snapshot.data?.lastMoodCategory;
        return ActionChip(
          label: Text(mood != null ? "VIBE: $mood" : "HOW'S THE BRAIN?"),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MoodCheckInScreen()),
            );
            if (result == true) _loadInitialAffirmation();
          },
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

    // Draw a blinking terminal cursor or similar geometric dope loader
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