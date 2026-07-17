import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';
import '../../widgets/app_form_field.dart';
import '../../widgets/app_text.dart';
import '../../widgets/crop_image_view.dart';
import '../../widgets/custom_button.dart';
import 'remove_bg_controller.dart';

class RemoveBgView extends GetView<RemoveBgController> {
  const RemoveBgView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff090C11),
      // appBar: const CustomAppBar(title: 'Remove Background'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 22,),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
                SizedBox(width: 12.w,),
                AppText(
                  "Remove Background",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),

              ],
            ),
            SizedBox(height: 12,),
            ///  SUBTITLE (no duplicate title)
            AppText(
              "Upload an image and remove its background instantly using AI.",
              type: AppTextType.caption,
              color: AppColors.textSecondary,
            ),

            SizedBox(height: 2.h),

            AppText(
              "Refinement Prompt",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            SizedBox(height: 1.h),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff0B1726),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: AppFormField(
                filledColor: const Color(0xff0B1726),
                textColor: Colors.white,
                isMultiline: true,
                title: "e.g. Replace the background with a white background while preserving the person.",
                textEditingController: controller.promptController,
                focusNode: controller.promptFocusNode,
              ),
            ),

            SizedBox(height: 2.5.h),

            ///  MAIN UPLOAD ZONE
            Expanded(child: _buildUploadArea()),

            SizedBox(height: 2.h),

            /// CTA
            Obx(
                  () => AppButtonWidget(
                text: controller.isLoading.value
                    ? "Processing..."
                    : "Download Image",
                isGradient: true,
                width: double.infinity,
                height: 6.5.h,
                radius: 30,
                onPressed: controller.isLoading.value
                    ? () {}
                    : controller.generateImage,
                prefixIcon: controller.isLoading.value
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.auto_awesome, color: Colors.white),
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  /// =============================
  /// Upload Area
  /// =============================
  Widget _buildUploadArea() {
    return Obx(() {
      final selected =
          controller.imagePickerController.selectedImage.value;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff0B141D),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: .2),
            width: 1.5,
          ),
        ),
        child: selected != null
            ? _buildSelectedImage(selected)
            : _buildEmptyState(),
      );
    });
  }

  /// =============================
  /// Selected Image
  /// =============================
  Widget _buildSelectedImage(File file) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.file(
            file,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: controller.imagePickerController.clearImage,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.close,
                  size: 18, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  /// =============================
  /// Empty State
  /// =============================
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Icon(
          Icons.image_outlined,
          size: 60,
          color: AppColors.primary.withValues(alpha: .6),
        ),

        SizedBox(height: 2.h),

        AppText(
          "Select an Image",
          type: AppTextType.heading2,
          color: AppColors.white,
        ),

        SizedBox(height: 0.5.h),

        AppText(
          "Choose from gallery or take a new photo.",
          type: AppTextType.caption,
          color: AppColors.white,
        ),

        SizedBox(height: 3.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _actionButton(
              icon: AppIcons.upload,
              label: "Gallery",
              onTap: _pickAndCropFromGallery,
              isSvg: true,
            ),
            SizedBox(width: 6.w),
            _actionButton(
              icon: "",
              label: "Camera",
              onTap: _openCameraAndCrop,
              isSvg: false,
            ),
          ],
        ),

        SizedBox(height: 8.h),

        /// Tip
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            children: [
              Icon(Icons.lightbulb,
                  color: AppColors.primary, size: 18),
              SizedBox(width: 2.w),
              Expanded(
                child: AppText(
                  "Use clear lighting and good contrast for best results.",
                  type: AppTextType.caption,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required bool isSvg,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: AppColors().gradient,
              shape: BoxShape.circle,
            ),
            child: isSvg
                ? SvgPicture.asset(
              icon,
              height: 4.h,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            )
                : Icon(Icons.camera_alt,
                size: 4.h, color: Colors.white),
          ),
          SizedBox(height: 1.h),
          AppText(
            label,
            type: AppTextType.caption,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }

  /// Image pick logic remains same
  Future<void> _pickAndCropFromGallery() async {
    await controller.imagePickerController.pickFromGallery();
    final file = controller.imagePickerController.selectedImage.value;
    if (file == null) return;

    final croppedBytes =
    await Get.to<Uint8List?>(() => CropImageView(imageFile: file));
    if (croppedBytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final croppedFile = await File(
      '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png',
    ).create();
    await croppedFile.writeAsBytes(croppedBytes);
    controller.imagePickerController.selectedImage.value = croppedFile;
  }

  Future<void> _openCameraAndCrop() async {
    await controller.imagePickerController.openCamera();
    final file = controller.imagePickerController.selectedImage.value;
    if (file == null) return;

    final croppedBytes =
    await Get.to<Uint8List?>(() => CropImageView(imageFile: file));
    if (croppedBytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final croppedFile = await File(
      '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png',
    ).create();
    await croppedFile.writeAsBytes(croppedBytes);
    controller.imagePickerController.selectedImage.value = croppedFile;
  }
}