import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// 1. Smooth Slide Transition - Pure slide with curve
class SmoothSlideTransition extends PageRouteBuilder {
  final Widget page;
  final SlideDirection direction;

  SmoothSlideTransition({
    required this.page,
    this.direction = SlideDirection.leftToRight,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Offset begin;
            switch (direction) {
              case SlideDirection.leftToRight:
                begin = const Offset(-1.0, 0.0);
                break;
              case SlideDirection.rightToLeft:
                begin = const Offset(1.0, 0.0);
                break;
              case SlideDirection.topToBottom:
                begin = const Offset(0.0, -1.0);
                break;
              case SlideDirection.bottomToTop:
                begin = const Offset(0.0, 1.0);
                break;
            }
            
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

// 2. Elastic Slide Transition - Bouncy slide effect
class ElasticSlideTransition extends PageRouteBuilder {
  final Widget page;

  ElasticSlideTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final curve = Curves.elasticOut;
            
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

// 3. Scale and Slide Transition - Combined effect
class ScaleSlideTransition extends PageRouteBuilder {
  final Widget page;

  ScaleSlideTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const slideBegin = Offset(0.3, 0.0);
            const slideEnd = Offset.zero;
            const slideCurve = Curves.easeOutCubic;

            var slideTween = Tween(begin: slideBegin, end: slideEnd).chain(
              CurveTween(curve: slideCurve),
            );

            const scaleBegin = 0.92;
            const scaleEnd = 1.0;
            const scaleCurve = Curves.easeOutCubic;
            
            var scaleTween = Tween(begin: scaleBegin, end: scaleEnd).chain(
              CurveTween(curve: scaleCurve),
            );
            
            return SlideTransition(
              position: animation.drive(slideTween),
              child: ScaleTransition(
                scale: animation.drive(scaleTween),
                child: child,
              ),
            );
          },
        );
}

// 4. Rotation Scale Transition - 3D rotation with scaling
class RotationScaleTransition extends PageRouteBuilder {
  final Widget page;

  RotationScaleTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var rotationAnimation = Tween<double>(
              begin: 0.5,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ));
            
            var scaleAnimation = Tween<double>(
              begin: 0.6,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));
            
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateZ((1 - rotationAnimation.value) * 0.5)
                    ..scale(scaleAnimation.value, scaleAnimation.value),
                  child: child,
                );
              },
              child: child,
            );
          },
        );
}

// 5. Parallax Slide - Depth effect with parallax
class ParallaxSlideTransition extends PageRouteBuilder {
  final Widget page;

  ParallaxSlideTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOutCubic;
            
            var slideAnimation = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve,
            ));
            
            var parallaxAnimation = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.2, 0.0),
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve,
            ));
            
            return SlideTransition(
              position: parallaxAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
        );
}

// 6. 3D Flip Transition - Card flip effect
class Flip3DTransition extends PageRouteBuilder {
  final Widget page;

  Flip3DTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var rotationAnimation = Tween<double>(
              begin: -0.5,
              end: 0.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutQuart,
            ));
            
            return AnimatedBuilder(
              animation: rotationAnimation,
              builder: (context, child) {
                final isShowing = rotationAnimation.value > -0.25;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(rotationAnimation.value * 3.14159),
                  child: isShowing ? child : Container(),
                );
              },
              child: child,
            );
          },
        );
}

// 7. Zoom Scale Transition - Pure zoom effect
class ZoomScaleTransition extends PageRouteBuilder {
  final Widget page;

  ZoomScaleTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeOutCubic;

            var scaleAnimation = Tween<double>(
              begin: 0.92,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve,
            ));

            return ScaleTransition(
              scale: scaleAnimation,
              child: child,
            );
          },
        );
}

// 8. Circular Reveal Transition - Material circular reveal
class CircularRevealTransition extends PageRouteBuilder {
  final Widget page;

  CircularRevealTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var scaleAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCirc,
            ));
            
            return AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, child) {
                return ClipPath(
                  clipper: CircularRevealClipper(
                    fraction: scaleAnimation.value,
                  ),
                  child: child,
                );
              },
              child: child,
            );
          },
        );
}

class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  
  CircularRevealClipper({required this.fraction});
  
  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.longestSide * 1.5) * fraction;
    
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
  }
  
  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}

// 9. Accordion Transition - Accordion-style expansion
class AccordionTransition extends PageRouteBuilder {
  final Widget page;

  AccordionTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var scaleAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutExpo,
            ));
            
            return AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..scale(1.0, scaleAnimation.value, 1.0),
                  child: child,
                );
              },
              child: child,
            );
          },
        );
}

// 10. iOS Push Transition - Native iOS style
class IOSPushTransition extends PageRouteBuilder {
  final Widget page;

  IOSPushTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = CubicBezier(0.25, 0.46, 0.45, 0.94);
            
            var primaryAnimation = Tween(begin: begin, end: end).animate(
              CurvedAnimation(
                parent: animation,
                curve: curve,
                reverseCurve: curve,
              ),
            );
            
            var secondarySlideAnimation = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.3, 0.0),
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve,
              reverseCurve: curve,
            ));
            
            return SlideTransition(
              position: secondarySlideAnimation,
              child: SlideTransition(
                position: primaryAnimation,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3 * animation.value),
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

// Custom Cubic Bezier curve for smooth animations
class CubicBezier extends Curve {
  final double a;
  final double b;
  final double c;
  final double d;
  
  const CubicBezier(this.a, this.b, this.c, this.d);
  
  @override
  double transformInternal(double t) {
    double start = 0.0;
    double end = 1.0;
    while (true) {
      double midpoint = (start + end) / 2;
      double estimate = _calcBezier(midpoint, a, c);
      if ((estimate - t).abs() < 0.001) {
        return _calcBezier(midpoint, b, d);
      }
      if (estimate < t) {
        start = midpoint;
      } else {
        end = midpoint;
      }
    }
  }
  
  double _calcBezier(double t, double a1, double a2) {
    return (((1.0 - 3.0 * a2 + 3.0 * a1) * t + (3.0 * a2 - 6.0 * a1)) * t + (3.0 * a1)) * t;
  }
}