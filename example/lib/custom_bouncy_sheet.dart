import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Custom Bouncy Sheet with Specific Spring Parameters
/// stiffness = 160, damping = 19, dampingRatio = 0.4
/// Creates playful, bouncy animation with 5% overshoot
class CustomBouncySheet {
  /// Show sheet with custom bouncy spring animation
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return Navigator.of(context).push<T>(
      _CustomBouncySheetRoute<T>(
        builder: builder,
      ),
    );
  }
}

class _CustomBouncySheetRoute<T> extends PopupRoute<T> {
  _CustomBouncySheetRoute({
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
  Duration get transitionDuration => const Duration(milliseconds: 350);

  // Custom spring parameters from specification
  static const double _customStiffness = 160.0;
  static const double _customDamping = 19.0;
  static const double _customMass = 1.0;
  static const double _customDampingRatio = 0.4;
  static const double _customNaturalFrequency = 12.6;
  static const double _customSettlingTime = 0.35;
  static const double _customOvershoot = 0.05;

  SpringDescription get _customSpringDescription {
    return SpringDescription(
      mass: _customMass,
      stiffness: _customStiffness,
      damping: _customDamping,
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
    return _CustomBouncySheetTransition(
      animation: animation,
      springDescription: _customSpringDescription,
      child: child,
    );
  }
}

class _CustomBouncySheetTransition extends StatefulWidget {
  const _CustomBouncySheetTransition({
    required this.animation,
    required this.springDescription,
    required this.child,
  });

  final Animation<double> animation;
  final SpringDescription springDescription;
  final Widget child;

  @override
  State<_CustomBouncySheetTransition> createState() => _CustomBouncySheetTransitionState();
}

class _CustomBouncySheetTransitionState extends State<_CustomBouncySheetTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    // Start with custom bouncy spring animation
    _startCustomBouncySpring(from: 0.0, to: 1.0);

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(_controller);

    widget.animation.addStatusListener(_handleRouteStatusChange);
  }

  void _startCustomBouncySpring({
    required double from,
    required double to,
    double velocity = 0,
  }) {
    // Use the exact custom spring parameters
    _controller.animateWith(
      SpringSimulation(
        widget.springDescription,
        from,
        to,
        velocity,
      ),
    );
  }

  void _handleRouteStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.reverse) {
      // Use custom bouncy spring for dismissal
      _startCustomBouncySpring(
        from: _controller.value,
        to: 0.0,
      );
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
          // Dismiss with custom bouncy spring
          _startCustomBouncySpring(
            from: _controller.value,
            to: 0.0,
            velocity: velocity,
          ).then((_) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        } else {
          // Snap back with custom bouncy spring
          _startCustomBouncySpring(
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