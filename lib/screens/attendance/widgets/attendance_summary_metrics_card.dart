import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceSummaryMetricsCard extends StatelessWidget {
  const AttendanceSummaryMetricsCard({
    super.key,
    required this.columns,
    this.isLoading = false,
  });

  final List<SummaryMetricColumn> columns;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 88,
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey300),
        ),
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.black,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey300),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (int i = 0; i < columns.length; i++) ...[
              if (i > 0)
                VerticalDivider(
                  width: 24,
                  thickness: 1,
                  color: AppColors.grey300,
                ),
              Expanded(child: _MetricColumn(column: columns[i])),
            ],
          ],
        ),
      ),
    );
  }
}

class SummaryMetricColumn {
  const SummaryMetricColumn({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({required this.column});

  final SummaryMetricColumn column;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          column.label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.grey500,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          column.value,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
