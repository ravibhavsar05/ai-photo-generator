// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:ai_photo_generator/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'models/generative_ai_model.dart';
import '../../core/base/base_controller.dart';
import 'package:get/get.dart';
import 'models/trending_template_model.dart';

class HomeController extends BaseController {
  final selectedStyle = 0.obs;
  final selectedAspect = 0.obs;

  final generativeAiList = <GenerativeAiModel>[].obs;
  final scrollController = ScrollController();

  RxBool isTrendingLoading = true.obs;
  RxList<TrendingTemplateModel> trendingList = <TrendingTemplateModel>[].obs;

  final isLoading = true.obs;
  final showBannerShimmer = true.obs;
  final RxBool showFaceSwap = true.obs;

  List<String> trending_temp = [
    AppAssets.trending_temp1,
    AppAssets.trending_temp4,
    AppAssets.trending_temp3,
    AppAssets.trending_temp2,
  ];

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 2), () {
      showBannerShimmer.value = false;
    });

    listenTrendingTemplates();
    fetchGenerativeAi();
  }

  Future<void> listenTrendingTemplates() async {
    try {
      isTrendingLoading.value = true;
      final String jsonString = await rootBundle.loadString('assets/data/trending_templates.json');
      final List<dynamic> data = jsonDecode(jsonString);
      trendingList.value = data.map((item) => TrendingTemplateModel.fromJson(item)).toList();
    } finally {
      isTrendingLoading.value = false;
    }
  }

  Future<void> fetchGenerativeAi() async {
    try {
      isLoading.value = true;
      final String jsonString = await rootBundle.loadString('assets/data/generative_ai.json');
      final List<dynamic> data = jsonDecode(jsonString);
      generativeAiList.value = data.map((item) => GenerativeAiModel.fromJson(item)).toList();
    } finally {
      isLoading.value = false;
    }
  }
}
