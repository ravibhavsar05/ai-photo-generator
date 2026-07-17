import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:ai_photo_generator/core/model/generate_image_model.dart';
import 'package:ai_photo_generator/core/repository/image_generate_repo/image_generate_repo.dart';
import 'package:ai_photo_generator/core/services/network_services/result_type.dart';

class ImageGenerateUseCase {
  final ImageGenerateRepo imageGenerateRepo;

  ImageGenerateUseCase(this.imageGenerateRepo);

  String getUserId() {
    return imageGenerateRepo.getUserId();
  }

  bool getUserLoggedInStatus() {
    return imageGenerateRepo.getUserLoggedInStatus();
  }

  Future<Either<AppError, GenerateImageModel>> generateImage({
    required Uint8List userImage,
    required String prompt,
    int? seed,
    String? model,
  }) async {
    final response = await imageGenerateRepo.generateImage(
      userImage: userImage,
      prompt: prompt,
      seed: seed,
      model: model,
    );
    return response.fold(
      (error) {
        return Left(error);
      },
      (success) {
        return Right(success);
      },
    );
  }

  Future<Either<AppError, GenerateImageModel>> generateFromPrompt({
    Uint8List? userImage,
    required String prompt,
    int? seed,
  }) async {
    final response = await imageGenerateRepo.generateFromPrompt(
      userImage: userImage,
      prompt: prompt,
      seed: seed,
    );
    return response.fold(
      (error) {
        return Left(error);
      },
      (success) {
        return Right(success);
      },
    );
  }
}
