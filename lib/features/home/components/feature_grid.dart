import 'package:ai_photo_generator/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../utils/screen_utils.dart';
import 'feature_card.dart';
import 'feature_card_model.dart';

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      FeatureCardModel(
        title: 'Remove BG',
        previewImage: AppAssets.removeBg,
        onTap: () => Get.toNamed(Routes.removeBg),
      ),
      FeatureCardModel(
        title: 'Face Swap',
        previewImage: AppAssets.faceSwap,
        onTap: () => Get.toNamed(Routes.faceSwap),
      ),
      FeatureCardModel(
        title: 'Enhance',
        previewImage: AppAssets.photoEnhancer,
        onTap: () => Get.toNamed(Routes.enhancePhoto),
      ),
      FeatureCardModel(
        title: 'Restore',
        previewImage: AppAssets.oldPhotoRestore,
        onTap: () => Get.toNamed(Routes.oldPhotoRestore),
      ),
    ];

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 3.w,
        crossAxisSpacing: 3.w,
        childAspectRatio: 1.03,
      ),
      itemBuilder: (context, index) {
        return FeatureCard(model: features[index]);
      },
    );
  }
}