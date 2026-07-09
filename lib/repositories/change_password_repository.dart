import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/change_password/change_password_request.dart';
import 'package:employee_app/models/change_password/change_password_response.dart';
import 'package:employee_app/services/change_password_service.dart';

class ChangePasswordRepository {
  ChangePasswordRepository(this._changePasswordService);

  final ChangePasswordService _changePasswordService;

  Future<ChangePasswordResponse> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      return await _changePasswordService.changePassword(
        ChangePasswordRequest(
          email: email,
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
}
