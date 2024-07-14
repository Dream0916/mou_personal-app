
import 'package:flutter/material.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_constants.dart';

class AppStyles {
  static TextStyle heading7Style = TextStyle(
    color: AppColors.normal,
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    fontFamily: AppConstants.fontQuickSand,
  );

  static TextStyle subheadingStyle = TextStyle(
    color: AppColors.normal,
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    fontFamily: AppConstants.fontQuickSand,
  );

  static TextStyle bodyStyle = TextStyle(
    color: AppColors.normal,
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    fontFamily: AppConstants.fontQuickSand,
  );
}
