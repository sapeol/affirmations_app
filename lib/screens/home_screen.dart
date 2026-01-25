import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../services/affirmations_service.dart';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Affirmation? _currentAffirmation;
  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialAffirmation();
  }

  Future<void> _loadInitialAffirmation() async {
    final aff = await AffirmationsService.getDailyAffirmation();
    if (mounted) {
      setState(() => _currentAffirmation = aff);
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
    final aff = await AffirmationsService.getRandomAffirmation();
    setState(() => _currentAffirmation = aff);
    _updateWidget(aff);
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
                duration: const Duration(milliseconds: 600),
                child: aff == null
                    ? const SizedBox.shrink()
                    : Card(
                        key: ValueKey(aff.text),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
                          child: Column(
                            children: [
                              Icon(
                                aff.isCustom ? Icons.edit_note_rounded : Icons.spa_rounded,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                aff.text,
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
              const SizedBox(height: 100), // Spacing for FABs
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'refresh',
              onPressed: _refreshAffirmation,
              child: const Icon(Icons.refresh_rounded),
            ),
            FloatingActionButton.extended(
              heroTag: 'add',
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add),
              label: const Text("Create My Own"),
            ),
          ],
        ),
      ),
    );
  }
}