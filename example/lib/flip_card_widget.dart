import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 3D Flip Card Widget matching JS TweenMax animation exactly
/// TweenMax.to(container, 2, {rotationY:"+=180", ease:Power2.easeInOut})
/// TweenMax.to(container, 1, {z:"-=100", yoyo:true, repeat:1, ease:Power2.easeIn})
/// Power2.easeInOut = Cubic(0.455, 0.03, 0.515, 0.955)
/// Power2.easeIn = Cubic(0.55, 0.085, 0.68, 0.53)
class FlipCardWidget extends StatefulWidget {
  final Widget frontCard;
  final Widget backCard;
  final double width;
  final double height;

  const FlipCardWidget({
    Key? key,
    required this.frontCard,
    required this.backCard,
    this.width = 400,
    this.height = 226,
  }) : super(key: key);

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _zController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _zAnimation;

  double _currentRotation = 0.0; // Track cumulative rotation like JS +=180

  @override
  void initState() {
    super.initState();

    // Rotation controller - 1s with Power2.easeInOut
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // 500ms
    );

    // Z-depth controller - 500ms (half of rotation)
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250), // 250ms yoyo
    );

    // Rotation animation will be updated in toggleCard() with current rotation
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: const Cubic(0.455, 0.03, 0.515, 0.955), // GreenSock Power2.easeInOut
    ));

    // Z-depth as scale animation: 1.0 → 0.92 → 1.0 (like code example)
    _zAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.92)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.92, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 55,
      ),
    ]).animate(_zController);
  }

  void toggleCard() {
    // Haptic feedback - light impact for subtle tactile response
    HapticFeedback.lightImpact();

    // JS: rotationY:"+=180" - always add 180°, but flip in opposite direction (negative)
    final targetRotation = _currentRotation - 3.14159; // Subtract 180° for opposite direction

    // Update rotation animation with new begin/end values
    _rotationAnimation = Tween<double>(
      begin: _currentRotation,
      end: targetRotation,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: const Cubic(0.455, 0.03, 0.515, 0.955), // Power2.easeInOut
    ));

    _currentRotation = targetRotation;

    // Start animations
    _rotationController.forward(from: 0);
    _zController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCard,
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationController, _zController]),
        builder: (context, child) {
          final rotation = _rotationAnimation.value;

          // backfaceVisibility: hidden logic with cumulative rotation
          // Use modulo to check which face is showing
          final normalizedRotation = (rotation % (2 * 3.14159)).abs();
          final isShowingFront = normalizedRotation < 1.5708 || normalizedRotation > 4.71239; // 0-90° or 270-360°
          final frontOpacity = isShowingFront ? 1.0 : 0.0;
          final backOpacity = isShowingFront ? 0.0 : 1.0;

          // Get z-depth scale from animation (1.0 → 0.92 → 1.0)
          final zScale = _zAnimation.value;

          // Build transformation matrix with perspective + rotate + scale
          // Exactly like code example
          final matrix = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(rotation)
            ..scale(zScale, zScale * 0.95, 1.0); // scaleY slightly less to reduce height

          return Stack(
            alignment: Alignment.center,
            children: [
              // Fake shadow
              Opacity(
                opacity: isShowingFront ? frontOpacity : backOpacity,
                child: Transform(
                  alignment: Alignment.center,
                  transform: matrix,
                  child: Transform.scale(
                    scale: 0.98,
                    child: Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Front card (hearts) - backfaceVisibility: hidden
              Opacity(
                opacity: frontOpacity,
                child: Transform(
                  alignment: Alignment.center,
                  transform: matrix,
                  child: widget.frontCard,
                ),
              ),
              // Back card (spades) - backfaceVisibility: hidden, rotationY: -180
              Opacity(
                opacity: backOpacity,
                child: Transform(
                  alignment: Alignment.center,
                  transform: matrix,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159),
                    child: widget.backCard,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _zController.dispose();
    super.dispose();
  }
}
