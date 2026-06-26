import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SubtlePatternPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _SubtlePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.grey100.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.08),
      80,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.25),
      60,
      paint..color = AppColors.grey100.withOpacity(0.35),
    );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.55),
      100,
      paint..color = AppColors.grey100.withOpacity(0.25),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
