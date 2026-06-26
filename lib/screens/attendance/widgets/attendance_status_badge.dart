import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AttendanceDayStatus {
  present,
  absent,
  halfDay,
  holiday,
  weekOff,
}

enum CorrectionStatus { pending, approved, rejected }

class AttendanceStatusBadge extends StatelessWidget {
  const AttendanceStatusBadge({
    super.key,
    required this.status,
  });

  final AttendanceDayStatus status;

  @override
  Widget build(BuildContext context) {
    return _Badge(label: _label, style: _style);
  }

  String get _label {
    switch (status) {
      case AttendanceDayStatus.present:
        return 'Present';
      case AttendanceDayStatus.absent:
        return 'Absent';
      case AttendanceDayStatus.halfDay:
        return 'Half Day';
      case AttendanceDayStatus.holiday:
        return 'Holiday';
      case AttendanceDayStatus.weekOff:
        return 'Week Off';
    }
  }

  _BadgeStyle get _style {
    switch (status) {
      case AttendanceDayStatus.present:
        return const _BadgeStyle(
          background: AppColors.black,
          foreground: AppColors.white,
        );
      case AttendanceDayStatus.absent:
        return const _BadgeStyle(
          background: AppColors.grey700,
          foreground: AppColors.white,
        );
      case AttendanceDayStatus.halfDay:
        return const _BadgeStyle(
          background: AppColors.grey500,
          foreground: AppColors.white,
        );
      case AttendanceDayStatus.holiday:
      case AttendanceDayStatus.weekOff:
        return const _BadgeStyle(
          background: AppColors.grey100,
          foreground: AppColors.grey900,
        );
    }
  }
}

class CorrectionStatusBadge extends StatelessWidget {
  const CorrectionStatusBadge({
    super.key,
    required this.status,
  });

  final CorrectionStatus status;

  @override
  Widget build(BuildContext context) {
    return _Badge(label: _label, style: _style);
  }

  String get _label {
    switch (status) {
      case CorrectionStatus.pending:
        return 'Pending';
      case CorrectionStatus.approved:
        return 'Approved';
      case CorrectionStatus.rejected:
        return 'Rejected';
    }
  }

  _BadgeStyle get _style {
    switch (status) {
      case CorrectionStatus.pending:
        return const _BadgeStyle(
          background: Color(0xFFF5F0E0),
          foreground: Color(0xFF6B5E2E),
        );
      case CorrectionStatus.approved:
        return const _BadgeStyle(
          background: Color(0xFFE8F0E8),
          foreground: Color(0xFF2E4A34),
        );
      case CorrectionStatus.rejected:
        return const _BadgeStyle(
          background: Color(0xFFF0E8E8),
          foreground: Color(0xFF5A3A3A),
        );
    }
  }
}

class _BadgeStyle {
  const _BadgeStyle({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.style});

  final String label;
  final _BadgeStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: style.foreground,
        ),
      ),
    );
  }
}
