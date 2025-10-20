import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math' as math;

/// iOS 26 Maps Animation Sheet with Original OTP UI
/// Uses iOS 26 Maps spring parameters, keeps original UI
class IOSMapsAnimationSheet {
  /// Show sheet with iOS 26 Maps spring animation
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return Navigator.of(context).push<T>(
      _IOSMapsSheetRoute<T>(
        builder: builder,
      ),
    );
  }
}

class _IOSMapsSheetRoute<T> extends PopupRoute<T> {
  _IOSMapsSheetRoute({
    required this.builder,
  });

  final WidgetBuilder builder;

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.3);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  // iOS 26 Maps animation parameters
  static const double _maxAnimationDuration = 0.25; // iOS 26 timing

  SpringDescription get _springDescription {
    // iOS: interpolatingSpring(duration: duration, bounce: 0, initialVelocity: 0)
    // Flutter equivalent for no-bounce spring
    return SpringDescription(
      mass: 1.0,
      stiffness: 600.0, // Calculated from iOS parameters
      damping: 35.0, // No bounce, slight damping
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Material(
        color: Colors.transparent,
        child: builder(context),
      ),
    );
  }

  @override
  Widget buildBarrier(
    BuildContext context,
    Color barrierColor,
    Animation<double> animation,
    bool barrierDismissible,
  ) {
    return IgnorePointer(
      ignoring: !barrierDismissible,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (barrierDismissible) {
            Navigator.pop(context);
          }
        },
        child: Container(
          color: barrierColor.withOpacity(animation.value),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _IOSMapsSheetTransition(
      animation: animation,
      springDescription: _springDescription,
      child: child,
    );
  }
}

class _IOSMapsSheetTransition extends StatefulWidget {
  const _IOSMapsSheetTransition({
    required this.animation,
    required this.springDescription,
    required this.child,
  });

  final Animation<double> animation;
  final SpringDescription springDescription;
  final Widget child;

  @override
  State<_IOSMapsSheetTransition> createState() => _IOSMapsSheetTransitionState();
}

class _IOSMapsSheetTransitionState extends State<_IOSMapsSheetTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    // iOS 26 Maps spring animation with dynamic duration
    _startIOSMapsAnimation(from: 0.0, to: 1.0);

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(_controller);

    // Listen for dismissal
    widget.animation.addStatusListener(_handleRouteStatusChange);
  }

  void _startIOSMapsAnimation({required double from, required double to, double velocity = 0}) {
    // iOS 26 Maps duration calculation: max(min(diff / 100, 0.25), 0.05)
    final diff = (to - from).abs();
    final duration = math.max(math.min(diff / 100, _IOSMapsSheetRoute._maxAnimationDuration), 0.05);

    // Calculate spring parameters for iOS 26 Maps feel
    // iOS uses interpolatingSpring(duration: duration, bounce: 0, initialVelocity: 0)
    final stiffness = 600.0 / (duration * duration);
    final damping = 2.0 * math.sqrt(stiffness) * 0.9; // No bounce

    _controller.animateWith(
      SpringSimulation(
        SpringDescription(
          mass: 1.0,
          stiffness: stiffness,
          damping: damping,
        ),
        from,
        to,
        velocity,
      ),
    );
  }

  void _handleRouteStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.reverse) {
      // Use iOS 26 Maps animation for dismissal
      _startIOSMapsAnimation(from: _controller.value, to: 0.0);
    }
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_handleRouteStatusChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: (details) {
        // Allow dragging down only
        if (details.primaryDelta! > 0) {
          final screenHeight = MediaQuery.of(context).size.height;
          final newValue = _controller.value - (details.primaryDelta! / screenHeight);
          _controller.value = newValue.clamp(0.0, 1.0);
        }
      },
      onVerticalDragEnd: (details) {
        final screenHeight = MediaQuery.of(context).size.height;
        final velocity = details.primaryVelocity! / screenHeight;

        if (_controller.value < 0.7 || velocity < -1.5) {
          // Dismiss with iOS 26 Maps animation
          _startIOSMapsAnimation(
            from: _controller.value,
            to: 0.0,
            velocity: velocity,
          );

          // Pop after animation completes
          _controller.addStatusListener((status) {
            if (status == AnimationStatus.completed && _controller.value == 0.0) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            }
          });
        } else {
          // Snap back with iOS 26 Maps animation
          _startIOSMapsAnimation(
            from: _controller.value,
            to: 1.0,
            velocity: velocity,
          );
        }
      },
      child: AnimatedBuilder(
        animation: _offsetAnimation,
        builder: (context, child) {
          return SlideTransition(
            position: _offsetAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}