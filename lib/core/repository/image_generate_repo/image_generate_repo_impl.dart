import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../model/generate_image_model.dart';
import 'package:ai_photo_generator/core/services/network_services/end_points.dart';
import 'package:ai_photo_generator/core/services/network_services/result_type.dart';
import 'package:ai_photo_generator/core/services/storage_services/storage_repo.dart';
import 'package:ai_photo_generator/core/services/storage_services/storage_keys.dart';
import 'image_generate_repo.dart';
import 'package:ai_photo_generator/utils/app_utils.dart';

class ImageGenerateRepoImpl implements ImageGenerateRepo {
  final StorageRepo _storageRepo;

  ImageGenerateRepoImpl(this._storageRepo);

  @override
  String getUserId() {
    String uid = _storageRepo.getString(StorageKeys.uid) ?? "";
    return uid;
  }

  @override
  bool getUserLoggedInStatus() {
    return _storageRepo.getBool(StorageKeys.isUserLoggedIn) ?? false;
  }

  /// Image-to-image via Pollinations.
  /// Image-to-image via Pollinations.
  /// Sends the actual [userImage] bytes as a multipart POST so the model
  /// can edit/process the supplied photo rather than generating from scratch.
  @override
  Future<Either<AppError, GenerateImageModel>> generateImage({
    required Uint8List userImage,
    required String prompt,
    int? seed,
    String? model,
  }) async {
    return _postImageToPollinations(
      userImage: userImage,
      prompt: prompt,
      seed: seed,
      model: model,
    );
  }

  /// Text-to-image (or image-to-image when [userImage] is? provided).
  @override
  Future<Either<AppError, GenerateImageModel>> generateFromPrompt({
    Uint8List? userImage,
    required String prompt,
    int? seed,
  }) async {
    if (userImage != null) {
      return _postImageToPollinations(userImage: userImage, prompt: prompt, seed: seed);
    }
    return _fetchFromPollinations(prompt: prompt, seed: seed);
  }

