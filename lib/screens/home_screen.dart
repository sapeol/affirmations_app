import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay/pay.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Affirmation> _affirmations = [];
  bool _isLoading = true;
  final ScreenshotController _screenshotController = ScreenshotController();
  List<String> _likedIds = [];
  bool _isPremium = false;
  int _swipeCount = 0;
  int _undoCount = 0;
  final int _maxFreeSwipes = 5;
  final int _maxFreeUndos = 2;
  bool _isActionInProgress = false;
  final GlobalKey<SwipeCardState> _cardKey = GlobalKey<SwipeCardState>();
  final List<Affirmation> _history = [];

  late AnimationController _entranceController;
  late List<Animation<double>> _staggeredAnimations;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _staggeredAnimations = List.generate(4, (index) {
      final start = index * 0.15;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _entranceController,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      );
    });

    _init();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _init() async {
    final prefs = await UserPreferences.load();
    if (mounted) {
      setState(() {
        _swipeCount = 0; 
        _likedIds = prefs.likedAffirmations;
        _isPremium = false; 
      });
    }
    await _loadAffirmations();
    if (mounted) {
      _entranceController.forward();
    }
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

  Future<void> _updateWidget(Affirmation aff) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prefs = await UserPreferences.load();
    final displayText = aff.getText(DopeLanguage.en);
    final gradient = SwipeCard.getGradientForAffirmation(displayText, prefs.colorTheme);
    
    HomeWidget.saveWidgetData<String>('affirmation_text', displayText);
    HomeWidget.saveWidgetData<String>('gradient_start', '#${gradient[0].toARGB32().toRadixString(16).padLeft(8, '0')}');
    HomeWidget.saveWidgetData<String>('gradient_end', '#${gradient[1].toARGB32().toRadixString(16).padLeft(8, '0')}');
    
    final textColor = isDark ? Colors.white : Colors.black;
    HomeWidget.saveWidgetData<String>('text_color', '#${textColor.toARGB32().toRadixString(16).padLeft(8, '0')}');
    HomeWidget.saveWidgetData<String>('theme_name', prefs.colorTheme.name);
    HomeWidget.saveWidgetData<String>('persona_name', aff.persona?.name.toUpperCase() ?? 'DELUSIONS');
    
    HomeWidget.updateWidget(name: 'AffirmationWidgetProvider', androidName: 'AffirmationWidgetProvider', iOSName: 'AffirmationWidget');
    HomeWidget.updateWidget(name: 'AffirmationWidgetLargeProvider', androidName: 'AffirmationWidgetLargeProvider', iOSName: 'AffirmationWidgetLarge');
  }

  Future<bool> _onSwipeAction(SwipeDirection direction) async {
    if (_affirmations.isEmpty || _isActionInProgress) return false;

    if (!_isPremium && _swipeCount >= _maxFreeSwipes) {
      _showPaywall();
      return false;
    }

    _isActionInProgress = true;
    final removed = _affirmations.removeAt(0);
    _history.add(removed);
    if (_history.length > 15) _history.removeAt(0);

    setState(() {
      if (direction == SwipeDirection.right) {
        _toggleLike(removed);
        _swipeCount++;
      } else {
        _swipeCount = max(-100, _swipeCount - 1);
      }
    });

    if (_affirmations.isNotEmpty) {
      _updateWidget(_affirmations.first);
    } else {
      await _loadAffirmations();
    }
    
    _isActionInProgress = false;
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
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 40, offset: const Offset(0, -10))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.auto_awesome_rounded, color: Theme.of(context).colorScheme.primary, size: 48),
          ),
          const SizedBox(height: 32),
          Text("PAY UP, OPTIMIST", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 2)),
          const SizedBox(height: 16),
          Text("You've run out of delusions for today. Give us \$3 or go face reality. Your choice.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8))),
          const SizedBox(height: 48),
          _buildPaywallFeature(Icons.all_inclusive_rounded, "Endless Delusions"),
          _buildPaywallFeature(Icons.palette_outlined, "Slightly Different Pastels"),
          _buildPaywallFeature(Icons.history_rounded, "A List of Your Failures"),
          const Spacer(),
          if (Platform.isAndroid)
            FutureBuilder<PaymentConfiguration>(
              future: PaymentConfiguration.fromAsset('assets/google_pay_config.json'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GooglePayButton(
                    paymentConfiguration: snapshot.data!,
                    paymentItems: const [PaymentItem(label: 'Dopermations Premium', amount: '3.00', status: PaymentItemStatus.final_price)],
                    type: GooglePayButtonType.buy,
                    margin: const EdgeInsets.only(top: 15.0),
                    onPaymentResult: (result) {
                      setState(() => _isPremium = true);
                      Navigator.pop(context);
                    },
                    loadingIndicator: const Center(child: CircularProgressIndicator()),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          else
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () { setState(() => _isPremium = true); Navigator.pop(context); },
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onSurface, foregroundColor: Theme.of(context).colorScheme.surface, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                child: const Text("BUY HAPPINESS - \$3/MONTH", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 14)),
              ),
            ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("I'D RATHER BE MISERABLE", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPaywallFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 20),
          Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  void _undoSwipe() async {
    if (_history.isEmpty || _isActionInProgress) return;
    
    if (!_isPremium && _undoCount >= _maxFreeUndos) {
      _showPaywall();
      return;
    }
    
    _isActionInProgress = true;
    setState(() {
      final last = _history.removeLast();
      _affirmations.insert(0, last);
      _swipeCount = max(0, _swipeCount - 1); 
      _undoCount++;
    });
    await _updateWidget(_affirmations.first);
    _isActionInProgress = false;
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
      persona: prefs.persona, themeMode: prefs.themeMode, fontFamily: prefs.fontFamily, colorTheme: prefs.colorTheme, language: prefs.language,
      likedAffirmations: _likedIds, notificationsEnabled: prefs.notificationsEnabled, notificationHour: prefs.notificationHour,
      notificationMinute: prefs.notificationMinute, sanityStreak: prefs.sanityStreak, lastInteractionDate: prefs.lastInteractionDate, firstRunDate: prefs.firstRunDate,
    ));
  }

  Future<void> _shareAsImage() async {
    if (_affirmations.isEmpty) return;
    final current = _affirmations.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardWidth = MediaQuery.of(context).size.width * 0.85;
    final cardHeight = MediaQuery.of(context).size.height * 0.55;
    final prefs = await UserPreferences.load();

    final image = await _screenshotController.captureFromWidget(
      _buildShareCard(current, isDark, prefs.fontFamily, cardWidth, cardHeight, prefs.colorTheme),
      delay: const Duration(milliseconds: 10),
    );

    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/dopermation.png').create();
    await imagePath.writeAsBytes(image);

    await SharePlus.instance.share(ShareParams(files: [XFile(imagePath.path)], text: 'Sharing a delusion.'));
  }

  Widget _buildShareCard(Affirmation aff, bool isDark, String fontFamily, double width, double height, AppColorTheme colorTheme) {
    final displayText = aff.getText(DopeLanguage.en);
    var gradient = SwipeCard.getGradientForAffirmation(displayText, colorTheme);
    if (isDark) gradient = gradient.map((c) => Color.lerp(c, Colors.black, 0.7)!).toList();
    final baseStyle = GoogleFonts.getFont(fontFamily);
    
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient)),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(Icons.spa_rounded, color: isDark ? Colors.white10 : Colors.black26, size: 32),
            const Spacer(),
            Text(displayText, style: baseStyle.copyWith(color: isDark ? Colors.white : Colors.black, fontSize: 24, fontWeight: FontWeight.w600, height: 1.5, decoration: TextDecoration.none), textAlign: TextAlign.center),
            const Spacer(),
            if (aff.persona != null) Text("FROM ${aff.persona!.name.toUpperCase()}", style: baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w900, color: isDark ? Colors.white24 : Colors.black38, letterSpacing: 2, decoration: TextDecoration.none)),
            const SizedBox(height: 24),
            Text("DELUSIONS", style: baseStyle.copyWith(color: isDark ? Colors.white10 : Colors.black12, fontSize: 14, letterSpacing: 8, fontWeight: FontWeight.w300, decoration: TextDecoration.none)),
          ],
        ),
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
            backgroundColor: Colors.transparent, elevation: 0,
            title: AnimatedBuilder(
              animation: _staggeredAnimations[0],
              builder: (context, child) => Transform.translate(
                offset: Offset(0, 20 * (1 - _staggeredAnimations[0].value)),
                child: Opacity(opacity: _staggeredAnimations[0].value, child: child),
              ),
              child: Text("DELUSIONS", style: Theme.of(context).appBarTheme.titleTextStyle),
            ),
            centerTitle: true,
            leading: AnimatedBuilder(
              animation: _staggeredAnimations[0],
              builder: (context, child) => Opacity(opacity: _staggeredAnimations[0].value, child: child),
              child: IconButton(icon: Icon(Icons.blur_on_rounded, color: Theme.of(context).iconTheme.color), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()))),
            ),
            actions: [
              if (prefSnapshot.hasData) AnimatedBuilder(
                animation: _staggeredAnimations[0],
                builder: (context, child) => Opacity(opacity: _staggeredAnimations[0].value, child: child),
                child: Center(child: Padding(padding: const EdgeInsets.only(right: 16.0), child: Text("${prefSnapshot.data!.sanityStreak}D", style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1)))),
              ),
              AnimatedBuilder(
                animation: _staggeredAnimations[0],
                builder: (context, child) => Opacity(opacity: _staggeredAnimations[0].value, child: child),
                child: IconButton(icon: Icon(Icons.tune_rounded, color: Theme.of(context).iconTheme.color), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())).then((_) => _loadAffirmations())),
              ),
            ],
          ),
          body: Stack(
            children: [
              if (_isLoading) const Center(child: ExpressiveLoader())
              else if (_affirmations.isEmpty) Center(child: FadeIn(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.wb_sunny_outlined, size: 48, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)), const SizedBox(height: 24), Text("The well is dry. Just like your soul.", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)), const SizedBox(height: 48), TextButton(onPressed: _loadAffirmations, child: Text("REFETCH THE LIES", style: TextStyle(letterSpacing: 2, fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))))])))
              else Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(height: 24),
                Expanded(
                  flex: 12, 
                  child: AnimatedBuilder(
                    animation: _staggeredAnimations[1],
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, 100 * (1 - _staggeredAnimations[1].value)),
                      child: Opacity(opacity: _staggeredAnimations[1].value, child: child),
                    ),
                    child: Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: _affirmations.take(2).toList().reversed.toList().asMap().entries.map((entry) {
                      final reversedIndex = entry.key; final aff = entry.value; final totalInStack = min(_affirmations.length, 2); final isTop = reversedIndex == totalInStack - 1;
                      return Positioned(top: 40.0 - (reversedIndex * 15), child: SwipeCard(key: isTop ? _cardKey : ValueKey(aff.getText(DopeLanguage.en)), affirmation: aff, language: lang, onSwipe: isTop ? _onSwipeAction : (direction) async => false, isEnabled: isTop));
                    }).toList()),
                  ),
                ),
                const SizedBox(height: 32),
                AnimatedBuilder(
                  animation: _staggeredAnimations[2],
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, 50 * (1 - _staggeredAnimations[2].value)),
                    child: Opacity(opacity: _staggeredAnimations[2].value, child: child),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    _buildActionCircle(
                      icon: Icons.close_rounded,
                      color: Colors.redAccent,
                      onPressed: _undoSwipe,
                      isDisabled: _history.isEmpty || _isActionInProgress,
                    ),
                    const SizedBox(width: 40),
                    _buildActionCircle(
                      icon: Icons.favorite_rounded,
                      color: Colors.greenAccent,
                      onPressed: () {
                        if (!_isPremium && _swipeCount >= _maxFreeSwipes) {
                          _showPaywall();
                        } else {
                          _cardKey.currentState?.triggerSwipe(SwipeDirection.right);
                        }
                      },
                      isDisabled: _isActionInProgress,
                    ),
                  ]),
                ),
                const SizedBox(height: 32),
                if (!_isPremium) AnimatedBuilder(
                  animation: _staggeredAnimations[3],
                  builder: (context, child) => Opacity(opacity: _staggeredAnimations[3].value, child: child),
                  child: Padding(padding: const EdgeInsets.only(bottom: 24), child: Text("${_maxFreeSwipes - _swipeCount} MORE EXCUSES LEFT", style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.w900))),
                ),
                AnimatedBuilder(
                  animation: _staggeredAnimations[3],
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, 30 * (1 - _staggeredAnimations[3].value)),
                    child: Opacity(opacity: _staggeredAnimations[3].value, child: child),
                  ),
                  child: Padding(padding: const EdgeInsets.only(bottom: 40), child: _buildSoftButton(icon: Icons.ios_share_rounded, onPressed: _shareAsImage)),
                ),
              ]),
            ],
          ),
          floatingActionButton: AnimatedBuilder(
            animation: _staggeredAnimations[3],
            builder: (context, child) => Transform.scale(
              scale: _staggeredAnimations[3].value,
              child: Opacity(opacity: _staggeredAnimations[3].value, child: child),
            ),
            child: FloatingActionButton(heroTag: 'add', elevation: 0, highlightElevation: 0, backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05), foregroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4), onPressed: () async { final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAffirmationScreen())); if (result == true) _loadAffirmations(); }, child: const Icon(Icons.add_rounded, size: 20)),
          ),
        );
      },
    );
  }

  Widget _buildSoftButton({required IconData icon, VoidCallback? onPressed}) {
    return IconButton(onPressed: onPressed, icon: Icon(icon), iconSize: 20, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: onPressed == null ? 0.1 : 0.4));
  }

  Widget _buildActionCircle({required IconData icon, required Color color, required VoidCallback onPressed, bool isDisabled = false}) {
    return _AnimatedActionButton(
      icon: icon,
      color: color,
      onPressed: onPressed,
      isDisabled: isDisabled,
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isDisabled;

  const _AnimatedActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isDisabled) return;
    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => widget.isDisabled ? null : _controller.forward(),
      onTapUp: (_) => widget.isDisabled ? null : _controller.reverse(),
      onTapCancel: () => widget.isDisabled ? null : _controller.reverse(),
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(alpha: widget.isDisabled ? 0.02 : 0.1),
            border: Border.all(
              color: widget.color.withValues(alpha: widget.isDisabled ? 0.05 : 0.2),
              width: 2,
            ),
            boxShadow: widget.isDisabled ? [] : [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.1),
                blurRadius: 12,
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(
              widget.icon,
              color: widget.color.withValues(alpha: widget.isDisabled ? 0.2 : 1.0),
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class FadeIn extends StatelessWidget {
  final Widget child;
  const FadeIn({super.key, required this.child});
  @override
  Widget build(BuildContext context) { return TweenAnimationBuilder<double>(tween: Tween(begin: 0.0, end: 1.0), duration: const Duration(seconds: 1), builder: (context, value, child) => Opacity(opacity: value, child: child), child: child); }
}

class ExpressiveLoader extends StatefulWidget {
  const ExpressiveLoader({super.key});
  @override
  State<ExpressiveLoader> createState() => _ExpressiveLoaderState();
}

class _ExpressiveLoaderState extends State<ExpressiveLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) { return Column(mainAxisSize: MainAxisSize.min, children: [SizedBox(width: 60, height: 60, child: AnimatedBuilder(animation: _controller, builder: (context, child) { return CustomPaint(painter: _TerminalPainter(progress: _controller.value, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1))); })), const SizedBox(height: 32), Text("BREATHING...", style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 4.0))]); }
}

class _TerminalPainter extends CustomPainter {
  final double progress;
  final Color color;
  _TerminalPainter({required this.progress, required this.color});
  @override
  void paint(Canvas canvas, Size size) { final paint = Paint()..color = color..style = PaintingStyle.fill; final double cursorWidth = size.width * 0.4; final double cursorHeight = 2.0; if (progress < 0.5) { canvas.drawRect(Rect.fromLTWH((size.width - cursorWidth)/2, size.height/2, cursorWidth, cursorHeight), paint); } }
  @override
  bool shouldRepaint(_TerminalPainter oldDelegate) => true;
}