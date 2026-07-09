import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/models/timesheet/timesheet_history_model.dart';
import 'package:employee_app/screens/timesheet/widgets/timesheet_history_shimmer.dart';
import 'package:employee_app/viewmodels/timesheet_history_viewmodel.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TimesheetHistoryScreen extends GetView<TimesheetHistoryViewModel> {
  const TimesheetHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.black,
        ),
        title: Text(
          'Timesheet History',
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FilterSection(),
                Expanded(child: _HistoryContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends GetView<TimesheetHistoryViewModel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey300),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _DateFilterField(
                      label: 'From Date',
                      value: controller.formatDisplayDate(
                        controller.fromDate.value,
                      ),
                      onTap: controller.pickFromDate,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => _DateFilterField(
                      label: 'To Date',
                      value: controller.formatDisplayDate(
                        controller.toDate.value,
                      ),
                      onTap: controller.pickToDate,
                    ),
                  ),
                ),
              ],
            ),
            Obx(() {
              final error = controller.dateValidationError.value;
              if (error == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  error,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.error,
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            Obx(
              () => SizedBox(
                height: 44,
                child: FilledButton(
                  onPressed: controller.isLoading.value ||
                          controller.isRefreshing.value
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          controller.search();
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Search',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateFilterField extends StatelessWidget {
  const _DateFilterField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.grey500,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.grey500,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryContent extends GetView<TimesheetHistoryViewModel> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value || controller.isRefreshing.value) {
        return const TimesheetHistoryShimmer();
      }

      if (controller.errorMessage.value != null) {
        return _MessageState(
          message: controller.errorMessage.value!,
          icon: Icons.error_outline_rounded,
          actionLabel: 'Retry',
          onAction: controller.fetchTimesheetHistory,
        );
      }

      if (controller.records.isEmpty) {
        final message = controller.emptyMessage.value;
        if (message != null && message.trim().isNotEmpty) {
          return _MessageState(message: message);
        }
      }

      return RefreshIndicator(
        onRefresh: controller.refreshTimesheetHistory,
        color: AppColors.black,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          itemCount: controller.records.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _TimesheetRecordCard(record: controller.records[index]);
          },
        ),
      );
    });
  }
}

class _TimesheetRecordCard extends StatelessWidget {
  const _TimesheetRecordCard({required this.record});

  final TimeSheetHistoryData record;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardField(
            label: 'Task Date',
            value: TimesheetHistoryViewModel.formatTaskDate(record.taskDate),
          ),
          const SizedBox(height: 14),
          _CardField(label: 'Task', value: record.staffTask),
          const SizedBox(height: 14),
          _CardField(
            label: 'Hours Spent',
            value: TimesheetHistoryViewModel.formatHours(record.taskTakenTime),
          ),
          const SizedBox(height: 14),
          _CardField(
            label: 'Task Description',
            value: record.taskDesc,
            multiline: true,
          ),
        ],
      ),
    );
  }
}

class _CardField extends StatelessWidget {
  const _CardField({
    required this.label,
    required this.value,
    this.multiline = false,
  });

  final String label;
  final String value;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.grey500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isNotEmpty ? value : '—',
          style: GoogleFonts.inter(
            fontSize: multiline ? 14 : 15,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            height: multiline ? 1.45 : 1.2,
          ),
        ),
      ],
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.message,
    this.icon = Icons.history_rounded,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.grey500),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.grey700,
                height: 1.45,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: onAction,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.black,
                  side: const BorderSide(color: AppColors.black),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
