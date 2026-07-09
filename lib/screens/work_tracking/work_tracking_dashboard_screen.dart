import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_progress_ring.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_stat_card.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/screens/work_tracking/widgets/work_timeline_tile.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkTrackingDashboardScreen extends StatefulWidget {
  const WorkTrackingDashboardScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<WorkTrackingDashboardScreen> createState() =>
      _WorkTrackingDashboardScreenState();
}

class _WorkTrackingDashboardScreenState
    extends State<WorkTrackingDashboardScreen> {
  bool _isRefreshing = false;
  bool _showEarlyLogout = true;

  String _loginTime = '09:00 AM';
  String _logoutTime = '--';
  String _currentStatus = 'Working';
  String _workingDuration = '07h 15m';
  String _totalBreakDuration = '30m';
  String _productiveHours = '06h 45m';
  String _remainingHours = '45m';

  static const _requiredLogout = '06:00 PM';
  static const _actualLogout = '04:45 PM';
  static const _earlyLogoutDuration = '1h 15m';

  static const _timeline = [
    WorkTimelineEntry(
      title: 'Check-In',
      time: '09:00 AM',
      icon: Icons.login_rounded,
    ),
    WorkTimelineEntry(
      title: 'Break Started',
      time: '11:00 AM',
      icon: Icons.free_breakfast_outlined,
    ),
    WorkTimelineEntry(
      title: 'Break Ended',
      time: '11:15 AM',
      icon: Icons.play_arrow_rounded,
    ),
    WorkTimelineEntry(
      title: 'Break Started',
      time: '01:30 PM',
      icon: Icons.free_breakfast_outlined,
    ),
    WorkTimelineEntry(
      title: 'Break Ended',
      time: '01:45 PM',
      icon: Icons.play_arrow_rounded,
    ),
    WorkTimelineEntry(
      title: 'Check-Out',
      time: '04:45 PM',
      icon: Icons.logout_rounded,
      isLast: true,
    ),
  ];

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isRefreshing = false);
    showAuthSnackBar(context, 'Work tracking data refreshed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        title: 'Work Tracking',
        showBackButton: widget.showBackButton,
        onSettingsTap: () {},
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          if (_isRefreshing)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x66FFFFFF),
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(
            top: false,
            child: RefreshIndicator(
              color: AppColors.black,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTodaySummaryCard(),
                    const SizedBox(height: 20),
                    _buildWorkDurationCard(),
                    if (_showEarlyLogout) ...[
                      const SizedBox(height: 20),
                      _buildEarlyLogoutCard(),
                    ],
                    const SizedBox(height: 28),
                    _buildTimelineSection(),
                    const SizedBox(height: 28),
                    _buildWeeklySummary(),
                    const SizedBox(height: 28),
                    _buildMonthlySummary(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Text(
                "Today's Summary",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.white.withOpacity(0.85),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _currentStatus,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SummaryRow(label: 'Login Time', value: _loginTime),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Current Working Duration',
            value: _workingDuration,
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Total Break Duration',
            value: _totalBreakDuration,
          ),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Logout Time', value: _logoutTime),
        ],
      ),
    );
  }

  Widget _buildWorkDurationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work Duration Tracking',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const AttendanceProgressRing(percentage: 87, size: 100),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _MetricRow(
                      label: 'Work Duration',
                      value: _workingDuration,
                    ),
                    const SizedBox(height: 10),
                    _MetricRow(
                      label: 'Productive Hours',
                      value: _productiveHours,
                    ),
                    const SizedBox(height: 10),
                    _MetricRow(
                      label: 'Remaining Time',
                      value: _remainingHours,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarlyLogoutCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFF57C00),
              ),
              const SizedBox(width: 8),
              Text(
                'Early Logout Detected',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE65100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _MetricRow(label: 'Required Logout', value: _requiredLogout),
          const SizedBox(height: 8),
          _MetricRow(label: 'Actual Logout', value: _actualLogout),
          const SizedBox(height: 8),
          _MetricRow(label: 'Early Logout', value: _earlyLogoutDuration),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Activity Timeline',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 14),
        ..._timeline.map((e) => WorkTimelineTile(entry: e)),
      ],
    );
  }

  Widget _buildWeeklySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Work Summary',
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
              label: 'Total Working Hours',
              value: '38h 30m',
              icon: Icons.calendar_view_week_rounded,
            ),
            AttendanceStatCard(
              label: 'Average Daily Hours',
              value: '7h 42m',
              icon: Icons.trending_up_rounded,
            ),
            AttendanceStatCard(
              label: 'Total Break Hours',
              value: '3h 15m',
              icon: Icons.free_breakfast_outlined,
            ),
            AttendanceStatCard(
              label: 'Early Logout Count',
              value: '2',
              icon: Icons.logout_outlined,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthlySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Work Summary',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.82,
          children: const [
            AttendanceStatCard(
              label: 'Working Days',
              value: '22',
              icon: Icons.work_outline,
            ),
            AttendanceStatCard(
              label: 'Present Days',
              value: '20',
              icon: Icons.check_circle_outline,
            ),
            AttendanceStatCard(
              label: 'Absent Days',
              value: '2',
              icon: Icons.cancel_outlined,
            ),
            AttendanceStatCard(
              label: 'Avg Working Hours',
              value: '7h 45m',
              icon: Icons.access_time_outlined,
            ),
            AttendanceStatCard(
              label: 'Total Break Hours',
              value: '12h 30m',
              icon: Icons.coffee_outlined,
            ),
            AttendanceStatCard(
              label: 'Early Logouts',
              value: '3',
              icon: Icons.timer_off_outlined,
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
