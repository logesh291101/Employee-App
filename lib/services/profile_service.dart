import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/profile/employee_profile_model.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  ProfileService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 60);

  Future<EmployeeProfileModel> getProfileDetails() async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }

    final emNo = await SharedPrefHelper.getEmNo();
    if (emNo.trim().isEmpty) {
      throw ApiException(
        'Employee number not found. Please login again.',
      );
    }

    final uri = _buildUri(liveUrl, emNo);

    try {
      final response = await _client
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
            },
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

  Uri _buildUri(String liveUrl, String emNo) {
    final normalized = liveUrl.trim().endsWith('/')
        ? liveUrl.trim()
        : '${liveUrl.trim()}/';
    return Uri.parse(
      '${normalized}Employee-Connect/profile/getProfileDetails/?emNo=$emNo',
    );
  }

  EmployeeProfileModel _handleResponse(http.Response response) {
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

      final profileResponse = EmployeeProfileModel.fromJson(body);
      if (profileResponse.status == 1) {
        return profileResponse;
      }

      throw ApiException(
        profileResponse.message.isNotEmpty
            ? profileResponse.message
            : 'Failed to fetch profile. Please try again.',
      );
    }

    switch (response.statusCode) {
      case 400:
        throw ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Invalid request. Please try again.',
        );
      case 401:
        throw ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Unauthorized. Please login again.',
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
              : 'Failed to fetch profile. Please try again.',
        );
    }
  }
}
