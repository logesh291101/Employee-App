import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/attendance/attendance_correction_request_screen.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_empty_state.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_stat_card.dart';
import 'package:employee_app/screens/attendance/widgets/attendance_status_badge.dart';
import 'package:employee_app/screens/attendance/widgets/correction_request_card.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceCorrectionHistoryScreen extends StatefulWidget {
  const AttendanceCorrectionHistoryScreen({super.key});

  @override
  State<AttendanceCorrectionHistoryScreen> createState() =>
      _AttendanceCorrectionHistoryScreenState();
}

class _AttendanceCorrectionHistoryScreenState
    extends State<AttendanceCorrectionHistoryScreen> {
  final _requests = const [
    CorrectionRequestData(
      requestDate: '05 June 2026',
      attendanceDate: '04 June 2026',
      correctionType: 'Missed Check-Out',
      reason: 'Forgot to check out due to urgent client meeting off-site.',
      status: CorrectionStatus.pending,
      submittedDate: '05 June 2026, 10:30 AM',
    ),
    CorrectionRequestData(
      requestDate: '28 May 2026',
      attendanceDate: '27 May 2026',
      correctionType: 'Missed Check-In',
      reason: 'Biometric device was not working at the entrance.',
      status: CorrectionStatus.approved,
      submittedDate: '28 May 2026, 09:15 AM',
      reviewedDate: '28 May 2026, 04:00 PM',
      reviewerComments: 'Approved based on security log verification.',
    ),
    CorrectionRequestData(
      requestDate: '15 May 2026',
      attendanceDate: '14 May 2026',
      correctionType: 'Wrong Working Hours',
      reason: 'System recorded incorrect working hours.',
      status: CorrectionStatus.rejected,
      submittedDate: '15 May 2026, 11:00 AM',
      reviewedDate: '16 May 2026, 02:30 PM',
      reviewerComments: 'Insufficient supporting evidence provided.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final requests = _requests;
    final pending =
        _requests.where((r) => r.status == CorrectionStatus.pending).length;
    final approved =
        _requests.where((r) => r.status == CorrectionStatus.approved).length;
    final rejected =
        _requests.where((r) => r.status == CorrectionStatus.rejected).length;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.black,
        ),
        title: Text(
          'Correction History',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: requests.isEmpty
                ? AttendanceEmptyState(
                    icon: Icons.inbox_outlined,
                    title: 'No Correction Requests',
                    message:
                        'You have not submitted any attendance correction requests yet.',
                    actionLabel: 'Submit Request',
                    onAction: () => Navigator.of(context).push(
                      authPageRoute(
                        const AttendanceCorrectionRequestScreen(),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AttendanceStatCard(
                                label: 'Pending',
                                value: '$pending',
                                icon: Icons.hourglass_empty_rounded,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AttendanceStatCard(
                                label: 'Approved',
                                value: '$approved',
                                icon: Icons.check_circle_outline,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AttendanceStatCard(
                                label: 'Rejected',
                                value: '$rejected',
                                icon: Icons.cancel_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Request History',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...requests.map(
                          (r) => CorrectionRequestCard(request: r),
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
