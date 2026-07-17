import 'package:ai_photo_generator/utils/app_colors.dart';
import 'package:ai_photo_generator/widgets/shimmer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/styles.dart';
import '../../../widgets/app_text.dart';

class GenerativeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  const GenerativeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 30.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: AppShadows.medium,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [

              /// Image
              Positioned.fill(
                child: imageUrl.startsWith('http')
                    ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => ShimmerWidget(
                    child: Container(color: AppColors.cardBg),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.cardBg,
                    child: const Icon(Icons.error),
                  ),
                )
                    : Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),

              /// Dark gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: .7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

                // Positioned(
                //   top: 2.h,
                //   left: 4.w,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: .6.h),
                //     decoration: BoxDecoration(
                //       gradient: AppColors.heroGradient,
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: AppText(
                //       "Featured",
                //       fontSize: 11,
                //       fontWeight: FontWeight.w600,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),

              /// Bottom Text Content
              Positioned(
                left: 4.w,
                right: 4.w,
                bottom: 3.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    SizedBox(height: .5.h),
                    AppText("Tap to generate with AI", fontSize: 12, color: Colors.white.withValues(alpha: .85)),
                  ],
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}