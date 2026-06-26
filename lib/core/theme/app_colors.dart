import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0A0A0A);
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color grey900 = Color(0xFF212121);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color error = Color(0xFF424242);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E3A34),
      Color(0xFF1A1A2E),
      Color(0xFF0A0A0A),
    ],
  );
}
