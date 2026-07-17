import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_photo_generator/utils/app_colors.dart';
import '../history_controller.dart';

class HistorySearchBar extends StatefulWidget {
  const HistorySearchBar({super.key});

  @override
  State<HistorySearchBar> createState() => _HistorySearchBarState();
}

class _HistorySearchBarState extends State<HistorySearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search creations...',
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: const Icon(Icons.search, color: AppColors.textPrimary),
        filled: true,
        fillColor: AppColors.cardBg.withValues(alpha: .9),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        controller.updateSearch(value);
        setState(() {});
      },
      style: const TextStyle(color: AppColors.textPrimary),
    );
  }
}
