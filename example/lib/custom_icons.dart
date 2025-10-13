import 'package:flutter/material.dart';
import 'dart:math';

class CustomIcons {
  // Custom icon for "Thẻ" - Credit card
  static Widget creditCard({double size = 24.0, Color color = Colors.black}) {
    return CustomPaint(
      size: Size(size, size),
      painter: CreditCardPainter(color: color),
    );
  }

  // Custom icon for "Vay tiền" - Hand with floating coin
  static Widget handWithCoin({double size = 24.0, Color color = Colors.black}) {
    return CustomPaint(
      size: Size(size, size),
      painter: HandWithCoinPainter(color: color),
    );
  }

  // Custom icon for "Quét" - QR scanner with X mark
  static Widget qrScannerWithX({double size = 24.0, Color color = Colors.black}) {
    return CustomPaint(
      size: Size(size, size),
      painter: QRScannerWithXPainter(color: color),
    );
  }

  // Custom icon for "Tiết kiệm" - Piggy bank
  static Widget piggyBank({double size = 24.0, Color color = Colors.black}) {
    return CustomPaint(
      size: Size(size, size),
      painter: PiggyBankPainter(color: color),
    );
  }

  // Custom icon for "Đầu tư" - Bar chart with arrow
  static Widget barChartWithArrow({double size = 24.0, Color color = Colors.black}) {
    return CustomPaint(
      size: Size(size, size),
      painter: BarChartWithArrowPainter(color: color),
    );
  }
}

class CreditCardPainter extends CustomPainter {
  final Color color;

  CreditCardPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw credit card outline
    final cardWidth = size.width * 0.8;
    final cardHeight = size.height * 0.6;
    final cardLeft = (size.width - cardWidth) / 2;
    final cardTop = (size.height - cardHeight) / 2;

