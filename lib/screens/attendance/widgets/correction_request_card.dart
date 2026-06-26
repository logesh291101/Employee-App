import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CorrectionRequestData {
  const CorrectionRequestData({
    required this.requestDate,
    required this.attendanceDate,
    required this.correctionType,
    required this.reason,
    required this.status,
    required this.submittedDate,
    this.reviewedDate,
    this.reviewerComments,
  });

  final String requestDate;
  final String attendanceDate;
  final String correctionType;
  final String reason;
  final CorrectionStatus status;
  final String submittedDate;
  final String? reviewedDate;
  final String? reviewerComments;
}

class CorrectionRequestCard extends StatelessWidget {
  const CorrectionRequestCard({super.key, required this.request});

  final CorrectionRequestData request;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  request.correctionType,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
              CorrectionStatusBadge(status: request.status),
            ],
          ),
          const SizedBox(height: 10),
          _MetaRow(
            icon: Icons.calendar_today_outlined,
            label: 'Attendance Date',
            value: request.attendanceDate,
          ),
          const SizedBox(height: 6),
          _MetaRow(
            icon: Icons.send_outlined,
            label: 'Submitted',
            value: request.submittedDate,
          ),
          if (request.reviewedDate != null) ...[
            const SizedBox(height: 6),
            _MetaRow(
              icon: Icons.rate_review_outlined,
              label: 'Reviewed',
              value: request.reviewedDate!,
            ),
          ],
          const SizedBox(height: 12),
          Text(
            request.reason,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.grey700,
              height: 1.4,
            ),
          ),
          if (request.reviewerComments != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Reviewer: ${request.reviewerComments}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.grey700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey500),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey500),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.grey900,
          ),
        ),
      ],
    );
  }
}
