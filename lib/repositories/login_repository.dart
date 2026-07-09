import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/login/login_request.dart';
import 'package:employee_app/models/login/login_response.dart';
import 'package:employee_app/services/login_service.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';

class LoginRepository {
  LoginRepository(this._loginService);

  final LoginService _loginService;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _loginService.login(
        LoginRequest(email: email, password: password),
      );

      final employeeData = response.data;
      if (employeeData != null) {
        await SharedPrefHelper.saveEmployeeDetails(employeeData);
      }

      return response;
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
}
