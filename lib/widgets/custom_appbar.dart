import 'package:ai_photo_generator/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../core/theme/styles.dart';
import 'app_text.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onQuestionPressed;
  final VoidCallback? onBack;
  final bool showQuestionIcon;
  final IconData icon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onQuestionPressed,
    this.onBack,
    this.showQuestionIcon = false,
    this.icon = Icons.question_mark,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.surface0,
      surfaceTintColor: Colors.transparent,

      /// 🔥 SOFT SHADOW UNDER APPBAR
      flexibleSpace: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      ),

      /// 🔹 TITLE
      title: AppText(
        title,
        type: AppTextType.heading2,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),

      /// 🔹 BACK BUTTON
      leading: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onBack ?? () => Get.back(),
          child: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: AppColors.surface1,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderColor),
              boxShadow: AppShadows.soft,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),

      /// 🔹 ACTIONS
      actions: showQuestionIcon
          ? [
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onQuestionPressed,
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                gradient: AppColors.ctaGradient,
                shape: BoxShape.circle,
                boxShadow: AppShadows.glow,
              ),
              child: Icon(
                icon,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]
          : null,
    );
  }
}