import 'package:animations/animations.dart';
import 'pink_button_page.dart';
import 'pink_button.dart';
import 'cake_transition.dart';
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
import 'curve_demo.dart';
import 'spring_bottom_sheet.dart';
import 'dynamic_height_sheet.dart';
import 'multi_view_sheet.dart';
import 'simple_animation_sheet.dart';
import 'ios_page_transition.dart';

/// iOS-like slide:
/// - Top screen: slide từ phải -> trái, 250ms, easeOutCubic.
/// - Bottom screen: chỉ bắt đầu di chuyển khi secondaryAnimation >= 0.5,
///   trượt sang trái đến -30% chiều rộng, curve chậm hơn (easeOutQuad).
class IOS26SlideTransitionsBuilder extends PageTransitionsBuilder {
  const IOS26SlideTransitionsBuilder();

  static const _topDuration = Duration(milliseconds: 250);
  static const _topReverse = Duration(milliseconds: 220);

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final forwardCurve = Curves.easeInOut;
    final reverseCurve = Curves.easeOut;

    // Luôn áp dụng cả hai animation - chúng sẽ tự động hoạt động đúng
    // animation = 0->1 cho route mới, secondaryAnimation = 0->1 cho route cũ
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: forwardCurve, reverseCurve: reverseCurve)),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.30, 0.0),
        ).animate(CurvedAnimation(parent: secondaryAnimation, curve: forwardCurve, reverseCurve: reverseCurve)),
        child: child,
      ),
    );
  }
}

/// Dùng Route với duration mong muốn (phục vụ khi push thủ công).
class IOS26SlidePageRoute<T> extends PageRouteBuilder<T> {
  IOS26SlidePageRoute({required WidgetBuilder builder})
      : super(
          pageBuilder: (ctx, _, __) => builder(ctx),
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          transitionsBuilder: (context, animation, secondary, child) {
            // Lưu ý: trong PageRouteBuilder đơn lẻ, bạn KHÔNG render được "màn dưới".
            // Parallax của màn dưới sẽ hoạt động đúng nếu app đã set PageTransitionsTheme bên dưới.
            final curve = Curves.easeOutCubic;
            final topSlide = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation);

            return SlideTransition(position: topSlide, child: child);
          },
        );
}

/// PageRouteBuilder với hỗ trợ drag gesture
class IOS26SlidePageRouteWithGesture<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  final bool enableDragGesture;

  IOS26SlidePageRouteWithGesture({
    required this.builder,
    this.enableDragGesture = true,
  }) : super(
          settings: const RouteSettings(name: "IOS26SlidePageRouteWithGesture"),
          pageBuilder: (ctx, _, __) => builder(ctx),
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (!enableDragGesture) {
              final curve = Curves.easeOutCubic;
              final topSlide = Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: curve)).animate(animation);

              return SlideTransition(position: topSlide, child: child);
            }

            return _DraggablePageRouteTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
        );
}

/// Widget cho phép drag gesture điều khiển page transition
class _DraggablePageRouteTransition extends StatefulWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const _DraggablePageRouteTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  State<_DraggablePageRouteTransition> createState() => _DraggablePageRouteTransitionState();
}

