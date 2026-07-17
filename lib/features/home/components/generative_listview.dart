import 'package:ai_photo_generator/core/routes/app_routes.dart';
import 'package:ai_photo_generator/features/home/home_controller.dart';
import 'package:ai_photo_generator/widgets/app_text.dart';
import 'package:ai_photo_generator/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import 'generative_card_list.dart';

class GenerativeListview extends GetView<HomeController> {
  const GenerativeListview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24.h,
          child: Obx(() {
            if (controller.isLoading.value) {
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => SizedBox(width: 4.w),
                itemBuilder: (_, __) {
                  return ShimmerWidget(
                    child: Container(
                      width: 30.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  );
                },
              );
            }

            if (controller.generativeAiList.isEmpty) {
              return Center(
                child: AppText(
                  'No AI templates available',
                  color: AppColors.textSecondary,
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.generativeAiList.length,
              separatorBuilder: (_, __) => SizedBox(width: 4.w),
              itemBuilder: (context, index) {
                final item = controller.generativeAiList[index];

                return GenerativeCard(
                  title: "AI Template",
                  imageUrl: item.template ?? '',
                  onTap: () {
                    Get.toNamed(Routes.faceSwap, arguments: item);
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}