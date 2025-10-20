import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';
import 'spring_bottom_sheet.dart' as sheet;

/// Cake transition widget with spring animation
/// Cloned from V2CakeDialog's transition
class CakeTransition extends StatefulWidget {
  final Widget child;
  final Animation<double> animation;

  const CakeTransition({
    Key? key,
    required this.child,
    required this.animation,
  }) : super(key: key);

  @override
  _CakeTransitionState createState() => _CakeTransitionState();
}

class _CakeTransitionState extends State<CakeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Cake transition spring animation
    _controller.animateWith(
      SpringSimulation(
        const SpringDescription(
          mass: 1,
          stiffness: 300,
          damping: 30,
        ),
        0.0,
        1.0,
        0.0,
      ),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(_controller);

    widget.animation.addStatusListener((status) {
      if (status == AnimationStatus.reverse) {
        _controller.animateWith(
          SpringSimulation(
            const SpringDescription(
              mass: 1,
              stiffness: 300,
              damping: 30,
            ),
            _controller.value,
            0.0,
            0.0,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _offsetAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Helper function to show widget with cake transition
Future<T?> showWithCakeTransition<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
  Color barrierColor = Colors.black54,
  String? barrierLabel,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return CakeTransition(
        animation: animation,
        child: child,
      );
    },
  );
}

/// PageRoute with Cupertino transition and drag gesture for iOS screens
class CakePageRoute extends CupertinoPageRoute {
  final int screen;

  CakePageRoute({required this.screen})
      : super(
          builder: (context) => IOSScreen(screenNumber: screen),
        );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 250);
}

/// Screen displaying iOS fake images with invisible touch areas
class IOSScreen extends StatefulWidget {
  final int screenNumber;

  const IOSScreen({Key? key, required this.screenNumber}) : super(key: key);

  @override
  _IOSScreenState createState() => _IOSScreenState();
}

class _IOSScreenState extends State<IOSScreen> {
  void _showSheet() {
    if (widget.screenNumber == 3) {
      sheet.SpringBottomSheet.show(
        context: context,
        springType: sheet.SpringType.fast,
        builder: (context) => Container(
          child: Image.asset(
            'assets/Sheet.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full width image
          Positioned.fill(
            child: Image.asset(
              widget.screenNumber == 1
                  ? 'assets/1.png'
                  : widget.screenNumber == 2
                      ? 'assets/2.png'
                      : 'assets/bg.jpeg',
              width: double.infinity,
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // Invisible touch area for back button (top left)
          Positioned(
            top: 30,
            left: 10,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.transparent,
              ),
            ),
          ),

          // Invisible touch area in the middle for navigation
          if (widget.screenNumber == 1)
            Positioned.fill(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CakePageRoute(screen: 2),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 400,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),

          // Invisible touch area in the middle for sheet (screen 3)
          if (widget.screenNumber == 3)
            Positioned.fill(
              child: Center(
                child: GestureDetector(
                  onTap: _showSheet,
                  child: Container(
                    width: 300,
                    height: 400,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}