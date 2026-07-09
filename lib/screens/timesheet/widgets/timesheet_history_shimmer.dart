import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TimesheetHistoryShimmer extends StatefulWidget {
  const TimesheetHistoryShimmer({super.key});

  @override
  State<TimesheetHistoryShimmer> createState() =>
      _TimesheetHistoryShimmerState();
}

class _TimesheetHistoryShimmerState extends State<TimesheetHistoryShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = 0.35 + (_controller.value * 0.35);
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => _ShimmerCard(opacity: opacity),
        );
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(width: 90, height: 12, opacity: opacity),
          const SizedBox(height: 10),
          _ShimmerBox(width: 140, height: 16, opacity: opacity),
          const SizedBox(height: 14),
          _ShimmerBox(width: double.infinity, height: 12, opacity: opacity),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.opacity,
  });

  final double width;
  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.grey300.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
