import 'package:employee_app/bindings/assigned_request_details_binding.dart';
import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/core/utils/support_request_utils.dart';
import 'package:employee_app/models/support/assigned_request_model.dart';
import 'package:employee_app/models/support/raised_request_model.dart';
import 'package:employee_app/screens/support/assigned_request_details_screen.dart';
import 'package:employee_app/screens/support/raised_request_details_screen.dart';
import 'package:employee_app/screens/support/widgets/my_requests_shimmer.dart';
import 'package:employee_app/screens/support/widgets/ticket_status_badge.dart';
import 'package:employee_app/viewmodels/support_viewmodel.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends GetView<SupportViewModel> {
  const SupportScreen({super.key});

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
          'Support',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: AppColors.black,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.black,
          indicatorWeight: 2.5,
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'My Requests'),
            Tab(text: 'Assigned to Me'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.openCreateRequest,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'New Request',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: TabBarView(
              controller: controller.tabController,
              children: [
                const _MyRequestsTab(),
                const _AssignedRequestsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyRequestsTab extends GetView<SupportViewModel> {
  const _MyRequestsTab();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMyRequests.value ||
          controller.isRefreshingMyRequests.value) {
        return const MyRequestsShimmer();
      }

      if (controller.myRequestsError.value != null) {
        return _SupportMessageState(
          message: controller.myRequestsError.value!,
          icon: Icons.error_outline_rounded,
          actionLabel: 'Retry',
          onAction: controller.fetchMyRequests,
        );
      }

      if (controller.myRequests.isEmpty) {
        final message = controller.myRequestsEmptyMessage.value;
        if (message != null && message.trim().isNotEmpty) {
          return _SupportMessageState(message: message);
        }
      }

      return RefreshIndicator(
        onRefresh: controller.refreshMyRequests,
        color: AppColors.black,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 88),
          itemCount: controller.myRequests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final request = controller.myRequests[index];
            return _MyRequestCard(
              request: request,
              onTap: () => _openDetails(context, request),
            );
          },
        ),
      );
    });
  }

  void _openDetails(BuildContext context, RaisedRequestData request) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      authPageRoute(RaisedRequestDetailsScreen(request: request)),
    );
  }
}

class _MyRequestCard extends StatelessWidget {
  const _MyRequestCard({
    required this.request,
    required this.onTap,
  });

  final RaisedRequestData request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusLabel = SupportRequestUtils.mapStatusLabel(request.status);
    final createdDate =
        SupportRequestUtils.formatCreatedDate(request.createdAt);
    final category = request.categoryName.isNotEmpty
        ? request.categoryName
        : request.category;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Support ID : #${request.supportFormId}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey700,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 22,
                      color: AppColors.grey500,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Subject',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  request.subject,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                _CardField(label: 'Category', value: category),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Priority',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.grey500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          PriorityBadge(priority: request.priority),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.grey500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TicketStatusBadge(status: statusLabel),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _CardField(label: 'Created', value: createdDate),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AssignedRequestsTab extends GetView<SupportViewModel> {
  const _AssignedRequestsTab();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAssignedRequests.value ||
          controller.isRefreshingAssignedRequests.value) {
        return const MyRequestsShimmer();
      }

      if (controller.assignedRequestsError.value != null) {
        return _SupportMessageState(
          message: controller.assignedRequestsError.value!,
          icon: Icons.error_outline_rounded,
          actionLabel: 'Retry',
          onAction: controller.fetchAssignedRequests,
        );
      }

      if (controller.assignedRequests.isEmpty) {
        final message = controller.assignedRequestsEmptyMessage.value;
        if (message != null && message.trim().isNotEmpty) {
          return _SupportMessageState(message: message);
        }
      }

      return RefreshIndicator(
        onRefresh: controller.refreshAssignedRequests,
        color: AppColors.black,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 88),
          itemCount: controller.assignedRequests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final request = controller.assignedRequests[index];
            return _AssignedRequestCard(
              request: request,
              onTap: () => _openDetails(context, request),
            );
          },
        ),
      );
    });
  }

  void _openDetails(BuildContext context, AssignedRequestData request) {
    HapticFeedback.selectionClick();
    Get.to(
      () => const AssignedRequestDetailsScreen(),
      binding: AssignedRequestDetailsBinding(request),
    );
  }
}

class _AssignedRequestCard extends StatelessWidget {
  const _AssignedRequestCard({
    required this.request,
    required this.onTap,
  });

  final AssignedRequestData request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusLabel = SupportRequestUtils.mapStatusLabel(request.status);
    final createdDate =
        SupportRequestUtils.formatCreatedDate(request.createdAt);
    final category = request.categoryName.isNotEmpty
        ? request.categoryName
        : request.category;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Support ID : #${request.supportFormId}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey700,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 22,
                      color: AppColors.grey500,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Subject',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  request.subject,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                _CardField(label: 'Category', value: category),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Priority',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.grey500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          PriorityBadge(priority: request.priority),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.grey500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TicketStatusBadge(status: statusLabel),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _CardField(label: 'Created', value: createdDate),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportMessageState extends StatelessWidget {
  const _SupportMessageState({
    required this.message,
    this.icon = Icons.support_agent_outlined,
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
            Icon(icon, size: 48, color: AppColors.grey500),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.grey700,
                height: 1.4,
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

class _CardField extends StatelessWidget {
  const _CardField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.grey500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isNotEmpty ? value : '—',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
