import 'package:ai_photo_generator/utils/app_assets.dart';
import 'package:ai_photo_generator/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_rich_text.dart';
import '../onboarding_controller.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

   OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Stack(
      children: [
        Image.asset(
          image,
          fit: BoxFit.cover,
          height: 65.h,
          width: 100.w,
        ),

        /// CONTENT
        Positioned(
          top: 70.h,
          left: 6.w,   //  padding added
          right: 6.w,  //  padding added
          child: Stack(
            clipBehavior: Clip.none,
            children:[


              Container(
                height: 30.h,
                decoration: BoxDecoration(
                ),
              ),
              Positioned(
                  left: -120,
                  right: -120,
                  top: -140,
                  child: Image.asset(
                      AppAssets.blendEffect,
                      width: double.infinity,

                      fit: BoxFit.cover)),
              Positioned(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  /// TITLE + BUTTON
                  Row(
                      children: [
                        Expanded(
                          child: StyledText(
                            segments: [
                              TextSegment(
                                text: title,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 2.w,),
                        Obx(() {
                          if (controller.currentIndex.value ==
                              controller.pages.length - 1) {
                            return const SizedBox(); //  hide on last page
                          } else {
                            return GestureDetector(
                              onTap: (){
                                controller.nextPage();
                              },
                              child: Container(
                                width: 15.w,
                                height: 15.w,
                                margin: EdgeInsets.only(left: 3.w, top: 5.w),
                                decoration: const BoxDecoration(
                                  color: Color(0xff6F3FE3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        })
                      ]
                  ),

                  SizedBox(height: 6),

                  AppText(
                    subtitle,
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  SizedBox(height: 26),

                ],
              ),)
            ]
          ),
        ),
      ],
    );
  }
}

