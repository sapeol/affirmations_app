import 'dart:math';
import 'package:flutter/material.dart';
import '../models/affirmation.dart';
import '../models/user_preferences.dart';

class SwipeCard extends StatefulWidget {
  final Affirmation affirmation;
  final DopeLanguage language;
  final Function(bool isLike) onSwipe;
  final VoidCallback? onUndo;

  const SwipeCard({
    super.key,
    required this.affirmation,
    required this.language,
    required this.onSwipe,
    this.onUndo,
  });

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
      duration: const Duration(milliseconds: 300),
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isSwiping) return;
    setState(() {
      _dragOffset += details.delta;
      _dragRotation = (_dragOffset.dx / 20) * (pi / 180);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isSwiping) return;

    final threshold = MediaQuery.of(context).size.width * 0.35;
    if (_dragOffset.dx.abs() > threshold || details.velocity.pixelsPerSecond.dx.abs() > 800) {
      _swipe(_dragOffset.dx > 0);
    } else {
      _reset();
    }
  }

  void _swipe(bool isLike) {
    setState(() => _isSwiping = true);
    final screenWidth = MediaQuery.of(context).size.width;
    final endOffset = Offset(isLike ? screenWidth * 1.5 : -screenWidth * 1.5, _dragOffset.dy);
    
    _positionAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: endOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _rotationAnimation = Tween<double>(
      begin: _dragRotation,
      end: _dragRotation * 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward().then((_) {
      widget.onSwipe(isLike);
    });
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.affirmation.getText(widget.language);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = _controller.isAnimating ? _positionAnimation.value : _dragOffset;
        final rotation = _controller.isAnimating ? _rotationAnimation.value : _dragRotation;

        return Transform.translate(
          offset: offset,
          child: Transform.rotate(
            angle: rotation,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bolt_rounded, color: Colors.greenAccent, size: 40),
                  const SizedBox(height: 32),
                  Expanded(
                    child: Center(
                      child: Text(
                        displayText,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (widget.affirmation.persona != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.affirmation.persona!.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
