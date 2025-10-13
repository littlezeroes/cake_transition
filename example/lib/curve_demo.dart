import 'package:flutter/material.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';

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
  Color shadowColor = const Color(0x40000000);
  
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
                  page: _buildDemoPage('Home', Colors.blue[50]!),
                  title: 'Home',
                ),
                FloatingNavBarItem(
                  iconData: Icons.search,
                  page: _buildDemoPage('Search', Colors.green[50]!),
                  title: 'Search',
                ),
                FloatingNavBarItem(
                  iconData: Icons.add_circle,
                  page: _buildDemoPage('Add', Colors.purple[50]!),
                  title: 'Add',
                ),
                FloatingNavBarItem(
                  iconData: Icons.notifications,
                  page: _buildDemoPage('Notifications', Colors.orange[50]!),
                  title: 'Alerts',
                ),
                FloatingNavBarItem(
                  iconData: Icons.person,
                  page: _buildDemoPage('Profile', Colors.red[50]!),
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
  
  Widget _buildDemoPage(String title, Color color) {
    return Container(
      color: color,
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
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Curve Type: ${_getCurveTypeName(selectedCurveType)}',
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