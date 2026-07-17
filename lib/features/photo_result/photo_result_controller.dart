import 'dart:typed_data';
import 'package:ai_photo_generator/core/routes/app_routes.dart';
import 'package:ai_photo_generator/utils/app_utils.dart';
import 'package:ai_photo_generator/utils/enums.dart';
import 'package:get/get.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class PhotoResultController extends GetxController {
  final Rx<Uint8List?> resultImage = Rx<Uint8List?>(null);
  final Rx<ExportQuality> selectedQuality = ExportQuality.standard.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Uint8List) {
      resultImage.value = Get.arguments as Uint8List;
    }
  }

  void selectQuality(ExportQuality quality) {
    selectedQuality.value = quality;
  }

  Future<void> saveToGallery() async {
    if (resultImage.value == null) {
      AppUtils.showSnack(title: "Error", message: "No image to save");
      return;
    }

    isSaving.value = true;
    try {
      // Check permissions (handled by gal automatically on modern OS, but explicit check doesn't hurt)
      if (!await Gal.hasAccess()) {
        await Gal.requestAccess();
      }

      await Gal.putImageBytes(
        resultImage.value!,
        name: "AI_Generated_${DateTime.now().millisecondsSinceEpoch}",
      );

      AppUtils.showSnack(title: "Success", message: "Image saved to gallery");
      Get.offAllNamed(Routes.bottomNav);
    } catch (e) {
      AppUtils.showSnack(title: "Error", message: "Failed to save image: $e");
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> shareImage() async {
    if (resultImage.value == null) {
      AppUtils.showSnack(title: "Error", message: "No image to share");
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/shared_image.png').create();
      await file.writeAsBytes(resultImage.value!);

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(file.path),
          ],
          text: 'Check out this AI generated image!',
        ),
      );
    } catch (e) {
      AppUtils.showSnack(title: "Error", message: e.toString());
    }
  }
}
