import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_empty_state.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_stat_card.dart';
import 'package:employee_app/screens/work_tracking/widgets/work_timeline_tile.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BreakManagementScreen extends StatefulWidget {
  const BreakManagementScreen({super.key});

  @override
  State<BreakManagementScreen> createState() => _BreakManagementScreenState();
}

class _BreakManagementScreenState extends State<BreakManagementScreen> {
  bool _isOnBreak = false;
  bool _isLoading = false;
  String _breakStart = '--';
  String _breakEnd = '--';
  String _currentBreakDuration = '00m';

  final List<Map<String, String>> _breakHistory = [
    {
      'start': '11:30 AM',
      'end': '11:45 AM',
      'duration': '15m',
    },
    {
      'start': '01:15 PM',
      'end': '01:35 PM',
      'duration': '20m',
    },
    {
      'start': '04:00 PM',
      'end': '04:15 PM',
      'duration': '15m',
    },
  ];

  Future<void> _onBreakAction() async {
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (_isOnBreak) {
        _isOnBreak = false;
        _breakEnd = '05:10 PM';
        _currentBreakDuration = '15m';
        _breakHistory.insert(0, {
          'start': _breakStart,
          'end': _breakEnd,
          'duration': _currentBreakDuration,
        });
      } else {
        _isOnBreak = true;
        _breakStart = '05:10 PM';
        _breakEnd = '--';
        _currentBreakDuration = 'In Progress';
      }
    });

    showAuthSnackBar(
      context,
      _isOnBreak ? 'Break started' : 'Break ended',
    );
  }

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
          'Break Management',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 20),
                  GradientButton(
                    label: _isOnBreak ? 'End Break' : 'Start Break',
                    isLoading: _isLoading,
                    onPressed: _onBreakAction,
                  ),
                  const SizedBox(height: 28),
                  _buildStatistics(),
                  const SizedBox(height: 28),
                  _buildBreakHistory(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isOnBreak ? AppColors.black : AppColors.grey300,
          width: _isOnBreak ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _isOnBreak ? AppColors.black : AppColors.grey500,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _isOnBreak ? 'On Break' : 'Not On Break',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _BreakDetail(label: 'Break Start', value: _breakStart),
              ),
              Expanded(
                child: _BreakDetail(label: 'Break End', value: _breakEnd),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.timelapse, size: 18, color: AppColors.grey700),
                const SizedBox(width: 8),
                Text(
                  'Current Break Duration',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.grey700,
                  ),
                ),
                const Spacer(),
                Text(
                  _currentBreakDuration,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      children: const [
        Expanded(
          child: AttendanceStatCard(
            label: 'Total Break Today',
            value: '50m',
            icon: Icons.timer_outlined,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: AttendanceStatCard(
            label: 'Breaks Taken',
            value: '3',
            icon: Icons.repeat_rounded,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: AttendanceStatCard(
            label: 'Avg Duration',
            value: '17m',
            icon: Icons.av_timer_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakHistory() {
    if (_breakHistory.isEmpty) {
      return const AttendanceEmptyState(
        icon: Icons.free_breakfast_outlined,
        title: 'No Break Records',
        message: 'Your break history for today will appear here.',
        actionLabel: 'Start Break',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Break History",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        ..._breakHistory.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == _breakHistory.length - 1;
          return WorkTimelineTile(
            entry: WorkTimelineEntry(
              title: '${item['start']} – ${item['end']} (${item['duration']})',
              time: item['duration']!,
              icon: Icons.free_breakfast_outlined,
              isLast: isLast,
            ),
          );
        }),
      ],
    );
  }
}

class _BreakDetail extends StatelessWidget {
  const _BreakDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: AppColors.grey500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
