import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _reasonController = TextEditingController();

  String? _leaveType;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isSubmitting = false;
  String? _typeError;
  String? _fromError;
  String? _toError;
  String? _reasonError;

  static const _leaveTypes = [
    'Casual Leave',
    'Sick Leave',
    'Earned Leave',
    'Unpaid Leave',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
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
        if (isFrom) {
          _fromDate = picked;
          _fromError = null;
        } else {
          _toDate = picked;
          _toError = null;
        }
      });
    }
  }

  bool _validate() {
    var valid = true;
    setState(() {
      _typeError = _leaveType == null ? 'Please select leave type' : null;
      _fromError = _fromDate == null ? 'Please select from date' : null;
      _toError = _toDate == null ? 'Please select to date' : null;
      _reasonError = _reasonController.text.trim().isEmpty
          ? 'Reason is required'
          : null;
      if (_typeError != null ||
          _fromError != null ||
          _toError != null ||
          _reasonError != null) {
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
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    showAuthSnackBar(context, 'Leave application submitted successfully.');
    Navigator.of(context).pop<Map<String, String>>({
      'type': _leaveType!,
      'from': _formatDate(_fromDate!),
      'to': _formatDate(_toDate!),
      'reason': _reasonController.text.trim(),
      'status': 'Pending',
    });
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
          'Apply Leave',
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
                        _buildDropdown(),
                        const SizedBox(height: 20),
                        _buildDateField(
                          label: 'From Date',
                          value: _fromDate != null
                              ? _formatDate(_fromDate!)
                              : null,
                          error: _fromError,
                          onTap: () => _pickDate(isFrom: true),
                        ),
                        const SizedBox(height: 20),
                        _buildDateField(
                          label: 'To Date',
                          value:
                              _toDate != null ? _formatDate(_toDate!) : null,
                          error: _toError,
                          onTap: () => _pickDate(isFrom: false),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Reason',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _reasonController,
                          maxLines: 4,
                          onChanged: (_) {
                            if (_reasonError != null) {
                              setState(() => _reasonError = null);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter reason for leave',
                            errorText: _reasonError,
                            prefixIcon: const Icon(Icons.notes_outlined),
                          ),
                        ),
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

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leave Type',
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
              color: _typeError != null ? AppColors.error : AppColors.grey300,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _leaveType,
              isExpanded: true,
              hint: Text(
                'Select leave type',
                style: GoogleFonts.inter(color: AppColors.grey500),
              ),
              items: _leaveTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() {
                _leaveType = v;
                _typeError = null;
              }),
            ),
          ),
        ),
        if (_typeError != null) ...[
          const SizedBox(height: 6),
          Text(
            _typeError!,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required String? value,
    required String? error,
    required VoidCallback onTap,
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
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: error != null ? AppColors.error : AppColors.grey300,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      color: AppColors.grey500, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    value ?? 'Select date',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: value != null
                          ? AppColors.black
                          : AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          Text(
            error,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
          ),
        ],
      ],
    );
  }
}
