import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool isCircle;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (imageUrl.startsWith('assets/')) {
      image = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade800,
          child: const Icon(Icons.broken_image, color: Colors.white54),
        ),
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,

        /// SHIMMER LOADING
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: const Color(0xff1E293B),
          highlightColor: const Color(0xff334155),
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),

        ///  ERROR UI
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade800,
          child: const Icon(Icons.broken_image, color: Colors.white54),
        ),
      );
    }

    /// 🔥 CIRCLE SUPPORT
    if (isCircle) {
      return ClipOval(child: image);
    }

    return image;
  }
}