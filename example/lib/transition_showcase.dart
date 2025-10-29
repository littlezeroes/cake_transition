import 'package:flutter/material.dart';
import 'ios_transitions.dart';
import 'perfect_ios_transition.dart';
import 'custom_dialog.dart';

class TransitionShowcasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('iOS Transitions Review'),
        backgroundColor: Color(0xFF1E3A8A),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Currently Used - Most Perfect'),
          _buildTransitionCard(
            context,
            title: 'Perfect iOS Page Transition',
            subtitle: 'The most authentic iOS experience',
            description: '350ms • Cubic(0.25, 0.46, 0.45, 0.94)\nExact iOS parallax • Multi-layer shadows',
            color: Colors.blue,
            isActive: true,
            onTap: () => Navigator.push(
              context,
              PerfectIOSPageTransition(page: DemoPage(
                title: 'Perfect iOS Page',
                color: Colors.blue,
              )),
            ),
          ),
          
          SizedBox(height: 24),
          _buildSectionTitle('Enhanced Perfect Transitions'),
          
          _buildTransitionCard(
            context,
            title: 'Ultra Perfect iOS',
            subtitle: '120Hz Pro Motion optimized',
            description: '350ms • Cubic(0.28, 0.0, 0.22, 1.0)\nMicro-interactions • Brightness adjust',
            color: Colors.indigo,
            onTap: () => Navigator.push(
              context,
              UltraPerfectIOSTransition(page: DemoPage(
                title: 'Ultra Perfect',
                color: Colors.indigo,
              )),
            ),
          ),
          
          _buildTransitionCard(
            context,
            title: 'Silky Smooth iOS',
            subtitle: '60-120 FPS optimized',
            description: '375ms • Cubic(0.4, 0.0, 0.2, 1.0)\nMaximum smoothness • Opacity blend',
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              SilkySmoothIOSTransition(page: DemoPage(
                title: 'Silky Smooth',
                color: Colors.purple,
              )),
            ),
          ),
          
          _buildTransitionCard(
            context,
            title: 'Native Feel iOS',
            subtitle: 'Closest to actual iOS UIKit',
            description: '350ms • Cubic(0.25, 0.1, 0.25, 1.0)\nMinimal effects • Clean animation',
            color: Colors.cyan,
            onTap: () => Navigator.push(
              context,
              NativeFeelIOSTransition(page: DemoPage(
                title: 'Native Feel',
                color: Colors.cyan,
              )),
            ),
          ),
          
          _buildTransitionCard(
            context,
            title: 'Gesture iOS',
            subtitle: 'Interactive & responsive',
            description: '350ms • Cubic(0.35, 0.91, 0.33, 0.97)\nHaptic feedback • Gesture-ready',
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              GestureIOSTransition(page: DemoPage(
                title: 'Gesture iOS',
                color: Colors.orange,
              )),
            ),
          ),
          
          SizedBox(height: 24),
          _buildSectionTitle('Other Available Transitions'),
          
          _buildTransitionCard(
            context,
            title: 'Native iOS Page Route',
            subtitle: 'CupertinoPageRoute',
            description: '350ms • Native iOS behavior\nBuilt-in platform animation',
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              IOSPageTransition(
                builder: (_) => DemoPage(
                  title: 'Native iOS',
                  color: Colors.green,
                ),
              ),
            ),
          ),
          
          _buildTransitionCard(
            context,
            title: 'Ultra Smooth iOS',
            subtitle: 'iOS 17 style with enhancements',
            description: '400ms • Cubic(0.35, 0.0, 0.25, 1.0)\n30% parallax • 95% scale • 15% dimming',
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              UltraSmoothIOSTransition(page: DemoPage(
                title: 'Ultra Smooth',
                color: Colors.purple,
              )),
            ),
          ),
          
          _buildTransitionCard(
            context,
            title: 'iOS Modal',
            subtitle: 'Bottom sheet style',
            description: '500ms • Spring curve\nScale down background to 94%',
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              IOSModalTransition(page: DemoPage(
                title: 'iOS Modal',
                color: Colors.orange,
              )),
            ),
          ),
          
          _buildTransitionCard(
            context,
            title: 'iOS Zoom',
            subtitle: 'Scale transition',
            description: '350ms • Scale from 85% to 100%\nNo slide effect',
            color: Colors.teal,
            onTap: () => Navigator.push(
              context,
              IOSZoomTransition(page: DemoPage(
                title: 'iOS Zoom',
                color: Colors.teal,
              )),
            ),
          ),
          
          SizedBox(height: 24),
          _buildComparisonSection(context),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E3A8A),
        ),
      ),
    );
  }
  
  Widget _buildTransitionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: isActive ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive ? BorderSide(color: color, width: 2) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.animation,
                  color: color,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (isActive) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'ACTIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildComparisonSection(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Comparison',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            SizedBox(height: 12),
            _buildComparisonRow('Speed', 'Perfect iOS', 'Ultra Smooth'),
            _buildComparisonRow('Duration', '350ms', '400ms'),
            _buildComparisonRow('Parallax', '33%', '30%'),
            _buildComparisonRow('Background Scale', 'None', '95%'),
            _buildComparisonRow('Dimming', 'None', '15%'),
            _buildComparisonRow('Shadow', 'Subtle', 'Enhanced'),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _showSideBySideComparison(context),
              icon: Icon(Icons.compare_arrows),
              label: Text('Side-by-Side Test'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E3A8A),
                minimumSize: Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => showV2CakeDialog(context),
              icon: Icon(Icons.cake),
              label: Text('Show Pink Dialog'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF37A5),
                minimumSize: Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildComparisonRow(String label, String value1, String value2) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value1,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showSideBySideComparison(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Test Transitions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        PerfectIOSTransition(page: DemoPage(
                          title: 'Perfect iOS',
                          color: Colors.blue,
                        )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('Perfect iOS'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        UltraSmoothIOSTransition(page: DemoPage(
                          title: 'Ultra Smooth',
                          color: Colors.purple,
                        )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: Text('Ultra Smooth'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DemoPage extends StatelessWidget {
  final String title;
  final Color color;
  
  const DemoPage({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 60,
              ),
            ),
            SizedBox(height: 32),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Swipe back to test reverse transition',
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios),
              label: Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}