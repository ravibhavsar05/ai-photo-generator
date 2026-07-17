import 'package:get/get.dart';


import 'package:ai_photo_generator/features/prompt_to_image/prompt_to_image_binding.dart';
import 'package:ai_photo_generator/features/prompt_to_image/prompt_to_image_view.dart';
import 'package:ai_photo_generator/features/all_ai_generative/all_ai_generative_binding.dart';
import 'package:ai_photo_generator/features/all_ai_generative/all_ai_generative_view.dart';
import 'package:ai_photo_generator/features/bottom_nav/bottom_nav_bindings.dart' as bottom_nav;
import 'package:ai_photo_generator/features/bottom_nav/bottom_nav_view.dart' as bottom_nav;
import 'package:ai_photo_generator/features/photo_result/photo_result_binding.dart';
import 'package:ai_photo_generator/features/photo_result/photo_result_view.dart';
import 'package:ai_photo_generator/features/remove_bg/remove_bg_binding.dart';
import 'package:ai_photo_generator/features/remove_bg/remove_bg_view.dart';
import 'package:ai_photo_generator/features/old_photo_restore/old_photo_restore_binding.dart';
import 'package:ai_photo_generator/features/old_photo_restore/old_photo_restore_view.dart';
import 'package:ai_photo_generator/features/enhance_photo/enhance_photo_binding.dart';
import 'package:ai_photo_generator/features/enhance_photo/enhance_photo_view.dart';
import 'package:ai_photo_generator/features/face_swap/face_swap_binding.dart';
import 'package:ai_photo_generator/features/face_swap/face_swap_view.dart';
import 'package:ai_photo_generator/features/splash/splash_bindings.dart';
import 'package:ai_photo_generator/features/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static const String initial = Routes.splash;

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage(name: Routes.splash, page: () => const SplashView(), binding: SplashBindings()),

    GetPage(
      name: Routes.bottomNav,
      page: () => const bottom_nav.BottomNavView(),
      binding: bottom_nav.BottomNavBindings(),
    ),
    GetPage(name: Routes.promptToImage, page: () => const PromptToImageView(), binding: PromptToImageBinding()),
    GetPage(name: Routes.allAiGenerative, page: () => AllAiGenerativeView(), binding: AllAiGenerativeBinding()),
    GetPage(name: Routes.removeBg, page: () => const RemoveBgView(), binding: RemoveBgBinding()),
    GetPage(name: Routes.oldPhotoRestore, page: () => const OldPhotoRestoreView(), binding: OldPhotoRestoreBinding()),
    GetPage(name: Routes.enhancePhoto, page: () => const EnhancePhotoView(), binding: EnhancePhotoBinding()),
    GetPage(name: Routes.faceSwap, page: () => const FaceSwapView(), binding: FaceSwapBinding()),
    GetPage(name: Routes.photoResultView, page: () => const PhotoResultView(), binding: PhotoResultBinding()),
  ];

}
