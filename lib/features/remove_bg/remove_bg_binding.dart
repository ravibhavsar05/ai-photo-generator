import 'package:get/get.dart';
import 'remove_bg_controller.dart';

class RemoveBgBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RemoveBgController>(() => RemoveBgController());
  }
}
