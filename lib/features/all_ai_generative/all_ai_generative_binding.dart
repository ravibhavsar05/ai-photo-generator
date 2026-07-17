import 'package:get/get.dart';
import 'all_ai_generative_controller.dart';

class AllAiGenerativeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllAiGenerativeController>(() => AllAiGenerativeController());
  }
}
