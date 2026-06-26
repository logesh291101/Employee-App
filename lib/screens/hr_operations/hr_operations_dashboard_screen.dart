import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_stat_card.dart';
import 'package:employee_app/screens/hr_operations/hr_document_screen.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HrOperationsDashboardScreen extends StatefulWidget {
  const HrOperationsDashboardScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<HrOperationsDashboardScreen> createState() =>
      _HrOperationsDashboardScreenState();
}

class _HrOperationsDashboardScreenState
    extends State<HrOperationsDashboardScreen> {
  bool _isRefreshing = false;
  bool _isSubmittingRegularization = false;

  DateTime _calendarMonth = DateTime(2026, 6);
  DateTime? _regularizationDate;
  String? _attendanceIssue;
  final _regularizationReasonController = TextEditingController();

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static const _holidays = {
  '2026-6-15': 'Company Holiday',
  '2026-6-26': 'Public Holiday',
  '2026-7-4': 'Public Holiday',
  };

  static const _issueTypes = [
    'Missed Check-In',
    'Missed Check-Out',
    'Incorrect Hours',
    'Wrong Status',
  ];

  final List<Map<String, String>> _regularizationHistory = [
    {
      'date': '28 May 2026',
      'issue': 'Missed Check-In',
      'status': 'Approved',
    },
    {
      'date': '12 May 2026',
      'issue': 'Incorrect Hours',
      'status': 'Pending',
    },
  ];

  static const _announcements = [
    {
      'title': 'Annual Performance Review Cycle',
      'description':
          'The annual performance review cycle begins next week. Please complete your self-assessment by 15 June.',
      'date': '03 Jun 2026',
      'priority': 'High',
    },
    {
      'title': 'Updated Leave Policy',
      'description':
          'The leave policy has been updated effective 1 June. Review the document in Policy & Documents.',
      'date': '01 Jun 2026',
      'priority': 'Medium',
    },
    {
      'title': 'Team Building Event',
      'description':
          'Join us for the quarterly team building event on 20 June at Chennai HQ.',
      'date': '28 May 2026',
      'priority': 'Low',
    },
  ];

  static const _documents = [
    {
      'title': 'Employee Handbook',
      'description':
          'Comprehensive guide covering company policies, benefits, and employee expectations.',
      'icon': Icons.menu_book_outlined,
    },
    {
      'title': 'Leave Policy',
      'description':
          'Details on leave types, eligibility, application process, and approval workflow.',
      'icon': Icons.event_note_outlined,
    },
    {
      'title': 'Work From Home Policy',
      'description':
          'Guidelines for remote work eligibility, request process, and expectations.',
      'icon': Icons.home_work_outlined,
    },
    {
      'title': 'Code of Conduct',
      'description':
          'Standards of professional behavior and ethical guidelines for all employees.',
      'icon': Icons.gavel_outlined,
    },
    {
      'title': 'HR Guidelines',
      'description':
          'HR procedures, grievance handling, and employee support resources.',
      'icon': Icons.support_agent_outlined,
    },
  ];

  @override
  void dispose() {
    _regularizationReasonController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]} ${date.year}';
  }

  String _holidayKey(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';

  List<Map<String, String>> get _upcomingHolidays {
    return [
      {'date': '15 June 2026', 'name': 'Company Holiday', 'type': 'Company'},
      {'date': '26 June 2026', 'name': 'Independence Day Obs.', 'type': 'Public'},
      {'date': '04 July 2026', 'name': 'Public Holiday', 'type': 'Public'},
    ];
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _isRefreshing = false);
    showAuthSnackBar(context, 'HR data refreshed');
  }

  void _changeMonth(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _calendarMonth = DateTime(
        _calendarMonth.year,
        _calendarMonth.month + delta,
      );
    });
  }

  Future<void> _pickRegularizationDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
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
    if (picked != null && mounted) {
      setState(() => _regularizationDate = picked);
    }
  }

  Future<void> _submitRegularization() async {
    if (_regularizationDate == null ||
        _attendanceIssue == null ||
        _regularizationReasonController.text.trim().isEmpty) {
      HapticFeedback.heavyImpact();
      showAuthSnackBar(context, 'Please fill all fields');
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() => _isSubmittingRegularization = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isSubmittingRegularization = false;
      _regularizationHistory.insert(0, {
        'date': _formatDate(_regularizationDate!),
        'issue': _attendanceIssue!,
        'status': 'Pending',
      });
      _regularizationDate = null;
      _attendanceIssue = null;
      _regularizationReasonController.clear();
    });
    showAuthSnackBar(context, 'Regularization request submitted.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        title: 'HR Operations',
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
                    _buildHolidayCalendar(),
                    const SizedBox(height: 28),
                    _buildRegularizationSection(),
                    const SizedBox(height: 28),
                    _buildAnnouncementsSection(),
                    const SizedBox(height: 28),
                    _buildDocumentsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidayCalendar() {
    final firstDay = DateTime(_calendarMonth.year, _calendarMonth.month, 1);
    final daysInMonth =
        DateTime(_calendarMonth.year, _calendarMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Holiday Calendar'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.grey300),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => _changeMonth(-1),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Expanded(
                    child: Text(
                      '${_months[_calendarMonth.month - 1]} ${_calendarMonth.year}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _changeMonth(1),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: _weekdays
                    .map(
                      (d) => Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey500,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: startWeekday - 1 + daysInMonth,
                itemBuilder: (context, index) {
                  if (index < startWeekday - 1) return const SizedBox();
                  final day = index - (startWeekday - 1) + 1;
                  final date =
                      DateTime(_calendarMonth.year, _calendarMonth.month, day);
                  final holiday = _holidays[_holidayKey(date)];
                  final isToday = date.day == DateTime.now().day &&
                      date.month == DateTime.now().month &&
                      date.year == DateTime.now().year;

                  return Container(
                    decoration: BoxDecoration(
                      color: holiday != null
                          ? AppColors.black
                          : isToday
                              ? AppColors.grey100
                              : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: holiday != null
                              ? AppColors.white
                              : AppColors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.grey300),
              const SizedBox(height: 12),
              Text(
                'Upcoming Holidays',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              ..._upcomingHolidays.map(
                (h) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        h['type'] == 'Public'
                            ? Icons.flag_outlined
                            : Icons.business_outlined,
                        size: 18,
                        color: AppColors.grey700,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h['name']!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              h['date']!,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.grey300),
                        ),
                        child: Text(
                          h['type']!,
                          style: GoogleFonts.inter(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegularizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Attendance Regularization'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Date',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Material(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: _pickRegularizationDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Ink(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          _regularizationDate != null
                              ? _formatDate(_regularizationDate!)
                              : 'Select date',
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Attendance Issue',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _attendanceIssue,
                    isExpanded: true,
                    hint: const Text('Select issue type'),
                    items: _issueTypes
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => _attendanceIssue = v),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Reason',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _regularizationReasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Explain the attendance issue',
                ),
              ),
              const SizedBox(height: 16),
              GradientButton(
                label: 'Submit',
                height: 48,
                isLoading: _isSubmittingRegularization,
                onPressed: _submitRegularization,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Request History',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ..._regularizationHistory.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['date']!,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item['issue']!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: item['status']!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'HR Announcements'),
        const SizedBox(height: 12),
        ..._announcements.map(
          (a) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey300),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        a['title']!,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _PriorityBadge(priority: a['priority']!),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  a['description']!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.grey700,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  a['date']!,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Policy & Documents'),
        const SizedBox(height: 12),
        ..._documents.map(
          (doc) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AttendanceQuickActionCard(
              title: doc['title'] as String,
              subtitle: doc['description'] as String,
              icon: doc['icon'] as IconData,
              onTap: () => Navigator.of(context).push(
                authPageRoute(
                  HrDocumentScreen(
                    title: doc['title'] as String,
                    description: doc['description'] as String,
                  ),
                ),
              ),
            ),
          ),
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  Color get _color {
    switch (status) {
      case 'Approved':
        return const Color(0xFF2E7D32);
      case 'Rejected':
        return AppColors.error;
      default:
        return const Color(0xFFF57C00);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final String priority;

  Color get _color {
    switch (priority) {
      case 'High':
        return AppColors.error;
      case 'Medium':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}
