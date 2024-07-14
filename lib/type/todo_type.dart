import 'package:mou_app/utils/app_images.dart';

enum TodoType {
  SINGLE,
  GROUP;

  String get inactiveIcon {
    return switch (this) {
      SINGLE => AppImages.btFilterSingleOff,
      GROUP => AppImages.btFilterGroupOff,
    };
  }

  String get activeIcon {
    return switch (this) {
      SINGLE => AppImages.btFilterSingleOn,
      GROUP => AppImages.btFilterGroupOn,
    };
  }
}
