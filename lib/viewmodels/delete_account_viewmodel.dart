import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/core/routes/app_routes.dart';
import 'package:employee_app/core/utils/app_snackbar.dart';
import 'package:employee_app/repositories/delete_account_repository.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:employee_app/viewmodels/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccountViewModel extends GetxController {
  DeleteAccountViewModel(this._deleteAccountRepository);

  final DeleteAccountRepository _deleteAccountRepository;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxnString emailError = RxnString();
  final RxnString passwordError = RxnString();

  @override
  void onInit() {
    super.onInit();
    _prefillEmail();
  }

  Future<void> _prefillEmail() async {
    final email = await SharedPrefHelper.getEmail();
    if (email.isNotEmpty) {
      emailController.text = email;
    }
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

  Future<void> submit() async {
    if (!_validate() || isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await _deleteAccountRepository.deleteAccount(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _clearUserSession();
      AppSnackbar.show(
        response.message.isNotEmpty
            ? response.message
            : 'Account deleted successfully',
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

  Future<void> _clearUserSession() async {
    await SharedPrefHelper.clearUserSessionData();

    if (Get.isRegistered<ProfileViewModel>()) {
      final profileViewModel = Get.find<ProfileViewModel>();
      profileViewModel.profile.value = null;
      profileViewModel.errorMessage.value = null;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
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
