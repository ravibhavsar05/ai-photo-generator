import 'package:ai_photo_generator/widgets/custom_platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'bottom_nav_controller.dart';
import 'components/dashboard_navbar.dart';

class BottomNavView extends GetView<BottomNavController> {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }

          if (controller.index.value != 0) {
            controller.index.value = 0;
            return;
          }

          CustomPlatformWidget.showDefaultDialog(
            context: context,
            title: "Exit App?",
            message: "Do you want to exit the app?",
            confirmText: 'Exit',
            cancelText: 'Cancel',
            confirmColor: Colors.redAccent,
            cancelColor: Colors.grey,
            onConfirm: () {
              SystemNavigator.pop();
            },
          );
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
           body: controller.tabs[controller.index.value],
          bottomNavigationBar: DashboardNavbar(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      );
    });
  }
}
