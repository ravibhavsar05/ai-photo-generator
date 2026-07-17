import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  final Rx<ThemeMode> themeMode = ThemeMode.dark.obs;

  void setTheme(ThemeMode mode) {
    themeMode.value = mode;
  }

  void toggleTheme() {
    themeMode.value = themeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }
}
