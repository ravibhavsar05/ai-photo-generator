import 'package:ai_photo_generator/utils/app_colors.dart';
import 'package:ai_photo_generator/utils/app_utils.dart';
import 'package:ai_photo_generator/utils/app_icons.dart';
import 'package:ai_photo_generator/utils/screen_utils.dart';
import 'package:ai_photo_generator/widgets/app_text.dart';
import 'package:ai_photo_generator/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../widgets/app_form_field.dart';
import '../../widgets/custom_appbar.dart';
import 'prompt_to_image_controller.dart';

class PromptToImageView extends GetView<PromptToImageController> {
  const PromptToImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface0,
      appBar: CustomAppBar(title: 'Prompt to Image'),
      body: KeyboardActions(
        config: _buildConfig(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText('Enter Prompt', fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                SizedBox(height: 0.5.h),

                AppFormField(
                  textEditingController: controller.promptController,
                  focusNode: controller.promptFocusNode,
                  isMultiline: true,
                  showBorder: true,
                  title:
                      'Describe what you want to see... e.g A Fut rustic cyberpunk city with neon lights and flying cars in the rain.',
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 0.5.h),

                // Image Upload & Preview Section
                Obx(() {
                  final selectedImage =
                      controller.imagePickerController.selectedImage.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedImage != null) ...[
                        SizedBox(height: 1.h),
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImage,
                                height: 15.h,
                                width: 20.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  controller
                                          .imagePickerController
                                          .selectedImage
                                          .value =
                                      null;
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                      ],

                      AppButtonWidget(
                        text: selectedImage == null
                            ? "Upload Image (Optional)"
                            : "Change Image",
                        buttonColor: AppColors.secondary,
                        textColor: AppColors.primary,
                        height: 4.h,
                        radius: 5.w,
                        prefixIcon: SvgPicture.asset(
                          AppIcons.upload,
                          height: 2.h,
                        ),
                        alignment: Alignment.centerRight,
                        onPressed:
                            controller.imagePickerController.pickFromGallery,
                      ),
                    ],
                  );
                }),

                SizedBox(height: 1.h),

                AppText('Choose Style', fontWeight: FontWeight.w600),
                SizedBox(height: 1.h),

                SizedBox(
                  height: 18.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.styles.length,
                    itemBuilder: (context, index) {
                      final item = controller.styles[index];
                      return Obx(() {
                        final isSelected =
                            controller.selectedStyle.value == index;
                        return GestureDetector(
                          onTap: () => controller.selectStyle(index),
                          child: Column(
                            children: [
                              Container(
                                width: 25.w,
                                height: 12.h,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.borderColor,
                                    width: 2,
                                  ),
                                  color: AppColors.surface1,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: item['icon'] == true
                                      ? Container(
                                          color: Colors.grey.shade100,
                                          child: const Icon(
                                            Icons.block,
                                            size: 45,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Image.asset(
                                          item['image'] as String,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: AppText(
                                  item['title'] as String,
                                  textAlign: TextAlign.center,
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                ),

                SizedBox(height: 0.5.h),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText('Aspect Ratio', fontWeight: FontWeight.w600),

                      SizedBox(height: 1.h),

                      SizedBox(
                        height: 10.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.aspects.length,
                          itemBuilder: (context, index) {
                            return Obx(() {
                              final isSelected =
                                  controller.selectedAspect.value == index;
                              final isCustom =
                                  index == controller.aspects.length - 1;
                              String label = controller.aspects[index];
                              if (isCustom &&
                                  controller
                                      .customAspectRatio
                                      .value
                                      .isNotEmpty &&
                                  isSelected) {
                                label =
                                    "Custom (${controller.customAspectRatio.value})";
                              }

                              return GestureDetector(
                                onTap: () {
                                  if (isCustom) {
                                    _showCustomAspectSheet(context);
                                  } else {
                                    controller.customAspectRatio.value='';
                                    controller.selectAspect(index);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.borderColor,
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? AppUtils().withOpacity(
                                            color: AppColors.primary,
                                            opacity: .2,
                                          )
                                        : Colors.transparent,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        index == 0
                                            ? Icons.crop_square
                                            : index == 1
                                            ? Icons.crop_portrait
                                            : index == 2
                                            ? Icons.crop_landscape
                                            : Icons.add,
                                        size: 35,
                                        color: isSelected
                                            ? Colors.purple
                                            : AppColors.textSecondary,
                                      ),
                                      SizedBox(height: 0.5.h),
                                      AppText(
                                        label,
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                Obx(
                  () => AppButtonWidget(
                    text: controller.isLoading.value
                        ? "Generating..."
                        : "Generate Art",
                    width: 100.w,
                    height: 6.h,
                    radius: 10.w,
                    onPressed: controller.isLoading.value
                        ? () {}
                        : controller.generateImage,
                    prefixIcon: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.auto_awesome,
                            color: AppColors.white,
                            size: 30,
                          ),
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomAspectSheet(BuildContext context) {
    final ratioController = TextEditingController(
      text: controller.customAspectRatio.value,
    );

    String previousText = ratioController.text;
    ratioController.addListener(() {
      final text = ratioController.text;
      if (text.length > previousText.length &&
          text.length == 1 &&
          RegExp(r'^\d$').hasMatch(text) &&
          !text.contains(':')) {
        ratioController.text = '$text:';
        ratioController.selection = TextSelection.fromPosition(
          TextPosition(offset: ratioController.text.length),
        );
      }
      previousText = text;
    });

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Custom Aspect Ratio',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 1.h),
            AppFormField(
              textEditingController: ratioController,
              isMultiline: false,
              showBorder: true,
              textInputType: TextInputType.number,
              title: 'Enter ratio (e.g. 9:16)',
            ),
            SizedBox(height: 2.h),
            AppButtonWidget(
              text: 'Apply',
              width: double.infinity,
              height: 5.h,
              radius: 10.w,
              onPressed: () {
                final value = ratioController.text.trim();
                final regex = RegExp(r'^\d+:\d+$');
                if (!regex.hasMatch(value)) {
                  AppUtils.showSnack(
                    title: "Invalid ratio",
                    message: "Please enter a ratio like 9:16 or 4:8",
                  );
                  return;
                }
                final parts = value.split(':');
                if (parts.length != 2 ||
                    parts[0].length > 2 ||
                    parts[1].length > 2) {
                  AppUtils.showErrorSnack(
                    title: "Invalid ratio",
                    message: "Each side must be 1–2 digits, like 1:1 or 10:10",
                  );
                  return;
                }
                controller.customAspectRatio.value = value;
                controller.selectAspect(controller.aspects.length - 1);
                Get.back();
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: AppColors.cardBg,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: controller.promptFocusNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppText(
                    "Done",
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }
}
