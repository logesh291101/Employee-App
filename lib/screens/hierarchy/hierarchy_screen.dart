import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_managers_screen.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_mock_data.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_widgets.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HierarchyScreen extends StatelessWidget {
  const HierarchyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final owner = HierarchyMockData.owner;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: hierarchyAppBar(context: context, title: 'Hierarchy'),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const HierarchyBreadcrumb(segments: ['Hierarchy', 'Owner']),
                  const SizedBox(height: 20),
                  HierarchyOwnerCard(
                    member: owner,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).push(
                        authPageRoute(const HierarchyManagersScreen()),
                      );
                    },
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
