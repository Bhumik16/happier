import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/splash_controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF7F5C), // Coral/Orange
                  Color(0xFFFFB4A3), // Light Pink/Salmon
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF7F5C).withValues(alpha: 0.3),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(80, 80),
                painter: LogoIconPainter(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the curved swoosh logo icon
class LogoIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2a2a2a)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    // Create a curved path that looks like the swoosh in the image
    final path = Path();

    // Start point (bottom-left of the curve)
    path.moveTo(size.width * 0.3, size.height * 0.7);

    // Create a smooth S-curve using cubic bezier
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.5, // Control point 1
      size.width * 0.35,
      size.height * 0.35, // Control point 2
      size.width * 0.5,
      size.height * 0.3, // End point 1
    );

    path.cubicTo(
      size.width * 0.65,
      size.height * 0.25, // Control point 3
      size.width * 0.75,
      size.height * 0.35, // Control point 4
      size.width * 0.7,
      size.height * 0.5, // End point 2
    );

    // Make it thicker by stroking
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 16;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
