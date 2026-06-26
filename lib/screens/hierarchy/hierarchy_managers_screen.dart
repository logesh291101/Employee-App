import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_mock_data.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_team_leads_screen.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_widgets.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HierarchyManagersScreen extends StatefulWidget {
  const HierarchyManagersScreen({super.key});

  @override
  State<HierarchyManagersScreen> createState() =>
      _HierarchyManagersScreenState();
}

class _HierarchyManagersScreenState extends State<HierarchyManagersScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredManagers {
    return filterHierarchyMembers(
      HierarchyMockData.managers,
      _searchQuery,
    );
  }

  @override
  Widget build(BuildContext context) {
    final managers = _filteredManagers;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: hierarchyAppBar(context: context, title: 'Managers'),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HierarchyBreadcrumb(
                        segments: ['Owner', 'Managers'],
                      ),
                      const SizedBox(height: 16),
                      HierarchySearchBar(
                        controller: _searchController,
                        hintText: 'Search by name, ID, or role',
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: managers.isEmpty
                      ? Center(
                          child: Text(
                            'No managers found.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.grey700,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: managers.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final manager = managers[index];
                            return HierarchyMemberCard(
                              member: manager,
                              reportLabel: 'Direct Reports',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                Navigator.of(context).push(
                                  authPageRoute(
                                    HierarchyTeamLeadsScreen(
                                      manager: manager,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
