import 'package:flutter/material.dart';

// Simple iOS transition button - using Hero Animation
class IOSSimpleTransition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const IOSDetailPage(),
          ),
        );
      },
      child: Hero(
        tag: 'page_transition',
        child: Container(
          width: 350,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFF37A5),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Center(
            child: Text(
              'iOS Page Transition',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Detail Page with Hero Animation
class IOSDetailPage extends StatelessWidget {
  const IOSDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Home page content (visible underneath)
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(-100, 0), // Simulated pushed left
              child: Container(
                color: Colors.grey[100],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Home Page (Bottom)',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'This page was pushed left',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Detail page content
          Positioned.fill(
            child: Hero(
              tag: 'page_transition',
              flightShuttleBuilder: (flightContext, animation, direction, fromContext, toContext) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Container(
                      width: 350,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF37A5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          'iOS Page Transition',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Custom AppBar
                    Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Detail',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Content
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Detail Page (Top)',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}