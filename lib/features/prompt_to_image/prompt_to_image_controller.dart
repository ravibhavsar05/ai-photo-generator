import 'dart:typed_data';
import 'package:ai_photo_generator/core/routes/app_routes.dart';
import 'package:ai_photo_generator/utils/app_assets.dart';
import 'package:ai_photo_generator/utils/app_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../core/base/base_controller.dart';
import '../../core/controllers/image_picker_controller.dart';
import 'package:ai_photo_generator/domain/use_cases/image_generate_use_case/image_generate_use_case.dart';
import '../history/services/history_service.dart';

class PromptToImageController extends BaseController {
  late final ImagePickerController imagePickerController;
  final generateImageUseCase = Get.find<ImageGenerateUseCase>();

  final promptController = TextEditingController();
  final FocusNode promptFocusNode = FocusNode();
  final RxBool isLoading = false.obs;

  final selectedStyle = 0.obs;
  final selectedAspect = 0.obs;
  final RxString customAspectRatio = ''.obs;

  final styles = [
    {'title': 'None', 'icon': true},
    {'title': 'Realistic', 'image': AppAssets.realistic},
    {'title': 'Anime', 'image': AppAssets.anime},
    {'title': 'Cyberpunk', 'image': AppAssets.ai_1,},
    {'title': 'Studio Light', 'image': AppAssets.studioLight,},
    {'title': 'Digital Painting', 'image': AppAssets.digitalPainting,},
    {'title': 'Ultra Realistic', 'image': AppAssets.ultraRealistic,},
  ];

  final aspects = ['Square', 'Vertical', 'Horizontal', 'Custom'];

  @override
  void onInit() {
    super.onInit();
    imagePickerController = Get.put(ImagePickerController());
  }

  @override
  void onClose() {
    promptController.dispose();
    promptFocusNode.dispose();
    super.onClose();
  }

  void selectStyle(int index) => selectedStyle.value = index;
  void selectAspect(int index) => selectedAspect.value = index;

  void resetInputs() {
    promptController.clear();
    imagePickerController.clearImage();
    selectedStyle.value = 0;
    selectedAspect.value = 0;
    customAspectRatio.value = '';
  }

  Future<void> generateImage() async {
    final String promptText = promptController.text.trim();
    final selectedFile = imagePickerController.selectedImage.value;

    if (promptText.isEmpty && selectedFile == null) {
      AppUtils.showSnack(
        title: "Error",
        message: "Please enter a prompt or select an image",
      );
      return;
    }

    isLoading.value = true;
    try {
      String finalPrompt = promptText;

      if (selectedStyle.value > 0) {
        final styleName = styles[selectedStyle.value]['title'] as String;
        finalPrompt += ". Style: $styleName";
      }

      final aspectName = aspects[selectedAspect.value];
      String aspectHint = "";
      switch (aspectName) {
        case 'Vertical':
          aspectHint = "3:4 (vertical portrait)";
          break;
        case 'Horizontal':
          aspectHint = "4:3 (horizontal landscape)";
          break;
        case 'Square':
          aspectHint = "1:1 (square)";
          break;
        case 'Custom':
          aspectHint = customAspectRatio.value.isNotEmpty
              ? "${customAspectRatio.value} (custom aspect ratio)"
              : "custom aspect ratio that best fits the composition";
          break;
      }
      finalPrompt += ". Render in aspect ratio $aspectHint.";

      // Read image bytes if available
      final userImageBytes = selectedFile != null
          ? await selectedFile.readAsBytes()
          : null;

      final response = await generateImageUseCase.generateFromPrompt(
        userImage: userImageBytes,
        prompt: finalPrompt,
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
              title: promptText.isNotEmpty ? promptText : "Generated Art",
              featureName: "Text to Image",
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.toNamed(Routes.photoResultView, arguments: imageBytes);
            });
            resetInputs();
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
