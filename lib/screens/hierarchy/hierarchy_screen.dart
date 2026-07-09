import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_widgets.dart';
import 'package:employee_app/screens/hierarchy/widgets/hierarchy_shimmer.dart';
import 'package:employee_app/viewmodels/hierarchy_viewmodel.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HierarchyScreen extends GetView<HierarchyViewModel> {
  const HierarchyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: hierarchyAppBar(context: context, title: 'Hierarchy'),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: Obx(() {
              if (controller.isLoading.value || controller.isRefreshing.value) {
                return const HierarchyShimmer();
              }

              if (controller.errorMessage.value != null) {
                return _HierarchyMessageState(
                  message: controller.errorMessage.value!,
                  icon: Icons.error_outline_rounded,
                  actionLabel: 'Retry',
                  onAction: controller.fetchHierarchy,
                );
              }

              if (controller.rootNodes.isEmpty) {
                final message = controller.emptyMessage.value;
                if (message != null && message.trim().isNotEmpty) {
                  return _HierarchyMessageState(message: message);
                }
              }

              return RefreshIndicator(
                onRefresh: controller.refreshHierarchy,
                color: AppColors.black,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    for (final node in controller.rootNodes)
                      _HierarchyTreeNode(
                        node: node,
                        depth: 0,
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _HierarchyTreeNode extends GetView<HierarchyViewModel> {
  const _HierarchyTreeNode({
    required this.node,
    required this.depth,
  });

  final HierarchyNode node;
  final int depth;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded = controller.isExpanded(node.id);
      final hasChildren = node.hasChildren;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: depth * 18.0, bottom: 12),
            child: HierarchyEmployeeCard(
              name: node.name,
              role: node.roleId,
              email: node.email,
              profilePic: node.profilePic,
              hasChildren: hasChildren,
              isExpanded: isExpanded,
              onTap: hasChildren
                  ? () {
                      HapticFeedback.selectionClick();
                      controller.toggleNode(node.id);
                    }
                  : null,
            ),
          ),
          if (hasChildren && isExpanded)
            for (final child in node.children)
              _HierarchyTreeNode(
                node: child,
                depth: depth + 1,
              ),
        ],
      );
    });
  }
}

class _HierarchyMessageState extends StatelessWidget {
  const _HierarchyMessageState({
    required this.message,
    this.icon = Icons.account_tree_outlined,
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
