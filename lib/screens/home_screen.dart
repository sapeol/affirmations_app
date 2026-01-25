import 'package:flutter/material.dart';
import 'dart:math' as math;
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
    HomeWidget.saveWidgetData<String>('affirmation_text', aff.text);
    HomeWidget.updateWidget(
      name: 'AffirmationWidgetProvider',
      androidName: 'com.example.affirmations_app.AffirmationWidgetProvider',
      iOSName: 'AffirmationWidget',
    );
  }

  void _refreshAffirmation() async {
    setState(() => _isLoading = true);
    final aff = await AffirmationsService.getRandomAffirmation();
    
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
                leaning: prefs.leaning,
                focus: prefs.focus,
                lifeStage: prefs.lifeStage,
                gender: prefs.gender,
                themeMode: prefs.themeMode,
                fontFamily: prefs.fontFamily,
                colorTheme: prefs.colorTheme,
                userContext: prefs.userContext,
                tone: prefs.tone,
                lastMoodCategory: prefs.lastMoodCategory,
                notificationsEnabled: true,
              ));
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Notifications enabled")),
              );
            },
            child: const Text("Enable"),
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
          avatar: Icon(Icons.psychology_outlined, size: 16, color: Theme.of(context).colorScheme.primary),
          label: Text(mood != null ? "Feeling $mood? Update..." : "How are you truly?"),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MoodCheckInScreen()),
            );
            if (result == true) _loadInitialAffirmation();
          },
          backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final aff = _currentAffirmation;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Affirmations"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.spa_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
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
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                child: _isLoading
                    ? const ExpressiveLoader(key: ValueKey('loading'))
                    : Card(
                        key: ValueKey(aff?.text ?? 'none'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
                          child: Column(
                            children: [
                              Icon(
                                aff?.isCustom == true ? Icons.edit_note_rounded : Icons.spa_rounded,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                aff?.text ?? "",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                    ),
                                textAlign: TextAlign.center,
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
              if (result == true) {
                _refreshAffirmation();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text("Create My Own"),
          ),
        ],
      ),
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
      duration: const Duration(milliseconds: 3000),
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
          width: 100,
          height: 100,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _ExpressivePainter(
                  progress: _controller.value,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
        Text(
          "Gathering light...",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _ExpressivePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ExpressivePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final stepProgress = (progress + (i * 0.33)) % 1.0;
      final rotation = stepProgress * math.pi * 2;
      final scale = 0.6 + (math.sin(stepProgress * math.pi * 2) * 0.4);
      final opacity = 0.2 + (math.sin(stepProgress * math.pi) * 0.5);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);
      
      paint.color = color.withValues(alpha: opacity.clamp(0.0, 1.0));
      
      final path = Path()
        ..moveTo(0, -20 * scale)
        ..quadraticBezierTo(15 * scale, -30 * scale, 20 * scale, 0)
        ..quadraticBezierTo(15 * scale, 30 * scale, 0, 20 * scale)
        ..quadraticBezierTo(-15 * scale, 30 * scale, -20 * scale, 0)
        ..quadraticBezierTo(-15 * scale, -30 * scale, 0, -20 * scale)
        ..close();

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ExpressivePainter oldDelegate) => true;
}
