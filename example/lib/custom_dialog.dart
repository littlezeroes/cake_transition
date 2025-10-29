import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final String primaryButtonLabel;
  final String secondaryButtonLabel;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.primaryButtonLabel,
    required this.secondaryButtonLabel,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top headline section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.33,
                      letterSpacing: -0.01,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.43,
                      color: Color(0xFF737373),
                    ),
                  ),
                ],
              ),
            ),
            // Buttons container
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  // Secondary button
                  Expanded(
                    child: _SecondaryButton(
                      label: secondaryButtonLabel,
                      onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Primary button
                  Expanded(
                    child: _PrimaryButton(
                      label: primaryButtonLabel,
                      onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String description,
    required String primaryButtonLabel,
    required String secondaryButtonLabel,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
  }) {
      return showGeneralDialog<T>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 240), // 🎯 ANIMATION: Enter duration 240ms
      pageBuilder: (context, animation, secondaryAnimation) => CustomDialog(
        title: title,
        description: description,
        primaryButtonLabel: primaryButtonLabel,
        secondaryButtonLabel: secondaryButtonLabel,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // 🎯 ANIMATION: iOS-style smooth transition with scale + fade
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut, // 🎯 ANIMATION: Smooth acceleration/deceleration
          reverseCurve: Curves.easeInOut, // 🎯 ANIMATION: Same curve for exit
        );

        // 🎯 ANIMATION: Scale from 0.95 to 1.0 (gentle zoom in)
        final scaleAnimation = Tween<double>(
          begin: 0.95, // Start slightly smaller
          end: 1.0,   // End at normal size
        ).animate(curvedAnimation);

        // 🎯 ANIMATION: Fade from 0.0 to 1.0 (smooth transparency)
        final fadeAnimation = Tween<double>(
          begin: 0.0, // Start invisible
          end: 1.0,   // End fully visible
        ).animate(curvedAnimation);

        // 🎯 ANIMATION: Combine scale + fade effects
        return FadeTransition(
          opacity: fadeAnimation, // 🎯 ANIMATION: Apply fade effect
          child: ScaleTransition(
            scale: scaleAnimation, // 🎯 ANIMATION: Apply scale effect
            child: child, // 🎯 ANIMATION: Target widget
          ),
        );
      },
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0, // 🎯 ANIMATION: Scale down 3% when pressed
        duration: const Duration(milliseconds: 100), // 🎯 ANIMATION: Quick press feedback
        curve: Curves.easeOut, // 🎯 ANIMATION: Smooth deceleration
        child: Material(
          color: const Color(0xFFFF37A5),
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.5,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _SecondaryButton({
    required this.label,
    required this.onPressed,
  });

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0, // 🎯 ANIMATION: Scale down 3% when pressed
        duration: const Duration(milliseconds: 100), // 🎯 ANIMATION: Quick press feedback
        curve: Curves.easeOut, // 🎯 ANIMATION: Smooth deceleration
        child: Material(
          color: const Color(0xFFFEF1F9),
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.5,
                color: Color(0xFFFF37A5),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}