import 'package:flutter/material.dart';
import 'package:mou_app/utils/app_images.dart';

import '../app_colors.dart';

enum EventStatus {
  REQUEST,
  WAITING,
  CONFIRMED;

  String get inactiveIconAsset {
    return switch (this) {
      REQUEST => AppImages.icRequestInactive,
      WAITING => AppImages.icWaitingInactive,
      CONFIRMED => AppImages.icConfirmInactive,
    };
  }

  String get activeIconAsset {
    return switch (this) {
      REQUEST => AppImages.icRequestActive,
      WAITING => AppImages.icWaitingActive,
      CONFIRMED => AppImages.icCompleteActive,
    };
  }

  Color get color {
    return switch (this) {
      REQUEST => AppColors.redColor,
      WAITING => AppColors.colorGradient2,
      CONFIRMED => Colors.transparent,
    };
  }
}
