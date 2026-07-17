import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:ai_photo_generator/core/model/generate_image_model.dart';
import 'package:ai_photo_generator/core/services/network_services/result_type.dart';

mixin ImageGenerateRepo {
  String getUserId();

  ///Is User Logged In
  bool getUserLoggedInStatus();

  Future<Either<AppError, GenerateImageModel>> generateImage({
    required Uint8List userImage,
    required String prompt,
    int? seed,
    String? model,
  });

  ///Generate Image From Prompt (with optional image)
  Future<Either<AppError, GenerateImageModel>> generateFromPrompt({
    Uint8List? userImage,
    required String prompt,
    int? seed,
  });
}
