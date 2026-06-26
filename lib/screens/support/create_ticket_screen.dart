import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key, this.initialCategory});

  final String? initialCategory;

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _category;
  String? _priority;
  String? _attachmentName;
  bool _isSubmitting = false;

  static const _categories = [
    'HR Support',
    'IT Support',
    'Admin/Facility',
  ];

  static const _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _pickAttachment() {
    HapticFeedback.selectionClick();
    setState(() => _attachmentName = 'support_attachment.pdf');
    showAuthSnackBar(context, 'Attachment selected (demo)');
  }

  Future<void> _submit() async {
    if (_category == null ||
        _priority == null ||
        _subjectController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      HapticFeedback.heavyImpact();
      showAuthSnackBar(context, 'Please fill all required fields');
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    showAuthSnackBar(context, 'Ticket created successfully.');
    Navigator.of(context).pop<Map<String, dynamic>>({
      'id': 'TKT-${DateTime.now().millisecondsSinceEpoch % 100000}',
      'category': _category!,
      'subject': _subjectController.text.trim(),
      'description': _descriptionController.text.trim(),
      'priority': _priority!,
      'status': 'Open',
      'createdDate': '03 Jun 2026',
      'department': _departmentForCategory(_category!),
      'attachment': _attachmentName,
      'comments': [
        {
          'author': 'You',
          'message': _descriptionController.text.trim(),
          'time': 'Just now',
          'isEmployee': true,
        },
      ],
    });
  }

  String _departmentForCategory(String category) {
    switch (category) {
      case 'IT Support':
        return 'IT Department';
      case 'Admin/Facility':
        return 'Admin & Facilities';
      default:
        return 'Human Resources';
    }
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
          'Create Ticket',
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
                        _buildDropdown(
                          label: 'Ticket Category',
                          value: _category,
                          items: _categories,
                          onChanged: (v) => setState(() => _category = v),
                        ),
                        const SizedBox(height: 20),
                        _buildField(
                          label: 'Subject',
                          controller: _subjectController,
                          hint: 'Brief summary of the issue',
                        ),
                        const SizedBox(height: 20),
                        _buildField(
                          label: 'Description',
                          controller: _descriptionController,
                          hint: 'Describe your issue in detail',
                          maxLines: 5,
                        ),
                        const SizedBox(height: 20),
                        _buildDropdown(
                          label: 'Priority',
                          value: _priority,
                          items: _priorities,
                          onChanged: (v) => setState(() => _priority = v),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Attachment (Optional)',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: _pickAttachment,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.black,
                            side: const BorderSide(color: AppColors.grey300),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.attach_file_rounded),
                          label: Text(
                            _attachmentName ?? 'Upload attachment',
                            style: GoogleFonts.inter(fontSize: 14),
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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
            border: Border.all(color: AppColors.grey300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text('Select', style: GoogleFonts.inter(color: AppColors.grey500)),
              items: items
                  .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
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
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
