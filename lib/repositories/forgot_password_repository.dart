import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/forgot_password/forgot_password_request.dart';
import 'package:employee_app/models/forgot_password/forgot_password_response.dart';
import 'package:employee_app/services/forgot_password_service.dart';

class ForgotPasswordRepository {
  ForgotPasswordRepository(this._forgotPasswordService);

  final ForgotPasswordService _forgotPasswordService;

  Future<ForgotPasswordResponse> forgotPassword({
    required String email,
  }) async {
    try {
      return await _forgotPasswordService.forgotPassword(
        ForgotPasswordRequest(email: email),
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
}
