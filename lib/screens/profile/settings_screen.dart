import 'package:employee_app/core/routes/app_routes.dart';
import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/screens/profile/widgets/profile_detail_tile.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _onChangePasswordTap() {
    HapticFeedback.lightImpact();
    Get.toNamed(AppRoutes.changePassword);
  }

  void _onDeleteAccountTap() {
    HapticFeedback.lightImpact();
    Get.toNamed(AppRoutes.deleteAccount);
  }

  void _onLogoutTap(BuildContext context) async {
    HapticFeedback.mediumImpact();
    await SharedPrefHelper.clearEmployeeDetails();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const ProfileAppBar(
        title: 'Settings',
        showBackButton: true,
        showActions: false,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ProfileSectionTitle(title: 'Account'),
                  _SettingsMenuTile(
                    icon: Icons.lock_reset_rounded,
                    label: 'Change Password',
                    subtitle: 'Update your account password',
                    onTap: _onChangePasswordTap,
                  ),
                  const SizedBox(height: 12),
                  _SettingsMenuTile(
                    icon: Icons.delete_outline_rounded,
                    label: 'Delete Account',
                    subtitle: 'Permanently remove your account',
                    isDestructive: true,
                    onTap: _onDeleteAccountTap,
                  ),
                  const SizedBox(height: 20),
                  const ProfileSectionTitle(title: 'Session'),
                  _SettingsMenuTile(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    subtitle: 'Sign out of your account',
                    onTap: () => _onLogoutTap(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsMenuTile extends StatelessWidget {
  const _SettingsMenuTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final accentColor = isDestructive ? AppColors.error : AppColors.black;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey300),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? AppColors.grey100
                      : AppColors.grey50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: accentColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.grey500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.grey500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
