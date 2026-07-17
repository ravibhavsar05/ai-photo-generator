import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.currentStep = 1,
    this.totalSteps = 10,
    this.showSlider = false,
  });

  final int currentStep;
  final int totalSteps;
  final bool showSlider;

  @override
  Widget build(BuildContext context) {
    double progress = currentStep / totalSteps;

    return Row(
      spacing: 4.w,
      children: [
        IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.grey.shade800)),
        ),
        if (showSlider)
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xff292929),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFBA6D26), Color(0xFFFADF63)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Opacity(
          opacity: 0.0,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back),
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.grey.shade800)),
          ),
        ),
      ],
    );
  }
}
