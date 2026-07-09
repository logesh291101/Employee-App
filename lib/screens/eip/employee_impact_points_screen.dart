import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/models/eip/eip_model.dart';
import 'package:employee_app/screens/eip/widgets/eip_shimmer.dart';
import 'package:employee_app/viewmodels/eip_viewmodel.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeImpactPointsScreen extends GetView<EIPViewModel> {
  const EmployeeImpactPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Employee Impact Points',
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
            child: Obx(() {
              if (controller.isLoading.value || controller.isRefreshing.value) {
                return const EIPShimmer();
              }

              if (controller.errorMessage.value != null) {
                return _EIPMessageState(
                  message: controller.errorMessage.value!,
                  icon: Icons.error_outline_rounded,
                  actionLabel: 'Retry',
                  onAction: controller.fetchImpactPoints,
                );
              }

              if (controller.impactPoints.isEmpty) {
                final message = controller.emptyMessage.value;
                if (message != null && message.trim().isNotEmpty) {
                  return _EIPMessageState(message: message);
                }
              }

              return RefreshIndicator(
                onRefresh: controller.refreshImpactPoints,
                color: AppColors.black,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  itemCount: controller.impactPoints.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _EIPCard(item: controller.impactPoints[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _EIPCard extends StatelessWidget {
  const _EIPCard({required this.item});

  final EIPData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _InfoRow(
              label: 'Created Date',
              value: item.createdDate,
            ),
            const SizedBox(height: 14),
            _InfoRow(
              label: 'Month',
              value: item.month,
            ),
            const SizedBox(height: 20),
            _PointsHighlight(points: item.points),
            const SizedBox(height: 20),
            _InfoRow(
              label: 'Total Points Allocated',
              value: item.totalPointAllocated,
            ),
            const SizedBox(height: 14),
            _InfoRow(
              label: 'Comments',
              value: item.comments,
              multiline: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _PointsHighlight extends StatelessWidget {
  const _PointsHighlight({required this.points});

  final String points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E3A34).withValues(alpha: 0.08),
            const Color(0xFF1A1A2E).withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF1E3A34).withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Points',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.grey700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.brandGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    points.isNotEmpty ? points : '—',
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 28,
                child: Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: const Color(0xFFFFD54F).withValues(alpha: 0.9),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 24,
                child: Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: const Color(0xFFFFD54F).withValues(alpha: 0.75),
                ),
              ),
              Positioned(
                top: 18,
                left: 20,
                child: Icon(
                  Icons.auto_awesome,
                  size: 12,
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.multiline = false,
  });

  final String label;
  final String value;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.grey500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value.isNotEmpty ? value : '—',
          style: GoogleFonts.inter(
            fontSize: multiline ? 14 : 15,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            height: multiline ? 1.45 : 1.2,
          ),
        ),
      ],
    );
  }
}

class _EIPMessageState extends StatelessWidget {
  const _EIPMessageState({
    required this.message,
    this.icon = Icons.stars_rounded,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 52, color: AppColors.grey500),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.grey700,
                height: 1.45,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: onAction,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.black,
                  side: const BorderSide(color: AppColors.black),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
