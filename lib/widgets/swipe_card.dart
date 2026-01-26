import 'package:flutter/material.dart';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';
import '../theme.dart';

enum SwipeDirection { left, right, none }

class SwipeCard extends StatefulWidget {
  final Affirmation affirmation;
  final DopeLanguage language;
  final Future<bool> Function(SwipeDirection direction) onSwipe;
  final bool isEnabled;

  const SwipeCard({
    super.key,
    required this.affirmation,
    required this.language,
    required this.onSwipe,
    this.isEnabled = true,
  });

  static List<Color> getGradientForAffirmation(String text, AppColorTheme theme) {
    final palette = AppTheme.palettes[theme] ?? AppTheme.palettes[AppColorTheme.brutalist]!;
    final gradients = palette.cardGradients;
    // Deterministic selection based on text
    final index = text.length % gradients.length;
    return gradients[index];
  }

  @override
  State<SwipeCard> createState() => SwipeCardState();
}

class SwipeCardState extends State<SwipeCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _rotationAnimation;
  
  bool _isSwiping = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
  }

  @override
  void didUpdateWidget(SwipeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.affirmation != widget.affirmation) {
      // Reset state for the new affirmation
      _isSwiping = false;
      _controller.reset();
      _positionAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
      _rotationAnimation = Tween<double>(
        begin: 0,
        end: 0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> triggerSwipe(SwipeDirection direction) async {
    if (!widget.isEnabled || _isSwiping) return;
    
    // 1. Run animation first
    await _animateOut(direction);
    
    // 2. Then notify parent to update data and count
    await widget.onSwipe(direction);
  }

  Future<void> _animateOut(SwipeDirection direction) async {
    if (!mounted) return;
    setState(() => _isSwiping = true);
    final size = MediaQuery.of(context).size;
    
    Offset endOffset = direction == SwipeDirection.right 
        ? Offset(size.width * 1.5, 0) 
        : Offset(-size.width * 1.5, 0);
    
    _controller.duration = const Duration(milliseconds: 600); // Snappier exit

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: endOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: direction == SwipeDirection.right ? 0.4 : -0.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

    await _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserPreferences>(
      future: UserPreferences.load(),
      builder: (context, snapshot) {
        final theme = snapshot.data?.colorTheme ?? AppColorTheme.brutalist;
        final displayText = widget.affirmation.getText(widget.language);
        final gradient = SwipeCard.getGradientForAffirmation(displayText, theme);
        
        final isSystemDark = Theme.of(context).brightness == Brightness.dark;
        final palette = AppTheme.palettes[theme] ?? AppTheme.palettes[AppColorTheme.brutalist]!;
        final bool effectiveIsDark = palette.isAlwaysDark || isSystemDark;
        
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final offset = _positionAnimation.value;
            final rotation = _rotationAnimation.value;

            return Transform.translate(
              offset: offset,
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateY(rotation * 0.5)
                  ..rotateZ(rotation),
                alignment: Alignment.center,
                child: child,
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: effectiveIsDark ? 0.4 : 0.05),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: effectiveIsDark 
                          ? gradient.map((c) => Color.lerp(c, Colors.black, 0.7)!).toList()
                          : gradient,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.spa_rounded, 
                          color: effectiveIsDark ? Colors.white10 : Colors.black26, 
                          size: 32
                        ),
                        const Spacer(),
                        Text(
                          displayText,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                color: effectiveIsDark ? Colors.white : Colors.black,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        if (widget.affirmation.persona != null)
                          Text(
                            "FROM ${widget.affirmation.persona!.name.toUpperCase()}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: effectiveIsDark ? Colors.white24 : Colors.black38,
                              letterSpacing: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}