import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math' as math;

/// Simple Sheet với UI giống mấy cái kia, chỉ thay animation thôi
class SimpleAnimationSheet {
  /// Show sheet với smooth animation
  static Future<T?> showSmooth<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return _showSheetWithAnimation(
      context: context,
      builder: builder,
      springType: SimpleSpringType.smooth,
    );
  }

  /// Show sheet với snappy animation
  static Future<T?> showSnappy<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return _showSheetWithAnimation(
      context: context,
      builder: builder,
      springType: SimpleSpringType.snappy,
    );
  }

  /// Show sheet với bouncy animation
  static Future<T?> showBouncy<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return _showSheetWithAnimation(
      context: context,
      builder: builder,
      springType: SimpleSpringType.bouncy,
    );
  }

  static Future<T?> _showSheetWithAnimation<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    required SimpleSpringType springType,
  }) {
    return Navigator.of(context).push<T>(
      _SimpleSheetRoute<T>(
        builder: builder,
        springType: springType,
      ),
    );
  }
}

enum SimpleSpringType {
  smooth,
  snappy,
  bouncy,
}

class _SimpleSheetRoute<T> extends PopupRoute<T> {
  _SimpleSheetRoute({
    required this.builder,
    required this.springType,
  });

  final WidgetBuilder builder;
  final SimpleSpringType springType;

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.3);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration {
    switch (springType) {
      case SimpleSpringType.smooth:
        return const Duration(milliseconds: 300);
      case SimpleSpringType.snappy:
        return const Duration(milliseconds: 300);
      case SimpleSpringType.bouncy:
        return const Duration(milliseconds: 450); // New settling time: 0.45s
    }
  }

  SpringDescription get _springDescription {
    switch (springType) {
      case SimpleSpringType.smooth:
        return SpringDescription(
          mass: 1.0,
          stiffness: 246.0,
          damping: 31.0,
        );
      case SimpleSpringType.snappy:
        return SpringDescription(
          mass: 1.0,
          stiffness: 438.0,
          damping: 33.0,
        );
      case SimpleSpringType.bouncy:
        return SpringDescription(
          mass: 1.0,
          stiffness: 160.0,  // New stiffness
          damping: 19.0,    // New damping
        );
    }
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
    return _SpringSheetTransition(
      animation: animation,
      springDescription: _springDescription,
      child: child,
    );
  }
}

class _SpringSheetTransition extends StatefulWidget {
  const _SpringSheetTransition({
    required this.animation,
    required this.springDescription,
    required this.child,
  });

  final Animation<double> animation;
  final SpringDescription springDescription;
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

    // Spring animation for slide up
    _controller.animateWith(
      SpringSimulation(
        widget.springDescription,
        0.0,
        1.0,
        0.0,
      ),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(_controller);

    // Listen for dismissal
    widget.animation.addStatusListener(_handleRouteStatusChange);
  }

  void _handleRouteStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.reverse) {
      _controller.animateWith(
        SpringSimulation(
          widget.springDescription,
          _controller.value,
          0.0,
          0.0,
        ),
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
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragUpdate: (details) {
            // Chỉ cho phép drag xuống
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
              // Drag xuống đủ thì dismiss
              _controller.animateWith(
                SpringSimulation(
                  widget.springDescription,
                  _controller.value,
                  0.0,
                  velocity,
                ),
              ).then((_) {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              });
            } else {
              // Snap back lên
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
        );
      },
    );
  }
}