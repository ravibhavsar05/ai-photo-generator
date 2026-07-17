import 'package:ai_photo_generator/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import 'package:ai_photo_generator/core/services/storage_services/storage_repo.dart';
import 'package:ai_photo_generator/core/services/storage_services/storage_keys.dart';
import 'models/onboarding_model.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;
  final StorageRepo storageRepo = Get.find<StorageRepo>();

  final pages = [
    OnboardingModel(
      image: AppAssets.onboardingOne,
      title: 'Edit & Enhance Instantly',
      subtitle:
      'Enhanced any photo with a single tap.',
    ),
    OnboardingModel(
      image: AppAssets.onboardingTwo,
      title: 'Remove Background Instantly',
      subtitle:
      'Instant AI background removal.',
    ),
    OnboardingModel(
      image: AppAssets.onboardingThree,
      title: 'Ai Text to Image',
      subtitle:
      'Instant AI background removal.',
    ),
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      getStarted();
    }
  }

  void skip() {
    getStarted();
  }

  void getStarted() {
    storageRepo.setBool(StorageKeys.onboardingSeen, true);
    Get.offAllNamed(Routes.bottomNav);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
