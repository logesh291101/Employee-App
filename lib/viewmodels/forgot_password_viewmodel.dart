import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/core/routes/app_routes.dart';
import 'package:employee_app/core/utils/app_snackbar.dart';
import 'package:employee_app/repositories/forgot_password_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordViewModel extends GetxController {
  ForgotPasswordViewModel(this._forgotPasswordRepository);

  final ForgotPasswordRepository _forgotPasswordRepository;

  final emNoController = TextEditingController();
  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxnString emNoError = RxnString();
  final RxnString emailError = RxnString();

  bool _isValidEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  bool _validate() {
    final emNo = emNoController.text.trim();
    final email = emailController.text.trim();

    emNoError.value = emNo.isEmpty ? 'Employee number is required' : null;

    if (email.isEmpty) {
      emailError.value = 'Registered email address is required';
    } else if (!_isValidEmail(email)) {
      emailError.value = 'Please enter a valid email address';
    } else {
      emailError.value = null;
    }

    return emNoError.value == null && emailError.value == null;
  }

  Future<void> sendMail() async {
    if (!_validate()) return;

    isLoading.value = true;

    try {
      final response = await _forgotPasswordRepository.forgotPassword(
        emNo: emNoController.text.trim(),
        email: emailController.text.trim(),
      );

      AppSnackbar.show(
        response.message.isNotEmpty
            ? response.message
            : 'Password sent successfully',
      );
      Get.offAllNamed(AppRoutes.login);
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

  void navigateToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  void clearEmNoError(String _) => emNoError.value = null;

  void clearEmailError(String _) => emailError.value = null;

  @override
  void onClose() {
    emNoController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
