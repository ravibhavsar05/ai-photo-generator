import 'package:ai_photo_generator/core/routes/app_routes.dart';
import 'package:ai_photo_generator/utils/app_colors.dart';
import 'package:ai_photo_generator/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/app_text.dart';
import 'home_controller.dart';

// Feature button data model
class _FeatureItem {
  final String label;
  final String route;
  final IconData icon;
  final List<Color> gradient;
  const _FeatureItem({required this.label, required this.route, required this.icon, required this.gradient});
}

const _features = [
  _FeatureItem(
    label: 'Remove Background',
    route: Routes.removeBg,
    icon: Icons.auto_fix_high_rounded,
    gradient: [Color(0xFF7B2FF7), Color(0xFF9D50BB)],
  ),
  _FeatureItem(
    label: 'Enhance Photo',
    route: Routes.enhancePhoto,
    icon: Icons.photo_filter_rounded,
    gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
  ),
  _FeatureItem(
    label: 'AI Photo Generator',
    route: Routes.allAiGenerative,
    icon: Icons.auto_awesome_rounded,
    gradient: [Color(0xFFFC5C7D), Color(0xFF6A3093)],
  ),
];

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.surface0, AppColors.surface0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _appBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.2.h),
                SizedBox(height: 1.8.h),
                // ── Feature Buttons ──
                Column(
                  children: _features.map((feature) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.4.h),
                      child: GestureDetector(
                        onTap: () => Get.toNamed(feature.route),
                        child: Container(
                          width: double.infinity,
                          height: 7.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: feature.gradient,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: feature.gradient.last.withValues(alpha: 0.45),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Row(
                            children: [
                              Container(
                                width: 9.w,
                                height: 9.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(feature.icon, color: Colors.white, size: 20),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: AppText(
                                  feature.label,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 2.h),

                // ── All Templates ──
                // AppText(
                //   'All Templates',
                //   fontSize: 17,
                //   fontWeight: FontWeight.w600,
                //   color: AppColors.white,
                // ),

                // SizedBox(height: 1.5.h),

                // // ── Full masonry grid ──
                // Obx(() {
                //   if (controller.isTrendingLoading.value) {
                //     return GridView.builder(
                //       shrinkWrap: true,
                //       physics: const NeverScrollableScrollPhysics(),
                //       itemCount: 6,
                //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 2,
                //         mainAxisSpacing: 12,
                //         crossAxisSpacing: 12,
                //         childAspectRatio: 0.75,
                //       ),
                //       itemBuilder: (_, __) => Container(
                //         decoration: BoxDecoration(
                //           color: const Color(0xff0B141D),
                //           borderRadius: BorderRadius.circular(16),
                //         ),
                //       ),
                //     );
                //   }

                //   if (controller.trendingList.isEmpty) {
                //     return const Center(
                //       child: Padding(
                //         padding: EdgeInsets.symmetric(vertical: 24),
                //         child: Text('No Templates Found', style: TextStyle(color: Colors.white54)),
                //       ),
                //     );
                //   }

                //   return GridView.builder(
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemCount: controller.trendingList.length,
                //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 2,
                //       mainAxisSpacing: 12,
                //       crossAxisSpacing: 12,
                //       childAspectRatio: 0.75,
                //     ),
                //     itemBuilder: (context, index) {
                //       final item = controller.trendingList[index];
                //       return GestureDetector(
                //         onTap: () => Get.toNamed(
                //           Routes.allAiGenerative,
                //           arguments: {"prompt": item.prompt, "showStyles": false},
                //         ),
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.circular(16),
                //           child: AppCachedImage(
                //             imageUrl: item.template,
                //             width: double.infinity,
                //             height: double.infinity,
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       );
                //     },
                //   );
                // }),

                // SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      title: Row(
        children: [
          SizedBox(width: 3.w),
          AppText('Ai Photo Generator', type: AppTextType.heading2, color: AppColors.white),
        ],
      ),
    );
  }
}
