import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/splash/splash_controller.dart';
import 'package:ai_photo_generator/core/repository/image_generate_repo/image_generate_repo.dart';
import '../repository/image_generate_repo/image_generate_repo_impl.dart';
import 'package:ai_photo_generator/core/services/storage_services/storage_repo.dart';
import '../services/storage_services/storage_impl.dart';
import '../theme/theme_controller.dart';

class RepoDependencies {
  late SharedPreferences sharedPreferences;
  late StorageRepo _storageRepo;

  Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _storageRepo = StorageRepoImpl(sharedPreferences);
  }

  initializeRepoDependencies() {
    Get.lazyPut<ImageGenerateRepo>(
      () => ImageGenerateRepoImpl(_storageRepo),
      fenix: true,
    );
    Get.put<StorageRepo>(_storageRepo, permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(SplashController());
  }
}
