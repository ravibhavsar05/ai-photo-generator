import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final Rx<File?> selectedImage = Rx<File?>(null);

   Future<void> pickFromGallery() async {
    final permission = await _requestGalleryPermission();
    if (!permission) return;

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<bool> _requestGalleryPermission() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;

      if (status.isGranted || status.isLimited) return true;

      if (status.isDenied) {
        status = await Permission.photos.request();
        if (status.isGranted || status.isLimited) return true;
      }

      if (status.isPermanentlyDenied) {
        _showSettingsDialog(
          title: "Gallery Access Required",
          message:
          "Gallery permission is permanently denied. Please enable it from settings.",
        );
        return false;
      }

      return false;
    }

    if (Platform.isAndroid) {
      var status = await Permission.photos.status;

      if (status.isGranted) return true;

      if (status.isDenied) {
        status = await Permission.photos.request();
        if (status.isGranted) return true;
      }

      if (status.isPermanentlyDenied) {
        _showSettingsDialog(
          title: "Gallery Access Required",
          message:
          "Gallery permission is permanently denied. Please enable it from settings.",
        );
        return false;
      }

      return false;
    }

    return false;
  }

  void _showSettingsDialog({
    required String title,
    required String message,
  }) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      textConfirm: "Open Settings",
      textCancel: "Cancel",
      onConfirm: () {
        openAppSettings();
        Get.back();
      },
    );
  }

  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.status;

    if (status.isGranted) return true;

    status = await Permission.camera.request();

    if (status.isGranted) return true;

    // Polite message only
    Get.snackbar(
      'Camera Access Denied',
      'You can enable camera access later in Settings to take photos.',
    );
    return false;
  }

   Future<void> openCamera() async {
    final permission = await _requestCameraPermission();
    if (!permission) return;

    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }


  void clearImage() {
    selectedImage.value = null;
  }
}
