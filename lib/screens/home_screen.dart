import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../services/affirmations_service.dart';
import '../models/affirmation.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Affirmation _currentAffirmation;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _currentAffirmation = AffirmationsService.getDailyAffirmation();
    _updateWidget();
  }

  void _updateWidget() async {
    setState(() => _isUpdating = true);
    await HomeWidget.saveWidgetData<String>('affirmation_text', _currentAffirmation.text);
    await HomeWidget.updateWidget(
      name: 'AffirmationWidgetProvider',
      androidName: 'AffirmationWidgetProvider',
      iOSName: 'AffirmationWidget',
    );
    if (mounted) setState(() => _isUpdating = false);
  }

  void _refreshAffirmation() {
    setState(() {
      _currentAffirmation = AffirmationsService.getRandomAffirmation();
    });
    _updateWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Affirmations"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isUpdating)
                const Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Card(
                  key: ValueKey(_currentAffirmation.text),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.spa_rounded,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _currentAffirmation.text,
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
              const SizedBox(height: 48),
              FilledButton.tonalIcon(
                onPressed: _refreshAffirmation,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("New Affirmation"),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
