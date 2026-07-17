import 'package:get/get.dart';
import '../history/history_controller.dart';
import '../home/home_controller.dart';
import 'package:ai_photo_generator/features/bottom_nav/bottom_nav_controller.dart';

class BottomNavBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}
