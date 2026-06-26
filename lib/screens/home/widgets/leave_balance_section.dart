import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/home/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveBalanceItem {
  const LeaveBalanceItem({
    required this.title,
    required this.availableDays,
    required this.icon,
  });

  final String title;
  final int availableDays;
  final IconData icon;
}

class LeaveBalanceSection extends StatelessWidget {
  const LeaveBalanceSection({
    super.key,
    required this.items,
  });

  final List<LeaveBalanceItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Leave Balance'),
        const SizedBox(height: 12),
        Row(
          children: items.map((item) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: item != items.last ? 10 : 0,
                ),
                child: _LeaveCard(item: item),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _LeaveCard extends StatelessWidget {
  const _LeaveCard({required this.item});

  final LeaveBalanceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Icon(item.icon, size: 18, color: AppColors.black),
          ),
          const SizedBox(height: 12),
          Text(
            '${item.availableDays}',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.title,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.grey700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'days left',
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}
