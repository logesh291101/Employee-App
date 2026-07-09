import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/viewmodels/login_viewmodel.dart';
import 'package:employee_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends GetView<LoginViewModel> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 48.0 : 24.0;
    final maxContentWidth = screenWidth > 600 ? 440.0 : double.infinity;
    final logoWidth = screenWidth > 600 ? 160.0 : 140.0;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLogo(logoWidth),
                  const SizedBox(height: 40),
                  _buildWelcomeSection(),
                  const SizedBox(height: 36),
                  Obx(
                    () => AppTextField(
                      controller: controller.emailController,
                      label: 'Email Address',
                      hint: 'Enter your email address',
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
                      obscureText: controller.obscurePassword.value,
                      textInputAction: TextInputAction.done,
                      errorText: controller.passwordError.value,
                      onChanged: controller.clearPasswordError,
                      onSubmitted: (_) => controller.login(),
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
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: controller.navigateToForgotPassword,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.grey700,
                          color: AppColors.grey900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Obx(() {
                    final isLoading = controller.isLoading.value;
                    return SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : controller.login,
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          shadowColor: AppColors.black.withOpacity(0.15),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.white,
                                ),
                              )
                            : const Text('Sign In'),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.grey700,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.navigateToSignUp,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Secure access for VEDA GROUP employees',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.grey500,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(double width) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/veda_group_logo.png',
          width: width,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to access your employee portal and manage your workspace.',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.grey700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
