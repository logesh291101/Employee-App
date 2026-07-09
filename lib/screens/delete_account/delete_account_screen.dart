import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/viewmodels/delete_account_viewmodel.dart';
import 'package:employee_app/widgets/app_text_field.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountScreen extends GetView<DeleteAccountViewModel> {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const ProfileAppBar(
        title: 'Delete Account',
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
                    'Enter your email address and password to permanently delete your account. This action cannot be undone.',
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
                      controller: controller.passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: controller.obscurePassword.value,
                      textInputAction: TextInputAction.done,
                      errorText: controller.passwordError.value,
                      onChanged: controller.clearPasswordError,
                      onSubmitted: (_) => _onSubmit(),
                      suffixIcon: IconButton(
                        onPressed: controller.togglePasswordVisibility,
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.grey500,
                          size: 22,
                        ),
                        tooltip: controller.obscurePassword.value
                            ? 'Show password'
                            : 'Hide password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Obx(
                    () => GradientButton(
                      label: 'Delete Account',
                      isLoading: controller.isLoading.value,
                      onPressed:
                          controller.isLoading.value ? null : _onSubmit,
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

  void _onSubmit() {
    HapticFeedback.lightImpact();
    controller.submit();
  }
}
