import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/screens/support/create_ticket_screen.dart';
import 'package:employee_app/screens/support/ticket_details_screen.dart';
import 'package:employee_app/screens/support/widgets/ticket_status_badge.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportTicketsDashboardScreen extends StatefulWidget {
  const SupportTicketsDashboardScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<SupportTicketsDashboardScreen> createState() =>
      _SupportTicketsDashboardScreenState();
}

class _SupportTicketsDashboardScreenState
    extends State<SupportTicketsDashboardScreen> {
  String _filterCategory = 'All';

  List<Map<String, dynamic>> _tickets = [
    {
      'id': 'TKT-10482',
      'category': 'HR Support',
      'subject': 'Leave balance discrepancy',
      'description': 'My casual leave balance shows incorrect days.',
      'priority': 'Medium',
      'status': 'In Progress',
      'createdDate': '01 Jun 2026',
      'department': 'Human Resources',
      'requestType': 'Leave Issues',
      'comments': [
        {
          'author': 'You',
          'message': 'Please review my leave balance for June.',
          'time': '01 Jun, 10:30 AM',
          'isEmployee': true,
        },
        {
          'author': 'HR Support',
          'message': 'We are reviewing your records and will update shortly.',
          'time': '01 Jun, 02:15 PM',
          'isEmployee': false,
        },
      ],
    },
    {
      'id': 'TKT-10471',
      'category': 'IT Support',
      'subject': 'Email not syncing on mobile',
      'description': 'Outlook app fails to sync new emails since yesterday.',
      'priority': 'High',
      'status': 'Open',
      'createdDate': '02 Jun 2026',
      'department': 'IT Department',
      'requestType': 'Email Problems',
      'comments': [
        {
          'author': 'You',
          'message': 'Unable to receive emails on Android device.',
          'time': '02 Jun, 09:00 AM',
          'isEmployee': true,
        },
      ],
    },
    {
      'id': 'TKT-10455',
      'category': 'Admin/Facility',
      'subject': 'AC not working in meeting room',
      'description': 'Conference room B AC has been non-functional for 2 days.',
      'priority': 'Medium',
      'status': 'Pending',
      'createdDate': '30 May 2026',
      'department': 'Admin & Facilities',
      'requestType': 'Office Maintenance',
      'comments': [],
    },
    {
      'id': 'TKT-10440',
      'category': 'IT Support',
      'subject': 'VPN connection drops frequently',
      'description': 'VPN disconnects every 15-20 minutes while working remotely.',
      'priority': 'Low',
      'status': 'Resolved',
      'createdDate': '25 May 2026',
      'department': 'IT Department',
      'requestType': 'VPN/Network Issues',
      'comments': [],
    },
  ];

  static const _hrTypes = [
    'Leave Issues',
    'Payroll Queries',
    'Attendance Issues',
    'Policy Clarifications',
    'General HR Support',
  ];

  static const _itTypes = [
    'System Access Issues',
    'Email Problems',
    'Software Issues',
    'Hardware Issues',
    'VPN/Network Issues',
  ];

  static const _adminTypes = [
    'Office Maintenance',
    'Housekeeping',
    'Electricity',
    'Internet',
    'Seating Arrangement',
    'Facility Requests',
  ];

  List<Map<String, dynamic>> get _filteredTickets {
    if (_filterCategory == 'All') return _tickets;
    return _tickets.where((t) => t['category'] == _filterCategory).toList();
  }

  Future<void> _createTicket({String? category}) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      authPageRoute(CreateTicketScreen(initialCategory: category)),
    );
    if (result == null || !mounted) return;
    setState(() => _tickets.insert(0, result));
  }

  void _openTicket(Map<String, dynamic> ticket) {
    Navigator.of(context).push(
      authPageRoute(TicketDetailsScreen(ticket: ticket)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        title: 'Support & Tickets',
        showBackButton: widget.showBackButton,
        onSettingsTap: () {},
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GradientButton(
                    label: 'Create Ticket',
                    height: 52,
                    onPressed: () => _createTicket(),
                  ),
                  const SizedBox(height: 24),
                  _buildCategorySection(
                    title: 'HR Support Requests',
                    types: _hrTypes,
                    category: 'HR Support',
                    icon: Icons.people_outline,
                  ),
                  const SizedBox(height: 20),
                  _buildCategorySection(
                    title: 'IT Support Requests',
                    types: _itTypes,
                    category: 'IT Support',
                    icon: Icons.computer_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildCategorySection(
                    title: 'Admin / Facility Complaints',
                    types: _adminTypes,
                    category: 'Admin/Facility',
                    icon: Icons.apartment_outlined,
                  ),
                  const SizedBox(height: 28),
                  _buildTicketList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required List<String> types,
    required String category,
    required IconData icon,
  }) {
    final history = _tickets
        .where((t) => t['category'] == category)
        .take(2)
        .toList();

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
          Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _createTicket(category: category),
                child: Text(
                  'Raise',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: types
                .map(
                  (t) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.inter(fontSize: 11),
                    ),
                  ),
                )
                .toList(),
          ),
          if (history.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              'Recent',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
              ),
            ),
            const SizedBox(height: 8),
            ...history.map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        t['subject'] as String,
                        style: GoogleFonts.inter(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TicketStatusBadge(status: t['status'] as String),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTicketList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ticket Tracking',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'HR Support', 'IT Support', 'Admin/Facility']
                .map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(f),
                      selected: _filterCategory == f,
                      onSelected: (_) {
                        HapticFeedback.selectionClick();
                        setState(() => _filterCategory = f);
                      },
                      selectedColor: AppColors.grey100,
                      checkmarkColor: AppColors.black,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        ..._filteredTickets.map(
          (ticket) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () => _openTicket(ticket),
                borderRadius: BorderRadius.circular(14),
                child: Ink(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ticket['id'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.grey500,
                              ),
                            ),
                            Text(
                              ticket['subject'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${ticket['category']} • ${ticket['createdDate']}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.grey700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TicketStatusBadge(status: ticket['status'] as String),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
