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

  // Selected Preferences
  AppFocus _selectedFocus = AppFocus.general;
  SpiritualLeaning _selectedLeaning = SpiritualLeaning.secular;

  void _finish() async {
    await UserPreferences.save(UserPreferences(
      focus: _selectedFocus,
      leaning: _selectedLeaning,
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
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: LinearProgressIndicator(
                value: 0.33, // This can be updated per page
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildWelcomePage(),
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
      description: "A gentle space for your mind to rest and grow.",
    );
  }

  Widget _buildFocusPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("What brings you here?", 
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: AppFocus.values.map((f) => ChoiceChip(
              label: Text(f.name[0].toUpperCase() + f.name.substring(1)),
              selected: _selectedFocus == f,
              onSelected: (val) => setState(() => _selectedFocus = f),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaningPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Your spiritual leaning?", 
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12, runSpacing: 12,
            alignment: WrapAlignment.center,
            children: SpiritualLeaning.values.map((l) => ChoiceChip(
              label: Text(l.name[0].toUpperCase() + l.name.substring(1)),
              selected: _selectedLeaning == l,
              onSelected: (val) => setState(() => _selectedLeaning = l),
            )).toList(),
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
              if (_currentPage < 2) {
                _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutExpo);
              } else {
                _finish();
              }
            },
            child: Text(_currentPage == 2 ? "Ready" : "Next"),
          ),
        ],
      ),
    );
  }
}