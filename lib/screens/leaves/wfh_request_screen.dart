import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WfhRequestScreen extends StatefulWidget {
  const WfhRequestScreen({super.key});

  @override
  State<WfhRequestScreen> createState() => _WfhRequestScreenState();
}

class _WfhRequestScreenState extends State<WfhRequestScreen> {
  final _reasonController = TextEditingController();
  DateTime? _selectedDate;
  bool _isSubmitting = false;
  String? _dateError;
  String? _reasonError;

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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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
        _selectedDate = picked;
        _dateError = null;
      });
    }
  }

  Future<void> _submit() async {
    setState(() {
      _dateError = _selectedDate == null ? 'Please select a date' : null;
      _reasonError = _reasonController.text.trim().isEmpty
          ? 'Reason is required'
          : null;
    });
    if (_dateError != null || _reasonError != null) {
      HapticFeedback.heavyImpact();
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    showAuthSnackBar(context, 'Work from home request submitted.');
    Navigator.of(context).pop<Map<String, String>>({
      'date': _formatDate(_selectedDate!),
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
          'Work From Home',
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
                        Text(
                          'Date',
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
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(12),
                            child: Ink(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _dateError != null
                                      ? AppColors.error
                                      : AppColors.grey300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined,
                                      color: AppColors.grey500),
                                  const SizedBox(width: 12),
                                  Text(
                                    _selectedDate != null
                                        ? _formatDate(_selectedDate!)
                                        : 'Select date',
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
                        if (_dateError != null) ...[
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
                            hintText: 'Enter reason for WFH',
                            errorText: _reasonError,
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
}
