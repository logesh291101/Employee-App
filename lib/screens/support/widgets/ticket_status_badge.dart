import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketStatusBadge extends StatelessWidget {
  const TicketStatusBadge({super.key, required this.status});

  final String status;

  Color get _color {
    switch (status) {
      case 'Open':
        return const Color(0xFF1565C0);
      case 'In Progress':
        return const Color(0xFFF57C00);
      case 'On Hold':
        return const Color(0xFF7B1FA2);
      case 'Pending':
        return const Color(0xFF7B1FA2);
      case 'Resolved':
        return const Color(0xFF2E7D32);
      case 'Closed':
        return AppColors.grey700;
      default:
        return AppColors.grey700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withOpacity(0.35)),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}

class PriorityBadge extends StatelessWidget {
  const PriorityBadge({super.key, required this.priority});

  final String priority;

  Color get _color {
    switch (priority) {
      case 'Critical':
        return const Color(0xFFB71C1C);
      case 'High':
        return AppColors.error;
      case 'Medium':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}
