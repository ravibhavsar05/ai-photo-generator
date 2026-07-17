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

class RemoveBgController extends BaseController {
  late final ImagePickerController imagePickerController;
  final generateImageUseCase = Get.find<ImageGenerateUseCase>();

  final promptController = TextEditingController();
  final FocusNode promptFocusNode = FocusNode();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    imagePickerController = Get.put(ImagePickerController());
    promptController.text = bgRemovalPrompt;
  }

  @override
  void onClose() {
    promptController.dispose();
    promptFocusNode.dispose();
    super.onClose();
  }

  void resetInputs() {
    imagePickerController.clearImage();
    promptController.text = bgRemovalPrompt;
  }

  generateImage() async {
    final selectedFile = imagePickerController.selectedImage.value;
    if (selectedFile == null) {
      AppUtils.showSnack(title: "Error", message: "Please select an image first");
      return;
    }

    isLoading.value = true;
    try {
      final userImageBytes = await selectedFile.readAsBytes();
      final String promptText = promptController.text.trim().isNotEmpty
          ? promptController.text.trim()
          : bgRemovalPrompt;

      final response = await generateImageUseCase.generateImage(userImage: userImageBytes, prompt: promptText);

      response.fold(
        (error) {
          AppUtils.showSnack(title: error.title, message: error.description);
        },
        (success) {
          final Uint8List? imageBytes = success.imageBytes;
          if (imageBytes != null && imageBytes.isNotEmpty) {
            HistoryService.saveToHistory(
              imageBytes: imageBytes,
              title: "Background Removed",
              featureName: "Remove Background",
            );

            resetInputs();

            Get.toNamed(Routes.photoResultView, arguments: imageBytes);
          } else {
            AppUtils.showSnack(title: "Error", message: "No image data found in response");
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
