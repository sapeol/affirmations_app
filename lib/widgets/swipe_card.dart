import 'dart:math';
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
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _rotationAnimation;
  
  Offset _dragOffset = Offset.zero;
  double _dragRotation = 0;
  bool _isSwiping = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isEnabled || _isSwiping) return;
    setState(() {
      _dragOffset += details.delta;
      _dragRotation = (_dragOffset.dx / 60) * (pi / 180);
    });
  }

  void _onPanEnd(DragEndDetails details) async {
    if (!widget.isEnabled || _isSwiping) return;

    final thresholdX = MediaQuery.of(context).size.width * 0.3;

    if (_dragOffset.dx > thresholdX || details.velocity.pixelsPerSecond.dx > 700) {
      _handleSwipe(SwipeDirection.right);
    } else if (_dragOffset.dx < -thresholdX || details.velocity.pixelsPerSecond.dx < -700) {
      _handleSwipe(SwipeDirection.left);
    } else {
      _reset();
    }
  }

  Future<void> _handleSwipe(SwipeDirection direction) async {
    final accepted = await widget.onSwipe(direction);
    if (accepted) {
      _swipe(direction);
    } else {
      _reset();
    }
  }

  void _swipe(SwipeDirection direction) {
    setState(() => _isSwiping = true);
    final size = MediaQuery.of(context).size;
    
    Offset endOffset = direction == SwipeDirection.right 
        ? Offset(size.width * 1.5, _dragOffset.dy) 
        : Offset(-size.width * 1.5, _dragOffset.dy);
    
    _positionAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: endOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

    _rotationAnimation = Tween<double>(
      begin: _dragRotation,
      end: _dragRotation * 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

    _controller.forward();
  }

  void _reset() {
    _positionAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _rotationAnimation = Tween<double>(
      begin: _dragRotation,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward(from: 0).then((_) {
      setState(() {
        _dragOffset = Offset.zero;
        _dragRotation = 0;
        _isSwiping = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserPreferences>(
      future: UserPreferences.load(),
      builder: (context, snapshot) {
        final theme = snapshot.data?.colorTheme ?? AppColorTheme.brutalist;
        final displayText = widget.affirmation.getText(widget.language);
        final gradient = SwipeCard.getGradientForAffirmation(displayText, theme);
        
        final thresholdX = MediaQuery.of(context).size.width * 0.35;
        double feedbackOpacity = (_dragOffset.dx.abs() / thresholdX).clamp(0.0, 1.0);
        Color feedbackColor = _dragOffset.dx > 0 ? Colors.greenAccent : Colors.redAccent;
        IconData? feedbackIcon = _dragOffset.dx > 0 ? Icons.favorite_rounded : Icons.close_rounded;

            final isSystemDark = Theme.of(context).brightness == Brightness.dark;
            final palette = AppTheme.palettes[theme] ?? AppTheme.palettes[AppColorTheme.brutalist]!;
            final bool effectiveIsDark = palette.isAlwaysDark || isSystemDark;
        
            return AnimatedBuilder(          animation: _controller,
          builder: (context, child) {
            final offset = _controller.isAnimating ? _positionAnimation.value : _dragOffset;
            final rotation = _controller.isAnimating ? _rotationAnimation.value : _dragRotation;

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
          child: IgnorePointer(
            ignoring: !widget.isEnabled,
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
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
                                ),                    if (widget.isEnabled)
                      BoxShadow(
                        color: feedbackColor.withValues(alpha: feedbackOpacity * 0.1),
                        blurRadius: 40,
                        spreadRadius: 5,
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
                                              Icon(Icons.spa_rounded, color: effectiveIsDark ? Colors.white10 : Colors.black26, size: 32),
                                              const Spacer(),
                                              Text(
                                                displayText,
                                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                      height: 1.5,
                                                      color: effectiveIsDark ? Colors.white70 : Colors.black87,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const Spacer(),
                                              if (widget.affirmation.persona != null)
                                                Text(
                                                  "FROM ${widget.affirmation.persona!.name.toUpperCase()}",
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w900,
                                                    color: effectiveIsDark ? Colors.white24 : Colors.black38,
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),                      if (widget.isEnabled)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: feedbackColor.withValues(alpha: feedbackOpacity * 0.4),
                                  width: 8,
                                ),
                                borderRadius: BorderRadius.circular(40),
                                color: feedbackColor.withValues(alpha: feedbackOpacity * 0.1),
                              ),
                              child: Center(
                                child: Icon(
                                  feedbackIcon,
                                  size: 100,
                                  color: Colors.white.withValues(alpha: feedbackOpacity * 0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
