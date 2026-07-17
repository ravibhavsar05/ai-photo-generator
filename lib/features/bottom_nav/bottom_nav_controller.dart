import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_photo_generator/core/base/base_controller.dart';
import '../history/history_view.dart';
import '../home/home_screen.dart';


class BottomNavController extends BaseController {
  final RxInt index = 0.obs;

  final List<Widget> tabs = <Widget>[
    const HomeView(),
    const HistoryView(),
  ];


  void setIndex(int value) {
    index.value = value;
  }


}
