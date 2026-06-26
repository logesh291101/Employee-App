import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckInOutCard extends StatelessWidget {
  const CheckInOutCard({
    super.key,
    required this.isCheckedIn,
    required this.currentTime,
    required this.onAction,
    this.isLoading = false,
  });

  final bool isCheckedIn;
  final String currentTime;
  final VoidCallback onAction;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey300.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isCheckedIn ? AppColors.black : AppColors.grey500,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                isCheckedIn ? 'Checked In' : 'Not Checked In',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const Spacer(),
              Icon(
                isCheckedIn
                    ? Icons.verified_outlined
                    : Icons.access_time_outlined,
                size: 20,
                color: AppColors.grey700,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  'Current Time',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.grey500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentTime,
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GradientButton(
            label: isCheckedIn ? 'Check Out' : 'Check In',
            isLoading: isLoading,
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}
