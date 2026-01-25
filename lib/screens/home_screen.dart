import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../services/affirmations_service.dart';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  Affirmation? _currentAffirmation;
  final TextEditingController _customController = TextEditingController();
  bool _isLoading = true;
  int _loadingStep = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialAffirmation();
  }

  Future<void> _loadInitialAffirmation() async {
    setState(() {
      _isLoading = true;
      _loadingStep = 0;
    });
    
    final aff = await AffirmationsService.getDailyAffirmation();
    
    // Meditative multi-step loading for emotional resonance
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _loadingStep = 1);
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
    setState(() {
      _isLoading = true;
      _loadingStep = 0;
    });
    
    final aff = await AffirmationsService.getRandomAffirmation();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() => _loadingStep = 1);
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (mounted) {
      setState(() {
        _currentAffirmation = aff;
        _isLoading = false;
      });
      _updateWidget(aff);
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create Affirmation"),
        content: TextField(
          controller: _customController,
          decoration: const InputDecoration(hintText: "I am..."),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          FilledButton.tonal(
            onPressed: () async {
              if (_customController.text.isNotEmpty) {
                final newAff = Affirmation(text: _customController.text, isCustom: true);
                await UserPreferences.addCustomAffirmation(newAff);
                _customController.clear();
                if (!context.mounted) return;
                Navigator.pop(context);
                _refreshAffirmation();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 1200),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: _isLoading
                    ? _BreathingLoader(step: _loadingStep)
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
                                      height: 1.6,
                                      letterSpacing: 0.5,
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
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add),
            label: const Text("Create My Own"),
          ),
        ],
      ),
    );
  }
}

class _BreathingLoader extends StatefulWidget {
  final int step;
  const _BreathingLoader({required this.step});

  @override
  State<_BreathingLoader> createState() => _BreathingLoaderState();
}

class _BreathingLoaderState extends State<_BreathingLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ["Inhaling peace...", "Exhaling tension...", "Preparing your light..."];
    final message = messages[widget.step % messages.length];

    return Column(
      key: const ValueKey('breathing_loader'),
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _animation,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            ),
            child: Icon(
              Icons.spa_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(height: 48),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: Text(
            message,
            key: ValueKey(message),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.2,
                ),
          ),
        ),
      ],
    );
  }
}
