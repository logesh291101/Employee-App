import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_mock_data.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_widgets.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HierarchyEmployeesScreen extends StatefulWidget {
  const HierarchyEmployeesScreen({
    super.key,
    required this.manager,
    required this.teamLead,
  });

  final Map<String, dynamic> manager;
  final Map<String, dynamic> teamLead;

  @override
  State<HierarchyEmployeesScreen> createState() =>
      _HierarchyEmployeesScreenState();
}

class _HierarchyEmployeesScreenState extends State<HierarchyEmployeesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _employees {
    return HierarchyMockData.employeesForTeamLead(
      managerIndex: widget.manager['managerIndex'] as int,
      teamLeadIndex: widget.teamLead['teamLeadIndex'] as int,
    );
  }

  List<Map<String, dynamic>> get _filteredEmployees {
    return filterHierarchyMembers(_employees, _searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final employees = _filteredEmployees;
    final managerName = widget.manager['name'] as String;
    final teamLeadName = widget.teamLead['name'] as String;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: hierarchyAppBar(context: context, title: 'Employees'),
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
                        segments: [
                          'Owner',
                          managerName,
                          teamLeadName,
                          'Employees',
                        ],
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
                  child: employees.isEmpty
                      ? Center(
                          child: Text(
                            'No employees found.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.grey700,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: employees.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return HierarchyMemberCard(
                              member: employees[index],
                              showChevron: false,
                              onTap: null,
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
