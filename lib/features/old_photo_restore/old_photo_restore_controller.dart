import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/base/base_controller.dart';
import '../../core/controllers/image_picker_controller.dart';
import '../../core/routes/app_routes.dart';
import 'package:ai_photo_generator/domain/use_cases/image_generate_use_case/image_generate_use_case.dart';
import 'package:ai_photo_generator/utils/app_utils.dart';
import 'package:ai_photo_generator/utils/app_prompts.dart';
import '../history/services/history_service.dart';

class OldPhotoRestoreController extends BaseController {
  late final ImagePickerController imagePickerController;
  final generateImageUseCase = Get.find<ImageGenerateUseCase>();

  final RxBool isLoading = false.obs;

  // Using oldPhotoRestorePrompt from AppPrompts

  @override
  void onInit() {
    super.onInit();
    imagePickerController = Get.put(ImagePickerController());
  }

  void resetInputs() {
    imagePickerController.clearImage();
  }

  generateImage() async {
    final selectedFile = imagePickerController.selectedImage.value;
    if (selectedFile == null) {
      AppUtils.showSnack(
        title: "Error",
        message: "Please select an image first",
      );
      return;
    }

    isLoading.value = true;
    try {
      final userImageBytes = await selectedFile.readAsBytes();

      final response = await generateImageUseCase.generateImage(
        userImage: userImageBytes,
        prompt: oldPhotoRestorePrompt,
      );

      response.fold(
        (error) {
          AppUtils.showSnack(title: error.title, message: error.description);
        },
        (success) {
          final Uint8List? imageBytes = success.imageBytes;
          if (imageBytes != null && imageBytes.isNotEmpty) {
            HistoryService.saveToHistory(
              imageBytes: imageBytes,
              title: "Restored Photo",
              featureName: "Old Photo Restore",
            );

            resetInputs();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.toNamed(Routes.photoResultView, arguments: imageBytes);
            });
          } else {
            AppUtils.showSnack(
              title: "Error",
              message: "No image data found in response",
            );
          }
        },
      );
    } catch (e) {
      AppUtils.showSnack(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
