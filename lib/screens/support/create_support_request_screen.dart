import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportRequestForm extends StatefulWidget {
  const SupportRequestForm({super.key, required this.onSubmitted});

  final ValueChanged<Map<String, dynamic>> onSubmitted;

  @override
  State<SupportRequestForm> createState() => _SupportRequestFormState();
}

class _SupportRequestFormState extends State<SupportRequestForm> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _category;
  String? _priority;
  String? _attachmentName;
  String? _attachmentType;
  bool _isSubmitting = false;

  String? _categoryError;
  String? _subjectError;
  String? _descriptionError;
  String? _priorityError;

  static const _categories = [
    'HR Support',
    'IT Support',
    'Admin / Facility',
    'Payroll',
    'Attendance',
    'Leave',
    'Other',
  ];

  static const _priorities = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _pickAttachment() {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Upload Attachment',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _AttachmentOption(
                  icon: Icons.image_outlined,
                  label: 'Image',
                  onTap: () => _setAttachment('screenshot.png', 'Image'),
                ),
                const SizedBox(height: 8),
                _AttachmentOption(
                  icon: Icons.picture_as_pdf_outlined,
                  label: 'PDF',
                  onTap: () => _setAttachment('document.pdf', 'PDF'),
                ),
                const SizedBox(height: 8),
                _AttachmentOption(
                  icon: Icons.description_outlined,
                  label: 'Document',
                  onTap: () => _setAttachment('support_doc.docx', 'Document'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setAttachment(String name, String type) {
    Navigator.of(context).pop();
    setState(() {
      _attachmentName = name;
      _attachmentType = type;
    });
    showAuthSnackBar(context, 'Attachment selected (demo)');
  }

  void _removeAttachment() {
    setState(() {
      _attachmentName = null;
      _attachmentType = null;
    });
  }

  bool _validate() {
    var valid = true;
    setState(() {
      _categoryError = _category == null ? 'Please select a category' : null;
      _subjectError = _subjectController.text.trim().isEmpty
          ? 'Subject is required'
          : null;
      _descriptionError = _descriptionController.text.trim().isEmpty
          ? 'Description is required'
          : null;
      _priorityError =
          _priority == null ? 'Please select a priority' : null;

      if (_categoryError != null ||
          _subjectError != null ||
          _descriptionError != null ||
          _priorityError != null) {
        valid = false;
      }
    });
    return valid;
  }

  String _formatSubmittedDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
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

    final now = DateTime.now();
    final ticketId = 'SUP-${now.millisecondsSinceEpoch % 10000}';
    final submittedDate = _formatSubmittedDate(now);

    widget.onSubmitted({
      'id': ticketId,
      'category': _category!,
      'subject': _subjectController.text.trim(),
      'description': _descriptionController.text.trim(),
      'submittedDate': submittedDate,
      'priority': _priority!,
      'status': 'Open',
      'attachment': _attachmentName,
      'attachmentType': _attachmentType,
      'messages': [
        {
          'sender': 'Logesh K',
          'message': _descriptionController.text.trim(),
          'dateTime': '$submittedDate, ${_formatTime(now)}',
          'isEmployee': true,
        },
      ],
    });

    _subjectController.clear();
    _descriptionController.clear();
    setState(() {
      _category = null;
      _priority = null;
      _attachmentName = null;
      _attachmentType = null;
    });
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${date.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDropdown(
                  label: 'Support Category *',
                  value: _category,
                  items: _categories,
                  errorText: _categoryError,
                  onChanged: (v) => setState(() {
                    _category = v;
                    _categoryError = null;
                  }),
                ),
                const SizedBox(height: 20),
                _buildField(
                  label: 'Subject *',
                  controller: _subjectController,
                  hint: 'e.g. Unable to mark attendance',
                  errorText: _subjectError,
                  onChanged: (_) => setState(() => _subjectError = null),
                ),
                const SizedBox(height: 20),
                _buildField(
                  label: 'Description *',
                  controller: _descriptionController,
                  hint: 'Please describe your issue in detail...',
                  maxLines: 6,
                  errorText: _descriptionError,
                  onChanged: (_) => setState(() => _descriptionError = null),
                ),
                const SizedBox(height: 20),
                _buildDropdown(
                  label: 'Priority *',
                  value: _priority,
                  items: _priorities,
                  errorText: _priorityError,
                  onChanged: (v) => setState(() {
                    _priority = v;
                    _priorityError = null;
                  }),
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
                if (_attachmentName == null)
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
                      'Upload Image, PDF, or Document',
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _attachmentType == 'Image'
                              ? Icons.image_outlined
                              : _attachmentType == 'PDF'
                                  ? Icons.picture_as_pdf_outlined
                                  : Icons.description_outlined,
                          color: AppColors.grey700,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _attachmentName!,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _attachmentType ?? 'File',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.grey500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _pickAttachment,
                          icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                          tooltip: 'Replace',
                          color: AppColors.grey700,
                        ),
                        IconButton(
                          onPressed: _removeAttachment,
                          icon: const Icon(Icons.close_rounded, size: 20),
                          tooltip: 'Remove',
                          color: AppColors.grey700,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: GradientButton(
            label: 'Submit Request',
            isLoading: _isSubmitting,
            onPressed: _submit,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
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
              hint: Text(
                'Select',
                style: GoogleFonts.inter(color: AppColors.grey500),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem(
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

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? errorText,
    ValueChanged<String>? onChanged,
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
          minLines: maxLines > 1 ? maxLines : 1,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            alignLabelWithHint: maxLines > 1,
            contentPadding: maxLines > 1
                ? const EdgeInsets.all(16)
                : null,
          ),
        ),
      ],
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.black),
      title: Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.grey300),
      ),
    );
  }
}
