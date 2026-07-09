import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EIPShimmer extends StatefulWidget {
  const EIPShimmer({super.key});

  @override
  State<EIPShimmer> createState() => _EIPShimmerState();
}

class _EIPShimmerState extends State<EIPShimmer>
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
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, __) => _EIPShimmerCard(opacity: opacity),
        );
      },
    );
  }
}

class _EIPShimmerCard extends StatelessWidget {
  const _EIPShimmerCard({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        children: [
          _ShimmerBox(width: 120, height: 12, opacity: opacity),
          const SizedBox(height: 20),
          _ShimmerBox(width: 80, height: 80, opacity: opacity, circular: true),
          const SizedBox(height: 20),
          _ShimmerBox(width: double.infinity, height: 14, opacity: opacity),
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
    this.circular = false,
  });

  final double width;
  final double height;
  final double opacity;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.grey300.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(circular ? height / 2 : 8),
      ),
    );
  }
}
