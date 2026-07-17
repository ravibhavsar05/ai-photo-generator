import 'package:ai_photo_generator/utils/app_colors.dart';
import 'package:ai_photo_generator/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_controller.dart';
import 'components/onboarding_page.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) {
                  final page = controller.pages[index];
                  return OnboardingPage(
                    image: page.image,
                    title: page.title,
                    subtitle: page.subtitle,
                  );
                },
              ),
            ),


            /// Dots Indicator
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: controller.currentIndex.value == index ? 40 : 8,
                    height: 10,
                    decoration: BoxDecoration(
                      color: controller.currentIndex.value == index
                          ? Color(0xff6F3FE3)
                          : AppColors.borderColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),


            Obx(() {
              if (controller.currentIndex.value ==
                  controller.pages.length - 1) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SlideButton(
                    onComplete: controller.getStarted,
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
class SlideButton extends StatefulWidget {
  final VoidCallback onComplete;

  const SlideButton({super.key, required this.onComplete});

  @override
  State<SlideButton> createState() => _SlideButtonState();
}

class _SlideButtonState extends State<SlideButton> {
  double dragPosition = 0;
  final double maxDrag = 200; // adjust based on width

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      width: 70.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: const LinearGradient(
          colors: [
            Color(0xff7B4DFF),
            Color(0xff4DA1FF),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [

          ///  TEXT
          Center(
            child: Text(
              "Get Started",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),

          ///  DRAGGABLE BUTTON
          Positioned(
            left: dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  dragPosition += details.delta.dx;

                  if (dragPosition < 0) dragPosition = 0;
                  if (dragPosition > maxDrag) dragPosition = maxDrag;
                });
              },
              onHorizontalDragEnd: (_) {
                if (dragPosition > maxDrag * 0.99) {
                  widget.onComplete(); //  navigate
                } else {
                  setState(() {
                    dragPosition = 0; // reset
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 3.w),
                height: 5.5.h,
                width: 5.5.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.double_arrow_rounded,
                  color: Color(0xff7B4DFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}