import 'dart:io';

import 'package:ai_photo_generator/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/base/base_controller.dart';
import '../../core/routes/app_routes.dart';
import '../../utils/app_utils.dart';
import 'models/history_model.dart';
import 'services/history_service.dart';

class HistoryController extends BaseController {
  final RxList<HistoryModel> historyItems = <HistoryModel>[].obs;
  final RxList<HistoryModel> _allHistoryItems = <HistoryModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final FocusNode searchFocusNode = FocusNode();
  List<String> todayCollection = [
    AppAssets.coll_image1,
    AppAssets.coll_image2,
  ];
  List<String> yesterdayCollection = [
    AppAssets.coll_image2,
    AppAssets.coll_image1,
  ];
  List<String> text = [
    "Portrait Edit",
    "Remove BG",
  ];
  List<String> subtext = [
    "AI Image Enhancer",
   "Remove Background",
  ];

  bool get isHistoryEmpty {
    final today = groupedHistory["Today"] ?? [];
    final yesterday = groupedHistory["Yesterday"] ?? [];
    return today.isEmpty && yesterday.isEmpty;
  }

  bool get isSearchingNoResult {
    return searchQuery.value.isNotEmpty && historyItems.isEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    loadHistory();
    // Listen for external updates
    ever(HistoryService.onHistoryUpdated, (_) => loadHistory());
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    final items = await HistoryService.getHistory();
    _allHistoryItems.assignAll(items);
    _applySearch();
    isLoading.value = false;
  }

  Future<void> onRefresh() async {
    await loadHistory();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    _applySearch();
  }

  void _applySearch() {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      historyItems.assignAll(_allHistoryItems);
      return;
    }
    final filtered = _allHistoryItems.where((item) {
      final title = item.tag.toLowerCase();

      return title.contains(query);
    }).toList();
    historyItems.assignAll(filtered);
  }

  Future<void> openHistoryItem(HistoryModel item) async {
    try {
      final file = File(item.path);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        FocusManager.instance.primaryFocus?.unfocus();
        Get.toNamed(Routes.photoResultView, arguments: bytes);

      } else {
        AppUtils.showSnack(title: "Error", message: "Image file not found");
      }
    } catch (e) {
      AppUtils.showSnack(title: "Error", message: "Failed to load image: $e");
    }
  }

  Map<String, List<HistoryModel>> get groupedHistory {
    final Map<String, List<HistoryModel>> grouped = {};
    for (var item in historyItems) {
      final dateKey = _getDateKey(item.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(item);
    }
    return grouped;
  }

  String _getDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) {
      return 'Today';
    } else if (itemDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
  @override
  void onClose() {

    searchFocusNode.dispose();
    super.onClose();
  }
}
