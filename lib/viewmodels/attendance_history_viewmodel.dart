import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/attendance/work_time_history_model.dart';
import 'package:employee_app/repositories/attendance_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceHistoryViewModel extends GetxController {
  AttendanceHistoryViewModel(this._attendanceRepository);

  final AttendanceRepository _attendanceRepository;

  final RxList<WorkTimeHistoryData> records = <WorkTimeHistoryData>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxnString emptyMessage = RxnString();
  final RxnString errorMessage = RxnString();
  final RxnString dateValidationError = RxnString();

  final Rxn<DateTime> fromDate = Rxn<DateTime>();
  final Rxn<DateTime> toDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    fetchWorkingSummary();
  }

  String _formatApiDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  bool _validateDatesForSearch() {
    dateValidationError.value = null;

    final from = fromDate.value;
    final to = toDate.value;

    if (from == null && to == null) return true;

    if (from != null && to != null && from.isAfter(to)) {
      dateValidationError.value = 'From date cannot be after to date';
      return false;
    }

    return true;
  }

  Future<void> fetchWorkingSummary({bool isRefresh = false}) async {
    if (!_validateDatesForSearch()) return;

    if (isRefresh) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    emptyMessage.value = null;
    errorMessage.value = null;
    records.clear();

    try {
      final from = fromDate.value;
      final to = toDate.value;

      final response = await _attendanceRepository.getWorkingSummary(
        fromDate: from != null ? _formatApiDate(from) : null,
        toDate: to != null ? _formatApiDate(to) : null,
      );
      _applyResponse(response);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (error) {
      errorMessage.value = _resolveErrorMessage(error);
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  void _applyResponse(WorkTimeHistoryModel response) {
    if (!response.status) {
      errorMessage.value = response.message;
      return;
    }

    if (response.data.isNotEmpty) {
      records.assignAll(response.data);
      return;
    }

    emptyMessage.value = response.message;
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException && error.message.trim().isNotEmpty) {
      return error.message;
    }
    if (error is Exception) {
      final message = error.toString();
      if (message.trim().isNotEmpty) return message;
    }
    return error.toString();
  }

  Future<void> search() async {
    await fetchWorkingSummary();
  }

  Future<void> refreshWorkingSummary() async {
    await fetchWorkingSummary(isRefresh: true);
  }

  Future<void> pickFromDate() async {
    final context = Get.context;
    if (context == null) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      fromDate.value = DateTime(picked.year, picked.month, picked.day);
      dateValidationError.value = null;
    }
  }

  Future<void> pickToDate() async {
    final context = Get.context;
    if (context == null) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: toDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      toDate.value = DateTime(picked.year, picked.month, picked.day);
      dateValidationError.value = null;
    }
  }

  String formatDisplayDate(DateTime? date) {
    if (date == null) return 'Select date';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} ${date.year}';
  }

  static String formatHistoryDate(String raw) {
    if (raw.trim().isEmpty) return '';

    final parsed = DateTime.tryParse(raw.trim());
    if (parsed != null) {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${parsed.day.toString().padLeft(2, '0')} '
          '${months[parsed.month - 1]} ${parsed.year}';
    }

    return raw;
  }
}
