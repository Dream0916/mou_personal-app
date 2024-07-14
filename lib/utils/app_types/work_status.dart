import 'dart:ui';

import 'package:mou_app/utils/app_images.dart';

enum WorkStatus {
  OPEN,
  IN_PROGRESS,
  DONE;

  String get apiRequestName {
    return switch (this) {
      OPEN => "open",
      IN_PROGRESS => "progress",
      DONE => "done",
    };
  }

  String get inactiveIconAsset {
    return switch (this) {
      OPEN => AppImages.icOpenInactive,
      IN_PROGRESS => AppImages.icOngoingInactive,
      DONE => AppImages.icConfirmInactive,
    };
  }

  String get activeIconAsset {
    return switch (this) {
      OPEN => AppImages.icOpenActive,
      IN_PROGRESS => AppImages.icOngoingActive,
      DONE => AppImages.icCompleteActive,
    };
  }

  Color get color {
    return switch (this) {
      OPEN => Color(0xffebe71d),
      IN_PROGRESS => Color(0xffed1c24),
      DONE => Color(0xff5367b0),
    };
  }

  Color get gradientColor {
    return switch (this) {
      OPEN => Color(0xFFEDEBEA),
      IN_PROGRESS => Color(0xFFFEFBD8),
      DONE => Color(0xFFD7EAC9),
    };
  }
}
