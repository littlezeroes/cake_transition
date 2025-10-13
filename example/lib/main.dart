import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'otp_screen.dart';
import 'custom_dialog.dart';
import 'card_detail_screen.dart';
import 'flip_comparison_screen.dart';
import 'custom_toast.dart';
import 'transition_showcase.dart';
import 'swipeable_page_route.dart';
import 'curve_demo.dart';

// Perfect iOS page transition
class PerfectIOSPageTransition extends PageRouteBuilder {
  final Widget page;

  PerfectIOSPageTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const iosCurve = Cubic(0.25, 0.1, 0.25, 1.0);

            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: iosCurve,
            );

            final secondaryCurvedAnimation = CurvedAnimation(
              parent: secondaryAnimation,
              curve: iosCurve,
            );

            final newPage = SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-0.3, 0.0),
              ).animate(secondaryCurvedAnimation),
              child: newPage,
            );
          },
        );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation Demo',
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

// Home Screen với QR scan và floating navbar
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content - QR Scan Page
          ScanPage(),

          // Floating Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
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
                          icon: Icons.swap_horiz,
                          label: 'NẠP RÚT',
                          onTap: () => Navigator.push(context, SwipeablePageRoute(builder: (_) => EmptyPage())),
                        ),
                        _buildNavItem(
                          context,
                          icon: Icons.show_chart,
                          label: 'THỊ TRƯỜNG',
                          onTap: () {
                            Navigator.push(context, SwipeablePageRoute(builder: (_) => EmptyPage()));
                          },
                        ),
                        _buildHighlightedNavItem(
                          context,
                          icon: Icons.gavel,
                          label: 'ĐẶT LỆNH',
                          onTap: () => Navigator.push(context, PerfectIOSPageTransition(page: EmptyPage())),
                        ),
                        _buildNavItem(
                          context,
                          icon: Icons.access_time,
                          label: 'SAO KÊ',
                          onTap: () => Navigator.push(context, SwipeablePageRoute(builder: (_) => EmptyPage())),
                        ),
                        _buildNavItem(
                          context,
                          icon: Icons.account_balance_wallet,
                          label: 'MARGIN',
                          onTap: () => Navigator.push(context, SwipeablePageRoute(builder: (_) => EmptyPage())),
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
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 32,
                child: Center(
                  child: Icon(icon, size: 20, color: Colors.black),
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

  static Widget _buildHighlightedNavItem(BuildContext context, {required IconData icon, required String label, VoidCallback? onTap}) {
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

// Empty Page
class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(),
    );
  }
}

