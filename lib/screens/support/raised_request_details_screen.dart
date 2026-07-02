import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/core/utils/support_request_utils.dart';
import 'package:employee_app/models/support/raised_request_model.dart';
import 'package:employee_app/screens/support/widgets/ticket_status_badge.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RaisedRequestDetailsScreen extends StatelessWidget {
  const RaisedRequestDetailsScreen({super.key, required this.request});

  final RaisedRequestData request;

  @override
  Widget build(BuildContext context) {
    final statusLabel = SupportRequestUtils.mapStatusLabel(request.status);
    final hasAttachment = request.attachment.trim().isNotEmpty;

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
          'Request Details',
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                _SectionCard(
                  title: 'Support ID',
                  child: Text(
                    '#${request.supportFormId}',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Subject',
                  child: Text(
                    request.subject,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Description',
                  child: Text(
                    request.description.isNotEmpty
                        ? request.description
                        : '—',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.grey700,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Request Information',
                  child: Column(
                    children: [
                      _DetailRow(
                        label: 'Category',
                        value: request.categoryName.isNotEmpty
                            ? request.categoryName
                            : request.category,
                      ),
                      _DetailRow(
                        label: 'Request User',
                        value: request.requestUser,
                      ),
                      _DetailRow(
                        label: 'Assigned Staff',
                        value: request.contactPerson,
                      ),
                      _DetailRow(
                        label: 'Priority',
                        valueWidget: PriorityBadge(priority: request.priority),
                      ),
                      _DetailRow(
                        label: 'Status',
                        valueWidget: TicketStatusBadge(status: statusLabel),
                      ),
                    ],
                  ),
                ),
                if (hasAttachment) ...[
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Attachment',
                    child: Material(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Opening attachments will be available soon.',
                                style: GoogleFonts.inter(),
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.attach_file_rounded,
                                size: 20,
                                color: AppColors.grey700,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  request.attachment,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.open_in_new_rounded,
                                size: 18,
                                color: AppColors.grey500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Timeline',
                  child: Column(
                    children: [
                      _DetailRow(
                        label: 'Created',
                        value: SupportRequestUtils.formatDateTime(
                          request.createdAt,
                        ),
                      ),
                      _DetailRow(
                        label: 'Updated',
                        value: SupportRequestUtils.formatDateTime(
                          request.updatedAt,
                        ),
                      ),
                      _DetailRow(
                        label: 'Created By',
                        value: request.createdBy,
                      ),
                      _DetailRow(
                        label: 'Updated By',
                        value: request.updatedBy,
                        showDivider: false,
                      ),
                    ],
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.grey500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    this.value,
    this.valueWidget,
    this.showDivider = true,
  }) : assert(value != null || valueWidget != null);

  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.grey500,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: valueWidget ??
                    Text(
                      value != null && value!.isNotEmpty ? value! : '—',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.grey300),
      ],
    );
  }
}
