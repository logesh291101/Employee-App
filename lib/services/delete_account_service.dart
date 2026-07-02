import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/delete_account/delete_account_request.dart';
import 'package:employee_app/models/delete_account/delete_account_response.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;

class DeleteAccountService {
  DeleteAccountService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 60);

  Future<DeleteAccountResponse> deleteAccount(
    DeleteAccountRequest request,
  ) async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }

    final uri = _buildUri(liveUrl);

    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on ApiException {
      rethrow;
    } on FormatException {
      throw ApiException('Unexpected response from server. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Uri _buildUri(String liveUrl) {
    final normalized = liveUrl.trim().endsWith('/')
        ? liveUrl.trim()
        : '${liveUrl.trim()}/';
    return Uri.parse('${normalized}Employee-Connect/profile/deleteaccount');
  }

  DeleteAccountResponse _handleResponse(http.Response response) {
    Map<String, dynamic>? body;

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        body = decoded;
      }
    } catch (_) {
      throw ApiException('Unexpected response from server. Please try again.');
    }

    final apiMessage = body?['message'] as String?;

    if (response.statusCode == 200) {
      if (body == null) {
        throw ApiException('Unexpected response from server. Please try again.');
      }

      final apiResponse = DeleteAccountResponse.fromJson(body);
      if (apiResponse.status == 1) {
        return apiResponse;
      }

      throw ApiException(
        apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Failed to delete account. Please try again.',
      );
    }

    switch (response.statusCode) {
      case 400:
        throw ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Invalid request. Please check your details.',
        );
      case 401:
        throw ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Unauthorized. Please check your credentials.',
        );
      case 403:
        throw ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Access forbidden. Please contact support.',
        );
      default:
        if (response.statusCode >= 500) {
          throw ApiException(
            apiMessage?.isNotEmpty == true
                ? apiMessage!
                : 'Server error. Please try again later.',
          );
        }
        throw ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Failed to delete account. Please try again.',
        );
    }
  }
}
