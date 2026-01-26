import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import 'home_screen.dart';

import '../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  DopePersona _selectedPersona = DopePersona.overthinker;
  DopeTone _selectedTone = DopeTone.straight;
  AppColorTheme _selectedTheme = AppColorTheme.terminal;

  void _finish() async {
    await UserPreferences.save(UserPreferences(
      persona: _selectedPersona,
      tone: _selectedTone,
      colorTheme: _selectedTheme,
      notificationsEnabled: false,
      firstRunDate: DateTime.now().toIso8601String(),
      seenAffirmations: const [],
      seenRebuttals: const [],
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
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildWelcomePage(),
                  _buildPersonaPage(),
                  _buildStylePage(),
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
            child: Text("SKIP", style: TextStyle(color: Theme.of(context).colorScheme.outline, fontWeight: FontWeight.bold, fontSize: 12)),
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
          Icon(Icons.bolt_rounded, size: 100, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 48),
          Text(
            "DOPERMATIONS",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Affirmations for people who hate affirmations. No manifest, just system reality.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5, color: Theme.of(context).colorScheme.outline),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildPersonaPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text("USER PERSONA", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text("HOW DOES YOUR BRAIN TYPICALLY OPERATE?", style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 40),
          _buildStableSelection(DopePersona.values, _selectedPersona, (v) => setState(() => _selectedPersona = v as DopePersona)),
        ],
      ),
    );
  }

  Widget _buildStylePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text("SYSTEM VIBE", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 40),
          _buildSelectionTitle("TONE OUTPUT"),
          _buildStableSelection(DopeTone.values, _selectedTone, (v) => setState(() => _selectedTone = v as DopeTone)),
          const SizedBox(height: 32),
          _buildSelectionTitle("COLOR PALETTE"),
          _buildStableSelection(AppColorTheme.values, _selectedTheme, (v) {
            setState(() => _selectedTheme = v as AppColorTheme);
            colorThemeNotifier.value = v as AppColorTheme;
          }),
        ],
      ),
    );
  }

  Widget _buildSelectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2)),
    );
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Text(
              _formatName(name).toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatName(String name) {
    if (name == 'adhdBrain') return 'ADHD Brain';
    if (name == 'burntOut') return 'Burned Out';
    if (name == 'deadpanTherapist') return 'Deadpan Therapist';
    if (name == 'softBullyFriend') return 'Soft Bully Friend';
    if (name == 'tiredMonk') return 'Tired Monk';
    if (name == 'overqualifiedHater') return 'Overqualified Hater';
    if (name == 'corporateBurnoutSurvivor') return 'Corp. Burnout Survivor';
    return name;
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            if (_currentPage < _totalPages - 1) {
              _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
            } else {
              _finish();
            }
          },
          child: Text(
            _currentPage == _totalPages - 1 ? "INITIALIZE SYSTEM" : "CONTINUE",
            style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
        ),
      ),
    );
  }
}