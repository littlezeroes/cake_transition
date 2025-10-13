import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Authentic iOS Push Transition - 100% iOS Native Feel with swipe gesture on all platforms
class IOSPageTransition extends CupertinoPageRoute {
  IOSPageTransition({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 350);

  @override
  bool get popGestureEnabled => true;  // Enable swipe gesture on all platforms including Android

  @override
  bool get fullscreenDialog => false;  // Allow gesture-based dismissal
}

// Custom iOS Transition with more control
class PerfectIOSTransition extends PageRouteBuilder {
  final Widget page;
  
  PerfectIOSTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // iOS exact curve - cubic-bezier(0.25, 0.46, 0.45, 0.94)
            const curve = Cubic(0.25, 0.46, 0.45, 0.94);
            const reverseCurve = Cubic(0.25, 0.46, 0.45, 0.94);
            
            // Primary page slides from right
            var primaryPosition = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve,
              reverseCurve: reverseCurve,
            ));
            
            // Previous page slides to left with parallax (30% movement)
            var secondaryPosition = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.33, 0.0),
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve,
              reverseCurve: reverseCurve,
            ));
            
            // iOS-style shadow on the entering page
            var shadowAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.4),
            ));
            
            // Build the transition
            return SlideTransition(
              position: secondaryPosition,
              child: SlideTransition(
                position: primaryPosition,
                child: DecoratedBox(
                  position: DecorationPosition.background,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1 * shadowAnimation.value),
                        blurRadius: 10.0,
                        spreadRadius: -5.0,
                        offset: const Offset(-5, 0),
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            );
          },
        );
}

// Ultra Smooth iOS Transition with enhanced smoothness
class UltraSmoothIOSTransition extends PageRouteBuilder {
  final Widget page;
  
  UltraSmoothIOSTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // iOS 17 style smoother curve
            const curve = Cubic(0.35, 0.0, 0.25, 1.0);
            
            // Enhanced parallax effect
            var primaryPosition = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve,
            ));
            
            var secondaryPosition = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.3, 0.0),
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve,
            ));
            
            // Subtle scale for depth
            var secondaryScale = Tween<double>(
              begin: 1.0,
              end: 0.95,
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve,
            ));
            
            // Dimming overlay for background page
            var dimmingOpacity = Tween<double>(
              begin: 0.0,
              end: 0.15,
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve,
            ));
            
            return Stack(
              children: [
                // Background page with parallax, scale, and dimming
                SlideTransition(
                  position: secondaryPosition,
                  child: ScaleTransition(
                    scale: secondaryScale,
                    child: Stack(
                      children: [
                        child,
                        if (secondaryAnimation.value > 0)
                          Container(
                            color: Colors.black.withValues(alpha: dimmingOpacity.value),
                          ),
                      ],
                    ),
                  ),
                ),
                // Foreground page sliding in
                SlideTransition(
                  position: primaryPosition,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10.0,
                          offset: const Offset(-2, 0),
                        ),
                      ],
                    ),
                    child: child,
                  ),
                ),
              ],
            );
          },
          opaque: false,
          barrierDismissible: false,
          maintainState: true,
        );
}

// iOS Modal Presentation (bottom sheet style)
class IOSModalTransition extends PageRouteBuilder {
  final Widget page;
  
  IOSModalTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Cubic(0.32, 0.72, 0, 1.0); // iOS spring curve
            
            var slideAnimation = Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve,
            ));
            
            // Background scale down effect
            var scaleAnimation = Tween<double>(
              begin: 1.0,
              end: 0.94,
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve,
            ));
            
            var radiusAnimation = Tween<double>(
              begin: 0.0,
              end: 10.0,
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve,
            ));
            
            return Stack(
              children: [
                ScaleTransition(
                  scale: scaleAnimation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radiusAnimation.value),
                    child: child,
                  ),
                ),
                SlideTransition(
                  position: slideAnimation,
                  child: child,
                ),
              ],
            );
          },
          opaque: false,
        );
}

// iOS Hero-style zoom transition
class IOSZoomTransition extends PageRouteBuilder {
  final Widget page;
  
  IOSZoomTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Cubic(0.25, 0.46, 0.45, 0.94);
            
            var scaleAnimation = Tween<double>(
              begin: 0.85,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve,
            ));
            
            var opacityAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.25),
            ));
            
            return FadeTransition(
              opacity: opacityAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
        );
}