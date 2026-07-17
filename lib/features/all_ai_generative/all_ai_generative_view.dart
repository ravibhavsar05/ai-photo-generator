import 'package:ai_photo_generator/utils/app_icons.dart';
import 'package:ai_photo_generator/widgets/app_form_field.dart';
import 'package:ai_photo_generator/widgets/app_text.dart';
import 'package:ai_photo_generator/widgets/custom_button.dart';
import 'package:ai_photo_generator/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ai_photo_generator/utils/app_colors.dart';

import '../../widgets/app_cached_image.dart';
import 'all_ai_generative_controller.dart';

class AllAiGenerativeView extends GetView<AllAiGenerativeController> {
  const AllAiGenerativeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff090C11),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 16, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: 12.w),
                    AppText("Ai Generator", color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ],
                ),
                SizedBox(height: 14),
                AppText("Enter Prompt", fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                SizedBox(height: 14),
                Container(
                  width: 100.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff0B1726), // dark bg
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Stack(
                    children: [
                      /// TEXT FIELD
                      AppFormField(
                        filledColor: Color(0xff0B1726),
                        textColor: Colors.white,
                        isMultiline: true,
                        title:
                            "Describe what you want to see... e.g A Fut rustic cyberpunk city with neon lights and flying cars in the rain.",
                        textEditingController: controller.promptController,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final selectedImage = controller.imagePickerController.selectedImage.value;

                      return AppUploadButton(
                        icon: SvgPicture.asset(AppIcons.upload),
                        title: selectedImage == null ? "Upload Image" : "Change Image",
                        onTap: controller.imagePickerController.pickFromGallery,
                        width: double.infinity,
                      );
                    }),

                    /// 🔹 IMAGE PREVIEW (NOW BELOW ROW)
                    Obx(() {
                      final selectedImage = controller.imagePickerController.selectedImage.value;

                      if (selectedImage == null) return const SizedBox();

                      return Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(selectedImage, height: 42.h, width: double.infinity, fit: BoxFit.cover),
                            ),

                            ///  REMOVE BUTTON
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  controller.imagePickerController.clearImage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 16),
                AppText("Image Ratio", fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    imageRatioWidget("1:1"),
                    imageRatioWidget("3:2"),
                    imageRatioWidget("16:9"),
                    imageRatioWidget("9:16"),
                  ],
                ),
                SizedBox(height: 16),

                Obx(() {
                  return controller.showStyles.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "Image Style (Optional)",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            SizedBox(height: 14),
                            buildImageStyleGrid(),
                          ],
                        )
                      : const SizedBox(); // hide
                }),
                SizedBox(height: 14),
                Obx(() {
                  return AppButtonWidget(
                    onPressed: controller.isCreating.value ? null : controller.generateImage,
                    prefixIcon: SvgPicture.asset(AppIcons.aiIcon, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    text: "Generate Image",
                    width: 95.w,
                    height: 14.w,
                    textColor: Colors.white,
                    buttonColor: Color(0xff6F3FE3),
                    loader: controller.isCreating.value,
                    radius: 20,
                    //  CONNECTED
                  );
                }),
                SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4, // placeholder items
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        return ShimmerWidget(
          child: Container(
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(16)),
          ),
        );
      },
    );
  }

  Widget imageRatioWidget(String text) {
    return Obx(() {
      final isSelected = controller.selectedRatio.value == text;

      return Material(
        color: Colors.transparent,
        child: Ink(
          height: 12.w,
          width: 20.w,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withValues(alpha: 0.2) : const Color(0xff191929),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade700),
          ),
          child: InkWell(
            onTap: () => controller.selectRatio(text), // ✅ CONNECTED
            borderRadius: BorderRadius.circular(30),
            child: Center(
              child: AppText(text, fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
    });
  }

  Widget buildImageStyleGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return buildShimmerGrid();
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.generativeAiList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.15,
        ),
        itemBuilder: (context, index) {
          final item = controller.generativeAiList[index];

          return GestureDetector(
            onTap: () {
              controller.selectedIndex.value = index;
              controller.promptController.text = item.prompt!;
              controller.promptController.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.promptController.text.length),
              );
            },
            child: Obx(() {
              final isSelected = controller.selectedIndex.value == index;

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 2.5),
                  boxShadow: isSelected
                      ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 1)]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    children: [
                      // Image
                      Positioned.fill(
                        child: AppCachedImage(imageUrl: item.template.toString(), fit: BoxFit.cover),
                      ),
                      // Dark gradient overlay at the bottom for readability
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withValues(alpha: 0.9), Colors.black.withValues(alpha: 0.0)],
                            ),
                          ),
                          child: Text(
                            item.name.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      );
    });
  }
}

class AppUploadButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? icon;
  final double? width;

  const AppUploadButton({super.key, required this.title, required this.onTap, this.icon, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 45.w,
        padding: EdgeInsets.symmetric(vertical: 2.w),
        decoration: BoxDecoration(
          color: const Color(0xff191929), // dark background
          borderRadius: BorderRadius.circular(50), // pill shape
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.15), blurRadius: 20, spreadRadius: 1)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ICON
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
              child: icon,
            ),

            SizedBox(width: 1.w),

            /// TEXT
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
