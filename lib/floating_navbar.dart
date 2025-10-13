library floating_navbar;

import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:floating_navbar/animation_constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FloatingNavBar extends StatefulWidget {
  /// FloatingNavBar
  ///
  /// [FloatingNavbar] Base class for the bottom navigation bar

  /// The current page index
  int initialIndex;

  /// The items to be displayed on the navbar
  List<FloatingNavBarItem> items;

  /// The color of the navbar card
  Color color;

  /// The color of unselected page icons
  Color unselectedIconColor;

  /// The color of selected page icons
  Color selectedIconColor;

  /// The horizontal padding between the navbar card and the page
  double horizontalPadding;

  /// Allow haptic feedback on page change
  bool hapticFeedback;

  /// The border radius of the navbar card
  double borderRadius;

  /// Custom curve type for smooth corners
  CurveType curveType;

  /// Custom shadow blur radius
  double shadowBlur;

  /// Custom shadow spread radius  
  double shadowSpread;

  /// Shadow color
  Color shadowColor;

  /// Shadow offset
  Offset shadowOffset;

  /// The width of the navbar card
  double? cardWidth;

  /// Make use of titles/labels instead of the dot indicator
  bool showTitle;

  bool resizeToAvoidBottomInset;

  ScrollPhysics? scrollPhysics;

  ValueSetter<int>? onPageChanged;

  FloatingNavBar({
    Key? key,
    this.initialIndex = 0,
    this.borderRadius = 28.0,
    this.cardWidth,
    this.showTitle = false,
    this.selectedIconColor = Colors.white,
    this.unselectedIconColor = Colors.white,
    this.resizeToAvoidBottomInset = false,
    this.curveType = CurveType.smoothCorner,
    this.shadowBlur = 20.0,
    this.shadowSpread = 2.0,
    this.shadowColor = const Color(0x40000000),
    this.shadowOffset = const Offset(0, 4),
    required this.horizontalPadding,
    required this.items,
    required this.color,
    this.hapticFeedback = true,
    this.onPageChanged,
    this.scrollPhysics,
  })  : assert(items.length > 1),
        assert(items.length <= 5);

  @override
  _FloatingNavBarState createState() {
    return _FloatingNavBarState();
  }
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  late int currentIndex;
  late PageController _pageController;

  @override
  initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            PageView(
              physics: widget.scrollPhysics,
              controller: _pageController,
              children: widget.items.map((item) => item.page).toList(),
              onPageChanged: (index) => this._changePage(index),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: widget.horizontalPadding,
                ),
                child: Container(
                  height: 70,
                  width: widget.cardWidth ?? MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: _getBorderRadius(),
                    boxShadow: [
                      BoxShadow(
                        color: widget.shadowColor,
                        blurRadius: widget.shadowBlur,
                        spreadRadius: widget.shadowSpread,
                        offset: widget.shadowOffset,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: _getBorderRadius(),
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: widget.items.map((item) {
                          int index = widget.items.indexOf(item);
                          return _floatingNavBarItem(
                              item, index, widget.hapticFeedback);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [_floatingNavBarItem] will build and return a [FloatingNavBar] item widget
  Widget _floatingNavBarItem(
      FloatingNavBarItem item, int index, bool hapticFeedback) {
    // If showTitle is set to true then no [FloatingNavBarItem] can have no title
    if (widget.showTitle && item.title.isEmpty) {
      throw Exception(
          'Show title set to true: Missing FloatingNavBarItem title!');
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          enableFeedback: hapticFeedback,
          onTap: () {
            _changePage(index);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                width: 50,
                child: item.useImageIcon
                    ? ImageIcon(
                        item.icon?.image,
                        color: currentIndex == index
                            ? widget.selectedIconColor
                            : widget.unselectedIconColor,
                        size: item.icon?.size,
                        semanticLabel: item.icon?.semanticLabel,
                      )
                    : Icon(
                        item.iconData,
                        color: currentIndex == index
                            ? widget.selectedIconColor
                            : widget.unselectedIconColor,
                      ),
              ),
              widget.showTitle
                  ? AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      child: currentIndex == index
                          ? Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 15,
                                color: currentIndex == index
                                    ? widget.selectedIconColor
                                    : Colors.transparent,
                              ),
                            )
                          : SizedBox.shrink(),
                    )
                  : AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: 5,
                      width: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentIndex == index
                            ? widget.selectedIconColor
                            : Colors.transparent,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  /// [_changePage] changes selected page index so as to change the page being currently viewed by the user
  _changePage(index) {
    _pageController.jumpToPage(index);
    currentIndex = index;
    widget.onPageChanged?.call(index);
    if (mounted) {
      setState(() {});
    }
  }

  /// Get border radius based on curve type
  BorderRadius _getBorderRadius() {
    switch (widget.curveType) {
      case CurveType.circular:
        return BorderRadius.circular(widget.borderRadius);
      case CurveType.smoothCorner:
        // iOS-style smooth continuous corners
        return BorderRadius.only(
          topLeft: Radius.elliptical(widget.borderRadius, widget.borderRadius * 0.9),
          topRight: Radius.elliptical(widget.borderRadius, widget.borderRadius * 0.9),
          bottomLeft: Radius.elliptical(widget.borderRadius, widget.borderRadius * 0.9),
          bottomRight: Radius.elliptical(widget.borderRadius, widget.borderRadius * 0.9),
        );
      case CurveType.stadium:
        return BorderRadius.circular(35);
      case CurveType.squircle:
        // Squircle-like corners (between rounded and square)
        return BorderRadius.all(
          Radius.elliptical(widget.borderRadius * 1.2, widget.borderRadius),
        );
      case CurveType.customTop:
        // Custom top curves with straight bottom
        return BorderRadius.only(
          topLeft: Radius.circular(widget.borderRadius),
          topRight: Radius.circular(widget.borderRadius),
          bottomLeft: Radius.circular(widget.borderRadius * 0.4),
          bottomRight: Radius.circular(widget.borderRadius * 0.4),
        );
    }
  }
}

/// Enum for different curve types
enum CurveType {
  circular,      // Standard circular corners
  smoothCorner,  // iOS-style smooth continuous corners
  stadium,       // Pill/stadium shape
  squircle,      // Squircle (between rounded rect and circle)
  customTop,     // Custom top curves
}
