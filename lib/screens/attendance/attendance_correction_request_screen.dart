import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceCorrectionRequestScreen extends StatefulWidget {
  const AttendanceCorrectionRequestScreen({super.key});

  @override
  State<AttendanceCorrectionRequestScreen> createState() =>
      _AttendanceCorrectionRequestScreenState();
}

class _AttendanceCorrectionRequestScreenState
    extends State<AttendanceCorrectionRequestScreen> {
  static const _maxReasonLength = 250;

  DateTime? _selectedDate;
  String? _correctionType;
  final _reasonController = TextEditingController();

  bool _isLoading = false;
  bool _hasAttemptedSubmit = false;
  String? _dateError;
  String? _typeError;
  String? _reasonError;

  final _correctionTypes = const [
    'Missed Check-In',
    'Missed Check-Out',
    'Incorrect Attendance',
    'Wrong Working Hours',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  void _validate() {
    setState(() {
      _dateError = _selectedDate == null ? 'Please select a date' : null;
      _typeError =
          _correctionType == null ? 'Please select correction type' : null;
      final reason = _reasonController.text.trim();
      _reasonError = reason.isEmpty
          ? 'Reason is required'
          : reason.length < 10
              ? 'Please provide a detailed reason (min 10 characters)'
              : null;
    });
  }

  bool get _isValid =>
      _dateError == null && _typeError == null && _reasonError == null;

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 6, 5),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
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
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _onSubmit() async {
    HapticFeedback.mediumImpact();
    setState(() => _hasAttemptedSubmit = true);
    _validate();
    if (!_isValid) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _isLoading = false);
    showAuthSnackBar(context, 'Correction request submitted successfully');
    Navigator.of(context).pop();
  }

  void _onAttachDocument() {
    showAuthSnackBar(context, 'Document upload — UI preview only');
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final reasonLength = _reasonController.text.length;

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
          'Attendance Correction Request',
          style: GoogleFonts.inter(
            fontSize: 17,
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
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.grey300.withOpacity(0.6)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Request Details',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Select Date',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _hasAttemptedSubmit && _dateError != null
                                  ? AppColors.grey700
                                  : AppColors.grey300,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.grey500,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _selectedDate != null
                                    ? _formatDate(_selectedDate!)
                                    : 'Choose attendance date',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: _selectedDate != null
                                      ? AppColors.black
                                      : AppColors.grey500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_hasAttemptedSubmit && _dateError != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        _dateError!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      'Attendance Type',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._correctionTypes.map((type) {
                      final isSelected = _correctionType == type;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: isSelected
                              ? AppColors.grey100
                              : AppColors.grey50,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () =>
                                setState(() => _correctionType = type),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.black
                                      : AppColors.grey300,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    size: 20,
                                    color: isSelected
                                        ? AppColors.black
                                        : AppColors.grey500,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    type,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    if (_hasAttemptedSubmit && _typeError != null) ...[
                      Text(
                        _typeError!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 12),
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
                      maxLength: _maxReasonLength,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText:
                            'Enter reason for attendance correction request',
                        counterText: '$reasonLength/$_maxReasonLength',
                        errorText:
                            _hasAttemptedSubmit ? _reasonError : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _onAttachDocument,
                      icon: const Icon(Icons.attach_file_rounded, size: 20),
                      label: const Text('Upload Supporting Document'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.black,
                        side: const BorderSide(color: AppColors.grey300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    GradientButton(
                      label: 'Submit Request',
                      isLoading: _isLoading,
                      onPressed: _onSubmit,
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
}
