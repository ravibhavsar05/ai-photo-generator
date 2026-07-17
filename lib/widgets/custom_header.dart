import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class CustomHeader extends StatelessWidget {
  final String title,subtitle;
  final VoidCallback? onSubtitleTap;
  const CustomHeader({super.key, required this.title, required this.subtitle, this.onSubtitleTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          title,
          type: AppTextType.heading1,
          color: AppColors.textPrimary,
        ),
        if (subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onSubtitleTap,
              child: AppText(
                subtitle,
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
