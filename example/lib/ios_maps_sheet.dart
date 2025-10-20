import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math' as math;

/// iOS 26 Maps Style Bottom Sheet with Advanced Spring Animation
/// Based on Apple Maps iOS 26 bottom sheet implementation
class IOSMapsSheet {
  /// Show iOS 26 Maps style bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    IOSMapsDetent initialDetent = IOSMapsDetent.medium,
  }) {
    return Navigator.of(context).push<T>(
      _IOSMapsSheetRoute<T>(
        builder: builder,
        initialDetent: initialDetent,
      ),
    );
  }
}

enum IOSMapsDetent {
  /// 80px height - compact mode
  compact,

  /// 350px height - medium mode
  medium,

  /// Full screen height - large mode
  large,
}

class _IOSMapsSheetRoute<T> extends PopupRoute<T> {
  _IOSMapsSheetRoute({
    required this.builder,
    required this.initialDetent,
  });

  final WidgetBuilder builder;
  final IOSMapsDetent initialDetent;

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.3);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

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
        child: _IOSMapsSheetContent(
          builder: builder,
          routeAnimation: animation,
          initialDetent: initialDetent,
        ),
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
      child: Container(
        color: barrierColor.withOpacity(animation.value * 0.3),
      ),
    );
  }
}

class _IOSMapsSheetContent extends StatefulWidget {
  const _IOSMapsSheetContent({
    required this.builder,
    required this.routeAnimation,
    required this.initialDetent,
  });

  final WidgetBuilder builder;
  final Animation<double> routeAnimation;
  final IOSMapsDetent initialDetent;

  @override
  State<_IOSMapsSheetContent> createState() => _IOSMapsSheetContentState();
}

class _IOSMapsSheetContentState extends State<_IOSMapsSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _heightAnimation;

  IOSMapsDetent _currentDetent = IOSMapsDetent.medium;
  double _targetHeight = 350;
  double _previousHeight = 0;
  bool _isDragging = false;

  // iOS 26 Maps animation parameters
  static const double _maxAnimationDuration = 0.25; // iOS 26 timing
  static const double _compactHeight = 80;
  static const double _mediumHeight = 350;

  @override
  void initState() {
    super.initState();
    _currentDetent = widget.initialDetent;
    _targetHeight = _getHeightForDetent(_currentDetent);
    _previousHeight = 0;

    _controller = AnimationController(vsync: this);

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _heightAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    widget.routeAnimation.addStatusListener(_handleRouteStatusChange);

    // Start with iOS 26 Maps spring animation
    _startSpringAnimation(from: 0, to: _targetHeight);
  }

  void _handleRouteStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.reverse) {
      _startSpringAnimation(from: _targetHeight, to: 0);
    }
  }

  @override
  void dispose() {
    widget.routeAnimation.removeStatusListener(_handleRouteStatusChange);
    _controller.dispose();
    super.dispose();
  }

  double _getHeightForDetent(IOSMapsDetent detent) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    switch (detent) {
      case IOSMapsDetent.compact:
        return _compactHeight;
      case IOSMapsDetent.medium:
        return _mediumHeight;
      case IOSMapsDetent.large:
        return screenHeight - 100; // Leave some top space
    }
  }

  IOSMapsDetent _getDetentForHeight(double height) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (height <= (_compactHeight + _mediumHeight) / 2) {
      return IOSMapsDetent.compact;
    } else if (height <= (_mediumHeight + (screenHeight - 100)) / 2) {
      return IOSMapsDetent.medium;
    } else {
      return IOSMapsDetent.large;
    }
  }

  void _startSpringAnimation({required double from, required double to, double velocity = 0}) {
    final diff = (to - from).abs();

    // iOS 26 Maps duration calculation: max(min(diff / 100, 0.25), 0)
    final duration = math.max(math.min(diff / 100, _maxAnimationDuration), 0.05);

    // Convert to Flutter spring description
    // iOS: interpolatingSpring(duration: duration, bounce: 0, initialVelocity: 0)
    // Flutter: stiffness and damping for no-bounce spring
    final stiffness = 600 / (duration * duration); // Approximate iOS spring
    final damping = 2 * math.sqrt(stiffness) * 0.9; // Slight damping, no bounce

    _controller.animateWith(
      SpringSimulation(
        SpringDescription(
          mass: 1.0,
          stiffness: stiffness,
          damping: damping,
        ),
        from / (MediaQuery.of(context).size.height - 100),
        to / (MediaQuery.of(context).size.height - 100),
        velocity / (MediaQuery.of(context).size.height - 100),
      ),
    );

    _previousHeight = from;
    _targetHeight = to;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    final screenHeight = MediaQuery.of(context).size.height;
    final newHeight = (_targetHeight - details.primaryDelta!)
        .clamp(_compactHeight, screenHeight - 100);

    if (newHeight != _targetHeight) {
      setState(() {
        _targetHeight = newHeight;
        _currentDetent = _getDetentForHeight(newHeight);
      });

      // Update controller value for smooth drag
      _controller.value = newHeight / (screenHeight - 100);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;

    final velocity = details.primaryVelocity ?? 0;
    final screenHeight = MediaQuery.of(context).size.height;
    final newDetent = _getDetentForHeight(_targetHeight);
    final newHeight = _getHeightForDetent(newDetent);

    setState(() {
      _currentDetent = newDetent;
    });

    _startSpringAnimation(
      from: _targetHeight,
      to: newHeight,
      velocity: -velocity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight - 100;

    return GestureDetector(
      onVerticalDragStart: (_) => _isDragging = true,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(_slideAnimation),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: _compactHeight,
                  maxHeight: maxHeight,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag indicator
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 36,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3E3E3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),

                      // Content area
                      Flexible(
                        child: widget.builder(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}