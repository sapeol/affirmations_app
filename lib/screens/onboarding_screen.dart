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
  final int _totalPages = 3;

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
      notificationsEnabled: false,
    ));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(), // Allows both swipe and button navigation
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildWelcomePage(),
                  _buildIdentityPage(),
                  _buildMindsetPage(),
                ],
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(_totalPages, (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: _currentPage == index 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.outlineVariant,
              ),
            )),
          ),
          TextButton(
            onPressed: _finish,
            child: Text("Skip", style: TextStyle(color: Theme.of(context).colorScheme.outline)),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(Icons.spa_rounded, size: 100, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 48),
          Text(
            "Soft & Calm",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Your personalized space for daily light and mindful growth.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildIdentityPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text("Tell us about you", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 40),
          _buildSelectionTitle("I identify as..."),
          const SizedBox(height: 12),
          _buildStableSelection(Gender.values, _selectedGender, (v) => setState(() => _selectedGender = v as Gender)),
          const SizedBox(height: 32),
          _buildSelectionTitle("Life stage"),
          const SizedBox(height: 12),
          _buildStableSelection(LifeStage.values, _selectedLifeStage, (v) => setState(() => _selectedLifeStage = v as LifeStage)),
        ],
      ),
    );
  }

  Widget _buildMindsetPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text("Customize your path", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 40),
          _buildSelectionTitle("Focus area"),
          const SizedBox(height: 12),
          _buildStableSelection(AppFocus.values, _selectedFocus, (v) => setState(() => _selectedFocus = v as AppFocus)),
          const SizedBox(height: 32),
          _buildSelectionTitle("Spiritual leaning"),
          const SizedBox(height: 12),
          _buildStableSelection(SpiritualLeaning.values, _selectedLeaning, (v) => setState(() => _selectedLeaning = v as SpiritualLeaning)),
        ],
      ),
    );
  }

  Widget _buildSelectionTitle(String text) {
    return Text(text, style: Theme.of(context).textTheme.labelLarge?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    ));
  }

  Widget _buildStableSelection(List options, dynamic selected, Function(dynamic) onSelected) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        final name = opt.toString().split('.').last;
        final isSelected = selected == opt;
        return GestureDetector(
          onTap: () => onSelected(opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Text(
              name[0].toUpperCase() + name.substring(1),
              style: TextStyle(
                color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () {
            if (_currentPage < _totalPages - 1) {
              _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
            } else {
              _finish();
            }
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _currentPage == _totalPages - 1 ? "Start Journey" : "Continue",
              key: ValueKey(_currentPage),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
