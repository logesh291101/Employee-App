import 'package:employee_app/viewmodels/forgot_password_viewmodel.dart';
import 'package:employee_app/widgets/app_text_field.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordViewModel> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      children: [
        AuthFormCard(
          title: 'Forgot Password?',
          subtitle: 'Enter the Employee Number and Registered Email Address',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => AppTextField(
                  controller: controller.emNoController,
                  label: 'Employee Number',
                  hint: 'Enter your employee number',
                  prefixIcon: Icons.badge_outlined,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  errorText: controller.emNoError.value,
                  onChanged: controller.clearEmNoError,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => AppTextField(
                  controller: controller.emailController,
                  label: 'Registered Email Address',
                  hint: 'Enter your registered email address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  errorText: controller.emailError.value,
                  onChanged: controller.clearEmailError,
                  onSubmitted: (_) => _onSendMail(),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => GradientButton(
                  label: 'Send Mail',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.isLoading.value ? null : _onSendMail,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AuthLinkRow(
          prefixText: 'Remember your password?',
          linkText: 'Back to Sign In',
          onLinkPressed: controller.navigateToLogin,
        ),
      ],
    );
  }

  void _onSendMail() {
    HapticFeedback.lightImpact();
    controller.sendMail();
  }
}
