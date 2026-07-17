import 'dart:io';

import 'package:ai_photo_generator/utils/app_colors.dart';
import 'package:ai_photo_generator/utils/app_assets.dart';
import 'package:ai_photo_generator/utils/screen_utils.dart';
import 'package:ai_photo_generator/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // keyboard + focus remove
      },
      child: Scaffold(
        backgroundColor: Color(0xff090C11),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal:4.w, vertical: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 4.w,),
                  AppText("Collections", fontSize: 20, fontWeight: FontWeight.w500,color: AppColors.white,),
                  SizedBox(height: 2.w,),
                  AppText("All your generated and edited images\nin one place.", fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white70,),
                  SizedBox(height: 4.w,),
                  Container(
                    width: double.infinity,
                    height: 13.w,
                    decoration: BoxDecoration(
                      color: Color(0xff191929),
                      border: BoxBorder.all(color: Colors.grey.shade600, width: 0.5),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        ///  Search Icon
                        Icon(Icons.search, color: Colors.white70, size: 22),

                        SizedBox(width: 10),

                        ///  TextField
                        Expanded(
                          child: TextField(
                            focusNode: controller.searchFocusNode,
                            onChanged:  controller.updateSearch,
                            // enabled: !controller.isSearchingNoResult,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: "Search...",
                              hintStyle: TextStyle(color: Colors.white54),

                              //  REMOVE ALL BORDERS
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,

                              //  EXTRA CLEAN (important)
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          )
                        )

                      ],
                    ),
                  ),
                  ///  Content Section

                  SizedBox(height: 8.w),
                Obx(() {
                  final todayList = controller.groupedHistory["Today"] ?? [];
                  final yesterdayList = controller.groupedHistory["Yesterday"] ?? [];

                  ///  NO HISTORY AT ALL
                  if (controller.isHistoryEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppAssets.noHistoryFound, height: 25.h),
                          SizedBox(height: 2.h),
                          AppText("No item Found",
                              fontSize: 16, color: AppColors.white),
                        ],
                      ),
                    );
                  }

                  ///  SEARCH NO RESULT
                  if (controller.isSearchingNoResult) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset( AppAssets.noResult,height: 25.h),
                          SizedBox(height: 2.h),
                          AppText("No Item Found",
                              fontSize: 16, color: AppColors.white),
                        ],
                      ),
                    );
                  }

                  ///  NORMAL DATA UI
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// TODAY
                      if (todayList.isNotEmpty) ...[
                        Row(
                          children: [
                            AppText("Today",
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Container(height: 1, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: todayList.length,

                          itemBuilder: (context, index) {
                            final item = todayList[index];
                            final date = formatDate(item.date);
                            return _historyItem(
                              image: item.path,
                              title: item.tag,
                              subtitle: date,
                              onTap: () => controller.openHistoryItem(item),
                            );
                          },
                        ),
                        SizedBox(height: 3.h),
                      ],

                      /// YESTERDAY
                      if (yesterdayList.isNotEmpty) ...[
                        Row(
                          children: [
                            AppText("Yesterday",
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Container(height: 1, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                }),


                  SizedBox(height: 2.h),

                  Obx(() {
                    final yesterdayItems =
                        controller.groupedHistory["Yesterday"] ?? [];



                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: yesterdayItems.length,
                      itemBuilder: (context, index) {
                        final item = yesterdayItems[index];
                       final date =  formatDate(item.date);
                        return _historyItem(
                          image: item.path,
                          title: item.tag,
                          subtitle: date,
                          onTap: () => controller.openHistoryItem(item),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    String year = date.year.toString();
    String month = months[date.month - 1];
    String day = date.day.toString().padLeft(2, '0');

    return "$year $month $day";
  }

  Widget _historyItem({
    required String image,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Container(
            margin: EdgeInsets.only(bottom: 1.5.h),
            height: 22.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(image), // ✅ IMPORTANT CHANGE
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// TITLE
          AppText(
            title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),

          SizedBox(height: 0.5.h),

          /// SUBTITLE
          AppText(
            subtitle,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white54,
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
  // Widget _emptyState() {
  //   return Center(
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 10.w),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(Icons.auto_awesome,
  //               size: 70, color: AppColors.primary),
  //           SizedBox(height: 2.h),
  //           Text(
  //             "No AI Creations Yet",
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.w600,
  //               color: AppColors.textPrimary,
  //             ),
  //           ),
  //           SizedBox(height: 1.h),
  //           Text(
  //             "Start generating AI images and they will appear here.",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               color: AppColors.textSecondary,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}