import 'package:flutter/material.dart';
import 'package:ai_photo_generator/utils/app_icons.dart';
import 'package:ai_photo_generator/utils/screen_utils.dart';
import '../../../core/theme/styles.dart';
import 'dashboard_nav_item.dart';

class DashboardNavbar extends StatelessWidget {
  const DashboardNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        // border: Border.all(color: AppColors.borderColor),
        boxShadow: AppShadows.medium,
      ),
      child: Row(
        children: const [
          Expanded(
            child: DashboardNavItem(icon: AppIcons.home, title: 'Home', index: 0),
          ),
          Expanded(
            child: DashboardNavItem(icon: AppIcons.history, title: 'Collection', index: 1),
          ),
        ],
      ),
    );
  }
}
