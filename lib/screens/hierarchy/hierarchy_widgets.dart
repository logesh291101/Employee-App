import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String hierarchyInitials(String name) {
  return name
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0])
      .take(2)
      .join()
      .toUpperCase();
}

class HierarchyEmployeeCard extends StatelessWidget {
  const HierarchyEmployeeCard({
    super.key,
    required this.name,
    this.role,
    this.email,
    this.profilePic,
    this.hasChildren = false,
    this.isExpanded = false,
    this.onTap,
  });

  final String name;
  final String? role;
  final String? email;
  final String? profilePic;
  final bool hasChildren;
  final bool isExpanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pic = profilePic?.trim();

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
                color: AppColors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileAvatar(name: name, profilePic: pic),
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
                      if (role != null && role!.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          role!,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey700,
                          ),
                        ),
                      ],
                      if (email != null && email!.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          email!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey700,
                          ),
                        ),
                      ],
                      if (hasChildren) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: AppColors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isExpanded
                                  ? 'Hide Reporting Members'
                                  : 'View Reporting Members',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.name,
    this.profilePic,
  });

  final String name;
  final String? profilePic;

  @override
  Widget build(BuildContext context) {
    final hasImage = profilePic != null && profilePic!.isNotEmpty;

    if (hasImage) {
      return ClipOval(
        child: Image.network(
          profilePic!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _initialsAvatar(),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return SizedBox(
              width: 52,
              height: 52,
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.grey500.withValues(alpha: 0.8),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return _initialsAvatar();
  }

  Widget _initialsAvatar() {
    return CircleAvatar(
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
