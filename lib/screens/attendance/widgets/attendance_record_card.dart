import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceRecordData {
  const AttendanceRecordData({
    required this.date,
    required this.day,
    required this.checkIn,
    required this.checkOut,
    required this.workingHours,
    required this.status,
  });

  final String date;
  final String day;
  final String checkIn;
  final String checkOut;
  final String workingHours;
  final AttendanceDayStatus status;
}

class AttendanceRecordCard extends StatelessWidget {
  const AttendanceRecordCard({super.key, required this.record});

  final AttendanceRecordData record;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.date,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          Text(
                            record.day,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AttendanceStatusBadge(status: record.status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _TimeChip(
                      label: 'In',
                      time: record.checkIn,
                      icon: Icons.login_rounded,
                    ),
                    const SizedBox(width: 12),
                    _TimeChip(
                      label: 'Out',
                      time: record.checkOut,
                      icon: Icons.logout_rounded,
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          record.workingHours,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          'Hours',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.time,
    required this.icon,
  });

  final String label;
  final String time;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.grey500),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 10, color: AppColors.grey500),
            ),
            Text(
              time,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.grey900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
