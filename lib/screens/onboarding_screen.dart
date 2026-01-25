import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5;

  // Selected Preferences
  AppFocus _selectedFocus = AppFocus.general;
  SpiritualLeaning _selectedLeaning = SpiritualLeaning.secular;
  LifeStage _selectedLifeStage = LifeStage.other;
  Gender _selectedGender = Gender.preferNotToSay;

  void _finish() async {
    await UserPreferences.save(UserPreferences(
      focus: _selectedFocus,
      leaning: _selectedLeaning,
      lifeStage: _selectedLifeStage,
      gender: _selectedGender,
    ));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / _totalPages,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                minHeight: 6,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildWelcomePage(),
                  _buildGenderPage(),
                  _buildLifeStagePage(),
                  _buildFocusPage(),
                  _buildLeaningPage(),
                ],
              ),
            ),
            _buildNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return _buildPageTemplate(
      icon: Icons.spa_rounded,
      title: "Soft & Calm",
      description: "A gentle space for your mind to rest and grow. Let's personalize your experience.",
    );
  }

  Widget _buildGenderPage() {
    return _buildSelectionPage(
      title: "How do you identify?",
      options: Gender.values,
      selected: _selectedGender,
      onSelected: (val) => setState(() => _selectedGender = val as Gender),
    );
  }

  Widget _buildLifeStagePage() {
    return _buildSelectionPage(
      title: "What stage of life are you at?",
      options: LifeStage.values,
      selected: _selectedLifeStage,
      onSelected: (val) => setState(() => _selectedLifeStage = val as LifeStage),
    );
  }

  Widget _buildFocusPage() {
    return _buildSelectionPage(
      title: "What brings you here?",
      options: AppFocus.values,
      selected: _selectedFocus,
      onSelected: (val) => setState(() => _selectedFocus = val as AppFocus),
    );
  }

  Widget _buildLeaningPage() {
    return _buildSelectionPage(
      title: "Your spiritual leaning?",
      options: SpiritualLeaning.values,
      selected: _selectedLeaning,
      onSelected: (val) => setState(() => _selectedLeaning = val as SpiritualLeaning),
    );
  }

  Widget _buildSelectionPage({required String title, required List options, required dynamic selected, required Function(dynamic) onSelected}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12, runSpacing: 12,
            alignment: WrapAlignment.center,
            children: options.map((opt) {
              final name = opt.toString().split('.').last;
              final label = name[0].toUpperCase() + name.substring(1);
              return ChoiceChip(
                label: Text(label),
                selected: selected == opt,
                onSelected: (val) => onSelected(opt),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPageTemplate({required IconData icon, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 40),
          Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Text(description, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutExpo),
              child: const Text("Back"),
            )
          else
            const SizedBox(width: 60),
          FilledButton.tonal(
            onPressed: () {
              if (_currentPage < _totalPages - 1) {
                _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutExpo);
              } else {
                _finish();
              }
            },
            child: Text(_currentPage == _totalPages - 1 ? "Ready" : "Next"),
          ),
        ],
      ),
    );
  }
}
