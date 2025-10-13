import 'package:flutter/material.dart';
import 'flip_card_widget.dart';
import 'flip_card_widget_option_a.dart';
import 'animated_card.dart';

class CardDetailScreen extends StatefulWidget {
  const CardDetailScreen({Key? key}) : super(key: key);

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  bool _useOptionA = false; // false = current version, true = option A (iOS spring)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: Column(
        children: [
          // Header
          _buildHeader(context),
          const SizedBox(height: 16),
          // Card flip widget
          _buildCardInfoSection(),
          // UI mockup image (rest of the screen)
          Expanded(
            child: SingleChildScrollView(
              child: Image.asset(
                'assets/images/UIimage.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Status bar placeholder
        Container(
          height: 44,
          width: double.infinity,
        ),
        // Navigation bar
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Color(0xFF394860),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Chi tiết thẻ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        height: 1.44,
                        color: Color(0xFF071A38),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _useOptionA = !_useOptionA;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _useOptionA ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _useOptionA ? 'Option A' : 'Current',
                          style: TextStyle(
                            fontSize: 12,
                            color: _useOptionA ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24), // Spacer to balance left icon
              ],
            ),
          ),
        ],
      );
  }

  Widget _buildCardInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedCard(
        child: _useOptionA
            ? FlipCardWidgetOptionA(
                width: double.infinity,
                height: 226,
                frontCard: _buildCardFront(),
                backCard: _buildCardBack(),
              )
            : FlipCardWidget(
                width: double.infinity,
                height: 226,
                frontCard: _buildCardFront(),
                backCard: _buildCardBack(),
              ),
      ),
    );
  }

  Widget _buildCardFront() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        'assets/images/card front.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: 226,
      ),
    );
  }

  Widget _buildCardBack() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        'assets/images/Card back.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: 226,
      ),
    );
  }

  Widget _buildCardUsageLimitSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0), // Exact Figma padding
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12), // Exact: 12px top/bottom, 0 left/right
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF), // Neutral-900
          border: Border.all(color: const Color(0xFFF2F1F7), width: 1), // Neutral-800
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Bar chart with title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16), // Exact: 0px 16px
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Hạn mức sử dụng',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          height: 1.467, // Fixed: exact line height
                          color: Color(0xFF394860), // Neutral-200
                        ),
                      ),
                      Text(
                        '15.000.000 đ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          height: 1.467,
                          color: Color(0xFF071A38), // Neutral-100
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress bar with exact gap
                  SizedBox(
                    height: 8,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 199,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF35B430), // GREEN - Hạn mức còn lại
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100),
                                bottomLeft: Radius.circular(100),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4), // Exact gap from Figma
                        Expanded(
                          flex: 123,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF37A5), // PINK - Chi tiêu kỳ này
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(100),
                                bottomRight: Radius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8), // Gap between bar and legends
            // Legends
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16), // Exact: 0px 16px
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6), // Exact: 6px 0px
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF35B430), // GREEN - matches bar
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Hạn mức còn lại',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                height: 1.538,
                                color: Color(0xFF666F80), // Neutral-300
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          '29.000.000 đ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            height: 1.538,
                            color: Color(0xFF071A38),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF37A5), // PINK - matches bar
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Dự nợ hiện tại',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                height: 1.538,
                                color: Color(0xFF666F80), // Neutral-300
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          '1.250.000 đ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            height: 1.538,
                            color: Color(0xFF071A38),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionsSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 4), // Exact Figma padding
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22), // Exact: 0px 22px
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFunctionButton(Icons.lock_outline, 'Khóa thẻ'),
                _buildFunctionButton(Icons.settings_outlined, 'Cài đặt'),
                _buildFunctionButton(Icons.credit_card_outlined, 'Số thẻ'),
                _buildFunctionButton(Icons.description_outlined, 'Sao kê'),
              ],
            ),
          ),
          const SizedBox(height: 16), // Gap between rows
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFunctionButton(Icons.notifications_outlined, 'Thông báo'),
                _buildFunctionButton(Icons.help_outline, 'Trợ giúp'),
                _buildFunctionButton(Icons.block_outlined, 'Giới hạn'),
                _buildFunctionButton(Icons.info_outline, 'Thông tin'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionButton(IconData icon, String label) {
    return Container(
      width: 76, // Fixed width from Figma
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F7), // Light gray background
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF2F1F7), width: 1),
            ),
            child: Icon(
              icon,
              size: 24,
              color: const Color(0xFF394860), // Neutral-200
            ),
          ),
          const SizedBox(height: 8), // Gap between icon and label
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500, // Fixed: was w400
              fontSize: 11, // Fixed: was 13
              height: 1.45, // Fixed: was 1.538
              color: Color(0xFF394860), // Neutral-200
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistorySection() {
    final transactions = [
      {'name': 'VIEON', 'time': '12:13', 'amount': '+65.000 đ', 'color': 0xFF35B430, 'iconBg': 0xFF4ADE80, 'icon': Icons.play_circle_outline},
      {'name': 'THE BAY CANADA', 'time': '10:02', 'amount': '-32.180.148 đ', 'color': 0xFF394860, 'iconBg': 0xFFE9D5FF, 'icon': Icons.restaurant},
      {'name': 'BeDriver', 'time': '10:02', 'amount': '-65.000 đ', 'color': 0xFF394860, 'iconBg': 0xFFFED7AA, 'icon': Icons.directions_car},
      {'name': 'UNIQLO VINCOM', 'time': '10:02', 'amount': '-65.000 đ', 'color': 0xFF394860, 'iconBg': 0xFFFBBACF, 'icon': Icons.shopping_bag},
      {'name': 'BeDriverSHYNH HOUSE...', 'time': '10:02', 'amount': '-65.000 đ', 'color': 0xFF394860, 'iconBg': 0xFFFEF08A, 'icon': Icons.directions_car},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24), // Exact Figma padding
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF), // Neutral-900
          border: Border.all(color: const Color(0xFFF2F1F7), width: 1), // Neutral-800
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), // Exact Figma padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giao dịch gần đây',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: 1.467, // Fixed: exact line height
                      color: Color(0xFF394860), // Neutral-200
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4), // Minimal padding for button
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        height: 1.538, // Fixed: exact line height
                        color: Color(0xFF00B5FF), // Brand/Dorger-500
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Transaction list
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), // Exact Figma padding
              child: Column(
                children: transactions.map((transaction) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12), // Gap between items
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Color(transaction['iconBg'] as int),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            transaction['icon'] as IconData,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12), // Gap from Figma
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction['name'] as String,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  height: 1.467, // Fixed: exact line height
                                  color: Color(0xFF394860), // Neutral-200
                                ),
                              ),
                              const SizedBox(height: 4), // Gap from Figma
                              Text(
                                transaction['time'] as String,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  height: 1.538, // Fixed: exact line height
                                  color: Color(0xFF666F80), // Neutral-300
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12), // Gap from Figma
                        Text(
                          transaction['amount'] as String,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            height: 1.467, // Fixed: exact line height
                            color: Color(transaction['color'] as int),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionsSection() {
    final promotions = [
      {'title': 'Quẹt thẻ liền tay, nhận ngay 200K', 'badgeColor': 0xFFFFF5CC, 'badgeText': 'Còn 2 ngày'},
      {'title': 'Quà khủng tặng bạn khi gia hạn tiền gửi', 'badgeColor': 0xFFD6F7FC, 'badgeText': 'Đang diễn ra'},
      {'title': 'Newbie gửi tiền, Cake liền thưởng nóng', 'badgeColor': 0xFFFFF5CC, 'badgeText': 'Còn 2 ngày'},
      {'title': 'Nhanh tay mở thẻ, thưởng trọn cả đôi', 'badgeColor': 0xFFD6F7FC, 'badgeText': 'Đang diễn ra'},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24), // Exact Figma padding
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF), // Neutral-900
          border: Border.all(color: const Color(0xFFF2F1F7), width: 1), // Neutral-800
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), // Exact Figma padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ưu đãi',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: 1.467, // Fixed: exact line height
                      color: Color(0xFF394860), // Neutral-200
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        height: 1.538, // Fixed: exact line height
                        color: Color(0xFF00B5FF), // Brand/Dorger-500
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Promotions grid
            Padding(
              padding: const EdgeInsets.all(16), // Exact: 16px all sides
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildPromotionCard(promotions[0]['title'] as String, promotions[0]['badgeColor'] as int, promotions[0]['badgeText'] as String),
                      ),
                      const SizedBox(width: 16), // Gap from Figma
                      Expanded(
                        child: _buildPromotionCard(promotions[1]['title'] as String, promotions[1]['badgeColor'] as int, promotions[1]['badgeText'] as String),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Gap between rows
                  Row(
                    children: [
                      Expanded(
                        child: _buildPromotionCard(promotions[2]['title'] as String, promotions[2]['badgeColor'] as int, promotions[2]['badgeText'] as String),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPromotionCard(promotions[3]['title'] as String, promotions[3]['badgeColor'] as int, promotions[3]['badgeText'] as String),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionCard(String title, int badgeColor, String badgeText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 155, // Exact height from Figma
          decoration: BoxDecoration(
            color: const Color(0xFFF2F1F7), // Neutral-800
            border: Border.all(color: const Color(0xFFF2F1F7), width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 8), // Gap from Figma
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 13,
            height: 1.538, // Fixed: exact line height
            color: Color(0xFF394860), // Neutral-200
          ),
        ),
        const SizedBox(height: 4), // Gap from Figma
        Container(
          padding: const EdgeInsets.fromLTRB(6, 4, 8, 4), // Exact Figma padding
          decoration: BoxDecoration(
            color: Color(badgeColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            badgeText,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 11, // Fixed: exact size from Figma
              height: 1.45, // Fixed: exact line height
              color: Color(0xFF394860), // Neutral-200
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeIndicator() {
    return Container(
      height: 34, // Exact height from Figma
      alignment: Alignment.center,
      child: Container(
        width: 135, // Exact width from Figma
        height: 5, // Exact height from Figma
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}