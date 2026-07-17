import 'package:ai_photo_generator/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/styles.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/app_text.dart';
import 'feature_card_model.dart';


class FeatureCard extends StatelessWidget {
  final FeatureCardModel model;

  const FeatureCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: AppShadows.soft,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: model.onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(model.previewImage, fit: BoxFit.cover),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withValues(alpha: .65), Colors.transparent],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          model.title,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: AppColors.overlayLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 2.h,
                  left: 3.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: .5.h),
                    decoration: BoxDecoration(
                      gradient: AppColors.heroGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText("AI", fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
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