import 'package:flutter/material.dart';
import 'page_transitions.dart';

// Demo page to showcase all transitions
class TransitionDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Transition Showcase'),
        elevation: 0,
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildTransitionCard(
            context,
            'Smooth Slide - Right to Left',
            'Classic slide transition with smooth curve',
            Colors.blue,
            () => Navigator.push(
              context,
              SmoothSlideTransition(
                page: DemoTargetPage(title: 'Smooth Slide RTL', color: Colors.blue),
                direction: SlideDirection.rightToLeft,
              ),
            ),
          ),
          _buildTransitionCard(
            context,
            'Smooth Slide - Bottom to Top',
            'Vertical slide transition',
            Colors.green,
            () => Navigator.push(
              context,
              SmoothSlideTransition(
                page: DemoTargetPage(title: 'Smooth Slide BTT', color: Colors.green),
                direction: SlideDirection.bottomToTop,
              ),
            ),
          ),
          _buildTransitionCard(
            context,
            'Elastic Slide',
            'Bouncy slide effect with spring physics',
            Colors.orange,
            () => Navigator.push(
              context,
              ElasticSlideTransition(
                page: DemoTargetPage(title: 'Elastic Slide', color: Colors.orange),
              ),
            ),
          ),
          _buildTransitionCard(
            context,
            'Scale & Slide',
            'Combined scale and slide animation',
            Colors.purple,
            () => Navigator.push(
              context,
              ScaleSlideTransition(
                page: DemoTargetPage(title: 'Scale & Slide', color: Colors.purple),
              ),
            ),
          ),
          _buildTransitionCard(
            context,
            'Rotation Scale',
            '3D rotation with scaling effect',
            Colors.red,
            () => Navigator.push(
              context,
              RotationScaleTransition(
                page: DemoTargetPage(title: 'Rotation Scale', color: Colors.red),
              ),
            ),
          ),
          _buildTransitionCard(
            context,
            'Parallax Slide',
            'Depth effect with parallax motion',
            Colors.teal,
            () => Navigator.push(
              context,
              ParallaxSlideTransition(
                page: DemoTargetPage(title: 'Parallax Slide', color: Colors.teal),
              ),
            ),
          ),
          _buildTransitionCard(
            context,
            '3D Flip',
            'Card flip rotation effect',
            Colors.indigo,
            () => Navigator.push(
              context,
              Flip3DTransition(
                page: DemoTargetPage(title: '3D Flip', color: Colors.indigo),
              ),
            ),
          ),
          _buildTransitionCard(
            context,
            'Zoom Scale',
            'Pure zoom scaling effect',
            Colors.pink,
            () => Navigator.push(
              context,
              ZoomScaleTransition(
                page: DemoTargetPage(title: 'Zoom Scale', color: Colors.pink),
              ),
            ),
          ),
          _buildTransitionCard(
            context,
            'Circular Reveal',
            'Material Design circular reveal',
            Colors.cyan,
            () => Navigator.push(
              context,
              CircularRevealTransition(
                page: DemoTargetPage(title: 'Circular Reveal', color: Colors.cyan),
              ),
            ),
          ),
          _buildTransitionCard(
            context,
            'Accordion',
            'Vertical accordion expansion',
            Colors.amber,
            () => Navigator.push(
              context,
              AccordionTransition(
                page: DemoTargetPage(title: 'Accordion', color: Colors.amber),
              ),
            ),
          ),
          _buildTransitionCard(
            context,
            'iOS Push',
            'Native iOS-style push transition',
            Colors.grey,
            () => Navigator.push(
              context,
              IOSPushTransition(
                page: DemoTargetPage(title: 'iOS Push', color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransitionCard(
    BuildContext context,
    String title,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.animation,
                  color: color,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
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
}

// Target page for demonstrations
class DemoTargetPage extends StatelessWidget {
  final String title;
  final Color color;

  const DemoTargetPage({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.withValues(alpha: 0.1),
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
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 60,
              ),
            ),
            SizedBox(height: 32),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'This page demonstrates the $title animation. Navigate back to see the reverse animation.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
              label: Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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