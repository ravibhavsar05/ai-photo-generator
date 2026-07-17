import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';
import '../../widgets/app_text.dart';
import '../../widgets/crop_image_view.dart';
import '../../widgets/custom_appbar.dart';
import 'old_photo_restore_controller.dart';

class OldPhotoRestoreView extends GetView<OldPhotoRestoreController> {
  const OldPhotoRestoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface0,
      appBar: const CustomAppBar(title: 'Restore Photo'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildContent()),
              SizedBox(height: 2.h),
              _buildRestoreButton(),
            ],
          ),
        ),
      ),
    );
  }

   Future<void> _pickAndCropFromGallery() async {
    await controller.imagePickerController.pickFromGallery();
    final file = controller.imagePickerController.selectedImage.value;
    if (file == null) return;

    final croppedBytes = await Get.to<Uint8List?>(
          () => CropImageView(imageFile: file),
    );
    if (croppedBytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final croppedFile = await File(
      '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png',
    ).create();
    await croppedFile.writeAsBytes(croppedBytes);
    controller.imagePickerController.selectedImage.value = croppedFile;
  }

   Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),

          /// SAME HEADER STYLE
          Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.primary, size: 26),
              SizedBox(width: 2.w),
              AppText(
                "AI Old Photo Restore",
                type: AppTextType.heading1,
                color: AppColors.textPrimary,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          /// SAME CARD STYLE
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.circular(4.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Obx(() {
              final selected =
                  controller.imagePickerController.selectedImage.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: selected == null
                        ? _pickAndCropFromGallery
                        : null,
                    child: Container(
                      height: 30.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(
                          color: selected != null
                              ? AppColors.primary
                              : AppColors.borderColor,
                        ),
                        image: selected != null
                            ? DecorationImage(
                          image: FileImage(selected),
                          fit: BoxFit.contain,
                        )
                            : null,
                      ),
                      child: selected == null
                          ? Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.upload,
                            height: 5.h,
                          ),
                          SizedBox(height: 1.h),
                          AppText(
                            "Upload Old Photo",
                            type: AppTextType.heading2,
                            color: AppColors.textPrimary,
                          ),
                          AppText(
                            "Tap to select from gallery",
                            type: AppTextType.caption,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      )
                          : Stack(
                        children: [
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                controller
                                    .imagePickerController
                                    .clearImage();
                              },
                              child: Container(
                                padding:
                                const EdgeInsets.all(5),
                                decoration:
                                const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 1.h),

                  AppText(
                    selected == null
                        ? "Select an old photo to restore"
                        : "Ready to restore",
                    type: AppTextType.caption,
                    color: AppColors.textSecondary,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

   Widget _buildRestoreButton() {
    return Obx(
          () => GestureDetector(
        onTap: controller.isLoading.value
            ? null
            : controller.generateImage,
        child: Container(
          height: 6.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: controller.isLoading.value
                ? const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.auto_awesome,
                    color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Restore Photo",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
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