    // Main card rectangle
    final cardRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cardLeft, cardTop, cardWidth, cardHeight),
      Radius.circular(4),
    );
    canvas.drawRRect(cardRect, paint);

    // Card chip (small rectangle)
    final chipWidth = cardWidth * 0.15;
    final chipHeight = cardHeight * 0.25;
    final chipLeft = cardLeft + cardWidth * 0.1;
    final chipTop = cardTop + cardHeight * 0.15;
    
    canvas.drawRect(
      Rect.fromLTWH(chipLeft, chipTop, chipWidth, chipHeight),
      fillPaint
    );

    // Card lines (simulating card details)
    final lineY = cardTop + cardHeight * 0.6;
    final lineWidth = cardWidth * 0.3;
    final lineLeft = cardLeft + cardWidth * 0.1;
    
    canvas.drawRect(
      Rect.fromLTWH(lineLeft, lineY, lineWidth, 2),
      fillPaint
    );

    // Smaller line
    final smallLineWidth = cardWidth * 0.2;
    final smallLineLeft = cardLeft + cardWidth * 0.1;
    final smallLineY = lineY + 8;
    
    canvas.drawRect(
      Rect.fromLTWH(smallLineLeft, smallLineY, smallLineWidth, 2),
      fillPaint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HandWithCoinPainter extends CustomPainter {
  final Color color;

  HandWithCoinPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw hand outline (simplified pixelated style)
    final handPath = Path();
    
    // Palm
    handPath.moveTo(size.width * 0.3, size.height * 0.6);
    handPath.lineTo(size.width * 0.7, size.height * 0.6);
    handPath.lineTo(size.width * 0.75, size.height * 0.7);
    handPath.lineTo(size.width * 0.7, size.height * 0.8);
    handPath.lineTo(size.width * 0.3, size.height * 0.8);
    handPath.close();

    // Fingers
    // Thumb
    handPath.moveTo(size.width * 0.25, size.height * 0.65);
    handPath.lineTo(size.width * 0.2, size.height * 0.55);
    handPath.lineTo(size.width * 0.25, size.height * 0.5);
    
    // Index finger
    handPath.moveTo(size.width * 0.35, size.height * 0.6);
    handPath.lineTo(size.width * 0.35, size.height * 0.45);
    
    // Middle finger
    handPath.moveTo(size.width * 0.5, size.height * 0.6);
    handPath.lineTo(size.width * 0.5, size.height * 0.4);
    
    // Ring finger
    handPath.moveTo(size.width * 0.65, size.height * 0.6);
    handPath.lineTo(size.width * 0.65, size.height * 0.45);
    
    // Pinky
    handPath.moveTo(size.width * 0.75, size.height * 0.6);
    handPath.lineTo(size.width * 0.8, size.height * 0.5);

    // Draw coin above hand
    final coinCenter = Offset(size.width * 0.5, size.height * 0.25);
    final coinRadius = size.width * 0.12;
    
    canvas.drawCircle(coinCenter, coinRadius, fillPaint);
    canvas.drawCircle(coinCenter, coinRadius, paint);
    
    // Draw coin symbol (star-like)
    final starPath = Path();
    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * 3.14159 / 5;
      final outerRadius = coinRadius * 0.6;
      final innerRadius = coinRadius * 0.3;
      
      final outerX = coinCenter.dx + outerRadius * cos(angle);
      final outerY = coinCenter.dy + outerRadius * sin(angle);
      final innerX = coinCenter.dx + innerRadius * cos(angle + 3.14159 / 5);
      final innerY = coinCenter.dy + innerRadius * sin(angle + 3.14159 / 5);
      
      if (i == 0) {
        starPath.moveTo(outerX, outerY);
      } else {
        starPath.lineTo(outerX, outerY);
      }
      starPath.lineTo(innerX, innerY);
    }
    starPath.close();
    
    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(starPath, starPaint);

    // Draw hand
    canvas.drawPath(handPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class QRScannerWithXPainter extends CustomPainter {
  final Color color;

  QRScannerWithXPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw QR scanner frame
    final frameSize = size.width * 0.6;
    final frameLeft = (size.width - frameSize) / 2;
    final frameTop = (size.height - frameSize) / 2;

    // Draw corner brackets
    final bracketLength = frameSize * 0.2;
    final bracketThickness = 3.0;

    // Top-left corner
    canvas.drawRect(
      Rect.fromLTWH(frameLeft, frameTop, bracketLength, bracketThickness),
      fillPaint
    );
    canvas.drawRect(
      Rect.fromLTWH(frameLeft, frameTop, bracketThickness, bracketLength),
      fillPaint
    );

    // Top-right corner
    canvas.drawRect(
      Rect.fromLTWH(frameLeft + frameSize - bracketLength, frameTop, bracketLength, bracketThickness),
      fillPaint
    );
    canvas.drawRect(
      Rect.fromLTWH(frameLeft + frameSize - bracketThickness, frameTop, bracketThickness, bracketLength),
      fillPaint
    );

    // Bottom-left corner
    canvas.drawRect(
      Rect.fromLTWH(frameLeft, frameTop + frameSize - bracketThickness, bracketLength, bracketThickness),
      fillPaint
    );
    canvas.drawRect(
      Rect.fromLTWH(frameLeft, frameTop + frameSize - bracketLength, bracketThickness, bracketLength),
      fillPaint
    );

    // Bottom-right corner
    canvas.drawRect(
      Rect.fromLTWH(frameLeft + frameSize - bracketLength, frameTop + frameSize - bracketThickness, bracketLength, bracketThickness),
      fillPaint
    );
    canvas.drawRect(
      Rect.fromLTWH(frameLeft + frameSize - bracketThickness, frameTop + frameSize - bracketLength, bracketThickness, bracketLength),
      fillPaint
    );

    // Draw center line
    final centerY = frameTop + frameSize / 2;
    canvas.drawRect(
      Rect.fromLTWH(frameLeft + bracketLength, centerY - 1, frameSize - 2 * bracketLength, 2),
      fillPaint
    );

    // Draw X mark at bottom center
    final xSize = frameSize * 0.15;
    final xCenter = Offset(size.width / 2, frameTop + frameSize + xSize);
    
    // Draw X lines
    canvas.drawLine(
      Offset(xCenter.dx - xSize, xCenter.dy - xSize),
      Offset(xCenter.dx + xSize, xCenter.dy + xSize),
      paint
    );
    canvas.drawLine(
      Offset(xCenter.dx + xSize, xCenter.dy - xSize),
      Offset(xCenter.dx - xSize, xCenter.dy + xSize),
      paint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PiggyBankPainter extends CustomPainter {
  final Color color;

  PiggyBankPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw piggy bank body (oval)
    final bodyCenter = Offset(size.width * 0.5, size.height * 0.6);
    final bodyWidth = size.width * 0.7;
    final bodyHeight = size.height * 0.6;
    
    final bodyRect = Rect.fromCenter(
      center: bodyCenter,
      width: bodyWidth,
      height: bodyHeight,
    );
    canvas.drawOval(bodyRect, paint);

    // Draw legs
    final legWidth = size.width * 0.08;
    final legHeight = size.height * 0.15;
    
    // Front legs
    canvas.drawRect(
      Rect.fromLTWH(bodyCenter.dx - bodyWidth * 0.3, bodyCenter.dy + bodyHeight * 0.3, legWidth, legHeight),
      fillPaint
    );
    canvas.drawRect(
      Rect.fromLTWH(bodyCenter.dx - bodyWidth * 0.1, bodyCenter.dy + bodyHeight * 0.3, legWidth, legHeight),
      fillPaint
    );
    
    // Back legs
    canvas.drawRect(
      Rect.fromLTWH(bodyCenter.dx + bodyWidth * 0.1, bodyCenter.dy + bodyHeight * 0.3, legWidth, legHeight),
      fillPaint
    );
    canvas.drawRect(
      Rect.fromLTWH(bodyCenter.dx + bodyWidth * 0.3, bodyCenter.dy + bodyHeight * 0.3, legWidth, legHeight),
      fillPaint
    );

    // Draw ear
    final earCenter = Offset(bodyCenter.dx, bodyCenter.dy - bodyHeight * 0.3);
    final earRadius = size.width * 0.08;
    canvas.drawCircle(earCenter, earRadius, fillPaint);
    canvas.drawCircle(earCenter, earRadius, paint);

    // Draw tail (curly)
    final tailCenter = Offset(bodyCenter.dx + bodyWidth * 0.4, bodyCenter.dy);
    final tailRadius = size.width * 0.06;
    canvas.drawCircle(tailCenter, tailRadius, fillPaint);
    canvas.drawCircle(tailCenter, tailRadius, paint);

    // Draw coin slot
    final slotCenter = Offset(bodyCenter.dx, bodyCenter.dy - bodyHeight * 0.1);
    final slotWidth = size.width * 0.12;
    final slotHeight = size.height * 0.08;
    
    final slotRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: slotCenter, width: slotWidth, height: slotHeight),
      Radius.circular(2),
    );
    canvas.drawRRect(slotRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BarChartWithArrowPainter extends CustomPainter {
  final Color color;

  BarChartWithArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw bar chart
    final chartLeft = size.width * 0.2;
    final chartBottom = size.height * 0.8;
    final barWidth = size.width * 0.12;
    final maxHeight = size.height * 0.5;

    // First bar (smallest)
    final bar1Height = maxHeight * 0.4;
    final bar1Left = chartLeft;
    canvas.drawRect(
      Rect.fromLTWH(bar1Left, chartBottom - bar1Height, barWidth, bar1Height),
      fillPaint
    );

    // Second bar (medium)
    final bar2Height = maxHeight * 0.6;
    final bar2Left = chartLeft + barWidth + size.width * 0.05;
    canvas.drawRect(
      Rect.fromLTWH(bar2Left, chartBottom - bar2Height, barWidth, bar2Height),
      fillPaint
    );

    // Third bar (largest)
    final bar3Height = maxHeight;
    final bar3Left = chartLeft + (barWidth + size.width * 0.05) * 2;
    canvas.drawRect(
      Rect.fromLTWH(bar3Left, chartBottom - bar3Height, barWidth, bar3Height),
      fillPaint
    );

    // Draw arrow pointing up from middle bar
    final arrowStart = Offset(bar2Left + barWidth / 2, chartBottom - bar2Height);
    final arrowEnd = Offset(bar2Left + barWidth / 2 + size.width * 0.15, chartBottom - bar2Height - size.height * 0.2);
    
    // Arrow line
    canvas.drawLine(arrowStart, arrowEnd, paint);
    
    // Arrow head
    final arrowHeadSize = size.width * 0.05;
    final arrowPath = Path();
    arrowPath.moveTo(arrowEnd.dx, arrowEnd.dy);
    arrowPath.lineTo(arrowEnd.dx - arrowHeadSize, arrowEnd.dy + arrowHeadSize);
    arrowPath.lineTo(arrowEnd.dx + arrowHeadSize, arrowEnd.dy + arrowHeadSize);
    arrowPath.close();
    
    canvas.drawPath(arrowPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
