import 'package:flutter/material.dart';
import 'dart:math' as math;

/// ====================
/// HEXAGON BADGE PAINTER
/// ====================
class HexagonBadgePainter extends CustomPainter {
  final String text;
  final bool isCompleted;
  final Color textColor; // ✅ ADDED

  HexagonBadgePainter({
    required this.text,
    this.isCompleted = false,
    this.textColor = Colors.black, // ✅ ADDED
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    for (int layer = 0; layer < 3; layer++) {
      final layerRadius = radius - (layer * 8);
      final path = _createHexagonPath(center, layerRadius);

      if (layer == 0) {
        final shadowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.black.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawPath(path, shadowPaint);
      }

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Colors.grey.withValues(alpha: 0.6 - (layer * 0.15));

      canvas.drawPath(path, paint);
    }

    // ✅ UPDATED: Use textColor
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  Path _createHexagonPath(Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i - math.pi / 6;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ====================
/// CIRCLE BADGE PAINTER
/// ====================
class CircleBadgePainter extends CustomPainter {
  final String text;
  final bool isCompleted;
  final Color textColor; // ✅ ADDED

  CircleBadgePainter({
    required this.text,
    this.isCompleted = false,
    this.textColor = Colors.black, // ✅ ADDED
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    for (int layer = 0; layer < 3; layer++) {
      final layerRadius = radius - (layer * 8);

      if (layer == 0) {
        final shadowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.black.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(center, layerRadius, shadowPaint);
      }

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Colors.grey.withValues(alpha: 0.6 - (layer * 0.15));

      canvas.drawCircle(center, layerRadius, paint);
    }

    // ✅ UPDATED: Use textColor
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ====================
/// SHIELD BADGE PAINTER
/// ====================
class ShieldBadgePainter extends CustomPainter {
  final String text;
  final bool isCompleted;
  final List<Color>? gradientColors;
  final Color textColor; // ✅ ADDED

  ShieldBadgePainter({
    required this.text,
    this.isCompleted = false,
    this.gradientColors,
    this.textColor = Colors.black, // ✅ ADDED
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width / 2.5;
    final height = size.height / 2.5;

    for (int layer = 0; layer < 3; layer++) {
      final layerWidth = width - (layer * 6);
      final layerHeight = height - (layer * 6);
      final path = _createShieldPath(center, layerWidth, layerHeight);

      if (layer == 0) {
        final shadowPath = _createShieldPath(
          Offset(center.dx + 2, center.dy + 2),
          layerWidth,
          layerHeight,
        );
        final shadowPaint = Paint()
          ..color = Colors.black.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawPath(shadowPath, shadowPaint);
      }

      if (layer == 2 && isCompleted && gradientColors != null) {
        final paint = Paint()
          ..shader =
              LinearGradient(
                colors: gradientColors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(
                Rect.fromLTWH(
                  center.dx - layerWidth,
                  center.dy - layerHeight,
                  layerWidth * 2,
                  layerHeight * 2,
                ),
              );

        canvas.drawPath(path, paint);
      } else {
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = Colors.grey.withValues(alpha: 0.6 - (layer * 0.15));

        canvas.drawPath(path, paint);
      }
    }

    // ✅ UPDATED: Use white for gradient shields, textColor otherwise
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: (isCompleted && gradientColors != null)
              ? Colors.white
              : textColor,
          fontSize: text.length > 2 ? 18 : 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  Path _createShieldPath(Offset center, double width, double height) {
    final path = Path();
    path.moveTo(center.dx, center.dy - height);
    path.lineTo(center.dx + width * 0.8, center.dy - height * 0.3);
    path.lineTo(center.dx + width * 0.6, center.dy + height);
    path.lineTo(center.dx, center.dy + height * 1.2);
    path.lineTo(center.dx - width * 0.6, center.dy + height);
    path.lineTo(center.dx - width * 0.8, center.dy - height * 0.3);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ====================
/// STAR BADGE PAINTER
/// ====================
class StarBadgePainter extends CustomPainter {
  final bool isCompleted;
  final List<Color>? gradientColors;

  StarBadgePainter({this.isCompleted = false, this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2.5;
    final innerRadius = outerRadius * 0.4;

    final path = _createStarPath(center, outerRadius, innerRadius);

    final shadowPath = _createStarPath(
      Offset(center.dx + 2, center.dy + 2),
      outerRadius,
      innerRadius,
    );
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(shadowPath, shadowPaint);

    if (isCompleted && gradientColors != null) {
      final paint = Paint()
        ..shader = LinearGradient(
          colors: gradientColors!,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromCircle(center: center, radius: outerRadius));

      canvas.drawPath(path, paint);

      final highlightPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withValues(alpha: 0.3);
      canvas.drawPath(path, highlightPaint);
    } else {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Colors.grey.withValues(alpha: 0.6);

      canvas.drawPath(path, paint);
    }
  }

  Path _createStarPath(Offset center, double outerRadius, double innerRadius) {
    final path = Path();
    const points = 5;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (math.pi / points) * i - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ====================
/// CRESCENT MOON PAINTER
/// ====================
class CrescentMoonPainter extends CustomPainter {
  final bool isCompleted;

  CrescentMoonPainter({this.isCompleted = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3.5;

    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.grey.withValues(alpha: 0.7),
          Colors.grey.withValues(alpha: 0.5),
        ],
        center: Alignment.topLeft,
        radius: 1.2,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, fillPaint);

    final craterPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.4),
      radius * 0.2,
      craterPaint,
    );

    canvas.drawCircle(
      Offset(center.dx + radius * 0.35, center.dy + radius * 0.1),
      radius * 0.15,
      craterPaint,
    );

    canvas.drawCircle(
      Offset(center.dx - radius * 0.1, center.dy + radius * 0.4),
      radius * 0.18,
      craterPaint,
    );

    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.2);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.25, center.dy - radius * 0.25),
      radius * 0.3,
      highlightPaint,
    );

    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.grey.withValues(alpha: 0.8);
    canvas.drawCircle(center, radius, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ====================
/// GIFT BOX PAINTER
/// ====================
class GiftBoxPainter extends CustomPainter {
  final bool isCompleted;
  final List<Color>? gradientColors;

  GiftBoxPainter({this.isCompleted = false, this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final boxWidth = size.width / 3.2;
    final boxHeight = size.height / 3.8;
    final ribbonHeight = size.height / 10;

    final boxRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + ribbonHeight * 0.2),
      width: boxWidth,
      height: boxHeight,
    );

    final shadowRect = Rect.fromCenter(
      center: Offset(center.dx + 2, center.dy + ribbonHeight * 0.2 + 2),
      width: boxWidth,
      height: boxHeight,
    );
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRect(shadowRect, shadowPaint);

    if (isCompleted && gradientColors != null) {
      final paint = Paint()
        ..shader = LinearGradient(
          colors: gradientColors!,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(boxRect);

      canvas.drawRect(boxRect, paint);

      final highlightPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withValues(alpha: 0.3);
      canvas.drawRect(boxRect, highlightPaint);
    } else {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Colors.grey.withValues(alpha: 0.6);

      canvas.drawRect(boxRect, paint);
    }

    final ribbonY = center.dy + ribbonHeight * 0.2 - boxHeight / 2;
    final ribbonPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = Colors.grey.withValues(alpha: 0.6);

    canvas.drawLine(
      Offset(center.dx - boxWidth / 2, ribbonY),
      Offset(center.dx + boxWidth / 2, ribbonY),
      ribbonPaint,
    );

    canvas.drawLine(
      Offset(center.dx, ribbonY - ribbonHeight),
      Offset(center.dx, center.dy + ribbonHeight * 0.2 + boxHeight / 2),
      ribbonPaint,
    );

    final bowSize = ribbonHeight * 0.7;
    final bowY = ribbonY - ribbonHeight * 0.6;

    if (isCompleted && gradientColors != null) {
      final bowFillPaint = Paint()
        ..color = gradientColors!.first.withValues(alpha: 0.5);
      canvas.drawCircle(
        Offset(center.dx - bowSize * 0.6, bowY),
        bowSize * 0.5,
        bowFillPaint,
      );
      canvas.drawCircle(
        Offset(center.dx + bowSize * 0.6, bowY),
        bowSize * 0.5,
        bowFillPaint,
      );
    }

    canvas.drawCircle(
      Offset(center.dx - bowSize * 0.6, bowY),
      bowSize * 0.5,
      ribbonPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + bowSize * 0.6, bowY),
      bowSize * 0.5,
      ribbonPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ====================
/// HEART PAINTER
/// ====================
class HeartPainter extends CustomPainter {
  final bool isCompleted;
  final List<Color>? gradientColors;

  HeartPainter({this.isCompleted = false, this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width / 2.8;
    final height = size.height / 2.8;

    final path = _createHeartPath(center, width, height);

    final shadowPath = _createHeartPath(
      Offset(center.dx + 3, center.dy + 3),
      width,
      height,
    );
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(shadowPath, shadowPaint);

    if (isCompleted && gradientColors != null) {
      final paint = Paint()
        ..shader =
            LinearGradient(
              colors: gradientColors!,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(
              Rect.fromLTWH(
                center.dx - width * 1.3,
                center.dy - height,
                width * 2.6,
                height * 2.5,
              ),
            );

      canvas.drawPath(path, paint);

      final divisionPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.black.withValues(alpha: 0.15);

      canvas.drawLine(
        Offset(center.dx, center.dy - height * 0.3),
        Offset(center.dx - width * 0.6, center.dy + height * 0.5),
        divisionPaint,
      );

      canvas.drawLine(
        Offset(center.dx, center.dy - height * 0.3),
        Offset(center.dx + width * 0.6, center.dy + height * 0.5),
        divisionPaint,
      );

      canvas.drawLine(
        Offset(center.dx, center.dy - height * 0.3),
        Offset(center.dx, center.dy + height * 1.2),
        divisionPaint,
      );

      final leftArcPath = Path();
      leftArcPath.moveTo(center.dx, center.dy - height * 0.3);
      leftArcPath.arcTo(
        Rect.fromCircle(
          center: Offset(center.dx - width * 0.45, center.dy - height * 0.4),
          radius: width * 0.5,
        ),
        -math.pi / 4,
        -math.pi / 2,
        false,
      );
      canvas.drawPath(leftArcPath, divisionPaint);

      final rightArcPath = Path();
      rightArcPath.moveTo(center.dx, center.dy - height * 0.3);
      rightArcPath.arcTo(
        Rect.fromCircle(
          center: Offset(center.dx + width * 0.45, center.dy - height * 0.4),
          radius: width * 0.5,
        ),
        -math.pi * 0.75,
        math.pi / 2,
        false,
      );
      canvas.drawPath(rightArcPath, divisionPaint);

      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(
        Offset(center.dx - width * 0.4, center.dy - height * 0.2),
        width * 0.3,
        highlightPaint,
      );

      canvas.drawCircle(
        Offset(center.dx + width * 0.4, center.dy - height * 0.2),
        width * 0.3,
        highlightPaint,
      );
    } else {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Colors.grey.withValues(alpha: 0.6);

      canvas.drawPath(path, paint);
    }

    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = isCompleted && gradientColors != null
          ? Colors.white.withValues(alpha: 0.4)
          : Colors.grey.withValues(alpha: 0.5);
    canvas.drawPath(path, outlinePaint);
  }

  Path _createHeartPath(Offset center, double width, double height) {
    final path = Path();
    path.moveTo(center.dx, center.dy + height * 1.3);
    path.cubicTo(
      center.dx - width * 1.25,
      center.dy + height * 0.45,
      center.dx - width * 1.3,
      center.dy - height * 0.2,
      center.dx - width * 0.75,
      center.dy - height * 0.55,
    );
    path.cubicTo(
      center.dx - width * 0.4,
      center.dy - height * 0.8,
      center.dx - width * 0.15,
      center.dy - height * 0.8,
      center.dx,
      center.dy - height * 0.3,
    );
    path.cubicTo(
      center.dx + width * 0.15,
      center.dy - height * 0.8,
      center.dx + width * 0.4,
      center.dy - height * 0.8,
      center.dx + width * 0.75,
      center.dy - height * 0.55,
    );
    path.cubicTo(
      center.dx + width * 1.3,
      center.dy - height * 0.2,
      center.dx + width * 1.25,
      center.dy + height * 0.45,
      center.dx,
      center.dy + height * 1.3,
    );
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
