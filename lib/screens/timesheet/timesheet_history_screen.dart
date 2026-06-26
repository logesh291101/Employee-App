import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TimesheetHistoryScreen extends StatefulWidget {
  const TimesheetHistoryScreen({super.key});

  @override
  State<TimesheetHistoryScreen> createState() => _TimesheetHistoryScreenState();
}

class _TimesheetHistoryScreenState extends State<TimesheetHistoryScreen> {
  DateTime? _filterDate;
  int? _filterMonth;
  int? _filterYear;

  static final List<Map<String, dynamic>> _allRecords = [
    {
      'date': DateTime(2026, 8, 15),
      'taskCategory': 'Development',
      'hoursSpent': '7.5',
      'taskDescription':
          'Implemented employee profile enhancements and fixed attendance-related UI issues.',
    },
    {
      'date': DateTime(2026, 6, 3),
      'taskCategory': 'Code Review',
      'hoursSpent': '8.0',
      'taskDescription':
          'Reviewed pull requests for the portal module and provided feedback on API integration changes.',
    },
    {
      'date': DateTime(2026, 6, 2),
      'taskCategory': 'Bug Fix',
      'hoursSpent': '7.5',
      'taskDescription':
          'Resolved login session timeout issues and fixed navigation bugs in the dashboard screen.',
    },
    {
      'date': DateTime(2026, 5, 28),
      'taskCategory': 'Testing',
      'hoursSpent': '6.0',
      'taskDescription':
          'Performed regression testing on leave management flows and documented test results.',
    },
    {
      'date': DateTime(2026, 5, 15),
      'taskCategory': 'Documentation',
      'hoursSpent': '4.0',
      'taskDescription':
          'Updated internal wiki pages for timesheet submission guidelines and onboarding steps.',
    },
    {
      'date': DateTime(2026, 4, 10),
      'taskCategory': 'Meeting',
      'hoursSpent': '8.0',
      'taskDescription':
          'Attended sprint planning, backlog grooming, and cross-team sync for Q2 deliverables.',
    },
  ];

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  List<Map<String, dynamic>> get _filteredRecords {
    return _allRecords.where((record) {
      final date = record['date'] as DateTime;
      if (_filterDate != null &&
          (date.year != _filterDate!.year ||
              date.month != _filterDate!.month ||
              date.day != _filterDate!.day)) {
        return false;
      }
      if (_filterMonth != null && date.month != _filterMonth) return false;
      if (_filterYear != null && date.year != _filterYear) return false;
      return true;
    }).toList()
      ..sort((a, b) =>
          (b['date'] as DateTime).compareTo(a['date'] as DateTime));
  }

  bool get _hasActiveFilters =>
      _filterDate != null || _filterMonth != null || _filterYear != null;

  List<int> get _availableYears {
    return _allRecords
        .map((r) => (r['date'] as DateTime).year)
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String get _filterChipLabel {
    final parts = <String>[];
    if (_filterDate != null) parts.add(_formatDate(_filterDate!));
    if (_filterMonth != null) parts.add(_months[_filterMonth! - 1]);
    if (_filterYear != null) parts.add(_filterYear.toString());
    return parts.join(' · ');
  }

  void _openFilterSheet() {
    HapticFeedback.lightImpact();
    DateTime? draftDate = _filterDate;
    int? draftMonth = _filterMonth;
    int? draftYear = _filterYear;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> pickDate() async {
              final picked = await showDatePicker(
                context: context,
                initialDate: draftDate ?? DateTime.now(),
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
                setSheetState(() => draftDate = picked);
              }
            }

            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                20 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Filter Timesheets',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FilterField(
                    label: 'Date',
                    value: draftDate != null
                        ? _formatDate(draftDate!)
                        : 'All dates',
                    icon: Icons.calendar_today_outlined,
                    onTap: pickDate,
                  ),
                  const SizedBox(height: 12),
                  _FilterDropdown<int>(
                    label: 'Month',
                    value: draftMonth,
                    hint: 'All months',
                    items: List.generate(12, (i) => i + 1),
                    display: (m) => _months[m - 1],
                    onChanged: (v) => setSheetState(() => draftMonth = v),
                  ),
                  const SizedBox(height: 12),
                  _FilterDropdown<int>(
                    label: 'Year',
                    value: draftYear,
                    hint: 'All years',
                    items: _availableYears,
                    display: (y) => y.toString(),
                    onChanged: (v) => setSheetState(() => draftYear = v),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            setSheetState(() {
                              draftDate = null;
                              draftMonth = null;
                              draftYear = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.black,
                            side: const BorderSide(color: AppColors.grey300),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Reset',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _filterDate = draftDate;
                              _filterMonth = draftMonth;
                              _filterYear = draftYear;
                            });
                            Navigator.of(sheetContext).pop();
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.black,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Apply',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _clearFilters() {
    HapticFeedback.selectionClick();
    setState(() {
      _filterDate = null;
      _filterMonth = null;
      _filterYear = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;

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
        actions: [
          IconButton(
            onPressed: _openFilterSheet,
            icon: Icon(
              Icons.filter_list_rounded,
              color: _hasActiveFilters ? AppColors.black : AppColors.grey700,
            ),
            tooltip: 'Filter',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_hasActiveFilters)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InputChip(
                        label: Text(
                          _filterChipLabel,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        deleteIcon: const Icon(Icons.close_rounded, size: 16),
                        onDeleted: _clearFilters,
                        backgroundColor: AppColors.grey100,
                        side: const BorderSide(color: AppColors.grey300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: records.isEmpty
                      ? Center(
                          child: Text(
                            'No timesheet records found.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.grey700,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                            20,
                            _hasActiveFilters ? 12 : 8,
                            20,
                            24,
                          ),
                          itemCount: records.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final record = records[index];
                            return _TimesheetRecordCard(
                              taskCategory:
                                  record['taskCategory'] ?? "",
                              date: _formatDate(record['date']),
                              hoursSpent: record['hoursSpent'] ?? "" ,
                              taskDescription:
                                  record['taskDescription'] ?? "",
                            );
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
}

class _FilterField extends StatelessWidget {
  const _FilterField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.grey700,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.grey500),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.grey500,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.display,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final String hint;
  final List<T> items;
  final String Function(T) display;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.grey700,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              hint: Text(hint, style: GoogleFonts.inter(color: AppColors.grey500)),
              items: [
                DropdownMenuItem<T>(
                  value: null,
                  child: Text('All', style: GoogleFonts.inter()),
                ),
                ...items.map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(display(item), style: GoogleFonts.inter()),
                  ),
                ),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _TimesheetRecordCard extends StatelessWidget {
  const _TimesheetRecordCard({
    required this.taskCategory,
    required this.date,
    required this.hoursSpent,
    required this.taskDescription,
  });

  final String taskCategory;
  final String date;
  final String hoursSpent;
  final String taskDescription;

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
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            taskCategory,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Date: $date',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Hours Spent: $hoursSpent hrs',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Task Description:',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            taskDescription,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.grey700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
