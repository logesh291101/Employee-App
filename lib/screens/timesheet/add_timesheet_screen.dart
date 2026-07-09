import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/viewmodels/add_timesheet_viewmodel.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTimesheetScreen extends GetView<AddTimesheetViewModel> {
  const AddTimesheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.black,
        ),
        title: Text(
          'Add Timesheet',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildDatePicker(context),
                          const SizedBox(height: 24),
                          ...List.generate(controller.entries.length, (index) {
                            final entry = controller.entries[index];
                            final showHeader = controller.entries.length > 1;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == controller.entries.length - 1
                                    ? 0
                                    : 24,
                              ),
                              child: _TaskEntrySection(
                                index: index,
                                entry: entry,
                                showHeader: showHeader,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      onPressed: controller.addEntry,
                      backgroundColor: AppColors.black,
                      foregroundColor: AppColors.white,
                      elevation: 4,
                      tooltip: 'Add another task',
                      child: const Icon(Icons.add_rounded),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Obx(
                    () => GradientButton(
                      label: 'Submit',
                      isLoading: controller.isSubmitting.value,
                      onPressed: controller.isSubmitting.value
                          ? null
                          : controller.submit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Obx(() {
      final selectedDate = controller.selectedDate.value;
      final dateError = controller.dateError.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date *',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _pickDate(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: dateError != null
                      ? AppColors.error
                      : AppColors.grey300,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? controller.formatDisplayDate(selectedDate)
                          : 'Select date',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: selectedDate != null
                            ? AppColors.black
                            : AppColors.grey500,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.grey500,
                  ),
                ],
              ),
            ),
          ),
          if (dateError != null) ...[
            const SizedBox(height: 6),
            Text(
              dateError,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
            ),
          ],
        ],
      );
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.black,
            onPrimary: AppColors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.onDateSelected(picked);
    }
  }
}

class _TaskEntrySection extends GetView<AddTimesheetViewModel> {
  const _TaskEntrySection({
    required this.index,
    required this.entry,
    required this.showHeader,
  });

  final int index;
  final TimesheetEntryItem entry;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeader) ...[
            Text(
              'Task ${index + 1}',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.grey700,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Obx(
            () => _buildTextField(
              label: 'Task Name *',
              controller: entry.taskNameController,
              hint: 'Enter task name',
              errorText: entry.taskNameError.value,
              onChanged: (value) => controller.clearTaskNameError(index, value),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => _buildHoursDropdown(
              value: entry.hoursSpent.value,
              errorText: entry.hoursSpentError.value,
              onChanged: (value) => controller.onHoursChanged(index, value),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => _buildTextField(
              label: 'Task Description *',
              controller: entry.taskDescController,
              hint: 'Describe the work completed...',
              maxLines: 6,
              errorText: entry.taskDescError.value,
              onChanged: (value) => controller.clearTaskDescError(index, value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
    String? errorText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.grey900,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          minLines: maxLines > 1 ? maxLines : 1,
          onChanged: onChanged,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            alignLabelWithHint: maxLines > 1,
            errorText: errorText,
            contentPadding: EdgeInsets.all(maxLines > 1 ? 16 : 14),
          ),
        ),
      ],
    );
  }

  Widget _buildHoursDropdown({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hours Spent *',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.grey900,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null ? AppColors.error : AppColors.grey300,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(
                'Select hours',
                style: GoogleFonts.inter(color: AppColors.grey500),
              ),
              items: AddTimesheetViewModel.hoursOptions
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: GoogleFonts.inter()),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
          ),
        ],
      ],
    );
  }
}
