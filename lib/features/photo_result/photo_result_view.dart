import 'package:ai_photo_generator/utils/app_colors.dart';
import 'package:ai_photo_generator/utils/app_assets.dart';
import 'package:ai_photo_generator/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/enums.dart';
import 'photo_result_controller.dart';

class PhotoResultView extends GetView<PhotoResultController> {
  const PhotoResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03000A), // Deepest dark
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0C0A1C), // Midnight violet glow
              Color(0xFF03000A), // Pure black
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                    const AppText("Export Photo", fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                    const SizedBox(width: 40), // Balanced spacing
                  ],
                ),
                const SizedBox(height: 20),

                // Image Canvas
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withValues(alpha: 0.08), blurRadius: 30, spreadRadius: -10),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Obx(
                        () => controller.resultImage.value != null
                            ? Image.memory(controller.resultImage.value!, width: double.infinity, fit: BoxFit.contain)
                            : Image.asset(AppAssets.ai_2, width: double.infinity, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Action Buttons Row (Save to Gallery & Share)
                Row(
                  children: [
                    Obx(() {
                      final isSaving = controller.isSaving.value;
                      return Expanded(
                        child: GestureDetector(
                          onTap: isSaving ? null : () => controller.saveToGallery(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: isSaving ? null : AppColors.ctaGradient,
                              color: isSaving ? Colors.white.withValues(alpha: 0.12) : null,
                              boxShadow: isSaving
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: const Color(0xFF9B7BFF).withValues(alpha: 0.3),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                            ),
                            alignment: Alignment.center,
                            child: isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      const AppText(
                                        'Save to Gallery',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => controller.shareImage(),
                      child: Container(
                        height: 54,
                        width: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Export Quality Section Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 16),
                    ),
                    const SizedBox(width: 10),
                    const AppText('Export Quality', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 16),

                // Quality Options
                Obx(() {
                  final isSelected = controller.selectedQuality.value == ExportQuality.standard;

                  return _QualityTile(
                    title: 'Standard',
                    subtitle: '1080 JPG • Fast Export',
                    isSelected: isSelected,
                    trailing: isSelected
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const AppText(
                              'Free',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                        : null,
                    onTap: () => controller.selectQuality(ExportQuality.standard),
                  );
                }),
                const SizedBox(height: 12),
                Obx(() {
                  final isSelected = controller.selectedQuality.value == ExportQuality.hd4k;

                  return _QualityTile(
                    title: 'HD / 4K',
                    subtitle: '4096p PNG • Best for printing',
                    isSelected: isSelected,
                    trailing: isSelected
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const AppText(
                              'Free',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                        : null,
                    onTap: () => controller.selectQuality(ExportQuality.hd4k),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QualityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final Widget? trailing;
  final VoidCallback onTap;

  const _QualityTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color(0xff8B5CF6), // Primary Purple
                    Color(0xffA78BFA), // Light Purple
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.03),
          border: Border.all(
            color: isSelected ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xff8B5CF6).withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Radio Circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3), width: 2),
              ),
              child: isSelected ? const Icon(Icons.check_rounded, size: 14, color: Color(0xff8B5CF6)) : null,
            ),
            const SizedBox(width: 14),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      if (!isSelected)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Free",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isSelected ? Colors.white.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
