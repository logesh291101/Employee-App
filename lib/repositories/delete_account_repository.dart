import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/delete_account/delete_account_request.dart';
import 'package:employee_app/models/delete_account/delete_account_response.dart';
import 'package:employee_app/services/delete_account_service.dart';

class DeleteAccountRepository {
  DeleteAccountRepository(this._deleteAccountService);

  final DeleteAccountService _deleteAccountService;

  Future<DeleteAccountResponse> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      return await _deleteAccountService.deleteAccount(
        DeleteAccountRequest(email: email, password: password),
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
}
