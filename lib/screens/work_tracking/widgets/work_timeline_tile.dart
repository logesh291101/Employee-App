import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkTimelineEntry {
  const WorkTimelineEntry({
    required this.title,
    required this.time,
    required this.icon,
    this.isLast = false,
  });

  final String title;
  final String time;
  final IconData icon;
  final bool isLast;
}

class WorkTimelineTile extends StatelessWidget {
  const WorkTimelineTile({super.key, required this.entry});

  final WorkTimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.grey300),
                ),
                child: Icon(entry.icon, size: 18, color: AppColors.black),
              ),
              if (!entry.isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.grey300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: entry.isLast ? 0 : 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Text(
                    entry.time,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
