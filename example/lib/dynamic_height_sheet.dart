import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math' as math;

/// Dynamic Height Bottom Sheet with iOS-style spring animations
/// Inspired by iOS DynamicHeightSheet with SwiftUI animations
class DynamicHeightSheet {
  /// Show dynamic height bottom sheet with smooth spring animation
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    Color barrierColor = Colors.black54,
    bool isDismissible = true,
    SpringAnimationType animationType = SpringAnimationType.smooth,
  }) {
    return Navigator.of(context).push<T>(
      _DynamicHeightSheetRoute<T>(
        builder: builder,
        barrierColor: barrierColor,
        barrierDismissible: isDismissible,
        animationType: animationType,
      ),
    );
  }
}

enum SpringAnimationType {
  /// Smooth: Gentle spring like iOS .smooth animation
  /// stiffness=246, damping=31, duration=350ms
  smooth,

  /// Snappy: Fast response like iOS .snappy animation
  /// stiffness=438, damping=33, duration=300ms
  snappy,

  /// Bouncy: More oscillation like iOS .bouncy
  /// stiffness=200, damping=20, duration=400ms
  bouncy,
}

class _DynamicHeightSheetRoute<T> extends PopupRoute<T> {
  _DynamicHeightSheetRoute({
    required this.builder,
    required Color barrierColor,
    required bool barrierDismissible,
    required this.animationType,
  })  : _barrierColor = barrierColor,
        _barrierDismissible = barrierDismissible;

  final WidgetBuilder builder;
  final Color _barrierColor;
  final bool _barrierDismissible;
  final SpringAnimationType animationType;

  @override
  Color? get barrierColor => _barrierColor;

  @override
  bool get barrierDismissible => _barrierDismissible;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => _getDuration();

  Duration _getDuration() {
    switch (animationType) {
      case SpringAnimationType.smooth:
        return const Duration(milliseconds: 350);
      case SpringAnimationType.snappy:
        return const Duration(milliseconds: 300);
      case SpringAnimationType.bouncy:
        return const Duration(milliseconds: 400);
    }
  }

  SpringDescription get _springDescription {
    switch (animationType) {
      case SpringAnimationType.smooth:
        // iOS .smooth equivalent
        return SpringDescription(
          mass: 1.0,
          stiffness: 246.0,
          damping: 31.0,
        );
      case SpringAnimationType.snappy:
        // iOS .snappy equivalent
        return SpringDescription(
          mass: 1.0,
          stiffness: 438.0,
          damping: 33.0,
        );
      case SpringAnimationType.bouncy:
        // iOS .bouncy equivalent
        return SpringDescription(
          mass: 1.0,
          stiffness: 200.0,
          damping: 20.0,
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
        child: _DynamicHeightSheet(
          builder: builder,
          springDescription: _springDescription,
          routeAnimation: animation,
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
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
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
              color: barrierColor.withOpacity(curvedAnimation.value * 0.5),
            ),
          ),
        );
      },
    );
  }
}

class _DynamicHeightSheet extends StatefulWidget {
  const _DynamicHeightSheet({
    required this.builder,
    required this.springDescription,
    required this.routeAnimation,
  });

  final WidgetBuilder builder;
  final SpringDescription springDescription;
  final Animation<double> routeAnimation;

  @override
  State<_DynamicHeightSheet> createState() => _DynamicHeightSheetState();
}

class _DynamicHeightSheetState extends State<_DynamicHeightSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _heightAnimation;
  double _targetHeight = 0.0;
  bool _heightMeasured = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Start spring animation for slide up
    _controller.animateWith(
      SpringSimulation(
        widget.springDescription,
        0.0,
        1.0,
        0.0,
      ),
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _heightAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Listen for dismissal
    widget.routeAnimation.addStatusListener(_handleRouteStatusChange);
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
    widget.routeAnimation.removeStatusListener(_handleRouteStatusChange);
    _controller.dispose();
    super.dispose();
  }

  void _onHeightMeasured(double height) {
    if (!_heightMeasured) {
      setState(() {
        _targetHeight = height;
        _heightMeasured = true;
      });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight - 110; // Keep 110px from top like iOS

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(_slideAnimation),
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! > 0) {
                final newValue = _controller.value - (details.primaryDelta! / screenHeight);
                _controller.value = newValue.clamp(0.0, 1.0);
              }
            },
            onVerticalDragEnd: (details) {
              final velocity = details.primaryVelocity! / screenHeight;

              if (_controller.value < 0.7 || velocity < -1.5) {
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
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _DynamicHeightContainer(
                height: _targetHeight.clamp(0.0, maxHeight),
                heightAnimation: _heightAnimation,
                onHeightMeasured: _onHeightMeasured,
                builder: widget.builder,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DynamicHeightContainer extends StatefulWidget {
  const _DynamicHeightContainer({
    required this.height,
    required this.heightAnimation,
    required this.onHeightMeasured,
    required this.builder,
  });

  final double height;
  final Animation<double> heightAnimation;
  final Function(double height) onHeightMeasured;
  final WidgetBuilder builder;

  @override
  State<_DynamicHeightContainer> createState() => _DynamicHeightContainerState();
}

class _DynamicHeightContainerState extends State<_DynamicHeightContainer> {
  final GlobalKey _contentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureHeight();
    });
  }

  void _measureHeight() {
    final RenderBox? renderBox = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      widget.onHeightMeasured(size.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.heightAnimation,
      builder: (context, child) {
        return Container(
          constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: widget.height > 0 ? widget.height * widget.heightAnimation.value : 400,
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              key: _contentKey,
              child: widget.builder(context),
            ),
          ),
        );
      },
    );
  }
}