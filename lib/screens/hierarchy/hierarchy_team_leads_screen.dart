import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_employees_screen.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_mock_data.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_widgets.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HierarchyTeamLeadsScreen extends StatefulWidget {
  const HierarchyTeamLeadsScreen({super.key, required this.manager});

  final Map<String, dynamic> manager;

  @override
  State<HierarchyTeamLeadsScreen> createState() =>
      _HierarchyTeamLeadsScreenState();
}

class _HierarchyTeamLeadsScreenState extends State<HierarchyTeamLeadsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _teamLeads {
    final managerIndex = widget.manager['managerIndex'] as int;
    return HierarchyMockData.teamLeadsForManager(managerIndex);
  }

  List<Map<String, dynamic>> get _filteredTeamLeads {
    return filterHierarchyMembers(_teamLeads, _searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final teamLeads = _filteredTeamLeads;
    final managerName = widget.manager['name'] as String;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: hierarchyAppBar(context: context, title: 'Team Leads'),
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
                      HierarchyBreadcrumb(
                        segments: ['Owner', managerName, 'Team Leads'],
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
                  child: teamLeads.isEmpty
                      ? Center(
                          child: Text(
                            'No team leads found.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.grey700,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: teamLeads.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final teamLead = teamLeads[index];
                            return HierarchyMemberCard(
                              member: teamLead,
                              reportLabel: 'Team Members',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                Navigator.of(context).push(
                                  authPageRoute(
                                    HierarchyEmployeesScreen(
                                      manager: widget.manager,
                                      teamLead: teamLead,
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
