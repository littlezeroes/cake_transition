import 'package:flutter/material.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';

// Helper function moved to the top level
String _getCurveTypeName(CurveType type) {
  switch (type) {
    case CurveType.circular:
      return 'Circular';
    case CurveType.smoothCorner:
      return 'Smooth';
    case CurveType.stadium:
      return 'Stadium';
    case CurveType.squircle:
      return 'Squircle';
    case CurveType.customTop:
      return 'Custom';
  }
}

class CurveDemoScreen extends StatefulWidget {
  @override
  _CurveDemoScreenState createState() => _CurveDemoScreenState();
}

class _CurveDemoScreenState extends State<CurveDemoScreen> {
  CurveType selectedCurveType = CurveType.smoothCorner;
  double borderRadius = 28.0;
  double shadowBlur = 20.0;
  double shadowSpread = 2.0;
  double horizontalPadding = 20.0;
  Color shadowColor = const Color(0x1A000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: FloatingNavBar(
              borderRadius: borderRadius,
              curveType: selectedCurveType,
              shadowBlur: shadowBlur,
              shadowSpread: shadowSpread,
              shadowColor: shadowColor,
              shadowOffset: Offset(0, 4),
              horizontalPadding: horizontalPadding,
              color: Colors.white,
              selectedIconColor: Colors.blue,
              unselectedIconColor: Colors.grey,
              items: [
                FloatingNavBarItem(
                  iconData: Icons.home,
                  page: DemoPage(title: 'Home', color: Colors.blue[50]!, borderRadius: borderRadius, selectedCurveType: selectedCurveType),
                  title: 'Home',
                ),
                FloatingNavBarItem(
                  iconData: Icons.search,
                  page: DemoPage(title: 'Search', color: Colors.green[50]!, borderRadius: borderRadius, selectedCurveType: selectedCurveType),
                  title: 'Search',
                ),
                FloatingNavBarItem(
                  iconData: Icons.add_circle,
                  page: DemoPage(title: 'Add', color: Colors.purple[50]!, borderRadius: borderRadius, selectedCurveType: selectedCurveType),
                  title: 'Add',
                ),
                FloatingNavBarItem(
                  iconData: Icons.notifications,
                  page: DemoPage(title: 'Notifications', color: Colors.orange[50]!, borderRadius: borderRadius, selectedCurveType: selectedCurveType),
                  title: 'Alerts',
                ),
                FloatingNavBarItem(
                  iconData: Icons.person,
                  page: DemoPage(title: 'Profile', color: Colors.red[50]!, borderRadius: borderRadius, selectedCurveType: selectedCurveType),
                  title: 'Profile',
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Curve Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Curve Type Selection
                  Text('Curve Type:', style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: CurveType.values.map((type) {
                      return ChoiceChip(
                        label: Text(_getCurveTypeName(type)),
                        selected: selectedCurveType == type,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              selectedCurveType = type;
                            });
                          }
                        },
                        selectedColor: Colors.blue[100],
                      );
                    }).toList(),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Border Radius Slider
                  Text('Border Radius: ${borderRadius.toStringAsFixed(0)}'),
                  Slider(
                    value: borderRadius,
                    min: 10,
                    max: 40,
                    divisions: 30,
                    onChanged: (value) {
                      setState(() {
                        borderRadius = value;
                      });
                    },
                  ),
                  
                  // Shadow Blur Slider
                  Text('Shadow Blur: ${shadowBlur.toStringAsFixed(0)}'),
                  Slider(
                    value: shadowBlur,
                    min: 0,
                    max: 40,
                    divisions: 40,
                    onChanged: (value) {
                      setState(() {
                        shadowBlur = value;
                      });
                    },
                  ),
                  
                  // Shadow Spread Slider
                  Text('Shadow Spread: ${shadowSpread.toStringAsFixed(0)}'),
                  Slider(
                    value: shadowSpread,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        shadowSpread = value;
                      });
                    },
                  ),
                  
                  // Horizontal Padding Slider
                  Text('Horizontal Padding: ${horizontalPadding.toStringAsFixed(0)}'),
                  Slider(
                    value: horizontalPadding,
                    min: 0,
                    max: 40,
                    divisions: 40,
                    onChanged: (value) {
                      setState(() {
                        horizontalPadding = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// DemoPage Widget is now a top-level class
class DemoPage extends StatefulWidget {
  final String title;
  final Color color;
  final double borderRadius;
  final CurveType selectedCurveType;

  const DemoPage({
    Key? key,
    required this.title,
    required this.color,
    required this.borderRadius,
    required this.selectedCurveType,
  }) : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  late BorderRadius _currentBorderRadius;

  @override
  void initState() {
    super.initState();
    // Start with rounded corners
    _currentBorderRadius = BorderRadius.only(
      topLeft: Radius.elliptical(widget.borderRadius, widget.borderRadius * 0.6),
      topRight: Radius.elliptical(widget.borderRadius, widget.borderRadius * 0.6),
      bottomLeft: Radius.elliptical(widget.borderRadius, widget.borderRadius * 0.6),
      bottomRight: Radius.elliptical(widget.borderRadius, widget.borderRadius * 0.6),
    );

    // After the first frame, animate to sharp corners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _currentBorderRadius = BorderRadius.zero;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: _currentBorderRadius,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.widgets,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Curve Type: ${_getCurveTypeName(widget.selectedCurveType)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
