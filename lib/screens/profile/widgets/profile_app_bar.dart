import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBack,
    this.onSettingsTap,
    this.showActions = true,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onSettingsTap;
  final bool showActions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              onPressed: onBack ?? () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              color: AppColors.black,
            )
          : const SizedBox(width: 8),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
          letterSpacing: -0.2,
        ),
      ),
      actions: showActions
          ? [
              IconButton(
                onPressed: onSettingsTap,
                icon: const Icon(Icons.settings_outlined),
                color: AppColors.black,
              ),
              const SizedBox(width: 4),
            ]
          : null,
    );
  }
}
