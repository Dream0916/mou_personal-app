import 'package:mou_app/utils/app_images.dart';

enum BubbleButtonType {
  Todo,
  Settings,
  Calendar,
  Event;

  (double, double) get positionOffset {
    return switch (this) {
      Todo => (0, 79),
      Settings => (30, 20),
      Calendar => (67, 75),
      Event => (95, 15),
    };
  }

  String get icon {
    return switch (this) {
      Todo => AppImages.icToDoW,
      Settings => AppImages.icMenuBarSettings,
      Calendar => AppImages.icMenuBarAgenda,
      Event => AppImages.icEventW,
    };
  }
}
