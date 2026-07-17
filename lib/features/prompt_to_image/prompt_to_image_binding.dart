import 'package:get/get.dart';
import 'prompt_to_image_controller.dart';

class PromptToImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromptToImageController>(() => PromptToImageController());
  }
}
