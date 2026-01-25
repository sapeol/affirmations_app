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

  DopePersona _selectedPersona = DopePersona.overthinker;
  DopeTone _selectedTone = DopeTone.straight;

  void _finish() async {
    await UserPreferences.save(UserPreferences(
      persona: _selectedPersona,
      tone: _selectedTone,
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
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildWelcomePage(),
                  _buildPersonaPage(),
                  _buildTonePage(),
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
          Icon(Icons.bolt_rounded, size: 100, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 48),
          Text(
            "Dopermations",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Affirmations for people who hate affirmations. Grounded. Street-smart. No manifest, just reality.",
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
          Text("Who are you?", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          _buildStableSelection(DopePersona.values, _selectedPersona, (v) => setState(() => _selectedPersona = v as DopePersona)),
        ],
      ),
    );
  }

  Widget _buildTonePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text("Choose your vibe", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          _buildStableSelection(DopeTone.values, _selectedTone, (v) => setState(() => _selectedTone = v as DopeTone)),
          const SizedBox(height: 24),
          Text(
            "Note: Deadpan is recommended for maximum brain-hack efficiency.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
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
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Text(
              _formatName(name),
              style: TextStyle(
                color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
    return name[0].toUpperCase() + name.substring(1);
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            if (_currentPage < _totalPages - 1) {
              _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
            } else {
              _finish();
            }
          },
          child: Text(
            _currentPage == _totalPages - 1 ? "ENTER DOPERMATIONS" : "CONTINUE",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
        ),
      ),
    );
  }
}
