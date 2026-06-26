import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_empty_state.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_progress_ring.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_stat_card.dart';
import 'package:employee_app/screens/work_tracking/widgets/work_timeline_tile.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkSummaryScreen extends StatelessWidget {
  const WorkSummaryScreen({super.key});

  static const _hasData = true;

  @override
  Widget build(BuildContext context) {
    if (!_hasData) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: _buildAppBar(context),
        body:  Stack(
          children: [
            Positioned.fill(child: AuthBackground()),
            AttendanceEmptyState(
              icon: Icons.summarize_outlined,
              title: 'No Work Summary Available',
              message:
                  'Your work summary will be available once you complete your shift.',
              actionLabel: 'Go to Work Tracking',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDailySummaryCard(),
                  const SizedBox(height: 28),
                  _buildPerformanceMetrics(),
                  const SizedBox(height: 28),
                  _buildAnalytics(),
                  const SizedBox(height: 28),
                  _buildTimeline(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        color: AppColors.black,
      ),
      title: Text(
        'Work Summary',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildDailySummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Summary',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.white.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _SummaryItem(label: 'Hours Worked', value: '08h 45m'),
              _SummaryItem(label: 'Break Time', value: '50m'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _SummaryItem(label: 'Productive Hours', value: '07h 55m'),
              _SummaryItem(label: 'Status', value: 'Present'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Performance',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.55,
          children: const [
            AttendanceStatCard(
              label: 'Total Hours',
              value: '08h 45m',
              icon: Icons.schedule_outlined,
            ),
            AttendanceStatCard(
              label: 'Late Login',
              value: '10 min',
              icon: Icons.warning_amber_outlined,
            ),
            AttendanceStatCard(
              label: 'Early Logout',
              value: 'None',
              icon: Icons.logout_outlined,
            ),
            AttendanceStatCard(
              label: 'Overtime',
              value: '01h 20m',
              icon: Icons.more_time_outlined,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalytics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey300.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work Analytics',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const AttendanceProgressRing(percentage: 88, size: 100),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _AnalyticsRow(label: 'Weekly Hours', value: '42h 30m'),
                    const SizedBox(height: 10),
                    _AnalyticsRow(label: 'Monthly Hours', value: '168h 15m'),
                    const SizedBox(height: 10),
                    _AnalyticsRow(label: 'Attendance', value: '96%'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.88,
              minHeight: 6,
              backgroundColor: AppColors.grey300,
              valueColor: AlwaysStoppedAnimation(AppColors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    const entries = [
      WorkTimelineEntry(
        title: 'Check-In',
        time: '09:00 AM',
        icon: Icons.login_rounded,
      ),
      WorkTimelineEntry(
        title: 'Break Started',
        time: '11:30 AM',
        icon: Icons.free_breakfast_outlined,
      ),
      WorkTimelineEntry(
        title: 'Break Ended',
        time: '11:45 AM',
        icon: Icons.play_arrow_rounded,
      ),
      WorkTimelineEntry(
        title: 'Check-Out',
        time: '06:00 PM',
        icon: Icons.logout_rounded,
        isLast: true,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Timeline",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...entries.map((e) => WorkTimelineTile(entry: e)),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsRow extends StatelessWidget {
  const _AnalyticsRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey700),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
