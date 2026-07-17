import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

class CropImageController extends GetxController {
  final File imageFile;

  CropImageController(this.imageFile);

  final CropController cropController = CropController();

  Rxn<Uint8List> originalBytes = Rxn();
  Rxn<Uint8List> imageBytes = Rxn();
  Rxn<Uint8List> croppedPreview = Rxn();

  RxBool isCropping = false.obs;
  RxBool shouldReturnResult = false.obs;

  Rxn<double> aspectRatio = Rxn<double>();

  int rotationTurns = 0;
  bool flipX = false;
  bool flipY = false;

  @override
  void onInit() {
    super.onInit();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final bytes = await imageFile.readAsBytes();
    originalBytes.value = bytes;
    imageBytes.value = bytes;
  }

  Future<void> updateTransformedImage() async {
    if (originalBytes.value == null) return;

    final decoded = img.decodeImage(originalBytes.value!);
    if (decoded == null) return;

    img.Image current = decoded;

    if (rotationTurns != 0) {
      final angle = (rotationTurns % 4) * 90;
      if (angle != 0) {
        current = img.copyRotate(current, angle: angle);
      }
    }

    if (flipX) current = img.flipHorizontal(current);
    if (flipY) current = img.flipVertical(current);

    imageBytes.value = Uint8List.fromList(img.encodePng(current));
    croppedPreview.value = null;
  }

  void startCropping({required bool returnResult}) {
    if (imageBytes.value == null || isCropping.value) return;

    isCropping.value = true;
    shouldReturnResult.value = returnResult;

    cropController.crop();
  }

  void handleCropped(Uint8List croppedImage) async {
    isCropping.value = false;
    croppedPreview.value = croppedImage;

    if (shouldReturnResult.value) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!isClosed) {
        Get.back(result: croppedImage);
      }
    }
  }

  void setAspectRatio(double? ratio) {
    cropController.aspectRatio = ratio;
    aspectRatio.value = ratio;
  }

  void rotateLeft() {
    rotationTurns = (rotationTurns - 1) % 4;
    updateTransformedImage();
  }

  void rotateRight() {
    rotationTurns = (rotationTurns + 1) % 4;
    updateTransformedImage();
  }

  void toggleFlipX() {
    flipX = !flipX;
    updateTransformedImage();
  }

  void toggleFlipY() {
    flipY = !flipY;
    updateTransformedImage();
  }
}