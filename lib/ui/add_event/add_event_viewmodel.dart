import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/models/day_in_week.dart';
import 'package:mou_app/core/models/time_in_alarm.dart';
import 'package:mou_app/core/repositories/event_repository.dart';
import 'package:mou_app/core/repositories/user_repository.dart';
import 'package:mou_app/core/requests/event_request.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/send_notification_local.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:rxdart/rxdart.dart';

class AddEventViewModel extends BaseViewModel {
  final EventRepository eventRepository;
  final UserRepository userRepository;
  final Event? event;

  AddEventViewModel({
    required this.event,
    required this.eventRepository,
    required this.userRepository,
  });

  final titleController = TextEditingController();
  final titleFocusNode = FocusNode();

  final commentController = TextEditingController();
  final commentFocusNode = FocusNode();

  final placeController = TextEditingController();
  final placeFocusNode = FocusNode();

  final alarmsSubject = BehaviorSubject<List<TimeInAlarm>>();
  final contactSubject = BehaviorSubject<String>();
  final busyModeSubject = BehaviorSubject<String>();
  final startDateHourSubject = BehaviorSubject<String>();
  final endDateHourSubject = BehaviorSubject<String>();

  final isTypingTitle = BehaviorSubject<bool?>();
  final isTypingDate = BehaviorSubject<bool?>();
  final isTypingComment = BehaviorSubject<bool?>();
  final isTagSomeOne = BehaviorSubject<bool?>();
  final isTypingPlace = BehaviorSubject<bool?>();
  final isSelectAlarm = BehaviorSubject<bool?>();

  DateTime? startDateHour;
  DateTime? endDateHour;

  List<DayInWeek>? daysInWeek;
  List<TimeInAlarm> timesInAlarm = [];
  List<Contact>? contacts;

  int bugModeStatus = -1;

  void initData() {
    _initEvent(event);

    // update animation
    isTypingTitle.add(titleController.text.trim().isNotEmpty);
    isTypingDate.add(startDateHourSubject.valueOrNull?.isNotEmpty);
    isTypingComment.add(commentController.text.trim().isNotEmpty);
    isTagSomeOne.add(contactSubject.valueOrNull?.isNotEmpty);
    isTypingPlace.add(placeController.text.trim().isNotEmpty);
    isSelectAlarm.add(alarmsSubject.valueOrNull?.isNotEmpty);
  }

  void _initEvent(Event? event) {
    if (event == null) return;

    final String startDateString = event.startDate ?? '';
    if (startDateString.isNotEmpty) {
      DateTime startDate = DateTime.tryParse(startDateString) ?? DateTime.now();
      DateTime? endDate;
      final bool showEndDate = event.showEndDate ?? true;
      final String endDateString = event.endDate ?? '';
      if (showEndDate && endDateString.isNotEmpty) {
        endDate = DateTime.parse(event.endDate ?? '');
      }

      setDateHour(
        startDate.hour,
        startDate.minute,
        startDate.day,
        startDate.month,
        startDate.year,
        endDate == null ? 0 : endDate.hour,
        endDate == null ? 0 : endDate.minute,
        endDate == null ? 0 : endDate.day,
        endDate == null ? 0 : endDate.month,
        endDate == null ? 0 : endDate.year,
      );
    }

    if (timeInAlarmData.length > 0) {
      var lstAlarm = event.alarm?.split(";") ?? [];
      if (lstAlarm.isNotEmpty) {
        var timeInAlarmLocal = <TimeInAlarm>[];
        for (int i = 0; i < lstAlarm.length; i++) {
          var timeInAlarmExist = timeInAlarmData.firstWhere((item) => item.value == lstAlarm[i]);
          timeInAlarmLocal.add(timeInAlarmExist);
        }

        setTimeInAlarm(timeInAlarmLocal);
      }
    }

    final List<Contact> contacts =
        event.users?.map<Contact>((item) => Contact.fromJson(item)).toList() ?? [];
    if (contacts.isNotEmpty) {
      setContacts(contacts);
    }

    titleController.text = event.title ?? '';
    commentController.text = event.comment ?? '';
    placeController.text = event.place ?? '';

    if (event.busyMode != null) {
      setBugMode(event.busyMode!);
    }
  }

