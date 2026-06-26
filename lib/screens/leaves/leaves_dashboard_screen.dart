import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/leaves/apply_leave_screen.dart';
import 'package:employee_app/screens/leaves/permission_request_screen.dart';
import 'package:employee_app/screens/leaves/wfh_request_screen.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LeavesDashboardScreen extends StatefulWidget {
  const LeavesDashboardScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<LeavesDashboardScreen> createState() => _LeavesDashboardScreenState();
}

class _LeavesDashboardScreenState extends State<LeavesDashboardScreen> {
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _leaveBalances = [
    {
      'title': 'Casual Leave',
      'available': 12,
      'used': 4,
      'icon': Icons.beach_access_outlined,
    },
    {
      'title': 'Sick Leave',
      'available': 10,
      'used': 2,
      'icon': Icons.medical_services_outlined,
    },
    {
      'title': 'Earned Leave',
      'available': 15,
      'used': 3,
      'icon': Icons.card_giftcard_outlined,
    },
  ];

  List<Map<String, String>> _leaveApprovals = [
    {
      'type': 'Casual Leave',
      'dates': '10 Jun – 11 Jun 2026',
      'status': 'Pending',
    },
    {
      'type': 'Sick Leave',
      'dates': '28 May 2026',
      'status': 'Approved',
    },
    {
      'type': 'Earned Leave',
      'dates': '15 May – 17 May 2026',
      'status': 'Rejected',
    },
  ];

  List<Map<String, String>> _wfhHistory = [
    {
      'date': '05 Jun 2026',
      'reason': 'Home maintenance work',
      'status': 'Approved',
    },
    {
      'date': '22 May 2026',
      'reason': 'Personal appointment',
      'status': 'Pending',
    },
  ];

  List<Map<String, String>> _permissionRequests = [
    {
      'date': '03 Jun 2026',
      'time': '02:00 PM – 04:00 PM',
      'reason': 'Bank visit',
      'status': 'Pending',
    },
    {
      'date': '30 May 2026',
      'time': '11:00 AM – 12:30 PM',
      'reason': 'Doctor appointment',
      'status': 'Approved',
    },
    {
      'date': '18 May 2026',
      'time': '03:00 PM – 05:00 PM',
      'reason': 'Family event',
      'status': 'Rejected',
    },
  ];

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _isRefreshing = false);
    showAuthSnackBar(context, 'Leave data refreshed');
  }

  Future<void> _openApplyLeave() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      authPageRoute(const ApplyLeaveScreen()),
    );
    if (result == null || !mounted) return;
    setState(() {
      _leaveApprovals.insert(0, {
        'type': result['type']!,
        'dates': '${result['from']} – ${result['to']}',
        'status': result['status']!,
      });
    });
  }

  Future<void> _openWfh() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      authPageRoute(const WfhRequestScreen()),
    );
    if (result == null || !mounted) return;
    setState(() {
      _wfhHistory.insert(0, {
        'date': result['date']!,
        'reason': result['reason']!,
        'status': result['status']!,
      });
    });
  }

  Future<void> _openPermission() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      authPageRoute(const PermissionRequestScreen()),
    );
    if (result == null || !mounted) return;
    setState(() {
      _permissionRequests.insert(0, {
        'date': result['date']!,
        'time': '${result['start']} – ${result['end']}',
        'reason': result['reason']!,
        'status': result['status']!,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        title: 'Leaves',
        showBackButton: widget.showBackButton,
        onSettingsTap: () {},
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          if (_isRefreshing)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x66FFFFFF),
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(
            top: false,
            child: RefreshIndicator(
              color: AppColors.black,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBalanceSection(),
                    const SizedBox(height: 24),
                    GradientButton(
                      label: 'Apply Leave',
                      height: 52,
                      onPressed: _openApplyLeave,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionChip(
                            icon: Icons.home_work_outlined,
                            label: 'WFH Request',
                            onTap: _openWfh,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionChip(
                            icon: Icons.more_time_outlined,
                            label: 'Permission',
                            onTap: _openPermission,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _SectionTitle(title: 'Leave Approvals'),
                    const SizedBox(height: 12),
                    ..._leaveApprovals.map(_buildLeaveApprovalCard),
                    const SizedBox(height: 28),
                    _SectionTitle(title: 'Work From Home Requests'),
                    const SizedBox(height: 12),
                    ..._wfhHistory.map(_buildWfhCard),
                    const SizedBox(height: 28),
                    _SectionTitle(title: 'Permission / Short Leave'),
                    const SizedBox(height: 12),
                    _buildPermissionGroup('Pending', 'Pending'),
                    const SizedBox(height: 12),
                    _buildPermissionGroup('Approved', 'Approved'),
                    const SizedBox(height: 12),
                    _buildPermissionGroup('Rejected', 'Rejected'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Leave Balance'),
        const SizedBox(height: 12),
        ..._leaveBalances.map((b) {
          final available = b['available'] as int;
          final used = b['used'] as int;
          final total = available + used;
          final remaining = available;
          final progress = total == 0 ? 0.0 : used / total;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
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
                    Icon(b['icon'] as IconData, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        b['title'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '$remaining left',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.grey300,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.black),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _BalanceStat(label: 'Available', value: '$available'),
                    _BalanceStat(label: 'Used', value: '$used'),
                    _BalanceStat(label: 'Remaining', value: '$remaining'),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLeaveApprovalCard(Map<String, String> item) {
    return _RequestCard(
      title: item['type']!,
      subtitle: item['dates']!,
      status: item['status']!,
      icon: Icons.event_busy_outlined,
    );
  }

  Widget _buildWfhCard(Map<String, String> item) {
    return _RequestCard(
      title: item['date']!,
      subtitle: item['reason']!,
      status: item['status']!,
      icon: Icons.home_work_outlined,
    );
  }

  Widget _buildPermissionGroup(String title, String statusFilter) {
    final items =
        _permissionRequests.where((r) => r['status'] == statusFilter).toList();
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Text(
          'No $title requests',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey500),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.grey900,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => _RequestCard(
            title: '${item['date']} • ${item['time']}',
            subtitle: item['reason']!,
            status: item['status']!,
            icon: Icons.more_time_outlined,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  const _BalanceStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: AppColors.grey500),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.grey300),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: AppColors.black),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String status;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.grey700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _StatusBadge(status: status),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  Color get _color {
    switch (status) {
      case 'Approved':
        return const Color(0xFF2E7D32);
      case 'Rejected':
        return AppColors.error;
      default:
        return const Color(0xFFF57C00);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}
