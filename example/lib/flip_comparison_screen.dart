import 'package:flutter/material.dart';
import 'flip_card_widget.dart';
import 'flip_card_widget_option_a.dart';

class FlipComparisonScreen extends StatelessWidget {
  const FlipComparisonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        title: const Text('Animation Comparison'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Version
            const Text(
              'Current (1s rotation, 500ms scale)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            FlipCardWidget(
              width: double.infinity,
              height: 200,
              frontCard: _buildCardFront('Current'),
              backCard: _buildCardBack('Current'),
            ),
            const SizedBox(height: 32),

            // Option A
            const Text(
              'Option A (iOS Spring: stiffness=100, damping=15)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            FlipCardWidgetOptionA(
              width: double.infinity,
              height: 200,
              frontCard: _buildCardFront('Option A'),
              backCard: _buildCardBack('Option A'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront(String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.credit_card, size: 48, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              'Front - $label',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack(String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFF43F5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.credit_card, size: 48, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              'Back - $label',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
