import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:ai_photo_generator/core/base/base_controller.dart';
import 'package:ai_photo_generator/core/routes/app_routes.dart';

class SplashController extends BaseController {
  final RxDouble opacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Future.delayed(const Duration(milliseconds: 500), () {
      opacity.value = 1.0;
    });
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAllNamed(Routes.bottomNav);
    });
  }
}
