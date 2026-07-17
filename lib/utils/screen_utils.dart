import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenSize {
  static Size _size = const Size(0, 0);

  static Size get size {
    final context = Get.context;
    if (context != null) {
      _size = MediaQuery.of(context).size;
    }
    return _size;
  }

  static double get width => size.width;
  static double get height => size.height;
}

extension SizePercentExtensions on num {
  double get h => (this / 100) * ScreenSize.height;
  double get w => (this / 100) * ScreenSize.width;
}

