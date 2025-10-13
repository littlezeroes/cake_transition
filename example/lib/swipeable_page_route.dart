import 'package:flutter/material.dart';

/// Swipeable page route with iOS-style slide animation
/// Works on ALL platforms (Android, iOS, Web)
/// Following Emil Kowalski's animation principles
class SwipeablePageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final Duration transitionDuration;

  SwipeablePageRoute({
    required this.builder,
    this.transitionDuration = const Duration(milliseconds: 250),
    RouteSettings? settings,
  }) : super(settings: settings);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return _SwipeableTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
      onDismiss: () => Navigator.of(context).pop(),
    );
  }
}

class _SwipeableTransition extends StatefulWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;
  final VoidCallback onDismiss;

  const _SwipeableTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
    required this.onDismiss,
  });

  @override
  State<_SwipeableTransition> createState() => _SwipeableTransitionState();
}

class _SwipeableTransitionState extends State<_SwipeableTransition> {
  double _dragExtent = 0.0;
  bool _isDragging = false;

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    // Only allow right swipe (back gesture)
    if (delta > 0 || _dragExtent > 0) {
      setState(() {
        _dragExtent += delta;
        _dragExtent = _dragExtent.clamp(0.0, MediaQuery.of(context).size.width);
      });
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final velocity = details.primaryVelocity ?? 0;

    // Dismiss if dragged > 40% or fast swipe
    if (_dragExtent > screenWidth * 0.4 || velocity > 800) {
      widget.onDismiss();
    } else {
      // Snap back
      setState(() {
        _dragExtent = 0.0;
        _isDragging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // iOS curve - Cubic(0.25, 0.1, 0.25, 1.0)
    const iosCurve = Cubic(0.25, 0.1, 0.25, 1.0);

    final curvedAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: iosCurve,
    );

    final secondaryCurvedAnimation = CurvedAnimation(
      parent: widget.secondaryAnimation,
      curve: iosCurve,
    );

    // Calculate offset
    double primaryOffset;
    if (_isDragging) {
      // During drag
      primaryOffset = _dragExtent / screenWidth;
    } else {
      // During animation
      primaryOffset = 1.0 - widget.animation.value;
    }

    // Primary page: slides in from right
    final primaryPosition = _isDragging
        ? Offset(primaryOffset, 0)
        : Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation).value;

    // Secondary page: parallax slide out (30%)
    final secondaryPosition = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0.0),
    ).animate(secondaryCurvedAnimation).value;

    Widget result = Transform.translate(
      offset: Offset(secondaryPosition.dx * screenWidth, 0),
      child: Transform.translate(
        offset: Offset(primaryOffset * screenWidth, 0),
        child: widget.child,
      ),
    );

    // Add gesture detector when page is visible
    if (widget.animation.value > 0.0) {
      result = GestureDetector(
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        behavior: HitTestBehavior.translucent,
        child: result,
      );
    }

    return result;
  }
}
