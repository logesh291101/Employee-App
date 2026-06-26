import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialFeedCard extends StatelessWidget {
  const SocialFeedCard({
    super.key,
    required this.authorName,
    required this.caption,
    required this.tag,
    required this.timeLabel,
    required this.likeCount,
    required this.isLiked,
    required this.isVideo,
    this.imageAsset,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  final String authorName;
  final String caption;
  final String tag;
  final String timeLabel;
  final int likeCount;
  final bool isLiked;
  final bool isVideo;
  final String? imageAsset;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.grey100,
                  child: Text(
                    authorName.isNotEmpty
                        ? authorName[0].toUpperCase()
                        : 'E',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        timeLabel,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildMedia(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tag.isNotEmpty) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: Text(
                      '#$tag',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Text(
                  caption,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: Row(
              children: [
                _FeedActionButton(
                  icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  label: '$likeCount',
                  isActive: isLiked,
                  onTap: onLike,
                ),
                _FeedActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Comment',
                  onTap: onComment,
                ),
                _FeedActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: onShare,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedia() {
    if (isVideo) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: AppColors.charcoal,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (imageAsset != null)
                Image.asset(
                  imageAsset!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  color: AppColors.black.withOpacity(0.35),
                  colorBlendMode: BlendMode.darken,
                ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 32,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (imageAsset != null) {
      return Image.asset(
        imageAsset!,
        width: double.infinity,
        fit: BoxFit.cover,
        height: 220,
      );
    }

    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
      ),
      child: const Icon(
        Icons.image_outlined,
        size: 48,
        color: AppColors.white,
      ),
    );
  }
}

class _FeedActionButton extends StatelessWidget {
  const _FeedActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive ? AppColors.error : AppColors.black,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isActive ? AppColors.error : AppColors.grey700,
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
