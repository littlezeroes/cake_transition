import 'cake_transition.dart';
import 'custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cake Animations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Home Screen với 2 Cake Animations
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Main content - Animations Page
          Expanded(
            child: RepaintBoundary(
              child: ScanPage(),
            ),
          ),

          // Floating Navigation Bar
          RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(1),
                  ],
                  stops: const [0.0, 0.89],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 40,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildNavItem(
                          context,
                          icon: Icons.animation,
                          label: 'ANIMATIONS',
                          onTap: () => Container(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildNavItem(BuildContext context, {required IconData icon, required String label, VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFF37A5), Color(0xFFEB0081)],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Icon(icon, size: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 12,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 8,
                    height: 1.5,
                    letterSpacing: 0.02,
                    color: Color(0xFF737373),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Scan Page - Animations Screen
class ScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Cake Animations
          _buildPinkButton(
            context,
            'Page transition',
            () => Navigator.push(
              context,
              CakePageRoute(screen: 1),
            ),
          ),
          const SizedBox(height: 12),
          _buildPinkButton(
            context,
            'Sheet Animation',
            () => Navigator.push(
              context,
              CakePageRoute(screen: 3),
            ),
          ),
          const SizedBox(height: 12),
          _buildPinkButton(
            context,
            'Dialog Animation',
            () => CustomDialog.show(
              context: context,
              title: 'Title cố gắng 1 dòng thôi',
              description: 'Description Nội dung chi tiết bỏ ở đây nhé. Xin cảm ơn! Kamsahamita',
              primaryButtonLabel: 'Label',
              secondaryButtonLabel: 'Label',
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  static Widget _buildPinkButton(
    BuildContext context,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 350,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFF37A5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}