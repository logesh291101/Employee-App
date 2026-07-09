import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/hierarchy/employee_hierarchy_model.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;

class HierarchyService {
  HierarchyService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 60);

  Future<EmployeeHierarchyModel> getTeamHierarchy() async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }

    final uri = _buildUri(liveUrl, 'Employee-Connect/employeeList/team');

    try {
      final response = await _client
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      return _parseResponse(response);
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

  Uri _buildUri(String liveUrl, String path) {
    final normalized = liveUrl.trim().endsWith('/')
        ? liveUrl.trim()
        : '${liveUrl.trim()}/';
    return Uri.parse('$normalized$path');
  }

  EmployeeHierarchyModel _parseResponse(http.Response response) {
    final body = _decodeBody(response);
    final apiMessage = body['message'] as String?;

    if (response.statusCode == 200) {
      return EmployeeHierarchyModel.fromJson(body);
    }

    throw _httpError(response.statusCode, apiMessage);
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      throw ApiException('Unexpected response from server. Please try again.');
    }
    throw ApiException('Unexpected response from server. Please try again.');
  }

  ApiException _httpError(int statusCode, String? apiMessage) {
    switch (statusCode) {
      case 400:
        return ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Invalid request. Please check your details.',
        );
      case 401:
        return ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Unauthorized. Please check your credentials.',
        );
      case 403:
        return ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Access forbidden. Please contact support.',
        );
      default:
        if (statusCode >= 500) {
          return ApiException(
            apiMessage?.isNotEmpty == true
                ? apiMessage!
                : 'Server error. Please try again later.',
          );
        }
        return ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Failed to fetch hierarchy. Please try again.',
        );
    }
  }
}
