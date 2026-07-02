import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/profile/settings_screen.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/screens/profile/widgets/profile_detail_tile.dart';
import 'package:employee_app/screens/profile/widgets/profile_header_card.dart';
import 'package:employee_app/viewmodels/profile_viewmodel.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends GetView<ProfileViewModel> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        title: 'My Profile',
        onSettingsTap: () {
          HapticFeedback.lightImpact();
          Get.to(() => const SettingsScreen());
        },
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          Obx(() {
            if (controller.isLoading.value && controller.profile.value == null) {
              return const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.black,
                  ),
                ),
              );
            }

            final profile = controller.profile.value;
            final error = controller.errorMessage.value;

            if (profile == null) {
              return _ProfileErrorState(
                message: error ?? 'Unable to load profile.',
                onRetry: controller.fetchProfile,
              );
            }

            return Stack(
              children: [
                if (controller.isLoading.value)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color(0x88FFFFFF),
                      child: Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                SafeArea(
                  top: false,
                  child: RefreshIndicator(
                    color: AppColors.black,
                    onRefresh: controller.refreshProfile,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProfileHeaderCard(
                            name: profile.name,
                            employeeId: profile.employeeNumber,
                            email: profile.email,
                            mobile: profile.phoneNumber,
                            role: profile.role,
                            profileImageUrl: profile.profileImage,
                          ),
                          const SizedBox(height: 28),
                          const ProfileSectionTitle(title: 'Employee Details'),
                          ProfileDetailTile(
                            icon: Icons.work_outline,
                            label: 'Role',
                            value: profile.role,
                          ),
                          ProfileDetailTile(
                            icon: Icons.email_outlined,
                            label: 'Email Address',
                            value: profile.email,
                          ),
                          ProfileDetailTile(
                            icon: Icons.phone_outlined,
                            label: 'Phone Number',
                            value: profile.phoneNumber,
                          ),
                          ProfileDetailTile(
                            icon: Icons.business_outlined,
                            label: 'Brand',
                            value: profile.brand,
                          ),
                          ProfileDetailTile(
                            icon: Icons.apartment_outlined,
                            label: 'Centre',
                            value: profile.centre,
                          ),
                          ProfileDetailTile(
                            icon: Icons.calendar_today_outlined,
                            label: 'Joining Date',
                            value: controller.formatJoiningDate(
                              profile.joiningDate,
                            ),
                          ),
                          ProfileDetailTile(
                            icon: Icons.supervisor_account_outlined,
                            label: 'Reporting Manager',
                            value: profile.reportManager,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ProfileErrorState extends StatelessWidget {
  const _ProfileErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 48,
              color: AppColors.grey500,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.grey700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                side: const BorderSide(color: AppColors.grey300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