// Scan Page - QR Screen
class ScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            // 5 Pink buttons theo Figma
            _buildPinkButton(
              context,
              'Show Bottom Sheet',
              () => showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => OTPScreen(),
              ),
            ),
            const SizedBox(height: 20),
            _buildPinkButton(
              context,
              'Card Detail',
              () => Navigator.push(
                context,
                SwipeablePageRoute(builder: (_) => CardDetailScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _buildPinkButton(
              context,
              'Show Toast',
              () => CustomToast.show(
                context: context,
                content: 'This is a toast message with animation!',
                buttonLabel: 'Got it',
              ),
            ),
            const SizedBox(height: 20),
            _buildPinkButton(
              context,
              'Show Dialog',
              () {
                showDialog(
                  context: context,
                  builder: (_) => CustomDialog(
                    title: 'Success!',
                    description: 'This is a custom dialog with smooth animations.',
                    primaryButtonLabel: 'OK',
                    secondaryButtonLabel: 'Cancel',
                    onPrimaryPressed: () => Navigator.pop(context),
                    onSecondaryPressed: () => Navigator.pop(context),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildPinkButton(
              context,
              'Tab Page',
              () => Navigator.push(
                context,
                SwipeablePageRoute(builder: (_) => FigmaTabScreen()),
              ),
            ),
          ],
        ),
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

// Figma Tab Screen - Simple and clean
class FigmaTabScreen extends StatefulWidget {
  @override
  _FigmaTabScreenState createState() => _FigmaTabScreenState();
}

class _FigmaTabScreenState extends State<FigmaTabScreen> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _previousTabIndex = 0;
  int? _tappedIndex;
  double? _dragProgress;
  int? _dragStartIndex;
  List<double> _tabCenters = [];

  final List<String> tabs = ['Tài sản', 'Danh mục', 'Phải trả', 'Quyền', 'Tab'];
  final List<GlobalKey> _tabKeys = List.generate(5, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
      value: 1.0,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 56,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            alignment: Alignment.center,
            child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          ),
        ),
        title: const Text(
          'Đầu tư',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
            height: 1.33,
            letterSpacing: -0.0018,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 56,
      ),
      body: Column(
        children: [
          // Tab Bar with animated shape
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (details) {
                _animationController.stop();
                setState(() {
                  _previousTabIndex = _selectedTabIndex;
                  _dragStartIndex = _selectedTabIndex;
                });
              },
              onHorizontalDragUpdate: (details) {
                if (_dragStartIndex == null) return;

                double currentX = details.globalPosition.dx;

                // Find progress between tabs
                for (int i = 0; i < _tabKeys.length - 1; i++) {
                  final RenderBox? currentBox = _tabKeys[i].currentContext?.findRenderObject() as RenderBox?;
                  final RenderBox? nextBox = _tabKeys[i + 1].currentContext?.findRenderObject() as RenderBox?;

                  if (currentBox != null && nextBox != null) {
                    final currentPos = currentBox.localToGlobal(Offset.zero);
                    final nextPos = nextBox.localToGlobal(Offset.zero);
                    final currentCenter = currentPos.dx + currentBox.size.width / 2;
                    final nextCenter = nextPos.dx + nextBox.size.width / 2;

                    if (currentX >= currentCenter && currentX <= nextCenter) {
                      double progress = (currentX - currentCenter) / (nextCenter - currentCenter);
                      progress = progress.clamp(0.0, 1.0);

                      if (_previousTabIndex != i || _selectedTabIndex != i + 1 || _dragProgress == null || (_dragProgress! - progress).abs() > 0.01) {
                        setState(() {
                          _previousTabIndex = i;
                          _selectedTabIndex = i + 1;
                          _dragProgress = progress;
                        });
                      }
                      return;
                    }
                  }
                }

                // Check if before first tab or after last tab
                final RenderBox? firstBox = _tabKeys[0].currentContext?.findRenderObject() as RenderBox?;
                final RenderBox? lastBox = _tabKeys[_tabKeys.length - 1].currentContext?.findRenderObject() as RenderBox?;

                if (firstBox != null) {
                  final firstCenter = firstBox.localToGlobal(Offset.zero).dx + firstBox.size.width / 2;
                  if (currentX < firstCenter && _selectedTabIndex != 0) {
                    setState(() {
                      _previousTabIndex = 0;
                      _selectedTabIndex = 0;
                      _dragProgress = 0;
                    });
                    return;
                  }
                }

                if (lastBox != null) {
                  final lastCenter = lastBox.localToGlobal(Offset.zero).dx + lastBox.size.width / 2;
                  if (currentX > lastCenter && _selectedTabIndex != _tabKeys.length - 1) {
                    setState(() {
                      _previousTabIndex = _tabKeys.length - 1;
                      _selectedTabIndex = _tabKeys.length - 1;
                      _dragProgress = 0;
                    });
                    return;
                  }
                }
              },
              onHorizontalDragEnd: (details) {
                setState(() {
                  _dragStartIndex = null;
                  _dragProgress = null;
                });
              },
              child: Stack(
                children: [
                  // Animated background shape
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _TabIndicatorPainter(
                          currentIndex: _previousTabIndex,
                          nextIndex: _selectedTabIndex,
                          progress: _dragProgress ?? _animation.value,
                          tabKeys: _tabKeys,
                        ),
                        child: Container(),
                      );
                    },
                  ),
                  // Tab items
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: tabs.asMap().entries.map((entry) {
                    int index = entry.key;
                    String tab = entry.value;
                    bool isSelected = _selectedTabIndex == index;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        print('✅ TAP tab $index');
                        if (_selectedTabIndex != index) {
                          setState(() {
                            _previousTabIndex = _selectedTabIndex;
                            _selectedTabIndex = index;
                          });
                          _animationController.forward(from: 0.0);
                        }
                      },
                      child: Container(
                          key: _tabKeys[index],
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Text(
                            tab,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 1.43,
                              color: isSelected ? Colors.black : const Color(0xFF737373),
                            ),
                          ),
                      ),
                    );
                  }).toList(),
                  ),
                ],
              ),
            ),
          ),
          // PnL Info Section
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '9.110.000 đ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    height: 1.25,
                    letterSpacing: -0.03125,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'PnL hôm nay:',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.67,
                        color: Color(0xFF737373),
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      '+19.591.291 đ (+0.37%)',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 1.67,
                        color: Color(0xFF20B757),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Content area with PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for animated tab indicator
class _TabIndicatorPainter extends CustomPainter {
  final int currentIndex;
  final int nextIndex;
  final double progress;
  final List<GlobalKey> tabKeys;

  _TabIndicatorPainter({
    required this.currentIndex,
    required this.nextIndex,
    required this.progress,
    required this.tabKeys,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (tabKeys.isEmpty) return;
    if (currentIndex >= tabKeys.length || nextIndex >= tabKeys.length) return;

    final RenderBox? currentBox = tabKeys[currentIndex].currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? nextBox = tabKeys[nextIndex].currentContext?.findRenderObject() as RenderBox?;

    if (currentBox == null || nextBox == null) return;

    // Get positions relative to the parent
    final currentOffset = currentBox.localToGlobal(Offset.zero);
    final nextOffset = nextBox.localToGlobal(Offset.zero);

    // Find the Stack's global position to calculate relative positions
    final RenderBox? firstTabBox = tabKeys[0].currentContext?.findRenderObject() as RenderBox?;
    if (firstTabBox == null) return;

    final parentGlobalOffset = firstTabBox.localToGlobal(Offset.zero);

    final currentPosition = Offset(
      currentOffset.dx - parentGlobalOffset.dx,
      currentOffset.dy - parentGlobalOffset.dy,
    );
    final currentSize = currentBox.size;

    final nextPosition = Offset(
      nextOffset.dx - parentGlobalOffset.dx,
      nextOffset.dy - parentGlobalOffset.dy,
    );
    final nextSize = nextBox.size;

    // Interpolate position only, use target size (no stretching)
    final left = currentPosition.dx + (nextPosition.dx - currentPosition.dx) * progress;
    final width = nextSize.width;
    final top = currentPosition.dy + (nextPosition.dy - currentPosition.dy) * progress;
    final height = nextSize.height;

    final paint = Paint()
      ..color = const Color(0xFFF8F8F8)
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, width, height),
      const Radius.circular(12),
    );

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(_TabIndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.currentIndex != currentIndex ||
           oldDelegate.nextIndex != nextIndex;
  }
}

// Transition Showcase Screen
class TransitionShowcaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transitions'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text('Transition Showcase'),
      ),
    );
  }
}
