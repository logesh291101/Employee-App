import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/support/widgets/ticket_status_badge.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key, required this.ticket});

  final Map<String, dynamic> ticket;

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final _commentController = TextEditingController();
  late List<Map<String, dynamic>> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List<Map<String, dynamic>>.from(
      widget.ticket['comments'] as List? ?? [],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _comments.add({
        'author': 'You',
        'message': text,
        'time': 'Just now',
        'isEmployee': true,
      });
      _commentController.clear();
    });
    showAuthSnackBar(context, 'Comment added');
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;

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
          ticket['id'] as String,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInfoCard(ticket),
                        const SizedBox(height: 24),
                        Text(
                          'Comments & History',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._comments.map(_buildCommentBubble),
                        if (_comments.isEmpty)
                          Text(
                            'No comments yet.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.grey500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border(top: BorderSide(color: AppColors.grey300)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.grey500,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide:
                                  const BorderSide(color: AppColors.grey300),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Material(
                        color: AppColors.black,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: _addComment,
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.send_rounded,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> ticket) {
    return Container(
      padding: const EdgeInsets.all(18),
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
              Expanded(
                child: Text(
                  ticket['subject'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TicketStatusBadge(status: ticket['status'] as String),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              PriorityBadge(priority: ticket['priority'] as String? ?? 'Medium'),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: Text(
                  ticket['category'] as String,
                  style: GoogleFonts.inter(fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.grey300),
          const SizedBox(height: 12),
          _InfoRow(label: 'Description', value: ticket['description'] as String),
          _InfoRow(label: 'Created', value: ticket['createdDate'] as String),
          _InfoRow(
            label: 'Assigned Department',
            value: ticket['department'] as String,
          ),
          _InfoRow(label: 'Status', value: ticket['status'] as String),
        ],
      ),
    );
  }

  Widget _buildCommentBubble(Map<String, dynamic> comment) {
    final isEmployee = comment['isEmployee'] as bool? ?? true;

    return Align(
      alignment: isEmployee ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isEmployee ? AppColors.grey100 : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isEmployee ? 16 : 4),
            bottomRight: Radius.circular(isEmployee ? 4 : 16),
          ),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  comment['author'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  comment['time'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              comment['message'] as String,
              style: GoogleFonts.inter(fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.grey500),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
