import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/models/support/department_dropdown_model.dart';
import 'package:employee_app/models/support/staff_dropdown_model.dart';
import 'package:employee_app/viewmodels/create_support_request_viewmodel.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateSupportRequestScreen extends GetView<CreateSupportRequestViewModel> {
  const CreateSupportRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.black,
        ),
        title: Text(
          'Create Support Request',
          style: GoogleFonts.inter(
            fontSize: 17,
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
            child: Obx(() {
              if (controller.isLoadingDepartments.value &&
                  controller.departments.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.black),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildDepartmentDropdown(),
                          const SizedBox(height: 20),
                          _buildStaffDropdown(),
                          const SizedBox(height: 20),
                          Obx(
                            () => _buildField(
                              label: 'Subject *',
                              controller: controller.subjectController,
                              hint: 'e.g. Unable to mark attendance',
                              errorText: controller.subjectError.value,
                              onChanged: controller.clearSubjectError,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Obx(
                            () => _buildField(
                              label: 'Description *',
                              controller: controller.descriptionController,
                              hint: 'Please describe your issue in detail...',
                              maxLines: 6,
                              errorText: controller.descriptionError.value,
                              onChanged: controller.clearDescriptionError,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildPriorityDropdown(),
                          const SizedBox(height: 20),
                          _buildAttachmentSection(context),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Obx(
                      () => GradientButton(
                        label: 'Submit',
                        isLoading: controller.isSubmitting.value,
                        onPressed: controller.isSubmitting.value
                            ? null
                            : _onSubmit,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentDropdown() {
    return Obx(() {
      return _buildModelDropdown<DepartmentDropDownModel>(
        label: 'Support Category *',
        value: controller.selectedDepartment.value,
        items: controller.departments,
        isLoading: controller.isLoadingDepartments.value,
        errorText: controller.categoryError.value,
        hint: 'Select category',
        itemLabel: (item) => item.name,
        onChanged: controller.onDepartmentChanged,
      );
    });
  }

  Widget _buildStaffDropdown() {
    return Obx(() {
      final enabled = controller.isStaffDropdownEnabled;

      return _buildModelDropdown<StaffDropDownModel>(
        label: 'Staff Name *',
        value: controller.selectedStaff.value,
        items: controller.staffs,
        isLoading: controller.isLoadingStaff.value,
        errorText: controller.staffError.value,
        hint: enabled ? 'Select staff' : 'Select a category first',
        itemLabel: (item) => item.name,
        onChanged: enabled ? controller.onStaffChanged : null,
      );
    });
  }

  Widget _buildPriorityDropdown() {
    return Obx(() {
      return _buildStringDropdown(
        label: 'Priority *',
        value: controller.selectedPriority.value,
        items: CreateSupportRequestViewModel.priorities,
        errorText: controller.priorityError.value,
        onChanged: controller.onPriorityChanged,
      );
    });
  }

  Widget _buildAttachmentSection(BuildContext context) {
    return Obx(() {
      final attachmentName = controller.attachmentName.value;
      final attachmentType = controller.attachmentType.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attachment (Optional)',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 8),
          if (attachmentName == null)
            OutlinedButton.icon(
              onPressed: () => _pickAttachment(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                side: const BorderSide(color: AppColors.grey300),
                padding: const EdgeInsets.symmetric(vertical: 14,horizontal:18),
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
                    attachmentType == 'Image'
                        ? Icons.image_outlined
                        : attachmentType == 'PDF'
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
                          attachmentName,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          attachmentType ?? 'File',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _pickAttachment(context),
                    icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                    tooltip: 'Replace',
                    color: AppColors.grey700,
                  ),
                  IconButton(
                    onPressed: controller.removeAttachment,
                    icon: const Icon(Icons.close_rounded, size: 20),
                    tooltip: 'Remove',
                    color: AppColors.grey700,
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  void _pickAttachment(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
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
                  onTap: () => _setAttachment(
                    sheetContext,
                    'screenshot.png',
                    'Image',
                  ),
                ),
                const SizedBox(height: 8),
                _AttachmentOption(
                  icon: Icons.picture_as_pdf_outlined,
                  label: 'PDF',
                  onTap: () => _setAttachment(
                    sheetContext,
                    'document.pdf',
                    'PDF',
                  ),
                ),
                const SizedBox(height: 8),
                _AttachmentOption(
                  icon: Icons.description_outlined,
                  label: 'Document',
                  onTap: () => _setAttachment(
                    sheetContext,
                    'support_doc.docx',
                    'Document',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setAttachment(BuildContext context, String name, String type) {
    Navigator.of(context).pop();
    controller.setAttachment(name, type);
    showAuthSnackBar(Get.context!, 'Attachment selected (demo)');
  }

  void _onSubmit() {
    HapticFeedback.mediumImpact();
    controller.submit();
  }

  Widget _buildModelDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?>? onChanged,
    required String hint,
    String? errorText,
    bool isLoading = false,
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
            color: onChanged == null ? AppColors.grey50 : AppColors.white,
          ),
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Loading...',
                        style: GoogleFonts.inter(color: AppColors.grey500),
                      ),
                    ],
                  ),
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    isExpanded: true,
                    hint: Text(
                      hint,
                      style: GoogleFonts.inter(color: AppColors.grey500),
                    ),
                    items: items
                        .map(
                          (item) => DropdownMenuItem<T>(
                            value: item,
                            child: Text(
                              itemLabel(item),
                              style: GoogleFonts.inter(),
                            ),
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

  Widget _buildStringDropdown({
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
            contentPadding:
                maxLines > 1 ? const EdgeInsets.all(16) : null,
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
