import 'package:get/get.dart';
import 'photo_result_controller.dart';

class PhotoResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotoResultController>(() => PhotoResultController());
  }
}
