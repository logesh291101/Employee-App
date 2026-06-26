import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/support/create_support_request_screen.dart';
import 'package:employee_app/screens/support/support_details_screen.dart';
import 'package:employee_app/screens/support/widgets/ticket_status_badge.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<Map<String, dynamic>> _requests = _seedRequests();

  static List<Map<String, dynamic>> _seedRequests() {
    return [
      {
        'id': 'SUP-1025',
        'category': 'IT Support',
        'subject': 'Unable to connect to VPN',
        'description':
            'I am unable to connect to the company VPN from my home network since yesterday evening.',
        'submittedDate': '12 Aug 2026',
        'priority': 'High',
        'status': 'In Progress',
        'attachment': 'vpn_error_log.pdf',
        'attachmentType': 'PDF',
        'messages': [
          {
            'sender': 'Logesh K',
            'message':
                'I am unable to connect to the company VPN from my home network since yesterday evening.',
            'dateTime': '12 Aug 2026, 10:15 AM',
            'isEmployee': true,
          },
          {
            'sender': 'IT Support Team',
            'message':
                'Thank you for reporting this. We are checking your VPN credentials and will update you shortly.',
            'dateTime': '12 Aug 2026, 11:30 AM',
            'isEmployee': false,
          },
          {
            'sender': 'IT Support Team',
            'message':
                'Your VPN profile has been refreshed. Please try reconnecting and let us know if the issue persists.',
            'dateTime': '12 Aug 2026, 02:45 PM',
            'isEmployee': false,
          },
        ],
      },
      {
        'id': 'SUP-1018',
        'category': 'Payroll',
        'subject': 'Payroll clarification for July',
        'description':
            'There seems to be a discrepancy in my July payslip regarding overtime hours.',
        'submittedDate': '05 Aug 2026',
        'priority': 'Medium',
        'status': 'Resolved',
        'attachment': null,
        'attachmentType': null,
        'messages': [
          {
            'sender': 'Logesh K',
            'message':
                'There seems to be a discrepancy in my July payslip regarding overtime hours.',
            'dateTime': '05 Aug 2026, 09:00 AM',
            'isEmployee': true,
          },
          {
            'sender': 'HR Payroll',
            'message':
                'We have reviewed your payslip and issued a corrected version. Please check your email.',
            'dateTime': '06 Aug 2026, 04:00 PM',
            'isEmployee': false,
          },
        ],
      },
      {
        'id': 'SUP-1002',
        'category': 'Attendance',
        'subject': 'Unable to mark attendance',
        'description':
            'The attendance app shows an error when I try to check in from the office premises.',
        'submittedDate': '28 Jul 2026',
        'priority': 'Critical',
        'status': 'Closed',
        'attachment': 'attendance_error.png',
        'attachmentType': 'Image',
        'messages': [
          {
            'sender': 'Logesh K',
            'message':
                'The attendance app shows an error when I try to check in from the office premises.',
            'dateTime': '28 Jul 2026, 08:45 AM',
            'isEmployee': true,
          },
        ],
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onRequestSubmitted(Map<String, dynamic> request) {
    setState(() => _requests.insert(0, request));
    _tabController.animateTo(1);
    showAuthSnackBar(
      context,
      'Your support request has been submitted successfully.',
    );
  }

  void _openDetails(Map<String, dynamic> request) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      authPageRoute(
        SupportDetailsScreen(
          request: request,
          onRequestUpdated: (updated) {
            setState(() {
              final index =
                  _requests.indexWhere((r) => r['id'] == updated['id']);
              if (index != -1) _requests[index] = updated;
            });
          },
        ),
      ),
    );
  }

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
          controller: _tabController,
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
            Tab(text: 'New Request'),
            Tab(text: 'My Requests'),
          ],
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: TabBarView(
              controller: _tabController,
              children: [
                SupportRequestForm(onSubmitted: _onRequestSubmitted),
                _MyRequestsTab(
                  requests: _requests,
                  onTap: _openDetails,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyRequestsTab extends StatelessWidget {
  const _MyRequestsTab({
    required this.requests,
    required this.onTap,
  });

  final List<Map<String, dynamic>> requests;
  final ValueChanged<Map<String, dynamic>> onTap;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.support_agent_outlined,
                size: 48,
                color: AppColors.grey500,
              ),
              const SizedBox(height: 16),
              Text(
                'No support requests yet',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Submit a new request from the New Request tab.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.grey700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _SupportRequestCard(
          request: requests[index],
          onTap: () => onTap(requests[index]),
        );
      },
    );
  }
}

class _SupportRequestCard extends StatelessWidget {
  const _SupportRequestCard({
    required this.request,
    required this.onTap,
  });

  final Map<String, dynamic> request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                      'Ticket #${request['id']}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const Spacer(),
                    TicketStatusBadge(status: request['status'] as String),
                  ],
                ),
                const SizedBox(height: 12),
                _buildRow('Category', request['category'] as String),
                const SizedBox(height: 6),
                _buildRow('Subject', request['subject'] as String),
                const SizedBox(height: 6),
                _buildRow('Submitted', request['submittedDate'] as String),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Priority: ',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.grey700,
                      ),
                    ),
                    PriorityBadge(priority: request['priority'] as String),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey700),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
