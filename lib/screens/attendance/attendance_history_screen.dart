import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_empty_state.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_record_card.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_status_badge.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  String _selectedMonth = 'June 2026';
  String _statusFilter = 'All';
  bool _showEmptyResults = false;

  final _allRecords = const [
    AttendanceRecordData(
      date: '08 June 2026',
      day: 'Monday',
      checkIn: '09:05 AM',
      checkOut: '06:15 PM',
      workingHours: '09:10',
      status: AttendanceDayStatus.present,
    ),
    AttendanceRecordData(
      date: '07 June 2026',
      day: 'Sunday',
      checkIn: '--',
      checkOut: '--',
      workingHours: '--',
      status: AttendanceDayStatus.weekOff,
    ),
    AttendanceRecordData(
      date: '06 June 2026',
      day: 'Saturday',
      checkIn: '--',
      checkOut: '--',
      workingHours: '--',
      status: AttendanceDayStatus.weekOff,
    ),
    AttendanceRecordData(
      date: '05 June 2026',
      day: 'Friday',
      checkIn: '09:30 AM',
      checkOut: '01:30 PM',
      workingHours: '04:00',
      status: AttendanceDayStatus.halfDay,
    ),
    AttendanceRecordData(
      date: '04 June 2026',
      day: 'Thursday',
      checkIn: '09:02 AM',
      checkOut: '06:10 PM',
      workingHours: '09:08',
      status: AttendanceDayStatus.present,
    ),
    AttendanceRecordData(
      date: '03 June 2026',
      day: 'Wednesday',
      checkIn: '--',
      checkOut: '--',
      workingHours: '--',
      status: AttendanceDayStatus.holiday,
    ),
    AttendanceRecordData(
      date: '02 June 2026',
      day: 'Tuesday',
      checkIn: '--',
      checkOut: '--',
      workingHours: '--',
      status: AttendanceDayStatus.absent,
    ),
  ];

  List<AttendanceRecordData> get _filteredRecords {
    if (_showEmptyResults) return [];
    if (_statusFilter == 'All') return _allRecords;
    return _allRecords.where((r) {
      switch (_statusFilter) {
        case 'Present':
          return r.status == AttendanceDayStatus.present;
        case 'Absent':
          return r.status == AttendanceDayStatus.absent;
        case 'Half Day':
          return r.status == AttendanceDayStatus.halfDay;
        case 'Holiday':
          return r.status == AttendanceDayStatus.holiday;
        default:
          return true;
      }
    }).toList();
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
      initialDateRange: DateTimeRange(
        start: DateTime(2026, 6, 1),
        end: DateTime(2026, 6, 8),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.black,
              onPrimary: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (range != null && mounted) {
      HapticFeedback.selectionClick();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Date range: ${range.start.day}/${range.start.month} – '
            '${range.end.day}/${range.end.month}',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.black,
        ),
        title: Text(
          'Attendance History',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: Column(
              children: [
                _buildFilters(),
                Expanded(
                  child: records.isEmpty
                      ? AttendanceEmptyState(
                          icon: Icons.search_off_outlined,
                          title: _showEmptyResults
                              ? 'No Search Results'
                              : 'No Attendance Records',
                          message: _showEmptyResults
                              ? 'Try adjusting your filters to find records.'
                              : 'Your attendance history will appear here.',
                          actionLabel: 'Clear Filters',
                          onAction: () => setState(() {
                            _statusFilter = 'All';
                            _showEmptyResults = false;
                          }),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: records.length,
                          itemBuilder: (_, index) {
                            return AttendanceRecordCard(record: records[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    const filters = ['All', 'Present', 'Absent', 'Half Day', 'Holiday'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _FilterCard(
                  icon: Icons.date_range_outlined,
                  label: 'Date Range',
                  value: '01 Jun – 08 Jun 2026',
                  onTap: _pickDateRange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FilterCard(
                  icon: Icons.calendar_month_outlined,
                  label: 'Month',
                  value: _selectedMonth,
                  onTap: () async {
                    final months = [
                      'April 2026',
                      'May 2026',
                      'June 2026',
                      'July 2026',
                    ];
                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: AppColors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: months
                                .map(
                                  (m) => ListTile(
                                    title: Text(m),
                                    trailing: m == _selectedMonth
                                        ? const Icon(Icons.check,
                                            color: AppColors.black)
                                        : null,
                                    onTap: () => Navigator.pop(context, m),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    );
                    if (selected != null) {
                      setState(() => _selectedMonth = selected);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((filter) {
                final isSelected = _statusFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _statusFilter = filter;
                        _showEmptyResults = filter == 'Absent' && false;
                      });
                    },
                    selectedColor: AppColors.black,
                    checkmarkColor: AppColors.white,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.white : AppColors.grey900,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.black : AppColors.grey300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.grey300),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.grey700),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.grey500,
                      ),
                    ),
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
