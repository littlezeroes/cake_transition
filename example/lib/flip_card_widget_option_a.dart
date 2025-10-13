import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

/// 3D Flip Card Widget with iOS-style spring animation
/// Uses SpringSimulation with stiffness=50, damping=14.14, mass=1
/// Animation settles in ~1000ms (matches Current version)
class FlipCardWidgetOptionA extends StatefulWidget {
  final Widget frontCard;
  final Widget backCard;
  final double width;
  final double height;

  const FlipCardWidgetOptionA({
    Key? key,
    required this.frontCard,
    required this.backCard,
    this.width = 400,
    this.height = 226,
  }) : super(key: key);

  @override
  State<FlipCardWidgetOptionA> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidgetOptionA>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _zController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _zAnimation;

  double _currentRotation = 0.0; // Track cumulative rotation like JS +=180

  @override
  void initState() {
    super.initState();

    // Rotation controller - no fixed duration, controlled by spring
    _rotationController = AnimationController(
      vsync: this,
      value: 0,
    );

    // Z-depth controller not needed anymore - scale is calculated from rotation progress
    _zController = AnimationController(
      vsync: this,
      value: 0,
    );

    // Rotation animation will be updated in toggleCard()
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(_rotationController);

    // zAnimation not used
    _zAnimation = AlwaysStoppedAnimation(0);
  }

  void toggleCard() {
    // Haptic feedback - light impact for subtle tactile response
    HapticFeedback.lightImpact();

    // Flip 180° in opposite direction
    final targetRotation = _currentRotation - 3.14159; // -180°

    // Update rotation animation
    _rotationAnimation = Tween<double>(
      begin: _currentRotation,
      end: targetRotation,
    ).animate(_rotationController);

    // iOS-style spring adjusted to settle in ~1000ms (match Current)
    // Reduced stiffness for slower, smoother motion
    final spring = SpringSimulation(
      SpringDescription(
        mass: 1.0,
        stiffness: 50.0,  // Reduced from 100 for ~1000ms settle time
        damping: 14.14,   // Critically damped: 2 * sqrt(mass * stiffness)
      ),
      0.0, // start at 0
      1.0, // end at 1
      0.0, // velocity
    );

    _rotationController.animateWith(spring);
    _currentRotation = targetRotation;
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
          final normalizedRotation = (rotation % (2 * 3.14159)).abs();
          final isShowingFront = normalizedRotation < 1.5708 || normalizedRotation > 4.71239;
          final frontOpacity = isShowingFront ? 1.0 : 0.0;
          final backOpacity = isShowingFront ? 0.0 : 1.0;

          // Calculate animation progress (0 to 1 over rotation controller)
          final progress = _rotationController.value;

          // iOS-style scale animation with different X and Y
          // Scale X and Y differently to create "thụt cạnh trái" effect
          final scaleProgress = progress < 0.45 ? progress / 0.45 : (1.0 - progress) / 0.55;
          final scaleX = 1.0 - (scaleProgress * 0.15); // 1.0 → 0.85 → 1.0
          final scaleY = 1.0 - (scaleProgress * 0.08); // 1.0 → 0.92 → 1.0

          // Subtle opacity change for depth
          final cardOpacity = 1.0 - (scaleProgress * 0.05); // 1.0 → 0.95 → 1.0

          // Build transformation matrix - iOS style
          final matrix = Matrix4.identity()
            ..setEntry(3, 2, 0.002) // perspective (0.002 for natural feel)
            ..rotateY(rotation)
            ..scale(scaleX, scaleY, 1.0);

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
                opacity: frontOpacity * cardOpacity,
                child: Transform(
                  alignment: Alignment.center,
                  transform: matrix,
                  child: widget.frontCard,
                ),
              ),
              // Back card (spades) - backfaceVisibility: hidden, rotationY: -180
              Opacity(
                opacity: backOpacity * cardOpacity,
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
