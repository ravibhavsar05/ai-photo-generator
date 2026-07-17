import 'package:get/get.dart';
import 'face_swap_controller.dart';

class FaceSwapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceSwapController>(() => FaceSwapController());
  }
}
