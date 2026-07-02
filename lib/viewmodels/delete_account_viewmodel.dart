import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/core/routes/app_routes.dart';
import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/core/utils/app_snackbar.dart';
import 'package:employee_app/repositories/delete_account_repository.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:employee_app/viewmodels/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountViewModel extends GetxController {
  DeleteAccountViewModel(this._deleteAccountRepository);

  final DeleteAccountRepository _deleteAccountRepository;

  final emNoController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxnString emNoError = RxnString();
  final RxnString passwordError = RxnString();

  bool _validate() {
    final emNo = emNoController.text.trim();
    final password = passwordController.text.trim();

    emNoError.value = emNo.isEmpty ? 'Employee number is required' : null;
    passwordError.value =
        password.isEmpty ? 'Password is required' : null;

    return emNoError.value == null && passwordError.value == null;
  }

  void submit() {
    if (!_validate()) return;
    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    Get.dialog<void>(
      AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Account',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.grey700,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _deleteAccount();
            },
            child: Text(
              'Confirm',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _deleteAccount() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await _deleteAccountRepository.deleteAccount(
        emNo: emNoController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _logoutAndNavigate(
        response.message.isNotEmpty
            ? response.message
            : 'Account deleted successfully',
      );
    } on ApiException catch (error) {
      await _logoutAndNavigate(error.message, isError: true);
    } catch (_) {
      await _logoutAndNavigate(
        'Something went wrong. Please try again.',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _logoutAndNavigate(
    String message, {
    bool isError = false,
  }) async {
    await _clearUserSession();
    AppSnackbar.show(message, isError: isError);
    Get.offAllNamed(AppRoutes.login);
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

  void clearEmNoError(String _) => emNoError.value = null;

  void clearPasswordError(String _) => passwordError.value = null;

  @override
  void onClose() {
    emNoController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
