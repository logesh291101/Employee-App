import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/core/utils/app_snackbar.dart';
import 'package:employee_app/repositories/timesheet_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TimesheetEntryItem {
  TimesheetEntryItem();

  final taskNameController = TextEditingController();
  final taskDescController = TextEditingController();
  final RxnString hoursSpent = RxnString();
  final RxnString taskNameError = RxnString();
  final RxnString hoursSpentError = RxnString();
  final RxnString taskDescError = RxnString();

  void clearErrors() {
    taskNameError.value = null;
    hoursSpentError.value = null;
    taskDescError.value = null;
  }

  void dispose() {
    taskNameController.dispose();
    taskDescController.dispose();
  }
}

class AddTimesheetViewModel extends GetxController {
  AddTimesheetViewModel(this._timesheetRepository);

  final TimesheetRepository _timesheetRepository;

  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final RxnString dateError = RxnString();
  final RxList<TimesheetEntryItem> entries = <TimesheetEntryItem>[].obs;
  final RxBool isSubmitting = false.obs;

  static const hoursOptions = [
    '0.5',
    '1.0',
    '1.5',
    '2.0',
    '2.5',
    '3.0',
    '3.5',
    '4.0',
    '4.5',
    '5.0',
    '5.5',
    '6.0',
    '6.5',
    '7.0',
    '7.5',
    '8.0',
    '8.5',
    '9.0',
    '9.5',
    '10.0',
  ];

  @override
  void onInit() {
    super.onInit();
    _resetEntries();
  }

  void addEntry() {
    entries.add(TimesheetEntryItem());
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
    dateError.value = null;
  }

  void onHoursChanged(int index, String? value) {
    if (index < 0 || index >= entries.length) return;
    entries[index].hoursSpent.value = value;
    entries[index].hoursSpentError.value = null;
  }

  void clearTaskNameError(int index, String _) {
    if (index < 0 || index >= entries.length) return;
    entries[index].taskNameError.value = null;
  }

  void clearTaskDescError(int index, String _) {
    if (index < 0 || index >= entries.length) return;
    entries[index].taskDescError.value = null;
  }

  String formatDisplayDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String _formatApiDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  bool _validate() {
    var valid = true;

    if (selectedDate.value == null) {
      dateError.value = 'Please select a date';
      valid = false;
    } else {
      dateError.value = null;
    }

    for (final entry in entries) {
      final taskName = entry.taskNameController.text.trim();
      final taskDesc = entry.taskDescController.text.trim();

      if (taskName.isEmpty) {
        entry.taskNameError.value = 'Task name is required';
        valid = false;
      } else {
        entry.taskNameError.value = null;
      }

      if (entry.hoursSpent.value == null) {
        entry.hoursSpentError.value = 'Please select hours spent';
        valid = false;
      } else {
        entry.hoursSpentError.value = null;
      }

      if (taskDesc.isEmpty) {
        entry.taskDescError.value = 'Task description is required';
        valid = false;
      } else {
        entry.taskDescError.value = null;
      }
    }

    return valid;
  }

  List<Map<String, dynamic>> _buildTimesheetPayload() {
    return entries.map((entry) {
      final hours = double.parse(entry.hoursSpent.value!);
      return {
        'staff_task': entry.taskNameController.text.trim(),
        'task_taken_time': hours,
        'task_desc': entry.taskDescController.text.trim(),
      };
    }).toList();
  }

  void _resetEntries() {
    for (final entry in entries) {
      entry.dispose();
    }
    entries
      ..clear()
      ..add(TimesheetEntryItem());
  }

  void resetForm() {
    selectedDate.value = null;
    dateError.value = null;
    _resetEntries();
  }

  Future<void> submit() async {
    if (!_validate()) {
      HapticFeedback.heavyImpact();
      return;
    }

    if (isSubmitting.value) return;

    HapticFeedback.mediumImpact();
    isSubmitting.value = true;

    try {
      final response = await _timesheetRepository.storeTimesheet(
        taskDate: _formatApiDate(selectedDate.value!),
        timesheetEntries: _buildTimesheetPayload(),
      );

      AppSnackbar.show(
        response.message.isNotEmpty
            ? response.message
            : 'Timesheet submitted successfully.',
      );
      resetForm();
    } on ApiException catch (error) {
      AppSnackbar.show(error.message, isError: true);
    } catch (_) {
      AppSnackbar.show(
        'Something went wrong. Please try again.',
        isError: true,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    for (final entry in entries) {
      entry.dispose();
    }
    super.onClose();
  }
}
