import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/timesheet/timesheet_history_model.dart';
import 'package:employee_app/repositories/timesheet_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimesheetHistoryViewModel extends GetxController {
  TimesheetHistoryViewModel(this._timesheetRepository);

  final TimesheetRepository _timesheetRepository;

  final RxList<TimeSheetHistoryData> records = <TimeSheetHistoryData>[].obs;
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
    _setDefaultDateRange();
    fetchTimesheetHistory();
  }

  void _setDefaultDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    fromDate.value = today.subtract(const Duration(days: 6));
    toDate.value = today;
  }

  String _formatApiDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  bool _validateDates() {
    dateValidationError.value = null;

    final from = fromDate.value;
    final to = toDate.value;

    if (from == null) {
      dateValidationError.value = 'Please select a from date';
      return false;
    }
    if (to == null) {
      dateValidationError.value = 'Please select a to date';
      return false;
    }
    if (from.isAfter(to)) {
      dateValidationError.value = 'From date cannot be after to date';
      return false;
    }

    return true;
  }

  Future<void> fetchTimesheetHistory({bool isRefresh = false}) async {
    if (!_validateDates()) return;

    if (isRefresh) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    emptyMessage.value = null;
    errorMessage.value = null;
    records.clear();

    try {
      final response = await _timesheetRepository.getTimesheetHistory(
        fromDate: _formatApiDate(fromDate.value!),
        toDate: _formatApiDate(toDate.value!),
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

  void _applyResponse(TimeSheetHistoryModel response) {
    _syncDatesFromResponse(response);

    if (response.status && response.data.isNotEmpty) {
      records.assignAll(response.data);
      return;
    }

    emptyMessage.value = response.message;
  }

  void _syncDatesFromResponse(TimeSheetHistoryModel response) {
    final apiFrom = _parseDate(response.fromDate);
    final apiTo = _parseDate(response.toDate);
    if (apiFrom != null) fromDate.value = apiFrom;
    if (apiTo != null) toDate.value = apiTo;
  }

  DateTime? _parseDate(String raw) {
    if (raw.trim().isEmpty) return null;
    return DateTime.tryParse(raw.trim());
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
    await fetchTimesheetHistory();
  }

  Future<void> refreshTimesheetHistory() async {
    await fetchTimesheetHistory(isRefresh: true);
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

  static String formatTaskDate(String raw) {
    if (raw.trim().isEmpty) return '—';

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

  static String formatHours(String hours) {
    if (hours.trim().isEmpty) return '—';
    final normalized = hours.trim();
    if (normalized.toLowerCase().contains('hour')) return normalized;
    return '$normalized Hours';
  }
}
