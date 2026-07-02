import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
  });

  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: onMenuTap,
        icon: const Icon(Icons.menu_rounded),
        color: AppColors.black,
      ),
      title: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/veda_group_logo.png',
          height: 32,
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onNotificationTap,
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.black,
          tooltip: 'Notifications',
        ),
      ],
    );
  }
}
