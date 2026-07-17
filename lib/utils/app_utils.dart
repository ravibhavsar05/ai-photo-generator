import 'package:ai_photo_generator/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static String capitalize(String value) {
    if (isNullOrEmpty(value)) return '';
    final v = value.trim();
    return v[0].toUpperCase() + v.substring(1);
  }

  static void showSnack({required String title, required String message}) {
    Get.snackbar(title, message);
  }

  static void showErrorSnack({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.error,
      colorText: AppColors.white,
    );
  }

  static Color fromHex(String hex) {
    var formatted = hex.replaceAll('#', '');
    if (formatted.length == 6) {
      formatted = 'FF$formatted';
    }
    return Color(int.parse(formatted, radix: 16));
  }

  Color withOpacity({required Color color, required double opacity}) {
    return color.withAlpha((opacity * 255).toInt());
  }

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not open URL: $url';
    }
  }

  static int getDeterministicSeed(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = input.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return hash.abs() % 1000000000;
  }

  static Future<Uint8List> compressImage(Uint8List imageBytes, {int maxDimension = 1024, int quality = 80}) async {
    return await compute(_compressImageWork, {
      'bytes': imageBytes,
      'maxDimension': maxDimension,
      'quality': quality,
    });
  }

  static Uint8List _compressImageWork(Map<String, dynamic> args) {
    try {
      final Uint8List imageBytes = args['bytes'] as Uint8List;
      final int maxDimension = args['maxDimension'] as int;
      final int quality = args['quality'] as int;

      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) return imageBytes;

      img.Image resizedImage = decodedImage;
      if (decodedImage.width > maxDimension || decodedImage.height > maxDimension) {
        if (decodedImage.width > decodedImage.height) {
          resizedImage = img.copyResize(decodedImage, width: maxDimension);
        } else {
          resizedImage = img.copyResize(decodedImage, height: maxDimension);
        }
      }

      final compressed = img.encodeJpg(resizedImage, quality: quality);
      return Uint8List.fromList(compressed);
    } catch (e) {
      debugPrint("Error compressing image: $e");
      return args['bytes'] as Uint8List;
    }
  }
}
