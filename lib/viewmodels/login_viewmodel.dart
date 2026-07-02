import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/core/routes/app_routes.dart';
import 'package:employee_app/core/utils/app_snackbar.dart';
import 'package:employee_app/repositories/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  LoginViewModel(this._loginRepository);

  final LoginRepository _loginRepository;

  final emNoController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxnString emNoError = RxnString();
  final RxnString passwordError = RxnString();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool _validate() {
    final emNo = emNoController.text.trim();
    final password = passwordController.text.trim();

    emNoError.value = emNo.isEmpty ? 'Employee number is required' : null;
    passwordError.value =
        password.isEmpty ? 'Password is required' : null;

    return emNoError.value == null && passwordError.value == null;
  }

  Future<void> login() async {
    if (!_validate()) return;

    isLoading.value = true;

    try {
      final response = await _loginRepository.login(
        emNo: emNoController.text.trim(),
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

  void clearEmNoError(String _) => emNoError.value = null;

  void clearPasswordError(String _) => passwordError.value = null;

  @override
  void onClose() {
    emNoController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
