import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.employeeId,
    required this.email,
    required this.mobile,
    this.role,
    this.profileImageUrl,
  });

  final String name;
  final String employeeId;
  final String email;
  final String mobile;
  final String? role;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Hero(
            tag: 'profile_avatar',
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.white.withOpacity(0.15),
                backgroundImage: _hasProfileImage
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: _hasProfileImage
                    ? null
                    : Text(
                        _initials,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          if (role != null && role!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              role!,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.white.withOpacity(0.9),
              ),
            ),
          ],
          const SizedBox(height: 16),
          _InfoChip(icon: Icons.badge_outlined, label: employeeId),
          const SizedBox(height: 8),
          _InfoChip(icon: Icons.email_outlined, label: email),
          const SizedBox(height: 8),
          _InfoChip(icon: Icons.phone_outlined, label: mobile),
        ],
      ),
    );
  }

  bool get _hasProfileImage =>
      profileImageUrl != null && profileImageUrl!.trim().isNotEmpty;

  String get _initials {
    final parts = name
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.white.withOpacity(0.9)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
