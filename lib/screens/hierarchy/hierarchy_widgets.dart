import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HierarchyBreadcrumb extends StatelessWidget {
  const HierarchyBreadcrumb({super.key, required this.segments});

  final List<String> segments;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < segments.length; i++) ...[
            if (i > 0) ...[
              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.grey500),
              const SizedBox(width: 6),
            ],
            Text(
              segments[i],
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: i == segments.length - 1
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: i == segments.length - 1
                    ? AppColors.black
                    : AppColors.grey700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class HierarchySearchBar extends StatefulWidget {
  const HierarchySearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  State<HierarchySearchBar> createState() => _HierarchySearchBarState();
}

class _HierarchySearchBarState extends State<HierarchySearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.grey500),
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  widget.controller.clear();
                  widget.onChanged('');
                },
                icon: const Icon(Icons.close_rounded, color: AppColors.grey500),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

List<Map<String, dynamic>> filterHierarchyMembers(
  List<Map<String, dynamic>> members,
  String query,
) {
  final trimmed = query.trim().toLowerCase();
  if (trimmed.isEmpty) return members;

  return members.where((member) {
    final name = (member['name'] as String).toLowerCase();
    final id = (member['id'] as String).toLowerCase();
    final role = (member['role'] as String).toLowerCase();
    return name.contains(trimmed) ||
        id.contains(trimmed) ||
        role.contains(trimmed);
  }).toList();
}

String hierarchyInitials(String name) {
  return name
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0])
      .take(2)
      .join()
      .toUpperCase();
}

class HierarchyOwnerCard extends StatelessWidget {
  const HierarchyOwnerCard({
    super.key,
    required this.member,
    required this.onTap,
  });

  final Map<String, dynamic> member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = member['name'] as String;

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
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  member['role'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.grey100,
                  child: Text(
                    hierarchyInitials(name),
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  member['email'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey700,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'View Reporting Members',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HierarchyMemberCard extends StatelessWidget {
  const HierarchyMemberCard({
    super.key,
    required this.member,
    required this.onTap,
    this.reportLabel,
    this.showChevron = true,
  });

  final Map<String, dynamic> member;
  final VoidCallback? onTap;
  final String? reportLabel;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final name = member['name'] as String;
    final directReports = member['directReports'] as int?;

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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.grey100,
                  child: Text(
                    hierarchyInitials(name),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member['role'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        member['id'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        member['email'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey700,
                        ),
                      ),
                      if (reportLabel != null && directReports != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '$reportLabel : $directReports',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey900,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showChevron)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.grey500,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget hierarchyAppBar({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    backgroundColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      color: AppColors.black,
    ),
    title: Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
    ),
  );
}
