import 'package:flutter/material.dart';

/// Animated card widget with scale-only entry animation
/// Phase 1 (0-10%): Hold at full size
/// Phase 2 (10-55%): Shrink (scaleX: 1.0→0.80, scaleY: 1.0→0.87)
/// Phase 3 (55-100%): Expand back to 1.0
/// Duration: 700ms
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AnimatedCard({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
  }) : super(key: key);

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleXAnimation;
  late Animation<double> _scaleYAnimation;

  // Phase timing constants
  static const double k1 = 0.10; // 10%
  static const double k2 = 0.55; // 55%

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // ScaleX animation: 1.0 → 0.80 → 1.0
    _scaleXAnimation = TweenSequence<double>([
      // Phase 1 (0-10%): Hold at 1.0
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: k1,
      ),
      // Phase 2 (10-55%): Shrink to 0.80
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.80)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: k2 - k1,
      ),
      // Phase 3 (55-100%): Expand back to 1.0
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.80, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 1.0 - k2,
      ),
    ]).animate(_controller);

    // ScaleY animation: 1.0 → 0.87 → 1.0
    _scaleYAnimation = TweenSequence<double>([
      // Phase 1 (0-10%): Hold at 1.0
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: k1,
      ),
      // Phase 2 (10-55%): Shrink to 0.87
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.87)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: k2 - k1,
      ),
      // Phase 3 (55-100%): Expand back to 1.0
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.87, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 1.0 - k2,
      ),
    ]).animate(_controller);

    // Start animation automatically
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(
            _scaleXAnimation.value,
            _scaleYAnimation.value,
            1.0,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
