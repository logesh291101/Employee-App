import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum PasswordStrength { none, weak, medium, strong }

PasswordStrength evaluatePasswordStrength(String password) {
  if (password.isEmpty) return PasswordStrength.none;
  var score = 0;
  if (password.length >= 8) score++;
  if (password.length >= 12) score++;
  if (RegExp(r'[A-Z]').hasMatch(password)) score++;
  if (RegExp(r'[0-9]').hasMatch(password)) score++;
  if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

  if (score <= 2) return PasswordStrength.weak;
  if (score <= 4) return PasswordStrength.medium;
  return PasswordStrength.strong;
}

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
  });

  final PasswordStrength strength;

  int get _activeSegments {
    switch (strength) {
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.medium:
        return 2;
      case PasswordStrength.strong:
        return 4;
      case PasswordStrength.none:
        return 0;
    }
  }

  String get _label {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.none:
        return '';
    }
  }

  Color get _activeColor {
    switch (strength) {
      case PasswordStrength.weak:
        return AppColors.grey500;
      case PasswordStrength.medium:
        return AppColors.grey700;
      case PasswordStrength.strong:
        return AppColors.black;
      case PasswordStrength.none:
        return AppColors.grey300;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (strength == PasswordStrength.none) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            final isActive = index < _activeSegments;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                decoration: BoxDecoration(
                  color: isActive ? _activeColor : AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Password strength: $_label',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.grey700,
          ),
        ),
      ],
    );
  }
}
