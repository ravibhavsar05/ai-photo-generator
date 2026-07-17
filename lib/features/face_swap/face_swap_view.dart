import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../widgets/app_text.dart';
import '../../widgets/crop_image_view.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/shimmer_widget.dart';
import 'face_swap_controller.dart';

class FaceSwapView extends GetView<FaceSwapController> {
  const FaceSwapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface0,
      appBar: const CustomAppBar(title: 'Swap Face'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildContent()),
              SizedBox(height: 2.h),
              _buildGenerateButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= PICK & CROP =================
  Future<void> _pickAndCropFromGallery() async {
    await controller.imagePickerController.pickFromGallery();
    final file = controller.imagePickerController.selectedImage.value;
    if (file == null) return;

    final croppedBytes = await Get.to<Uint8List?>(() => CropImageView(imageFile: file));
    if (croppedBytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final croppedFile = await File('${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png').create();
    await croppedFile.writeAsBytes(croppedBytes);
    controller.imagePickerController.selectedImage.value = croppedFile;
  }

  /// ================= MAIN CONTENT =================
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),

          /// Header
          Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.primary, size: 26),
              SizedBox(width: 2.w),
              AppText("AI Face Swap", type: AppTextType.heading1, color: AppColors.textPrimary),
            ],
          ),

          SizedBox(height: 2.h),

          /// Source & Target Card
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.circular(4.w),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              children: [
                Expanded(child: _buildSourceImage()),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: _buildSwapIcon(),
                ),

                Expanded(child: _buildTargetImage()),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          _buildTemplates(),
        ],
      ),
    );
  }

  /// ================= SWAP ICON =================
  Widget _buildSwapIcon() {
    return Container(
      height: 9.h,
      width: 9.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.6)]),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 15)],
      ),
      child: const Icon(Icons.swap_horiz, color: Colors.white, size: 30),
    );
  }

  /// ================= SOURCE IMAGE =================
  Widget _buildSourceImage() {
    return GestureDetector(
      onTap: _pickAndCropFromGallery,
      child: Obx(() {
        final selected = controller.imagePickerController.selectedImage.value;

        return Container(
          height: 20.h,
          width: 35.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(color: AppColors.borderColor),
            image: selected != null ? DecorationImage(image: FileImage(selected), fit: BoxFit.cover) : null,
          ),
          child: selected == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload, size: 28, color: AppColors.primary),
                    SizedBox(height: 1.h),
                    AppText("   ", type: AppTextType.caption, color: AppColors.textSecondary),
                  ],
                )
              : null,
        );
      }),
    );
  }

  Widget _buildTargetImage() {
    return Obx(
      () => Container(
        height: 20.h,
        width: 35.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.w),
          child: controller.selectedTargetImage.value.isEmpty
              ? Center(
                  child: AppText("Select Face", type: AppTextType.caption, color: AppColors.textSecondary),
                )
              : (controller.selectedTargetImage.value.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: controller.selectedTargetImage.value,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => ShimmerWidget(child: Container(color: Colors.white)),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      )
                    : Image.asset(
                        controller.selectedTargetImage.value,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      )),
        ),
      ),
    );
  }

  /// ================= TEMPLATES =================
  Widget _buildTemplates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText("Select Target Face", type: AppTextType.heading1, color: AppColors.textPrimary),
        SizedBox(height: 1.h),

        SizedBox(
          height: 20.h, // Reduced height
          child: Obx(() {
            if (controller.isTemplatesLoading.value) {
              return GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 👈 2 Rows
                  mainAxisSpacing: 2.w,
                  crossAxisSpacing: 2.w,
                  childAspectRatio: 0.75,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ShimmerWidget(
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.w), color: Colors.white),
                    ),
                  );
                },
              );
            }

            return GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 👈 2 Rows
                mainAxisSpacing: 2.w,
                crossAxisSpacing: 2.w,
                childAspectRatio: 0.75,
              ),
              itemCount: controller.generativeAiList.length,
              itemBuilder: (context, index) {
                final item = controller.generativeAiList[index];

                return Obx(() {
                  final isSelected = controller.selectedTargetImage.value == item.template;

                  return GestureDetector(
                    onTap: () {
                      if (item.template != null) {
                        controller.selectImage(item.template!);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: isSelected ? Matrix4.diagonal3Values(1.04, 1.04, 1.0) : Matrix4.identity(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3.w),
                        child: Stack(
                          children: [
                            /// Image
                            Positioned.fill(
                              child: item.template != null
                                  ? (item.template!.startsWith('http')
                                        ? CachedNetworkImage(
                                            imageUrl: item.template!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                ShimmerWidget(child: Container(color: Colors.white)),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          )
                                        : Image.asset(
                                            item.template!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                          ))
                                  : const SizedBox(),
                            ),

                            /// Selected Check
                            if (isSelected)
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            );
          }),
        ),
      ],
    );
  }

  /// ================= GENERATE BUTTON =================
  Widget _buildGenerateButton() {
    return Obx(
      () => GestureDetector(
        onTap: controller.isLoading.value ? null : controller.generateImage,
        child: Container(
          height: 6.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)]),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 6)),
            ],
          ),
          child: Center(
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.auto_awesome, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Generate Face Swap",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
