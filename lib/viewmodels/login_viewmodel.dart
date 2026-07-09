import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/core/routes/app_routes.dart';
import 'package:employee_app/core/utils/app_snackbar.dart';
import 'package:employee_app/repositories/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  LoginViewModel(this._loginRepository);

  final LoginRepository _loginRepository;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxnString emailError = RxnString();
  final RxnString passwordError = RxnString();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  bool _validate() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      emailError.value = 'Email address is required';
    } else if (!_isValidEmail(email)) {
      emailError.value = 'Please enter a valid email address';
    } else {
      emailError.value = null;
    }

    passwordError.value =
        password.isEmpty ? 'Password is required' : null;

    return emailError.value == null && passwordError.value == null;
  }

  Future<void> login() async {
    if (!_validate()) return;

    isLoading.value = true;

    try {
      final response = await _loginRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      AppSnackbar.show(
        response.message.isNotEmpty
            ? response.message
            : 'Login successful',
      );
      Get.offAllNamed(AppRoutes.home);
    } on ApiException catch (error) {
      AppSnackbar.show(error.message, isError: true);
    } catch (_) {
      AppSnackbar.show(
        'Something went wrong. Please try again.',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToSignUp() {
    Get.toNamed(AppRoutes.signUp);
  }

  void navigateToForgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  void clearEmailError(String _) => emailError.value = null;

  void clearPasswordError(String _) => passwordError.value = null;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
