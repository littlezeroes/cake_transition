import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:smooth_corner/smooth_corner.dart';

class V2CakeDialog extends StatelessWidget {
  const V2CakeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.only(bottom: 34, left: 16, right: 16),
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: SmoothRectangleBorder(
              borderRadius: BorderRadius.circular(40),
              smoothness: 0.6,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grabber
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  width: 36,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECECEC),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                child: Column(
                  children: const [
                    Text(
                      'Title cố gắng 1 dòng thôi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        height: 24 / 18,
                        color: Color(0xFF000000),
                        letterSpacing: -0.1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description Nội dung chi tiết bỏ ở đây nhé. Xin cảm ơn! Kamsahamita',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 20 / 14,
                        color: Color(0xFF737373),
                      ),
                    ),
                  ],
                ),
              ),
              // Footer
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  children: [
                    // Primary Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFFFF37A5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Label',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Secondary Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFFF8F8F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Label',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<T?> showV2CakeDialog<T>(BuildContext context) {
  return showGeneralDialog<T>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (context, animation, secondaryAnimation) => const V2CakeDialog(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return _DialogSpringTransition(
        animation: animation,
        child: child,
      );
    },
  );
}

class _DialogSpringTransition extends StatefulWidget {
  final Animation<double> animation;
  final Widget child;

  const _DialogSpringTransition({
    required this.animation,
    required this.child,
  });

  @override
  _DialogSpringTransitionState createState() => _DialogSpringTransitionState();
}

class _DialogSpringTransitionState extends State<_DialogSpringTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.animateWith(
      SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 300, damping: 30),
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
            const SpringDescription(mass: 1, stiffness: 300, damping: 30),
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