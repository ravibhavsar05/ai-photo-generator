import 'dart:ui';

class FeatureCardModel {
  final String title;
  final String previewImage;
  final VoidCallback onTap;

  FeatureCardModel({
    required this.title,
    required this.previewImage,
    required this.onTap,
  });
}
