import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DashboardTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onMenuTap;
  final bool showMenuButton;

  const DashboardTopBar({
    super.key,
    this.title = 'Dashboard',
    this.onMenuTap,
    this.showMenuButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showMenuButton) ...[
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
