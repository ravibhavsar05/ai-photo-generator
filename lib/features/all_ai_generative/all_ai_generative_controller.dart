import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:ai_photo_generator/core/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/controllers/image_picker_controller.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/use_cases/image_generate_use_case/image_generate_use_case.dart';
import '../../utils/app_prompts.dart';
import '../../utils/app_utils.dart';
import '../history/services/history_service.dart';
import '../home/models/generative_ai_model.dart';

class AllAiGenerativeController extends BaseController {
  late final ImagePickerController imagePickerController;
  final generateImageUseCase = Get.find<ImageGenerateUseCase>();

  final promptController = TextEditingController();
  int maxLength = 200;
  final generativeAiList = <GenerativeAiModel>[].obs;
  final isLoading = true.obs;
  RxInt selectedIndex = (-1).obs;
  final isCreating = false.obs;
  RxBool showStyles = true.obs;
  final ImagePicker _picker = ImagePicker();

  ///  SELECTED IMAGE
  Rx<File?> selectedImage = Rx<File?>(null);

  ///  IMAGE RATIO
  RxString selectedRatio = "1:1".obs;


  @override
  void onInit() {
    super.onInit();

    fetchGenerativeAi();
    final args = Get.arguments;

    if (args != null) {
      ///  SET PROMPT
      if (args["prompt"] != null) {
        promptController.text = args["prompt"];
      }

      ///  CONTROL STYLE VISIBILITY
      if (args["showStyles"] != null) {
        showStyles.value = args["showStyles"];
      }
    }
    imagePickerController = Get.put(ImagePickerController());
  }

  Future<void> fetchGenerativeAi() async {
    try {
      isLoading.value = true;
      final String jsonString = await rootBundle.loadString('assets/data/generative_ai.json');
      final List<dynamic> data = jsonDecode(jsonString);
      generativeAiList.value = data.map((item) => GenerativeAiModel.fromJson(item)).toList();
    } finally {
      isLoading.value = false;
    }
  }

  ///  UPLOAD IMAGE
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }


  ///  SELECT RATIO
  void selectRatio(String ratio) {
    selectedRatio.value = ratio;
  }

  ///  GENERATE IMAGE
  Future<void> generateImage() async {
    final String promptText = promptController.text.trim();
    final selectedFile = imagePickerController.selectedImage.value;

    if (promptText.isEmpty && selectedFile == null) {
      AppUtils.showSnack(title: "Error", message: "Please enter a prompt or select an image");
      return;
    }

    isCreating.value = true;
    try {
      String finalPrompt = "";

      ///  STYLE PROMPT
      String stylePrompt = "";
      if (selectedIndex.value != -1) {
        final selectedItem = generativeAiList[selectedIndex.value];
        stylePrompt = selectedItem.prompt ?? "";
      }

      ///  USER PROMPT
      final userPrompt = promptController.text.trim();

      ///  CASE HANDLING

      if (selectedFile != null && userPrompt.isNotEmpty) {
        ///  CASE 4: Image + User Prompt
        finalPrompt = userPrompt;
      } else if (selectedFile != null && stylePrompt.isNotEmpty) {
        /// CASE 1: Image + Style
        finalPrompt = stylePrompt;
      } else if (selectedFile == null && stylePrompt.isNotEmpty) {
        /// CASE 2: Only Style
        finalPrompt = stylePrompt;
      } else if (userPrompt.isNotEmpty) {
        /// CASE 3: Only Prompt
        finalPrompt = userPrompt;
      } else {
        AppUtils.showSnack(title: "Error", message: "Please enter prompt or select style/image");
        return;
      }

      finalPrompt += " Generate image in ${selectedRatio.value} aspect ratio.";

      if (!showStyles.value && selectedFile == null) {
        finalPrompt = "${buildTemplatePrompt(promptController.text.trim())}\nGenerate image in ${selectedRatio.value} aspect ratio.";
      }


      int? seed;
      if (!showStyles.value || selectedIndex.value != -1) {
        seed = AppUtils.getDeterministicSeed(promptController.text.trim());
      }

      final userImageBytes = selectedFile != null ? await selectedFile.readAsBytes() : null;

      final response = await generateImageUseCase.generateFromPrompt(
        userImage: userImageBytes,
        prompt: finalPrompt,
        seed: seed,
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
            AppUtils.showSnack(title: "Error", message: "No image data found in response");
          }
        },
      );
    } catch (e) {
      AppUtils.showSnack(title: "Error", message: e.toString());
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    promptController.dispose();
    super.onClose();
  }

  void resetInputs() {
    promptController.clear();
    imagePickerController.clearImage();
    selectedRatio.value = '';
  }
}
