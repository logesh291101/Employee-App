import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/support/widgets/ticket_status_badge.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportDetailsScreen extends StatefulWidget {
  const SupportDetailsScreen({
    super.key,
    required this.request,
    this.onRequestUpdated,
  });

  final Map<String, dynamic> request;
  final ValueChanged<Map<String, dynamic>>? onRequestUpdated;

  @override
  State<SupportDetailsScreen> createState() => _SupportDetailsScreenState();
}

class _SupportDetailsScreenState extends State<SupportDetailsScreen> {
  final _replyController = TextEditingController();
  late Map<String, dynamic> _request;
  late List<Map<String, dynamic>> _messages;
  String? _replyAttachmentName;

  @override
  void initState() {
    super.initState();
    _request = Map<String, dynamic>.from(widget.request);
    _messages = List<Map<String, dynamic>>.from(
      _request['messages'] as List? ?? [],
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _pickReplyAttachment() {
    HapticFeedback.selectionClick();
    setState(() => _replyAttachmentName = 'reply_attachment.pdf');
    showAuthSnackBar(context, 'File attached (demo)');
  }

  void _sendReply() {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    final now = DateTime.now();
    final dateTime = _formatDateTime(now);

    setState(() {
      _messages.add({
        'sender': 'Logesh K',
        'message': text,
        'dateTime': dateTime,
        'isEmployee': true,
        if (_replyAttachmentName != null)
          'attachment': _replyAttachmentName,
      });
      _request['messages'] = _messages;
      _replyController.clear();
      _replyAttachmentName = null;
    });

    widget.onRequestUpdated?.call(_request);
    showAuthSnackBar(context, 'Reply sent');
  }

  String _formatDateTime(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}, $hour:${date.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final attachment = _request['attachment'] as String?;

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
          'Ticket #${_request['id']}',
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
                        _buildDetailsCard(attachment),
                        const SizedBox(height: 24),
                        Text(
                          'Conversation',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._messages.map(_buildMessageBubble),
                        if (_messages.isEmpty)
                          Text(
                            'No messages yet.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.grey500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                _buildReplyBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(String? attachment) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _request['subject'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),
              TicketStatusBadge(status: _request['status'] as String),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              PriorityBadge(priority: _request['priority'] as String),
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
                  _request['category'] as String,
                  style: GoogleFonts.inter(fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.grey300),
          const SizedBox(height: 12),
          _InfoRow(label: 'Ticket ID', value: _request['id'] as String),
          _InfoRow(label: 'Category', value: _request['category'] as String),
          _InfoRow(label: 'Subject', value: _request['subject'] as String),
          _InfoRow(
            label: 'Description',
            value: _request['description'] as String,
          ),
          if (attachment != null)
            _InfoRow(label: 'Attachment', value: attachment),
          _InfoRow(
            label: 'Submitted Date',
            value: (_request['createdDate'] ??
                    _request['submittedDate'] ??
                    '—') as String,
          ),
          _InfoRow(label: 'Priority', value: _request['priority'] as String),
          _InfoRow(label: 'Current Status', value: _request['status'] as String),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isEmployee = message['isEmployee'] as bool? ?? true;
    final attachment = message['attachment'] as String?;

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
                  message['sender'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const Spacer(),
                Text(
                  message['dateTime'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              message['message'] as String,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.4,
                color: AppColors.grey900,
              ),
            ),
            if (attachment != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.attach_file_rounded,
                    size: 14,
                    color: AppColors.grey700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    attachment,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.grey700,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReplyBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.grey300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_replyAttachmentName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.attach_file_rounded, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _replyAttachmentName!,
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _replyAttachmentName = null),
                    child: const Icon(Icons.close_rounded, size: 18),
                  ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: _pickReplyAttachment,
                icon: const Icon(Icons.attach_file_rounded),
                color: AppColors.grey700,
                tooltip: 'Attach File',
              ),
              Expanded(
                child: TextField(
                  controller: _replyController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Type your reply...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.grey500,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.grey300),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.black,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: _sendReply,
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
        ],
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
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
