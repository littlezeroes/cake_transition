import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Optimized iOS Transition for Web - Minimal lag
class OptimizedIOSTransition extends PageRouteBuilder {
  final Widget page;
  static bool _isFirstTransition = true;
  
  OptimizedIOSTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          // Shorter duration for web to reduce lag perception
          transitionDuration: Duration(milliseconds: _isFirstTransition ? 250 : 350),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          maintainState: true,
          allowSnapshotting: true,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Mark first transition as complete
            if (_isFirstTransition && animation.status == AnimationStatus.completed) {
              _isFirstTransition = false;
            }
            
            // Use simpler curve for first transition
            final curve = _isFirstTransition 
                ? Curves.easeOut  // Simpler curve for first transition
                : const Cubic(0.25, 0.46, 0.45, 0.94);  // iOS curve for subsequent
            
            // Simplified animation for better performance
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );
            
            // Only slide animation, no complex effects for first transition
            if (_isFirstTransition) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              );
            }
            
            // Full iOS effect for subsequent transitions
            final slideIn = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(curvedAnimation);
            
            final slideOut = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.33, 0.0),
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve,
            ));
            
            return Stack(
              children: [
                SlideTransition(
                  position: slideOut,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.05 * secondaryAnimation.value),
                    child: child,
                  ),
                ),
                SlideTransition(
                  position: slideIn,
                  child: Material(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          if (!_isFirstTransition)
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(-2, 0),
                            ),
                        ],
                      ),
                      child: child,
                    ),
                  ),
                ),
              ],
            );
          },
        );
}

// Preloader widget to warm up the rendering pipeline
class TransitionPreloader extends StatefulWidget {
  final Widget child;
  
  const TransitionPreloader({Key? key, required this.child}) : super(key: key);
  
  @override
  State<TransitionPreloader> createState() => _TransitionPreloaderState();
}

class _TransitionPreloaderState extends State<TransitionPreloader> with TickerProviderStateMixin {
  late AnimationController _warmupController;
  bool _isWarmedUp = false;
  
  @override
  void initState() {
    super.initState();
    _warmupController = AnimationController(
      duration: const Duration(milliseconds: 1),
      vsync: this,
    );
    
    // Schedule warm-up after first frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _warmUp();
    });
  }
  
  void _warmUp() async {
    // Run dummy animations to compile shaders
    for (int i = 0; i < 3; i++) {
      await _warmupController.forward();
      await _warmupController.reverse();
    }
    
    if (mounted) {
      setState(() {
        _isWarmedUp = true;
      });
    }
  }
  
  @override
  void dispose() {
    _warmupController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Show invisible animation layers during warmup
    return Stack(
      children: [
        widget.child,
        if (!_isWarmedUp) ...[
          // Invisible warm-up layers
          Positioned(
            left: -1000,
            child: SizedBox(
              width: 1,
              height: 1,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(_warmupController),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            left: -1000,
            child: SizedBox(
              width: 1,
              height: 1,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(_warmupController),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Fast Material Page Route for Web
class FastMaterialRoute extends MaterialPageRoute {
  FastMaterialRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);
  
  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
  
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Simple fade for fastest performance
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}