import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSnackbar {
  AppSnackbar._();

  static void show(String message, {bool isError = false}) {
    if (message.trim().isEmpty) return;

    final context = Get.context ?? Get.overlayContext;
    if (context != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
            backgroundColor: isError ? AppColors.grey900 : AppColors.black,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
      return;
    }

    Get.closeAllSnackbars();
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? AppColors.grey900 : AppColors.black,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}
