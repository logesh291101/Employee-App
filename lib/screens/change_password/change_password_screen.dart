import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/viewmodels/change_password_viewmodel.dart';
import 'package:employee_app/widgets/app_text_field.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends GetView<ChangePasswordViewModel> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const ProfileAppBar(
        title: 'Change Password',
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
                  Text(
                    'Update your password. You will be signed out after a successful change.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.grey700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => AppTextField(
                      controller: controller.emailController,
                      label: 'Email Address',
                      hint: 'Enter your email address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      errorText: controller.emailError.value,
                      onChanged: controller.clearEmailError,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => AppTextField(
                      controller: controller.currentPasswordController,
                      label: 'Current Password',
                      hint: 'Enter your current password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: controller.obscureCurrentPassword.value,
                      textInputAction: TextInputAction.next,
                      errorText: controller.currentPasswordError.value,
                      onChanged: controller.clearCurrentPasswordError,
                      suffixIcon: IconButton(
                        onPressed: controller.toggleCurrentPasswordVisibility,
                        icon: Icon(
                          controller.obscureCurrentPassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.grey500,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => AppTextField(
                      controller: controller.newPasswordController,
                      label: 'New Password',
                      hint: 'Enter your new password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: controller.obscureNewPassword.value,
                      textInputAction: TextInputAction.next,
                      errorText: controller.newPasswordError.value,
                      onChanged: controller.clearNewPasswordError,
                      suffixIcon: IconButton(
                        onPressed: controller.toggleNewPasswordVisibility,
                        icon: Icon(
                          controller.obscureNewPassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.grey500,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => AppTextField(
                      controller: controller.confirmPasswordController,
                      label: 'Confirm New Password',
                      hint: 'Re-enter your new password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: controller.obscureConfirmPassword.value,
                      textInputAction: TextInputAction.done,
                      errorText: controller.confirmPasswordError.value,
                      onChanged: controller.clearConfirmPasswordError,
                      onSubmitted: (_) => _onChangePassword(),
                      suffixIcon: IconButton(
                        onPressed: controller.toggleConfirmPasswordVisibility,
                        icon: Icon(
                          controller.obscureConfirmPassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.grey500,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Obx(
                    () => GradientButton(
                      label: 'Change Password',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.isLoading.value
                          ? null
                          : _onChangePassword,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onChangePassword() {
    HapticFeedback.lightImpact();
    controller.changePassword();
  }
}
