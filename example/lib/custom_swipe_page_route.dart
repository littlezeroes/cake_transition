import 'package:flutter/material.dart';

class CustomSwipePageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  final Duration duration;
  final double parallaxOffset;
  final double swipeThreshold;
  final Curve springCurve;
  final bool enableGesture;

  CustomSwipePageRoute({
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
    this.parallaxOffset = 40.0,
    this.swipeThreshold = 0.5,
    this.springCurve = Curves.easeOut,
    this.enableGesture = true,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: Offset(-0.3, 0),
        end: Offset.zero,
      ).animate(animation);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;
}
