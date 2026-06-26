import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/screens/support/widgets/ticket_status_badge.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EscalationsScreen extends StatefulWidget {
  const EscalationsScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<EscalationsScreen> createState() => _EscalationsScreenState();
}

class _EscalationsScreenState extends State<EscalationsScreen> {
  final _referenceController = TextEditingController();
  final _reasonController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _escalationType;
  bool _isSubmitting = false;

  List<Map<String, String>> _history = [
    {
      'reference': 'TKT-10455',
      'type': 'Support Tickets',
      'reason': 'No response for 3 days',
      'status': 'In Progress',
      'date': '01 Jun 2026',
    },
    {
      'reference': 'LV-2026-0528',
      'type': 'HR Issues',
      'reason': 'Leave approval delayed',
      'status': 'Resolved',
      'date': '28 May 2026',
    },
  ];

  static const _types = [
    'Support Tickets',
    'HR Issues',
    'Approval Delays',
    'Administrative Issues',
  ];

  @override
  void dispose() {
    _referenceController.dispose();
    _reasonController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_escalationType == null ||
        _referenceController.text.trim().isEmpty ||
        _reasonController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      HapticFeedback.heavyImpact();
      showAuthSnackBar(context, 'Please fill all fields');
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _history.insert(0, {
        'reference': _referenceController.text.trim(),
        'type': _escalationType!,
        'reason': _reasonController.text.trim(),
        'status': 'Open',
        'date': '03 Jun 2026',
      });
      _escalationType = null;
      _referenceController.clear();
      _reasonController.clear();
      _descriptionController.clear();
    });
    showAuthSnackBar(context, 'Escalation submitted successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        title: 'Escalations',
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFFB300)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.priority_high_rounded,
                            color: Color(0xFFF57C00)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Escalate unresolved tickets, HR issues, or approval delays.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFFE65100),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Escalation Request',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Escalation Type',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _escalationType,
                              isExpanded: true,
                              hint: const Text('Select type'),
                              items: _types
                                  .map(
                                    (t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(t),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _escalationType = v),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _field(
                          'Reference Ticket/Request',
                          _referenceController,
                          'e.g. TKT-10482',
                        ),
                        const SizedBox(height: 16),
                        _field(
                          'Escalation Reason',
                          _reasonController,
                          'Why are you escalating?',
                        ),
                        const SizedBox(height: 16),
                        _field(
                          'Description',
                          _descriptionController,
                          'Provide additional details',
                          maxLines: 4,
                        ),
                        const SizedBox(height: 20),
                        GradientButton(
                          label: 'Submit Escalation',
                          height: 48,
                          isLoading: _isSubmitting,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Escalation History',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._history.map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.grey300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['reference']!,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              TicketStatusBadge(status: item['status']!),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['type']!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.grey700,
                            ),
                          ),
                          Text(
                            item['reason']!,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['date']!,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
