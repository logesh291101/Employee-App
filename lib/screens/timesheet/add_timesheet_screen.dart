import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTimesheetScreen extends StatefulWidget {
  const AddTimesheetScreen({super.key});

  @override
  State<AddTimesheetScreen> createState() => _AddTimesheetScreenState();
}

class _AddTimesheetScreenState extends State<AddTimesheetScreen> {
  final _workDetailsController = TextEditingController();

  DateTime? _selectedDate;
  String? _workItem;
  String? _hoursSpent;
  bool _isSubmitting = false;

  String? _dateError;
  String? _workItemError;
  String? _hoursSpentError;
  String? _workDetailsError;

  static const _workItems = [
    'Development',
    'Bug Fix',
    'Testing',
    'Meeting',
    'Documentation',
    'Code Review',
  ];

  static const _hoursOptions = [
    '0.5',
    '1.0',
    '1.5',
    '2.0',
    '2.5',
    '3.0',
    '3.5',
    '4.0',
    '4.5',
    '5.0',
    '5.5',
    '6.0',
    '6.5',
    '7.0',
    '7.5',
    '8.0',
    '8.5',
    '9.0',
    '9.5',
    '10.0',
  ];

  @override
  void dispose() {
    _workDetailsController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        _dateError = null;
      });
    }
  }

  bool _validate() {
    var valid = true;
    setState(() {
      _dateError = _selectedDate == null ? 'Please select a date' : null;
      _workItemError =
          _workItem == null ? 'Please select a Task Category' : null;
      _hoursSpentError =
          _hoursSpent == null ? 'Please select hours spent' : null;
      _workDetailsError = _workDetailsController.text.trim().isEmpty
          ? 'Task Description are required'
          : null;

      if (_dateError != null ||
          _workItemError != null ||
          _hoursSpentError != null ||
          _workDetailsError != null) {
        valid = false;
      }
    });
    return valid;
  }

  Future<void> _submit() async {
    if (!_validate()) {
      HapticFeedback.heavyImpact();
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    showAuthSnackBar(context, 'Timesheet submitted successfully.');
    Navigator.of(context).pop();
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDatePicker(),
                        const SizedBox(height: 20),
                        _buildDropdown(
                          label: 'Task Category',
                          value: _workItem,
                          hint: 'Select Task Category',
                          items: _workItems,
                          errorText: _workItemError,
                          onChanged: (value) => setState(() {
                            _workItem = value;
                            _workItemError = null;
                          }),
                        ),
                        const SizedBox(height: 20),
                        _buildDropdown(
                          label: 'Hours Spent',
                          value: _hoursSpent,
                          hint: 'Select hours',
                          items: _hoursOptions,
                          errorText: _hoursSpentError,
                          onChanged: (value) => setState(() {
                            _hoursSpent = value;
                            _hoursSpentError = null;
                          }),
                        ),
                        const SizedBox(height: 20),
                        _buildWorkDetailsField(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: GradientButton(
                    label: 'Submit',
                    isLoading: _isSubmitting,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.grey900,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _dateError != null ? AppColors.error : AppColors.grey300,
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
                    _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : 'Select date',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _selectedDate != null
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
        if (_dateError != null) ...[
          const SizedBox(height: 6),
          Text(
            _dateError!,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? errorText,
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
              hint: Text(hint, style: GoogleFonts.inter(color: AppColors.grey500)),
              items: items
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

  Widget _buildWorkDetailsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Description',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.grey900,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _workDetailsController,
          maxLines: 6,
          minLines: 6,
          onChanged: (_) => setState(() => _workDetailsError = null),
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Describe the work completed...',
            alignLabelWithHint: true,
            errorText: _workDetailsError,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
