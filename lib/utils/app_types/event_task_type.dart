import 'package:mou_app/utils/app_images.dart';

enum EventTaskType {
  EVENT,
  PROJECT_TASK,
  TASK,
  ROSTER;

  static List<EventTaskType> get workPageTypes =>
      EventTaskType.values.where((e) => e != EventTaskType.EVENT).toList();

  String get inactiveEventIcon {
    return switch (this) {
      EVENT => AppImages.btFilterEEventsOff,
      PROJECT_TASK => AppImages.btFilterEProjectOff,
      TASK => AppImages.btFilterETasksOff,
      ROSTER => AppImages.btFilterERostersOff,
    };
  }

  String get activeEventIcon {
    return switch (this) {
      EVENT => AppImages.btFilterEEventsOn,
      PROJECT_TASK => AppImages.btFilterEProjectOn,
      TASK => AppImages.btFilterETasksOn,
      ROSTER => AppImages.btFilterERostersOn,
    };
  }

  String get inactiveWorkIcon {
    return switch (this) {
      EVENT => '',
      PROJECT_TASK => AppImages.btFilterWProjectOff,
      TASK => AppImages.btFilterWTaskOff,
      ROSTER => AppImages.btFilterWRosterOff,
    };
  }

  String get activeWorkIcon {
    return switch (this) {
      EVENT => '',
      PROJECT_TASK => AppImages.btFilterWProjectOn,
      TASK => AppImages.btFilterWTaskOn,
      ROSTER => AppImages.btFilterWRosterOn,
    };
  }
}
