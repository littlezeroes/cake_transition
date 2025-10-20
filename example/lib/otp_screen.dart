import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

class OTPScreen extends StatefulWidget {
  final int? index;

  const OTPScreen({Key? key, this.index}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  List<String> otpDigits = ['', '', '', '', '', ''];
  int currentIndex = 0;
  bool showCode = false;

  void _onNumberTap(String number) {
    if (currentIndex < 6) {
      final newState = [...otpDigits];
      newState[currentIndex] = number;
      final newIndex = currentIndex < 5 ? currentIndex + 1 : currentIndex;

      if (currentIndex == 5) {
        // All digits entered, verify OTP immediately
        setState(() {
          otpDigits = newState;
          currentIndex = newIndex;
        });
        _verifyOTP();
      } else {
        setState(() {
          otpDigits = newState;
          currentIndex = newIndex;
        });
      }
    }
  }

  void _verifyOTP() {
    // Close the sheet immediately without delay
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _onClear() {
    if (currentIndex > 0) {
      setState(() {
        if (otpDigits[currentIndex].isEmpty && currentIndex > 0) {
          currentIndex--;
        }
        otpDigits[currentIndex] = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        shape: SmoothRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          smoothness: 0.6,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with drag indicator
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(0xFFE3E3E3),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              // Title
              Padding(
                padding: EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nhập Smart OTP để xác thực',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.33,
                      letterSpacing: -0.018,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // OTP Input boxes
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, showCode ? 40 : 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Numbers row
                        Row(
                          children: List.generate(6, (index) {
                            bool hasValue = otpDigits[index].isNotEmpty;
                            bool isActive = index == currentIndex;

                            return Container(
                              width: 32,
                              height: 56,
                              margin: EdgeInsets.only(right: index < 5 ? 4 : 0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Show value if exists
                                  if (hasValue && showCode)
                                    Text(
                                      otpDigits[index],
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 48,
                                        height: 1.17,
                                        letterSpacing: -1.5,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  // Show black dot if hidden and has value
                                  if (hasValue && !showCode)
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  // Show gray dot if no value
                                  if (!hasValue)
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFE3E3E3),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  // Show blue cursor line if active (positioned to left of dot)
                                  if (!hasValue && isActive)
                                    Positioned(
                                      left: 2,
                                      bottom: 8,
                                      child: Container(
                                        width: 2,
                                        height: 40,
                                        color: Color(0xFF3B82F6),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ),
                        // Eye icon
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showCode = !showCode;
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            child: Icon(
                              showCode
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Footer with forgot button
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      // Handle forgot action
                    },
                    child: Text(
                      'Quên mã? Tạo mới ngay',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF007AFF),
                      ),
                    ),
                  ),
                ),
              ),
              // Numpad keyboard
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    // Rows 1-3 (numbers 1-9)
                    for (int row = 0; row < 3; row++)
                      Row(
                        children: List.generate(3, (col) {
                          int number = row * 3 + col + 1;
                          return Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _onNumberTap(number.toString()),
                                child: Container(
                                  height: 56,
                                  alignment: Alignment.center,
                                  child: Text(
                                    number.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 28,
                                      height: 1.43,
                                      letterSpacing: -0.75,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    // Row 4 (empty, 0, clear)
                    Row(
                      children: [
                        // Empty space
                        Expanded(child: Container(height: 56)),
                        // 0
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _onNumberTap('0'),
                              child: Container(
                                height: 56,
                                alignment: Alignment.center,
                                child: Text(
                                  '0',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 28,
                                    height: 1.43,
                                    letterSpacing: -0.75,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Clear/Backspace
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _onClear,
                              child: Container(
                                height: 56,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.backspace_outlined,
                                  size: 28,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}