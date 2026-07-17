import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_photo_generator/utils/app_colors.dart';
import 'package:ai_photo_generator/utils/screen_utils.dart';
import '../../../../core/theme/styles.dart';
import '../models/history_model.dart';

class HistoryCard extends StatelessWidget {
  final HistoryModel item;
  final VoidCallback? onTap;

  const HistoryCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: AppShadows.soft,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [

              /// Image
              Positioned.fill(
                child: item.path.startsWith('http')
                    ? Image.network(item.path,
                    fit: BoxFit.cover)
                    : Image.file(
                  File(item.path),
                  fit: BoxFit.cover,
                ),
              ),

              /// Dark gradient
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

              /// Bottom content
              Positioned(
                left: 4.w,
                right: 4.w,
                bottom: 2.h,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: .5.h),
                    Text(
                      item.tag,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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