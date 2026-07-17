import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/screen_utils.dart';

class HistoryDateHeader extends StatelessWidget {
  final String date;

  const HistoryDateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 3.w, vertical: .6.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            date,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}