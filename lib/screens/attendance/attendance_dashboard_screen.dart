import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/attendance/attendance_correction_request_screen.dart';
import 'package:employee_app/screens/attendance/attendance_history_screen.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_record_card.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_status_badge.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceDashboardScreen extends StatefulWidget {
  const AttendanceDashboardScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<AttendanceDashboardScreen> createState() =>
      _AttendanceDashboardScreenState();
}

class _AttendanceDashboardScreenState extends State<AttendanceDashboardScreen> {
  bool _isRefreshing = false;
  bool _isActionLoading = false;
  bool _isCheckedIn = false;
  bool _isInsideGeofence = true;

  String? _checkInTime;
  String? _checkOutTime;

  static const _officeName = 'Veda Group – Chennai HQ';
  static const _loginReminder = '09:00 AM';
  static const _logoutReminder = '06:00 PM';

  static const _recentHistory = [
    AttendanceRecordData(
      date: '02 June 2026',
      day: 'Tuesday',
      checkIn: '09:02 AM',
      checkOut: '06:08 PM',
      workingHours: '09h 06m',
      status: AttendanceDayStatus.present,
    ),
    AttendanceRecordData(
      date: '01 June 2026',
      day: 'Monday',
      checkIn: '09:15 AM',
      checkOut: '06:00 PM',
      workingHours: '08h 45m',
      status: AttendanceDayStatus.present,
    ),
    AttendanceRecordData(
      date: '31 May 2026',
      day: 'Sunday',
      checkIn: '--',
      checkOut: '--',
      workingHours: '--',
      status: AttendanceDayStatus.weekOff,
    ),
  ];

  String get _currentStatus =>
      _isCheckedIn ? 'Checked In' : 'Checked Out';

  String get _totalHours {
    if (_checkInTime == null) return '--';
    if (_isCheckedIn) return 'In Progress';
    return '08h 30m';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isRefreshing = false);
    showAuthSnackBar(context, 'Attendance data refreshed');
  }

  Future<void> _onCheckIn() async {
    if (_isCheckedIn) return;

    if (!_isInsideGeofence) {
      HapticFeedback.heavyImpact();
      showAuthSnackBar(
        context,
        'You are outside the office premises. Check-In is not allowed.',
      );
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isActionLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    setState(() {
      _isActionLoading = false;
      _isCheckedIn = true;
      _checkInTime = _formatTime(DateTime.now());
      _checkOutTime = null;
    });
    showAuthSnackBar(context, 'Checked in successfully');
  }

  Future<void> _onCheckOut() async {
    if (!_isCheckedIn) return;

    HapticFeedback.mediumImpact();
    setState(() => _isActionLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    setState(() {
      _isActionLoading = false;
      _isCheckedIn = false;
      _checkOutTime = _formatTime(DateTime.now());
    });
    showAuthSnackBar(context, 'Checked out successfully');
  }

  void _toggleGeofenceDemo() {
    setState(() => _isInsideGeofence = !_isInsideGeofence);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        title: 'Attendance',
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
                    _buildStatusCard(),
                    const SizedBox(height: 16),
                    _buildGeofenceCard(),
                    const SizedBox(height: 16),
                    _buildCheckActions(),
                    const SizedBox(height: 28),
                    _buildRemindersSection(),
                    const SizedBox(height: 28),
                    _buildHistorySection(),
                    const SizedBox(height: 20),
                    GradientButton(
                      label: 'Request Attendance Correction',
                      height: 52,
                      onPressed: () => Navigator.of(context).push(
                        authPageRoute(
                          const AttendanceCorrectionRequestScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
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
                "Today's Attendance",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
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
          Row(
            children: [
              _StatusDetail(
                label: 'Check-In Time',
                value: _checkInTime ?? '--',
              ),
              const SizedBox(width: 20),
              _StatusDetail(
                label: 'Check-Out Time',
                value: _checkOutTime ?? '--',
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Total Hours: $_totalHours',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeofenceCard() {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _toggleGeofenceDemo,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isInsideGeofence
                  ? const Color(0xFF2E7D32)
                  : AppColors.error,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _isInsideGeofence
                      ? const Color(0xFFE8F5E9)
                      : AppColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _isInsideGeofence
                      ? Icons.location_on_rounded
                      : Icons.location_off_rounded,
                  color: _isInsideGeofence
                      ? const Color(0xFF2E7D32)
                      : AppColors.error,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isInsideGeofence
                          ? 'Inside Office Geofence'
                          : 'Outside Office Geofence',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _officeName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                _isInsideGeofence
                    ? Icons.verified_outlined
                    : Icons.warning_amber_rounded,
                color: _isInsideGeofence
                    ? const Color(0xFF2E7D32)
                    : AppColors.error,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckActions() {
    return Row(
      children: [
        Expanded(
          child: GradientButton(
            label: 'Check In',
            height: 52,
            isLoading: _isActionLoading && !_isCheckedIn,
            onPressed: _isCheckedIn || _isActionLoading ? null : _onCheckIn,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: !_isCheckedIn || _isActionLoading ? null : _onCheckOut,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: AppColors.black,
              side: const BorderSide(color: AppColors.black, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: _isActionLoading && _isCheckedIn
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.black,
                    ),
                  )
                : Text(
                    'Check Out',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemindersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Auto Login / Logout Reminders'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ReminderCard(
                icon: Icons.login_rounded,
                label: 'Login Reminder',
                time: _loginReminder,
                message: 'Reminder set for office login',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ReminderCard(
                icon: Icons.logout_rounded,
                label: 'Logout Reminder',
                time: _logoutReminder,
                message: 'Reminder set for office logout',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _SectionTitle(title: 'Attendance History')),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                authPageRoute(const AttendanceHistoryScreen()),
              ),
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._recentHistory.map(
          (record) => AttendanceRecordCard(record: record),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
    );
  }
}

class _StatusDetail extends StatelessWidget {
  const _StatusDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.icon,
    required this.label,
    required this.time,
    required this.message,
  });

  final IconData icon;
  final String label;
  final String time;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.black),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.grey700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
