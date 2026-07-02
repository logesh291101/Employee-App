import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/core/routes/app_routes.dart';
import 'package:employee_app/core/utils/app_snackbar.dart';
import 'package:employee_app/repositories/change_password_repository.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordViewModel extends GetxController {
  ChangePasswordViewModel(this._changePasswordRepository);

  final ChangePasswordRepository _changePasswordRepository;

  final emNoController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscureCurrentPassword = true.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  final RxnString emNoError = RxnString();
  final RxnString currentPasswordError = RxnString();
  final RxnString newPasswordError = RxnString();
  final RxnString confirmPasswordError = RxnString();

  @override
  void onInit() {
    super.onInit();
    _prefillEmNo();
  }

  Future<void> _prefillEmNo() async {
    final emNo = await SharedPrefHelper.getEmNo();
    if (emNo.isNotEmpty) {
      emNoController.text = emNo;
    }
  }

  bool _validate() {
    final emNo = emNoController.text.trim();
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    emNoError.value = emNo.isEmpty ? 'Employee number is required' : null;
    currentPasswordError.value =
        currentPassword.isEmpty ? 'Current password is required' : null;

    if (newPassword.isEmpty) {
      newPasswordError.value = 'New password is required';
    } else {
      newPasswordError.value = null;
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Please confirm your new password';
    } else if (newPassword.isNotEmpty && newPassword != confirmPassword) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = null;
    }

    return emNoError.value == null &&
        currentPasswordError.value == null &&
        newPasswordError.value == null &&
        confirmPasswordError.value == null;
  }

  Future<void> changePassword() async {
    if (!_validate() || isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await _changePasswordRepository.changePassword(
        emNo: emNoController.text.trim(),
        currentPassword: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      AppSnackbar.show(
        response.message.isNotEmpty
            ? response.message
            : 'Password changed successfully',
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

  void toggleCurrentPasswordVisibility() {
    obscureCurrentPassword.value = !obscureCurrentPassword.value;
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void clearEmNoError(String _) => emNoError.value = null;

  void clearCurrentPasswordError(String _) =>
      currentPasswordError.value = null;

  void clearNewPasswordError(String _) => newPasswordError.value = null;

  void clearConfirmPasswordError(String _) =>
      confirmPasswordError.value = null;

  @override
  void onClose() {
    emNoController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
