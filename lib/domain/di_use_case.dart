import 'package:get/get.dart';
import 'package:ai_photo_generator/core/repository/image_generate_repo/image_generate_repo.dart';
import 'package:ai_photo_generator/domain/use_cases/image_generate_use_case/image_generate_use_case.dart';

Future<void> initializeModelUseCasesDependencies() async {
  Get.lazyPut<ImageGenerateUseCase>(
    () => ImageGenerateUseCase(
      Get.find<ImageGenerateRepo>(),
    ),
    fenix: true,
  );
}
