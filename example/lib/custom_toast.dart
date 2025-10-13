import 'package:flutter/material.dart';

/// Simple toast component from Figma design
/// Only improved animation - UI stays the same
/// Following Emil Kowalski's 7 animation principles
/// https://emilkowal.ski/ui/7-practical-animation-tips
class CustomToast extends StatelessWidget {
  final String content;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onDismiss;
  final bool showIcon;
  final bool showButton;
  final bool showDismiss;

  const CustomToast({
    Key? key,
    required this.content,
    this.buttonLabel,
    this.onButtonPressed,
    this.onDismiss,
    this.showIcon = true,
    this.showButton = true,
    this.showDismiss = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon (Add icon)
              if (showIcon)
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 12),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),

              // Content and Button
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Content text
                    Text(
                      content,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.43,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.left,
                    ),

                    // Button
                    if (showButton && buttonLabel != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: _ToastButton(
                          label: buttonLabel!,
                          onPressed: onButtonPressed ?? () {},
                        ),
                      ),
                  ],
                ),
              ),

              // Dismiss icon (X)
              if (showDismiss)
                GestureDetector(
                  onTap: onDismiss,
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(left: 12),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show toast with IMPROVED spring animation
  ///
  /// Animation improvements (Emil Kowalski's principles):
  /// - Tip #1: Scale buttons on press
  /// - Tip #2: Scale from 0.92 for spring bounce
  /// - Tip #4: Spring easing curve cubic-bezier(0.5, 1.8, 0.3, 0.8)
  /// - Tip #6: Fast animation (350ms)
  ///
  /// UI stays exactly the same as Figma design
  static void show({
    required BuildContext context,
    required String content,
    String? buttonLabel,
    VoidCallback? onButtonPressed,
    VoidCallback? onDismiss,
    bool showIcon = true,
    bool showButton = true,
    bool showDismiss = true,
    Duration autoDismissDuration = const Duration(seconds: 4),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    // Animation controller - 280ms
    final animationController = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 280),
    );

    // Curve: easeInOut for enter, easeOut for gentler exit
    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeOut, // Gentler, slower finish on exit
    );

    // Subtle scale from 0.96 for smooth entrance
    final scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(curvedAnimation);

    // Slide from bottom - reduced distance for snappier feel
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(curvedAnimation);

    // Smooth fade in/out (full duration for symmetric feel)
    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curvedAnimation);

    void removeOverlay() {
      animationController.reverse().then((_) {
        overlayEntry.remove();
        animationController.dispose();
      });
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        bottom: MediaQuery.of(context).size.height * 0.15,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
          child: CustomToast(
            content: content,
            buttonLabel: buttonLabel,
            onButtonPressed: onButtonPressed ?? removeOverlay,
            onDismiss: onDismiss ?? removeOverlay,
            showIcon: showIcon,
            showButton: showButton,
            showDismiss: showDismiss,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    animationController.forward();

    // Auto-dismiss
    Future.delayed(autoDismissDuration, () {
      if (overlayEntry.mounted) {
        removeOverlay();
      }
    });
  }
}

/// Toast button with scale animation on press
/// Tip #1: Scale your buttons
class _ToastButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _ToastButton({
    required this.label,
    required this.onPressed,
  });

  @override
  State<_ToastButton> createState() => _ToastButtonState();
}

class _ToastButtonState extends State<_ToastButton> {
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
        // Tip #1: Scale to 0.97 on press for tactile feedback
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          height: 20,
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.43,
              color: Color(0xFF3B82F6), // Blue button from Figma
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
