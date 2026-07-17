import 'dart:io';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../core/controllers/crop_image_controller.dart';
import '../utils/app_colors.dart';
import 'app_text.dart';

class CropImageView extends StatefulWidget {
  final File imageFile;

  const CropImageView({super.key, required this.imageFile});

  @override
  State<CropImageView> createState() => _CropImageViewState();
}

class _CropImageViewState extends State<CropImageView> {
  late final CropImageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CropImageController(widget.imageFile));
  }

  @override
  void dispose() {
    Get.delete<CropImageController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff090C11),
      // appBar: const CustomAppBar(title: 'Crop Image'),
      body: Obx(() {
        if (controller.imageBytes.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            SizedBox(height: 7.w.sp,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(

                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                      child: Icon(Icons.arrow_back, color: Colors.white,)),
                  SizedBox(width: 10.w.sp,),
                  AppText("Crop Image", fontSize: 20,color: Colors.white,)
                ],
              ),
            ),

            SizedBox(height: 2.h),
            _buildAspectRatio(controller),
            SizedBox(height: 1.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.w),
                  child: Crop(
                    controller: controller.cropController,
                    image: controller.imageBytes.value!,
                    aspectRatio: controller.aspectRatio.value,
                    maskColor: Colors.black.withValues(alpha: 0.5),
                    baseColor: Colors.black,
                    onCropped: controller.handleCropped,
                  ),
                ),
              ),
            ),
            if (controller.croppedPreview.value != null)
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Container(
                  height: 18.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.w),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Image.memory(
                    controller.croppedPreview.value!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            SizedBox(height: 1.h),
            _buildTransformControls(controller),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      text: "Preview",
                      onTap: () => controller.startCropping(returnResult: false),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _buildButton(
                      text: "Done",
                      isPrimary: true,
                      onTap: () => controller.startCropping(returnResult: true),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAspectRatio(
      CropImageController controller) {
    final ratios = {
      'Free': null,
      '1:1': 1.0,
      '4:3': 4 / 3,
      '16:9': 16 / 9,
    };

    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: ratios.entries.map((entry) {
          return Expanded(
            child: GestureDetector(
              onTap: () => controller
                  .setAspectRatio(entry.value),
              child: Container(
                height: 4.5.h,
                margin: EdgeInsets.symmetric(
                    horizontal: 1.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(50),
                  border: Border.all(

                      color:
                      AppColors.textGrey),
                ),
                child: AppText(
                  entry.key,
                  type: AppTextType.caption,
                  color:
                  AppColors.white,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransformControls(
      CropImageController controller) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          _iconButton(Icons.rotate_left,
              controller.rotateLeft),
          _iconButton(Icons.rotate_right,
              controller.rotateRight),
          _iconButton(
              Icons.flip, controller.toggleFlipX),
          _iconButton(Icons.flip_camera_android,
              controller.toggleFlipY),
        ],
      ),
    );
  }

  Widget _iconButton(
      IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 5.h,
          margin: EdgeInsets.symmetric(
              horizontal: 1.w),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(50),
            border: Border.all(
                color: AppColors.textGrey),
          ),
          child:
          Icon(icon, color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 6.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary
                  .withValues(alpha: 0.7),
            ],
          )
              : null,
          color:
          isPrimary ? null : AppColors.surface1,
          borderRadius:
          BorderRadius.circular(30),
        ),
        child: AppText(
          text,
          type: AppTextType.heading2,
          color:
          isPrimary ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}