class _DraggablePageRouteTransitionState extends State<_DraggablePageRouteTransition>
    with TickerProviderStateMixin {
  late AnimationController _dragController;
  late Animation<double> _dragAnimation;
  bool _isDragging = false;
  double _dragStartX = 0.0;
  double _currentDragX = 0.0;

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _dragAnimation = _dragController;
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    // Bắt đầu drag từ bất kỳ đâu trên màn hình
    setState(() {
      _isDragging = true;
      _dragStartX = details.globalPosition.dx;
      _currentDragX = 0.0;
    });
    _dragController.value = 1.0; // Bắt đầu từ trạng thái hiển thị đầy đủ
    _dragController.stop();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    setState(() {
      _currentDragX = details.globalPosition.dx - _dragStartX;
      final screenWidth = MediaQuery.of(context).size.width;

      // Cho phép drag cả hai hướng
      double progress = 1.0 - (_currentDragX / screenWidth);
      progress = progress.clamp(0.0, 1.0);

      _dragController.value = progress;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final progress = (_currentDragX / screenWidth).clamp(0.0, 1.0);

    setState(() {
      _isDragging = false;
    });

    // Nếu drag > 30% screen width hoặc drag tốc độ nhanh, pop route
    if (progress > 0.3 || details.velocity.pixelsPerSecond.dx > 500) {
      _dragController.animateTo(0.0).then((_) {
        Navigator.of(context).pop();
      });
    } else {
      // Ngược lại, animate trở lại
      _dragController.animateTo(1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      behavior: HitTestBehavior.translucent,
      child: AnimatedBuilder(
        animation: Listenable.merge([widget.animation, _dragAnimation]),
        builder: (context, _) {
          // Sử dụng animation chính hoặc drag animation
          double progress = _isDragging ? _dragAnimation.value : widget.animation.value;

          // Áp dụng cả top slide và bottom parallax
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(
              AlwaysStoppedAnimation(progress),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-0.30, 0.0),
              ).chain(
                CurveTween(curve: const Interval(0.5, 1.0, curve: Curves.easeOutQuad)),
              ).animate(
                AlwaysStoppedAnimation(1.0 - progress), // Reverse cho bottom screen
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

// Perfect iOS page transition (legacy)
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
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: IOS26SlideTransitionsBuilder(),
            TargetPlatform.iOS: IOS26SlideTransitionsBuilder(),
            TargetPlatform.macOS: IOS26SlideTransitionsBuilder(),
            TargetPlatform.windows: IOS26SlideTransitionsBuilder(),
            TargetPlatform.linux: IOS26SlideTransitionsBuilder(),
            TargetPlatform.fuchsia: IOS26SlideTransitionsBuilder(),
          },
        ),
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
      body: Column(
        children: [
          // Main content - QR Scan Page
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
                          icon: Icons.swap_horiz,
                          label: 'NẠP RÚT',
                          page: EmptyPage(),
                        ),
                        _buildNavItem(
                          context,
                          icon: Icons.show_chart,
                          label: 'THỊ TRƯỜNG',
                          page: EmptyPage(),
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
                          page: EmptyPage(),
                        ),
                        _buildNavItem(
                          context,
                          icon: Icons.account_balance_wallet,
                          label: 'MARGIN',
                          page: EmptyPage(),
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

  static Widget _buildNavItem(BuildContext context, {required IconData icon, required String label, required Widget page}) {
    return Expanded(
      child: OpenContainer(
        transitionType: ContainerTransitionType.fade,
        transitionDuration: const Duration(milliseconds: 500),
        closedColor: Colors.transparent,
        closedElevation: 0,
        openElevation: 0,
        openBuilder: (context, _) => page,
        closedBuilder: (context, openContainer) => GestureDetector(
          onTap: openContainer,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // 5 Pink buttons theo Figma
            _buildPinkButton(
              context,
              'Bottom Sheet (Default)',
              () => showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black.withOpacity(0.3), // iOS 26 overlay
                isScrollControlled: true,
                builder: (context) => OTPScreen(index: 0),
              ),
            ),
            const SizedBox(height: 12),
            _buildPinkButton(
              context,
              'Bottom Sheet (Spring)',
              () => SpringBottomSheet.show(
                context: context,
                springType: SpringType.nonInteractive,
                builder: (context) => OTPScreen(index: 1),
              ),
            ),
            const SizedBox(height: 12),
            _buildPinkButton(
              context,
              'Cake Sheet with Spring',
              () => SpringBottomSheet.show(
                context: context,
                springType: SpringType.nonInteractive,
                builder: (context) => OTPScreen(index: 2),
              ),
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 12),
            _buildPinkButton(
              context,
              'Show Toast',
              () => CustomToast.show(
                context: context,
                content: 'This is a toast message with animation!',
                buttonLabel: 'Got it',
              ),
            ),
            const SizedBox(height: 12),
            _buildPinkButton(
              context,
              'Show Dialog',
              () {
                showV2CakeDialog(context);
              },
            ),
            const SizedBox(height: 12),
            _buildPinkButton(
              context,
              'Tab Page',
              () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => FigmaTabScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _buildPinkButton(
              context,
              'test Cake page transition',
              () => Navigator.push(
                context,
                CakePageRoute(screen: 1),
              ),
            ),
            const SizedBox(height: 12),
            _buildPinkButton(
              context,
              'Demo Sheet',
              () => Navigator.push(
                context,
                CakePageRoute(screen: 3),
              ),
            ),
            const SizedBox(height: 12),
            OpenContainer(
              transitionDuration: const Duration(milliseconds: 500),
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return _buildPinkButton(
                  context,
                  'New Pink Button (Transform)',
                  openContainer,
                );
              },
              openBuilder: (BuildContext _, VoidCallback __) {
                return PinkButtonPage();
              },
              closedColor: const Color(0xFFFF37A5),
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 12),
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

// iOS 26 Detail Page
class IOS26DetailPage extends StatelessWidget {
  const IOS26DetailPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'iOS 26 Transition',
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF37A5), Color(0xFFEB0081)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.flutter_dash,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'iOS 26 Slide Transition',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.black,
                height: 1.25,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '🎯 Drag Gesture Available!\n\nTry swiping from the right edge to go back:\n• Start drag from the right edge (20px zone)\n• Drag slowly to control the animation\n• Release >30% width or fast swipe to pop\n• Less than 30% = animates back\n\n✨ Features:\n• Top screen: right→left (250ms, easeOutCubic)\n• Bottom screen: starts at 50% progress\n• Bottom screen: slides to -30% (easeOutQuad)',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF737373),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildPinkButton(
                context,
                'Go Back',
                () => Navigator.pop(context),
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
        width: double.infinity,
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

// Cake Transition Page
class CupertinoTransitionPage extends StatelessWidget {
  const CupertinoTransitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Cake Transition',
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Image.asset(
          'assets/images/stock_homepage.png',
          width: double.infinity,
          fit: BoxFit.fitWidth,
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
        width: double.infinity,
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

class FullScreenDialogPage extends StatelessWidget {
  const FullScreenDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen Dialog'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('This is a full screen dialog page!'),
      ),
    );
  }
}

class CustomSwipePage extends StatelessWidget {
  const CustomSwipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Swipe Page'),
      ),
      body: const Center(
        child: Text('This page uses CustomSwipePageRoute!'),
      ),
    );
  }
}