  // ─────────────────────────────────────────────
  // POST multipart — sends the real image bytes to the correct edits API
  // ─────────────────────────────────────────────
  Future<Either<AppError, GenerateImageModel>> _postImageToPollinations({
    required Uint8List userImage,
    required String prompt,
    int? seed,
    String? model,
  }) async {
    try {
      final String key = EndPoints.apiKey.trim();
      final bool isStandardKey = key.startsWith('AIzaSy');

      // 1. Compress the selected user image first to optimize upload size and speed
      final Uint8List compressedImage = await AppUtils.compressImage(userImage);

      // 2. Convert compressedImage bytes to base64
      final String base64Image = base64Encode(compressedImage);

      // 2. Determine image dimensions & aspect ratio
      int width = 512;
      int height = 512;
      try {
        final ui.Codec codec = await ui.instantiateImageCodec(compressedImage);
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        width = frameInfo.image.width;
        height = frameInfo.image.height;
      } catch (_) {}

      String aspectRatio = "1:1";
      if (width > 0 && height > 0) {
        final double ratioVal = width / height;
        if (ratioVal > 1.5) {
          aspectRatio = "16:9";
        } else if (ratioVal > 1.15) {
          aspectRatio = "4:3";
        } else if (ratioVal < 0.65) {
          aspectRatio = "9:16";
        } else if (ratioVal < 0.85) {
          aspectRatio = "3:4";
        } else {
          aspectRatio = "1:1";
        }
      }

      // 3. Construct parts list for Gemini-based image generation
      final List<Map<String, dynamic>> parts = [];
      parts.add({
        'inlineData': {
          'mimeType': 'image/png',
          'data': base64Image,
        }
      });
      parts.add({'text': prompt});

      // 4. Call Google AI Studio Imagen 3 API to generate edited image
      final String imagenUrl = "${EndPoints.googleBaseUrl}/models/gemini-3.1-flash-image:generateContent?key=$key";
      final imagenUri = Uri.parse(imagenUrl);

      final Map<String, String> imagenHeaders = {'Content-Type': 'application/json'};
      if (!isStandardKey) {
        imagenHeaders['Authorization'] = 'Bearer $key';
      }

      final response = await http.post(
        imagenUri,
        headers: imagenHeaders,
        body: json.encode({
          'contents': [
            {
              'parts': parts,
            }
          ],
          'generationConfig': {
            'responseModalities': ['IMAGE'],
            'imageConfig': {
              'aspectRatio': aspectRatio,
            }
          }
        }),
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded['candidates'] != null) {
          final List? candidates = decoded['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final Map? firstCandidate = candidates[0] as Map?;
            if (firstCandidate != null && firstCandidate['content'] != null) {
              final Map? content = firstCandidate['content'] as Map?;
              if (content != null && content['parts'] != null) {
                final List? parts = content['parts'] as List?;
                if (parts != null) {
                  for (var part in parts) {
                    if (part is Map && part['inlineData'] != null) {
                      final Map? inlineData = part['inlineData'] as Map?;
                      if (inlineData != null && inlineData['data'] != null) {
                        final String base64Str = inlineData['data'] as String;
                        final Uint8List decodedBytes = base64Decode(base64Str.trim());
                        return Right(GenerateImageModel(imageBytes: decodedBytes));
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      String errorMsg = 'Failed to process image';
      if (response.body.isNotEmpty) {
        try {
          final decoded = json.decode(response.body);
          if (decoded is Map) {
            if (decoded['error'] != null && decoded['error']['message'] != null) {
              errorMsg = decoded['error']['message'] as String;
            } else {
              errorMsg = response.body;
            }
          }
        } catch (_) {
          errorMsg = response.body;
        }
      }
      return Left(AppError(title: 'Error ${response.statusCode}', description: errorMsg));
    } catch (e) {
      return Left(AppError(title: 'Network Error', description: e.toString()));
    }
  }

  // ─────────────────────────────────────────────
  // POST — text-to-image only (Google AI Studio Imagen 3 API)
  // ─────────────────────────────────────────────
  Future<Either<AppError, GenerateImageModel>> _fetchFromPollinations({required String prompt, int? seed}) async {
    try {
      final String key = EndPoints.apiKey.trim();
      final bool isStandardKey = key.startsWith('AIzaSy');

      final String urlString = "${EndPoints.googleBaseUrl}/models/gemini-3.1-flash-image:generateContent?key=$key";
      final uri = Uri.parse(urlString);

      final Map<String, String> headers = {'Content-Type': 'application/json'};
      if (!isStandardKey) {
        headers['Authorization'] = 'Bearer $key';
      }

      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'responseModalities': ['IMAGE'],
            'imageConfig': {
              'aspectRatio': '1:1',
            }
          }
        }),
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded['candidates'] != null) {
          final List? candidates = decoded['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final Map? firstCandidate = candidates[0] as Map?;
            if (firstCandidate != null && firstCandidate['content'] != null) {
              final Map? content = firstCandidate['content'] as Map?;
              if (content != null && content['parts'] != null) {
                final List? parts = content['parts'] as List?;
                if (parts != null) {
                  for (var part in parts) {
                    if (part is Map && part['inlineData'] != null) {
                      final Map? inlineData = part['inlineData'] as Map?;
                      if (inlineData != null && inlineData['data'] != null) {
                        final String base64Str = inlineData['data'] as String;
                        final Uint8List decodedBytes = base64Decode(base64Str.trim());
                        return Right(GenerateImageModel(imageBytes: decodedBytes));
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      String errorMsg = 'Failed to generate image';
      if (response.body.isNotEmpty) {
        try {
          final decoded = json.decode(response.body);
          if (decoded is Map) {
            if (decoded['error'] != null && decoded['error']['message'] != null) {
              errorMsg = decoded['error']['message'] as String;
            } else {
              errorMsg = response.body;
            }
          }
        } catch (_) {
          errorMsg = response.body;
        }
      }
      return Left(AppError(title: 'Error ${response.statusCode}', description: errorMsg));
    } catch (e) {
      return Left(AppError(title: 'Network Error', description: e.toString()));
    }
  }
}
