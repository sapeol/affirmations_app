import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 40,
            offset: const Offset(0, -10),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Column(
        children: [
          Container(
            width: 40, 
            height: 4, 
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black12, 
              borderRadius: BorderRadius.circular(2)
            )
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.pinkAccent, size: 48),
          ),
          const SizedBox(height: 32),
          Text(
            "PAY UP, OPTIMIST",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800, 
              letterSpacing: 2,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "You've run out of delusions for today. Give us \$3 or go face reality. Your choice.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54, 
              height: 1.6, 
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 48),
          _buildPaywallFeature(Icons.all_inclusive_rounded, "Endless Delusions", isDark),
          _buildPaywallFeature(Icons.palette_outlined, "Slightly Different Pastels", isDark),
          _buildPaywallFeature(Icons.history_rounded, "A List of Your Failures", isDark),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _isPremium = true);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.white : Colors.black,
                foregroundColor: isDark ? Colors.black : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text(
                "BUY HAPPINESS - \$3/MONTH", 
                style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1, fontSize: 14)
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "I'D RATHER BE MISERABLE", 
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.black54, 
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              )
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPaywallFeature(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isDark ? Colors.white38 : Colors.black45, size: 20),
          ),
          const SizedBox(width: 20),
          Text(
            text, 
            style: TextStyle(
              fontSize: 15, 
              fontWeight: FontWeight.w500, 
              color: isDark ? Colors.white70 : Colors.black87
            )
          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prefs = await UserPreferences.load();
    
    final image = await _screenshotController.captureFromWidget(
      _buildShareCard(current, isDark, prefs.fontFamily),
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

  Widget _buildShareCard(Affirmation aff, bool isDark, String fontFamily) {
    final displayText = aff.getText(DopeLanguage.en);
    var gradient = SwipeCard.getGradientForAffirmation(displayText);
    
    if (isDark) {
      gradient = gradient.map((c) => Color.lerp(c, Colors.black, 0.6)!).toList();
    }
    
    final baseStyle = GoogleFonts.getFont(fontFamily);
    
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
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              children: [
                Icon(
                  Icons.spa_rounded, 
                  color: isDark ? Colors.white10 : Colors.black12, 
                  size: 48
                ),
                const Spacer(),
                Text(
                  displayText,
                  style: baseStyle.copyWith(
                    color: isDark ? Colors.white70 : Colors.black.withValues(alpha: 0.7),
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                if (aff.persona != null)
                  Text(
                    "FROM ${aff.persona!.name.toUpperCase()}",
                    style: baseStyle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white24 : Colors.black45,
                      letterSpacing: 4,
                      decoration: TextDecoration.none,
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  "DELUSIONS",
                  style: baseStyle.copyWith(
                    color: isDark ? Colors.white10 : Colors.black12, 
                    fontSize: 10, 
                    letterSpacing: 12, 
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
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
        final isDark = Theme.of(context).brightness == Brightness.dark;

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
                        color: isDark ? Colors.white38 : Colors.black45,
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
                        Icon(Icons.wb_sunny_outlined, size: 48, color: isDark ? Colors.white10 : Colors.black12),
                        const SizedBox(height: 24),
                        Text(
                          "The well is dry. Just like your soul.",
                          style: TextStyle(
                            color: isDark ? Colors.white38 : Colors.black.withValues(alpha: 0.5),
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
                              color: isDark ? Colors.white54 : Colors.black54,
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
                    const SizedBox(height: 24),
                    Expanded(
                      flex: 12,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
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
                            top: 40.0 - (reversedIndex * 15),
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
                    const SizedBox(height: 32),
                    if (!_isPremium)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          "${_maxFreeSwipes - _swipeCount} MORE EXCUSES LEFT",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white38 : Colors.black45,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
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
            backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
            foregroundColor: isDark ? Colors.white38 : Colors.black45,
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
      color: (isDark ? Colors.white : Colors.black).withValues(alpha: onPressed == null ? 0.05 : 0.4),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
        Text(
          "BREATHING...",
          style: TextStyle(
                color: isDark ? Colors.white24 : Colors.black45,
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