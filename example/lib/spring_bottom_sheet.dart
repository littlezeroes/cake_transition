import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math' as math;

/// iOS-style Bottom Sheet with spring physics
/// Based on Nathan Gitter's fluid-interfaces (WWDC 2018)
///
/// Spring values:
/// - Non-interactive: stiffness=246.74, damping=31.42
/// - Interactive: stiffness=438.65, damping=33.51
/// - Community standard: stiffness=300, damping=30

class SpringBottomSheet {
  /// Show bottom sheet with iOS-style spring animation
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isDismissible = true,
    Color barrierColor = Colors.black54,
    SpringType springType = SpringType.nonInteractive,
  }) {
    return Navigator.of(context).push<T>(
      _SpringBottomSheetRoute<T>(
        builder: builder,
        barrierColor: barrierColor,
        barrierDismissible: isDismissible,
        springType: springType,
      ),
    );
  }
}

enum SpringType {
  /// Non-interactive (tap to open/close)
  /// Nathan Gitter: damping=1.0, response=0.4
  /// Result: stiffness=246.74, damping=31.42
  nonInteractive,

  /// Interactive (gesture-driven)
  /// Nathan Gitter: damping=0.8, response=0.3
  /// Result: stiffness=438.65, damping=33.51
  interactive,

  /// Community standard (balanced)
  /// stiffness=300, damping=30
  standard,

  /// Fast (quicker animation)
  /// stiffness=400, damping=30
  fast,
}

class _SpringBottomSheetRoute<T> extends PopupRoute<T> {
  _SpringBottomSheetRoute({
    required this.builder,
    required Color barrierColor,
    required bool barrierDismissible,
    required this.springType,
  })  : _barrierColor = barrierColor,
        _barrierDismissible = barrierDismissible;

  final WidgetBuilder builder;
  final Color _barrierColor;
  final bool _barrierDismissible;
  final SpringType springType;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => _barrierDismissible;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 285);

  SpringDescription get _springDescription {
    switch (springType) {
      case SpringType.nonInteractive:
        // Nathan Gitter: dampingRatio=1.0, response=0.4
        // Formula: stiffness=(2π/response)², damping=4π×dampingRatio/response
        return SpringHelper.fromDesignParams(
          dampingRatio: 1.0,
          response: 0.4,
        );
      case SpringType.interactive:
        // Nathan Gitter: dampingRatio=0.8, response=0.3
        return SpringHelper.fromDesignParams(
          dampingRatio: 0.8,
          response: 0.3,
        );
      case SpringType.standard:
        return SpringDescription(
          mass: 1.0,
          stiffness: 300.0,
          damping: 30.0,
        );
      case SpringType.fast:
        return SpringDescription(
          mass: 1.0,
          stiffness: 246.74,
          damping: 31.42,
        );
    }
  }

  // Use same spring for dismissal (Nathan Gitter approach)
  SpringDescription get _dismissalSpringDescription => _springDescription;

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
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _SpringSheetTransition(
      routeAnimation: animation,
      springDescription: _springDescription,
      dismissalSpringDescription: _dismissalSpringDescription,
      child: child,
    );
  }
}

class _SpringSheetTransition extends StatefulWidget {
  const _SpringSheetTransition({
    required this.routeAnimation,
    required this.springDescription,
    required this.dismissalSpringDescription,
    required this.child,
  });

  final Animation<double> routeAnimation;
  final SpringDescription springDescription;
  final SpringDescription dismissalSpringDescription;
  final Widget child;

  @override
  State<_SpringSheetTransition> createState() => _SpringSheetTransitionState();
}

class _SpringSheetTransitionState extends State<_SpringSheetTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    // Nathan Gitter exact spring animation
    _controller.animateWith(
      SpringSimulation(
        widget.springDescription,
        0.0, // start
        1.0, // end
        0.0, // initial velocity
      ),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero,
    ).animate(_controller);

    // Listen to route animation for dismissal
    widget.routeAnimation.addStatusListener(_handleRouteStatusChange);
  }

  void _handleRouteStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.reverse) {
      // Nathan Gitter approach: natural spring dismissal
      _controller.animateWith(
        SpringSimulation(
          widget.dismissalSpringDescription,
          _controller.value,
          0.0, // back to start
          0.0, // Natural spring physics, no artificial velocity
        ),
      );
    }
  }

  @override
  void dispose() {
    widget.routeAnimation.removeStatusListener(_handleRouteStatusChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(), // Tap-to-dismiss on the background
      child: Stack(
        children: [
          // Synchronized overlay fade
          FadeTransition(
            opacity: _controller,
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          // The original gesture detector for dragging the sheet
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: (details) {
              // Allow dragging only if drag is downward
              if (details.primaryDelta! > 0) {
                final newValue = _controller.value - details.primaryDelta! / MediaQuery.of(context).size.height;
                _controller.value = newValue.clamp(0.0, 1.0);
              }
            },
            onVerticalDragEnd: (details) {
              // Calculate velocity
              final velocity = details.primaryVelocity! / MediaQuery.of(context).size.height;

              if (_controller.value < 0.7 || velocity < -1.5) {
                // Nathan Gitter approach: natural spring dismissal with user velocity
                _controller.animateWith(
                  SpringSimulation(
                    widget.dismissalSpringDescription,
                    _controller.value,
                    0.0,
                    velocity, // Use actual user velocity, no artificial boost
                  ),
                ).then((_) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                });
              } else {
                // Snap back with regular spring
                _controller.animateWith(
                  SpringSimulation(
                    widget.springDescription,
                    _controller.value,
                    1.0,
                    velocity,
                  ),
                );
              }
            },
            child: SlideTransition(
              position: _offsetAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper to calculate spring parameters from design-friendly values
/// 100% Nathan Gitter's fluid-interfaces implementation
class SpringHelper {
  /// Convert design-friendly parameters to physics parameters
  ///
  /// dampingRatio: 0.0 - 1.0 (bounciness, 1.0 = no bounce)
  /// response: duration-like value (seconds)
  ///
  /// EXACT Nathan Gitter formula from WWDC 2018:
  /// stiffness = (2π / response)²
  /// damping = 4π × dampingRatio / response
  static SpringDescription fromDesignParams({
    required double dampingRatio,
    required double response,
    double mass = 1.0,
  }) {
    final stiffness = math.pow(2 * math.pi / response, 2).toDouble();
    final dampingValue = 4 * math.pi * dampingRatio / response;

    return SpringDescription(
      mass: mass,
      stiffness: stiffness,
      damping: dampingValue,
    );
  }

  /// EXACT Nathan Gitter presets from fluid-interfaces
  /// Non-interactive: dampingRatio=1.0, response=0.4
  static SpringDescription get nonInteractive => fromDesignParams(
    dampingRatio: 1.0,
    response: 0.4,
  );

  /// Interactive: dampingRatio=0.8, response=0.3
  static SpringDescription get interactive => fromDesignParams(
    dampingRatio: 0.8,
    response: 0.3,
  );

  /// Community standard
  static SpringDescription get standard => SpringDescription(
    mass: 1.0,
    stiffness: 300.0,
    damping: 30.0,
  );
}
