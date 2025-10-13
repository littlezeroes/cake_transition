import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Ultra-light transition for web - NO LAG
class WebOptimizedTransition extends PageRouteBuilder {
  final Widget page;
  
  WebOptimizedTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          // Much shorter duration for web
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: const Duration(milliseconds: 150),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // For web, use only simple fade - no complex animations
            if (kIsWeb) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }
            
            // For mobile, use slide
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            );
          },
        );
}

// Instant navigation - NO ANIMATION AT ALL
class InstantPageRoute extends PageRouteBuilder {
  final Widget page;
  
  InstantPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child; // No animation at all
          },
        );
}

// Simple fade only - fastest possible animation
class SimpleFadeRoute extends PageRouteBuilder {
  final Widget page;
  
  SimpleFadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 150),
          reverseTransitionDuration: const Duration(milliseconds: 150),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.linear, // Linear is fastest
              ),
              child: child,
            );
          },
        );
}

// Platform-aware route selector
class PlatformOptimizedRoute {
  static PageRoute getRoute({required Widget page}) {
    if (kIsWeb) {
      // Use simplest animation for web
      return SimpleFadeRoute(page: page);
    } else {
      // Use native transitions for mobile
      return MaterialPageRoute(builder: (_) => page);
    }
  }
  
  // Get instant route for critical navigations
  static PageRoute getInstantRoute({required Widget page}) {
    return InstantPageRoute(page: page);
  }
}