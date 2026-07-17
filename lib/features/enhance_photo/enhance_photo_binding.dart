import 'package:get/get.dart';
import 'enhance_photo_controller.dart';

class EnhancePhotoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnhancePhotoController>(() => EnhancePhotoController());
  }
}
