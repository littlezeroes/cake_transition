import 'package:flutter/material.dart';

class PinkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const PinkButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: const Color(0xFFFF37A5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}