  void setDateHour(
    int startHour,
    int startMinute,
    int startDay,
    int startMonth,
    int startYear,
    int endHour,
    int endMinute,
    int endDay,
    int endMonth,
    int endYear,
  ) {
    startDateHour = DateTime(startYear, startMonth, startDay, startHour, startMinute);
    endDateHour = DateTime(endYear, endMonth, endDay, endHour, endMinute);

    var startDateHourString =
        DateFormat(AppConstants.dateFormat).format(startDateHour ?? DateTime.now()).toString();
    var endDateHourString =
        DateFormat(AppConstants.dateFormat).format(endDateHour ?? DateTime.now()).toString();
    var startHourMinute = DateFormat(AppConstants.hourMinuteFormat)
        .format(startDateHour ?? DateTime.now())
        .toString();
    var endHourMinute =
        DateFormat(AppConstants.hourMinuteFormat).format(endDateHour ?? DateTime.now()).toString();

    if (endDay == 0 || endMonth == 0 || endYear == 0) {
      endDateHour = null;
      endDateHourSubject.add("");
      startDateHourSubject.add("$startDateHourString $startHourMinute");
    } else {
      if (startDay == endDay && startMonth == endMonth && startYear == endYear) {
        startDateHourSubject.add("$startDateHourString $startHourMinute - $endHourMinute");
        endDateHourSubject.add("");
      } else {
        startDateHourSubject.add("$startDateHourString $startHourMinute");
        endDateHourSubject.add("$endDateHourString $endHourMinute");
      }
    }
  }

  void setTimeInAlarm(List<TimeInAlarm> timesInAlarm) {
    this.timesInAlarm = timesInAlarm;
    alarmsSubject.add(timesInAlarm);
  }

  void setBugMode(int status) {
    this.bugModeStatus = status;
    busyModeSubject.add(this.bugModeStatus == 0 ? "Off" : "On");
  }

  void setContacts(List<Contact> contacts) {
    this.contacts = contacts;
    if (this.contacts != null) {
      List<String> contactsString = this.contacts!.map<String>((item) => item.name ?? '').toList();
      if (contactsString.length > 0) {
        contactSubject.add(contactsString.join(", "));
      } else {
        contactSubject.add("");
      }
    }
  }

  void createEvent() async {
    try {
      FocusScope.of(context).unfocus();
      setLoading(true);
      if (validate) {
        List<int>? userIds;
        if (contacts != null && contacts!.length > 0) {
          userIds = contacts!.map<int>((item) => item.id).toList();
        }

        String alarmString = "";
        alarmString = alarmsSubject.valueOrNull
                ?.map<String>((item) => item.value != null ? item.value.toString() : "")
                .join(";") ??
            '';

        EventRequest eventRequest = EventRequest(
          id: event?.id ?? 0,
          title: titleController.text,
          startDate: startDateHour!,
          endDate: endDateHour,
          comment: commentController.text,
          alarm: alarmString,
          place: placeController.text,
          busyMode: bugModeStatus == -1 ? 0 : bugModeStatus,
          userIds: userIds ?? [],
        );

        final response = event == null
            ? await eventRepository.createEvent(eventRequest)
            : await eventRepository.updateEvent(eventRequest);
        if (response.isSuccess) {
          if (event != null) {
            await SendNotificationLocal.removeEventRegisterFromDevice(event!);
          }
          SendNotificationLocal.registerLocalNotification(response.data ?? Event(id: 0));
          if (event == null) {
            // create new event
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routers.HOME,
              (route) => false,
              arguments: startDateHour,
            );
          } else {
            // edit event
            Navigator.pop(context);
          }
        } else {
          showSnackBar(response.message ?? "");
        }
      }
      setLoading(false);
    } catch (e) {
      setLoading(false);
      showSnackBar(e.toString());
    }
  }

  bool get validate {
    if (titleController.text.isEmpty) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseInputTitle));
      return false;
    } else if (startDateHourSubject.valueOrNull?.isEmpty ?? true) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseInputStartDate));
      return false;
    } else if (startDateHour != null &&
        DateTime(startDateHour!.year, startDateHour!.month, startDateHour!.day, 23, 59, 59)
            .isBefore(DateTime.now())) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseInputStartTimeGreaterCurrentTime));
      return false;
    } else if (startDateHour != null &&
        endDateHour != null &&
        startDateHour!.isAfter(endDateHour!)) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseInputStartDateSmallerEndDate));
      return false;
    }
    return true;
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    isTypingTitle.close();
    isTypingPlace.close();
    isTypingDate.close();
    isTypingComment.close();
    isTagSomeOne.close();
    isSelectAlarm.close();

    titleController.dispose();
    titleFocusNode.dispose();

    commentController.dispose();
    commentFocusNode.dispose();

    alarmsSubject.drain();
    alarmsSubject.close();

    placeController.dispose();
    placeFocusNode.dispose();

    startDateHourSubject.drain();
    startDateHourSubject.close();

    endDateHourSubject.drain();
    endDateHourSubject.close();

    contactSubject.drain();
    contactSubject.close();

    busyModeSubject.drain();
    busyModeSubject.close();

    super.dispose();
  }
}
