import 'package:get/get.dart';
import 'old_photo_restore_controller.dart';

class OldPhotoRestoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OldPhotoRestoreController>(() => OldPhotoRestoreController());
  }
}
