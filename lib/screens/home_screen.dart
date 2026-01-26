import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import '../services/affirmations_service.dart';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'create_affirmation_screen.dart';
import '../locator.dart';
import '../widgets/swipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<Affirmation> _affirmations = [];
  bool _isLoading = true;
  final ScreenshotController _screenshotController = ScreenshotController();
  List<String> _likedIds = [];
  final List<Affirmation> _history = [];
  int _swipeCount = 0;
  bool _isPremium = false;
  final int _maxFreeSwipes = 20;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final prefs = await UserPreferences.load();
    setState(() {
      _likedIds = prefs.likedAffirmations;
      _isPremium = false; 
    });
    _loadAffirmations();
  }

  Future<void> _loadAffirmations() async {
    setState(() => _isLoading = true);
    final service = locator<AffirmationsService>();
    final all = await service.getAllAffirmations();
    all.shuffle();
    
    if (mounted) {
      setState(() {
        _affirmations = all;
        _isLoading = false;
      });
      if (_affirmations.isNotEmpty) {
        _updateWidget(_affirmations.first);
      }
    }
  }

  void _updateWidget(Affirmation aff) {
    HomeWidget.saveWidgetData<String>('affirmation_text', aff.getText(DopeLanguage.en));
    HomeWidget.updateWidget(
      name: 'AffirmationWidgetProvider',
      androidName: 'AffirmationWidgetProvider',
      iOSName: 'AffirmationWidget',
    );
  }

  Future<bool> _onSwipeAction(SwipeDirection direction) async {
    if (_affirmations.isEmpty) return false;

    if (!_isPremium && _swipeCount >= _maxFreeSwipes) {
      _showPaywall();
      return false;
    }

    final removed = _affirmations.removeAt(0);
    _history.add(removed);
    if (_history.length > 10) _history.removeAt(0);

    if (direction == SwipeDirection.right) {
      _toggleLike(removed);
    }

    setState(() {
      _swipeCount++;
    });

    if (_affirmations.isNotEmpty) {
      _updateWidget(_affirmations.first);
    } else {
      _loadAffirmations();
    }
    
    return true;
  }

  void _showPaywall() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPaywall(),
    );
  }

  Widget _buildPaywall() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 48),
          const Icon(Icons.auto_awesome_rounded, color: Colors.pinkAccent, size: 64),
          const SizedBox(height: 24),
          Text(
            "PAY UP, OPTIMIST",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w300, letterSpacing: 4),
          ),
          const SizedBox(height: 16),
          const Text(
            "You've run out of delusions for today. Give us \$3 or go face reality. Your choice.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black45, height: 1.6, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 48),
          _buildPaywallFeature(Icons.all_inclusive_rounded, "Endless Delusions"),
          _buildPaywallFeature(Icons.palette_outlined, "Slightly Different Pastels"),
          _buildPaywallFeature(Icons.history_rounded, "A List of Your Failures"),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: TextButton(
              onPressed: () {
                setState(() => _isPremium = true);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("BUY HAPPINESS - \$3/MONTH", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, letterSpacing: 2)),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("I'D RATHER BE MISERABLE", style: TextStyle(color: Colors.black26, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaywallFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.black12, size: 20),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black54)),
        ],
      ),
    );
  }

  void _undoSwipe() {
    if (_history.isEmpty) return;
    
    setState(() {
      final last = _history.removeLast();
      _affirmations.insert(0, last);
      _swipeCount = max(0, _swipeCount - 1);
    });
    _updateWidget(_affirmations.first);
  }

  void _toggleLike(Affirmation aff) async {
    final id = aff.getText(DopeLanguage.en);
    
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });

    final prefs = await UserPreferences.load();
    await UserPreferences.save(UserPreferences(
      persona: prefs.persona,
      themeMode: prefs.themeMode,
      fontFamily: prefs.fontFamily,
      colorTheme: prefs.colorTheme,
      language: prefs.language,
      likedAffirmations: _likedIds,
      notificationsEnabled: prefs.notificationsEnabled,
      notificationHour: prefs.notificationHour,
      notificationMinute: prefs.notificationMinute,
      sanityStreak: prefs.sanityStreak,
      lastInteractionDate: prefs.lastInteractionDate,
      firstRunDate: prefs.firstRunDate,
    ));
  }

  Future<void> _shareAsImage() async {
    if (_affirmations.isEmpty) return;
    final current = _affirmations.first;
    
    final image = await _screenshotController.captureFromWidget(
      _buildShareCard(current),
      delay: const Duration(milliseconds: 10),
    );

    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/dopermation.png').create();
    await imagePath.writeAsBytes(image);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(imagePath.path)],
        text: 'Sharing a delusion.',
      ),
    );
  }

  Widget _buildShareCard(Affirmation aff) {
    final displayText = aff.getText(DopeLanguage.en);
    final gradient = SwipeCard.getGradientForAffirmation(displayText);
    
    return Container(
      width: 400,
      height: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
      ),
      padding: const EdgeInsets.all(60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.spa_rounded, color: Colors.black12, size: 48),
          const Spacer(),
          Text(
            displayText,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.5,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          const Text(
            "DELUSIONS",
            style: TextStyle(
              color: Colors.black26, 
              fontSize: 10, 
              letterSpacing: 8, 
              fontWeight: FontWeight.w300,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserPreferences>(
      future: UserPreferences.load(),
      builder: (context, prefSnapshot) {
        final lang = prefSnapshot.data?.language ?? DopeLanguage.en;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "DELUSIONS",
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.blur_on_rounded, color: Theme.of(context).iconTheme.color),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
            ),
            actions: [
              if (prefSnapshot.hasData)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "${prefSnapshot.data!.sanityStreak}D",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.black26,
                      ),
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(Icons.tune_rounded, color: Theme.of(context).iconTheme.color),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                ).then((_) => _loadAffirmations()),
              ),
            ],
          ),
          body: Stack(
            children: [
              if (_isLoading)
                const Center(child: ExpressiveLoader())
              else if (_affirmations.isEmpty)
                Center(
                  child: FadeIn(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wb_sunny_outlined, size: 48, color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.black12),
                        const SizedBox(height: 24),
                        Text(
                          "The well is dry. Just like your soul.",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.black.withValues(alpha: 0.3),
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 48),
                        TextButton(
                          onPressed: _loadAffirmations,
                          child: Text(
                            "REFETCH THE LIES",
                            style: TextStyle(
                              letterSpacing: 2,
                              fontSize: 10,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 10,
                      child: Stack(
                        alignment: Alignment.center,
                        children: _affirmations
                            .take(3)
                            .toList()
                            .reversed
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                          final reversedIndex = entry.key; 
                          final aff = entry.value;
                          final totalInStack = min(_affirmations.length, 3);
                          final isTop = reversedIndex == totalInStack - 1;

                          return Positioned(
                            top: 60.0 - (reversedIndex * 12),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 400),
                              opacity: 1.0 - ((totalInStack - 1 - reversedIndex) * 0.3),
                              child: SwipeCard(
                                key: ValueKey(aff.getText(DopeLanguage.en)),
                                affirmation: aff,
                                language: lang,
                                onSwipe: isTop ? _onSwipeAction : (direction) async => false,
                                isEnabled: isTop,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const Spacer(),
                    if (!_isPremium)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          "${_maxFreeSwipes - _swipeCount} MORE EXCUSES LEFT",
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.black.withValues(alpha: 0.2),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSoftButton(
                            icon: Icons.undo_outlined,
                            onPressed: _history.isEmpty ? null : _undoSwipe,
                          ),
                          const SizedBox(width: 60),
                          _buildSoftButton(
                            icon: Icons.ios_share_rounded,
                            onPressed: _shareAsImage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'add',
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
            foregroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.black26,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateAffirmationScreen()),
              );
              if (result == true) _loadAffirmations();
            },
            child: const Icon(Icons.add_rounded, size: 20),
          ),
        );
      },
    );
  }

  Widget _buildSoftButton({required IconData icon, VoidCallback? onPressed}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 20,
      color: (isDark ? Colors.white : Colors.black).withValues(alpha: onPressed == null ? 0.05 : 0.2),
    );
  }
}

class FadeIn extends StatelessWidget {
  final Widget child;
  const FadeIn({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: child,
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
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.black12,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
        Text(
          "BREATHING...",
          style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white24 : Colors.black26,
                letterSpacing: 4.0,
                fontSize: 10,
                fontWeight: FontWeight.w300,
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

    final double cursorWidth = size.width * 0.4;
    final double cursorHeight = 2.0;
    
    if (progress < 0.5) {
      canvas.drawRect(
        Rect.fromLTWH((size.width - cursorWidth)/2, size.height/2, cursorWidth, cursorHeight),
        paint
      );
    }
  }

  @override
  bool shouldRepaint(_TerminalPainter oldDelegate) => true;
}