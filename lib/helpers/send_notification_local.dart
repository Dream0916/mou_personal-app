import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/models/notify_id_management.dart';
import 'package:mou_app/core/models/time_in_alarm.dart';
import 'package:mou_app/helpers/push_notification_local_helper.dart';
import 'package:mou_app/utils/app_shared.dart';

class SendNotificationLocal {
  static List<NotifyIdManagement> notifyIds = [];

  static void registerLocalNotification(Event event) {
    notifyIds = <NotifyIdManagement>[];
    if (event.alarm != null && (event.busyMode == null || event.busyMode == 0)) {
      if (event.startDate != null && event.endDate != null) {
        //trường hợp alarm bằng khác null và repeat null thì thông báo sẽ hiển
        //thị vào thời gian đăng ký alarm và đúng vào giờ ngày bắt đầu sự
        //kiện
        _checkAlarm(event);
      } else if (event.startDate != null && event.endDate == null) {
        _checkAlarmStartDate(event, true);
      }
      if (notifyIds.isNotEmpty) {
        _saveEventNotifyToDataLocal();
      }
    }
  }

  //Trường hợp ngày bắt đầu khác null và ngày kết thúc null
  //Chọn Alarm và không chọn Repeat
  static void _checkAlarmStartDate(Event event, bool isFirst) {
    var lstAlarmString = event.alarm!.split(";");
    if (lstAlarmString.isNotEmpty) {
      DateTime? startDate = DateTime.parse(event.startDate ?? '');
      startDate = DateTime.now().difference(startDate).inDays > 6 &&
              DateTime.now().difference(startDate).inDays % 7 == 0
          ? DateTime.now().add(Duration(days: 1))
          : startDate;
      if (!isFirst && startDate.difference(DateTime.now()).inDays < 7) startDate = null;
      if (startDate != null) {
        for (var i = 0; i < lstAlarmString.length; i++) {
          for (int j = 0; j < 7; j++) {
            _prepareAddNotifyAlarm(event, startDate, j, lstAlarmString[i]);
          }
        }
      }
    }
  }

  //Trường hợp ngày bắt đầu và ngày kết thúc khác null
  //Chọn Alarm và không chọn Repeat
  static void _checkAlarm(Event event) {
    var lstAlarmString = event.alarm!.split(";");
    if (lstAlarmString.isNotEmpty) {
      var startDate = DateTime.parse(event.startDate ?? '');
      var endDate = DateTime.parse(event.endDate ?? '');
      int inDays = endDate.difference(startDate).inDays;
      int inStartDays = DateTime.now().difference(startDate).inDays;
      int daysDiff = inDays;
      if (inDays == 0) inDays = 1;

      startDate = startDate.add(Duration(days: inStartDays));
      if (daysDiff <= 0) {
        var hourDiff = DateTime.now().difference(startDate).inHours;
        if (hourDiff > 0) {
          startDate = startDate.add(Duration(days: 1));
        } else {
          var minuteDiff = DateTime.now().difference(startDate).inMinutes;
          if (minuteDiff > 0) {
            startDate = startDate.add(Duration(days: 1));
          }
        }
      }

      for (var i = 0; i < lstAlarmString.length; i++) {
        for (int j = 0; j < inDays; j++) {
          _prepareAddNotifyAlarm(event, startDate, daysDiff == 0 ? 0 : j, lstAlarmString[i]);
        }
      }
    }
  }

  //Kiểm tra loại alarm này thuộc loại báo thức 5 phút, 10 phút...
  // để đăng ký thông báo vào thiết bị
  static void _prepareAddNotifyAlarm(Event event, DateTime startDate, int days, String minutes) {
    switch (minutes) {
      case fiveMinutes:
        _addNotifyAlarm(event: event, startDate: startDate, days: days, minutes: 5);
        break;
      case tenMinutes:
        _addNotifyAlarm(event: event, startDate: startDate, days: days, minutes: 10);
        break;
      case thirtyMinutes:
        _addNotifyAlarm(event: event, startDate: startDate, days: days, minutes: 30);
        break;
      case oneHour:
        _addNotifyAlarm(event: event, startDate: startDate, days: days, minutes: 60);
        break;
      case oneDay:
        _addNotifyAlarm(event: event, startDate: startDate, days: days, minutes: 24 * 60);
        break;
      case oneWeek:
        _addNotifyAlarm(event: event, startDate: startDate, days: days, minutes: 7 * 24 * 60);
        break;
    }
  }

  // Kiểm tra  ngày bắt đầu sự kiện có giống với ngày bắt đầu sự kiện cộng thêm ngày
  // VD: Nếu ngày bắt đầu sự kiện là ngày thứ 2 và ngày bắt đầu sự kiện công 2 ngày
  // có phải là ngày thứ 2 hay không nếu bằng thì thêm báo thức
  static void _addNotifyAlarm({
    required Event event,
    required DateTime startDate,
    required int days,
    required int minutes,
  }) {
    if (startDate.weekday == startDate.add(Duration(days: days)).weekday) {
      _sendNotification(event, startDate.add(Duration(days: days)).add(Duration(minutes: minutes)));
      _sendNotification(event, startDate.add(Duration(days: days)));
    }
  }

  // Đăng ký báo thức cho ứng dụng
  static void _sendNotification(Event event, DateTime dateTime) async {
    DateTime createdAt = DateTime.parse(event.startDate ?? '');
    PushNotificationLocalHelper.getInstance().singleNotification(
      dateTime,
      event.title ?? "",
      event.comment ?? "",
      dateTime.hashCode,
      createdAt,
    );
    notifyIds.add(NotifyIdManagement(id: event.id, notifyId: dateTime.hashCode));
  }

  static Future<void> _saveEventNotifyToDataLocal() async {
    var notifyIdManagements = await AppShared.getNotifyIdManagementList();
    if ((notifyIdManagements.notifyIdManagements == null)) {
      notifyIdManagements = NotifyIdManagementList();
      notifyIdManagements.notifyIdManagements = <NotifyIdManagement>[];
    }
    notifyIdManagements.notifyIdManagements?.addAll(notifyIds);
    await AppShared.setNotifyIdManagementList(notifyIdManagements);
  }

  static Future<void> removeEventRegisterFromDevice(Event event) async {
    var notifyIdManagements = await AppShared.getNotifyIdManagementList();
    if (notifyIdManagements.notifyIdManagements != null &&
        notifyIdManagements.notifyIdManagements!.isNotEmpty) {
      var notifyListFilter =
          notifyIdManagements.notifyIdManagements?.where((item) => item.id == event.id).toList();
      if (notifyListFilter != null && notifyListFilter.isNotEmpty) {
        for (var notify in notifyListFilter) {
          await PushNotificationLocalHelper.getInstance().cancel(notify.notifyId ?? 0);
        }
        notifyIdManagements.notifyIdManagements =
            notifyIdManagements.notifyIdManagements?.where((item) => item.id != event.id).toList();
        await AppShared.setNotifyIdManagementList(notifyIdManagements);
      }
    }
  }
}
