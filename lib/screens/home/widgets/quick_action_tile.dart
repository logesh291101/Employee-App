import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const double kQuickActionTileHeight = 100;

class QuickAction {
  const QuickAction({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.action,
    required this.onTap,
    this.showShadow = false,
  });

  final QuickAction action;
  final VoidCallback onTap;
  final bool showShadow;

  static const double iconSize = 40;
  static const double iconTextSpacing = 8;

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
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 12, 6, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: iconSize,
                  width: iconSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      action.icon,
                      size: 20,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: iconTextSpacing),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      action.label.trim(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey900,
                        height: 1.2,
                      ),
                    ),
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
