import 'package:employee_app/bindings/attendance_history_binding.dart';
import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/attendance/attendance_history_screen.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_summary_metrics_card.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/viewmodels/attendance_dashboard_viewmodel.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceDashboardScreen extends GetView<AttendanceDashboardViewModel> {
  const AttendanceDashboardScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        title: 'Attendance',
        showBackButton: showBackButton,
        onSettingsTap: () {},
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // GradientButton(
                  //   label: 'Request Attendance Correction',
                  //   height: 52,
                  //   onPressed: () => Navigator.of(context).push(
                  //     authPageRoute(
                  //       const AttendanceCorrectionRequestScreen(),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  _buildAttendanceCard(context),
                  const SizedBox(height: 16),
                  _buildBreakTrackingCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context) {
    return _FeatureCard(
      title: 'Attendance',
      icon: Icons.fingerprint_rounded,
      summary: Obx(
        () => AttendanceSummaryMetricsCard(
          columns: [
            SummaryMetricColumn(
              label: 'Check In',
              value: controller.checkInTime.value,
            ),
            SummaryMetricColumn(
              label: 'Total Hours',
              value: controller.totalWorkHours.value,
            ),
            SummaryMetricColumn(
              label: 'Check Out',
              value: controller.checkOutTime.value,
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() {
            final isLoading = controller.isActionLoading;

            return Row(
              children: [
                Expanded(
                  child: GradientButton(
                    label: 'Check In',
                    height: 48,
                    isLoading:
                        controller.isLoading(AttendanceActionType.checkIn),
                    onPressed: isLoading ? null : controller.checkIn,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _OutlinedActionButton(
                    label: 'Check Out',
                    height: 48,
                    isLoading:
                        controller.isLoading(AttendanceActionType.checkOut),
                    onPressed: isLoading ? null : controller.checkOut,
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _ViewHistoryButton(
              onPressed: _openAttendanceHistory,
            ),
          ),
        ],
      ),
    );
  }

  void _openAttendanceHistory() {
    Get.to(
      () => const AttendanceHistoryScreen(),
      binding: AttendanceHistoryBinding(),
    );
  }

  Widget _buildBreakTrackingCard(BuildContext context) {
    return _FeatureCard(
      title: 'Break Tracking',
      icon: Icons.free_breakfast_outlined,
      summary: Obx(() {
        if (controller.breaks.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < controller.breaks.length; i++) ...[
              if (controller.breaks.length > 1) ...[
                Text(
                  'Break ${i + 1}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey700,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              AttendanceSummaryMetricsCard(
                columns: [
                  SummaryMetricColumn(
                    label: 'Start Time',
                    value: controller.breaks[i].startTime,
                  ),
                  SummaryMetricColumn(
                    label: 'Duration',
                    value: controller.breaks[i].duration,
                  ),
                  SummaryMetricColumn(
                    label: 'End Time',
                    value: controller.breaks[i].endTime,
                  ),
                ],
              ),
              if (i < controller.breaks.length - 1) const SizedBox(height: 12),
            ],
          ],
        );
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() {
            final isLoading = controller.isActionLoading;

            return Row(
              children: [
                Expanded(
                  child: GradientButton(
                    label: 'Start Break',
                    height: 48,
                    isLoading:
                        controller.isLoading(AttendanceActionType.startBreak),
                    onPressed: isLoading ? null : controller.startBreak,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _OutlinedActionButton(
                    label: 'End Break',
                    height: 48,
                    isLoading:
                        controller.isLoading(AttendanceActionType.endBreak),
                    onPressed: isLoading ? null : controller.endBreak,
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _ViewHistoryButton(
              onPressed: _openAttendanceHistory,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.summary,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget summary;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Icon(icon, size: 20, color: AppColors.black),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.grey300),
            const SizedBox(height: 16),
            summary,
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class _ViewHistoryButton extends StatelessWidget {
  const _ViewHistoryButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.black,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'View History',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_rounded, size: 16),
        ],
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size.fromHeight(height),
        foregroundColor: AppColors.black,
        side: const BorderSide(color: AppColors.black, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.black,
              ),
            )
          : Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
