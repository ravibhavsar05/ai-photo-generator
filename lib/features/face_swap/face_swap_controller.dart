import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ai_photo_generator/core/routes/app_routes.dart';
import 'package:ai_photo_generator/features/home/models/generative_ai_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/base/base_controller.dart';
import '../../core/controllers/image_picker_controller.dart';
import 'package:ai_photo_generator/domain/use_cases/image_generate_use_case/image_generate_use_case.dart';
import 'package:ai_photo_generator/utils/app_utils.dart';

import 'package:ai_photo_generator/features/history/services/history_service.dart';

class FaceSwapController extends BaseController {
  late final ImagePickerController imagePickerController;
  final generateImageUseCase = Get.find<ImageGenerateUseCase>();

  final RxBool isLoading = false.obs;
  final RxBool isTemplatesLoading = true.obs;

  // List of all AI images for face swap
  final generativeAiList = <GenerativeAiModel>[].obs;

  late RxString selectedTargetImage;

  @override
  void onInit() {
    super.onInit();
    imagePickerController = Get.put(ImagePickerController());
    selectedTargetImage = ''.obs;

    // Check if arguments are passed
    if (Get.arguments != null && Get.arguments is GenerativeAiModel) {
      final model = Get.arguments as GenerativeAiModel;
      if (model.template != null) {
        selectedTargetImage.value = model.template!;
      }
    }

    fetchGenerativeAi();
  }

  void resetInputs() {
    imagePickerController.clearImage();
    selectedTargetImage.value = '';
  }

  Future<void> fetchGenerativeAi() async {
    try {
      isTemplatesLoading.value = true;
      final String response = await rootBundle.loadString('assets/data/generative_ai.json');
      final List<dynamic> data = json.decode(response);
      generativeAiList.value = data.map((json) => GenerativeAiModel.fromJson(json)).toList();

      if (generativeAiList.isNotEmpty && selectedTargetImage.isEmpty) {
        selectedTargetImage.value = generativeAiList.first.template ?? '';
      }
    } catch (e) {
      debugPrint("Error fetching generative AI data: $e");
    } finally {
      isTemplatesLoading.value = false;
    }
  }

  void selectImage(String image) {
    selectedTargetImage.value = image;
  }

  generateImage() async {
    final selectedFile = imagePickerController.selectedImage.value;
    if (selectedFile == null) {
      AppUtils.showSnack(title: "Error", message: "Please select a source image first");
      return;
    }

    if (selectedTargetImage.value.isEmpty) {
      AppUtils.showSnack(title: "Error", message: "Please select a target face template");
      return;
    }

    isLoading.value = true;
    try {
      final userImageBytes = await selectedFile.readAsBytes();

      // Find the prompt for the selected template
      String prompt = "";
      final selectedModel = generativeAiList.firstWhereOrNull((model) => model.template == selectedTargetImage.value);
      if (selectedModel != null && selectedModel.prompt != null) {
        prompt = selectedModel.prompt!;
      }

      final response = await generateImageUseCase.generateImage(
        userImage: userImageBytes,
        prompt: prompt.isNotEmpty ? prompt : "Face swap with this template",
        seed: AppUtils.getDeterministicSeed(prompt),
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
              title: "Face Swap Result",
              featureName: "Face Swap",
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.toNamed(Routes.photoResultView, arguments: imageBytes);
            });
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
