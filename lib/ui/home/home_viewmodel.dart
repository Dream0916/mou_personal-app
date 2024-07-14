import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/core/models/list_response.dart';
import 'package:mou_app/core/repositories/contact_repository.dart';
import 'package:mou_app/core/repositories/event_repository.dart';
import 'package:mou_app/core/repositories/notification_repository.dart';
import 'package:mou_app/core/repositories/user_repository.dart';
import 'package:mou_app/core/requests/contact_request.dart';
import 'package:mou_app/core/resource.dart';
import 'package:mou_app/helpers/permissions_service.dart';
import 'package:mou_app/helpers/push_notification_helper.dart';
import 'package:mou_app/helpers/push_notification_local_helper.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/type/notify_type.dart';
import 'package:mou_app/ui/base/loadmore_viewmodel.dart';
import 'package:mou_app/ui/project_detail/project_detail_page.dart';
import 'package:mou_app/utils/app_globals.dart';
import 'package:mou_app/utils/app_shared.dart';
import 'package:mou_app/utils/app_types/event_task_type.dart';
import 'package:mou_app/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart' hide Notification;

class HomeViewModel extends LoadMoreViewModel<Event> {
  final focusedDaySubject = BehaviorSubject<DateTime>();
  final eventsSubject = BehaviorSubject<Map<DateTime, List<dynamic>>>();

  final EventRepository _eventRepository;
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;
  final PermissionsService _permissionsService;
  final ContactRepository _contactRepository;

  HomeViewModel(
    this._eventRepository,
    this._userRepository,
    this._notificationRepository,
    this._permissionsService,
    this._contactRepository,
  );

  @override
  Future<Resource<ListResponse>> onSyncResource(int page) {
    DateTime selected = AppUtils.clearTime(focusedDaySubject.value) ?? DateTime.now();
    return _eventRepository.getHomeEventsByDate(selected, page);
  }

  init(DateTime? selectedDay) {
    focusedDaySubject.add(selectedDay ?? DateTime.now());
    _countNotifications();
    _registerFCM();
    _initDynamicLinks();
    this.onRefresh();
    this.onSyncResource(1);

    _syncContacts();
  }

  void _initDynamicLinks() async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    _navigationDeepLink(data?.link);

    FirebaseDynamicLinks.instance.onLink.listen(
      (dynamicLink) => _navigationDeepLink(dynamicLink.link),
      onError: (e) async {
        print('onLinkError');
        print(e.message);
      },
    );
  }

  void _navigationDeepLink(Uri? deepLink) {
    if (deepLink == null) return;
    print("Dynamic link path: ${deepLink.toString()}");
    _navigationSMSMessage(deepLink.queryParameters);
  }

  void _registerFCM() {
    PushNotificationHelper.getToken().then((firebaseToken) {
      if (firebaseToken.isEmpty) return;
      //Update FireBase Cloud Message Token to server
      final deviceOS = Platform.isIOS ? "ios" : "android";
      _userRepository
          .updateFCMToken(token: firebaseToken, deviceOS: deviceOS)
          .then((value) => print("Update FCM ${value.message}"))
          .catchError((error) => print("Update FCM " + error.toString()));
    });
    PushNotificationHelper.processInitialMessage();
    PushNotificationHelper.setNotificationCallback((firebaseMessage) {
      if (firebaseMessage.isNavigate) {
        // Handle action when touch notify
        if (firebaseMessage.type == NotifyType.SMS_MESSAGE) {
          _navigationSMSMessage(firebaseMessage.toJson());
        } else {
          _navigationMessage(firebaseMessage.toJson());
        }
      } else if (firebaseMessage.title.isNotEmpty && (Platform.isAndroid || Platform.isIOS)) {
        PushNotificationLocalHelper.getInstance().showNotification(
          firebaseMessage.title,
          firebaseMessage.body,
          jsonEncode(firebaseMessage.toJson()),
        );
      }
    });

    PushNotificationLocalHelper.getInstance()
      ..addAlarmCallback((alarmDate) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routers.HOME,
          (router) => false,
          arguments: alarmDate,
        );
      })
      ..addMessageCallback((message) async {
        // Handle action when touch local notify
        String notifyType = "";
        if (message.containsKey("notify_type")) {
          notifyType = message["notify_type"] ?? "";
        }
        if (notifyType == NotifyType.SMS_MESSAGE) {
          _navigationSMSMessage(message);
        } else {
          _navigationMessage(message);
        }
      });
  }

  void _navigationMessage(Map<String, dynamic> message) {
    debugPrint('Navigation Message: ${jsonEncode(message)}');
    final String routeName = message.containsKey('route_name') ? message['route_name'] : '';
    if (routeName.isNotEmpty) {
      final arguments = message.containsKey('arguments') ? message['arguments'] : null;
      if (routeName == Routers.HOME) {
        Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false,
            arguments: arguments);
      } else {
        Navigator.pushNamed(context, routeName, arguments: arguments);
      }
    }
  }

  void navigateNotification(Notification notification) => _navigationMessage(notification.toJson());

  Future<void> _fetchEventChecks(DateTime fromDate, DateTime toDate) async {
    final dbEventChecks = await _eventRepository.getDBEventChecks(fromDate, toDate);
    _updateEvents(dbEventChecks);

    final resource = await _eventRepository.getEventChecks(fromDate, toDate);
    final focusedDay = focusedDaySubject.value;
    if (fromDate.isBefore(focusedDay) && toDate.isAfter(focusedDay)) {
      _updateEvents(resource.data ?? {});
    }
  }

  void _updateEvents(Map<String, dynamic> eventChecks) {
    Map<DateTime, List<dynamic>> events = {};
    eventChecks.forEach((key, value) {
      final dateKey = DateTime.parse(key);
      DateTime date = DateTime(dateKey.year, dateKey.month, dateKey.day);
      events[date] = [value];
    });
    if (!eventsSubject.isClosed) eventsSubject.add(events);
  }

  void onBackPressed() {
    Navigator.popUntil(context, (router) => router.isFirst);
    Navigator.pushNamed(
      context,
      Routers.MONTH_CALENDAR,
      arguments: focusedDaySubject.valueOrNull,
    );
  }

  void onAddPressed() => Navigator.pushNamed(context, Routers.ADD_EVENT);

  void onDaySelected(DateTime day) {
    _eventRepository.cancel();
    focusedDaySubject.add(day);
    this.onRefresh();
  }

  Future<void> onLeave(Event? event) async {
    if (event == null) return;
    if (event.type == EventTaskType.ROSTER) {
      await _eventRepository.declineRoster(event.id);
    } else {
      await _eventRepository.leaveEvent(event.id);
    }
  }

  @override
  Future<void> onRefresh() {
    final selected = AppUtils.clearTime(focusedDaySubject.valueOrNull);
    if (selected != null) {
      final weekDay = selected.weekday % 7;
      _fetchEventChecks(
        selected.subtract(Duration(days: weekDay)),
        selected.add(Duration(days: 6 - weekDay)),
      );
    }
    return super.onRefresh();
  }

  @override
  void dispose() {
    _eventRepository.cancel();
    focusedDaySubject.close();
    eventsSubject.close();
    super.dispose();
  }

  void _navigationSMSMessage(Map<String, dynamic> message) {
    if (message.isEmpty) return;
    if (message.containsKey("page")) {
      final page = message["page"] ?? "";
      print("Dynamic link page: $page");
      if (page.contains("corp")) {
        Navigator.pushNamed(context, Routers.CORP);
      } else if (page.contains("event")) {
        final key = message["key"] ?? 0;
        print("Dynamic link key: $key");
        Navigator.pushNamed(context, Routers.EVENT, arguments: int.parse(key.toString()));
      } else if (page.contains("project_detail")) {
        final id = message["id"] ?? 0;
        final name = message["name"] ?? 0;
        Navigator.pushNamed(context, Routers.PROJECT_DETAIL,
            arguments: ProjectDetailArgument(int.parse(id.toString()), name));
      }
    } else if (message.containsKey("action")) {
      final action = message["action"] ?? "";
      print("Dynamic link action: $action");
      if (action.contains("PHONE_CHANGE")) {
        AppGlobals.logout(context, arguments: message);
      }
    }
  }

  Future<void> _countNotifications() async {
    Resource<int?> resource = await _notificationRepository.countNotifications();

    if (resource.isSuccess) {
      AppShared.setCountNotification(resource.data ?? 0);
    }
  }

  Future<List<Notification>> getNotifications(int page) async {
    return _notificationRepository.getNotifications(page).then((resource) {
      if (resource.isSuccess) {
        return resource.data ?? [];
      } else {
        final String message = resource.message ?? '';
        if (message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ));
        }
        return <Notification>[];
      }
    });
  }

  Future<List<Notification>> getLocalNotifications() =>
      _notificationRepository.notificationDao.getAllNotifications();

  Future<void> _syncContacts() async {
    final isGranted = await _permissionsService.hasContactsPermission();
    if (!isGranted) return;
    var contacts = await ContactsService.getContacts();
    contacts = contacts
        .where((contact) =>
            contact.phones != null &&
            contact.phones!.isNotEmpty &&
            contact.phones!.first.value!.length > 6)
        .toList();
    if (contacts.isNotEmpty) {
      final user = await AppShared.getUser();
      List<ContactRequest> contactRequests = <ContactRequest>[];
      for (int i = 0; i < contacts.length; i++) {
        final contact = contacts[i];
        String phone = contact.phones
                ?.where((element) => element.value?.isNotEmpty ?? false)
                .firstOrNull
                ?.value ??
            '';
        String dialCode = _getDialCode(phone);
        String formattedPhone = _formatPhone(dialCode.isEmpty
            ? phone.startsWith("0")
                ? phone.replaceFirst("0", "")
                : phone
            : phone.replaceFirst(dialCode, ""));

        contactRequests.add(ContactRequest(
          name: contact.displayName ?? formattedPhone,
          phoneNumber: formattedPhone,
          dialCode: dialCode.isEmpty ? user.dialCode : dialCode,
          avatar: null,
        ));
      }

      try {
        int numberItemInUpload = 20;
        if (contactRequests.length > numberItemInUpload) {
          // Get the number of times a submit contact request has been sent
          double contactDiv = contactRequests.length.toDouble() / numberItemInUpload.toDouble();
          for (double i = 0; i < contactDiv; i++) {
            // Check if the first items is enough with one call
            double degIndex = contactDiv - (i + 1).toDouble();
            double endIndex = 0;
            if (degIndex < 0) {
              endIndex = (contactDiv - i.toDouble()).abs();
            } else {
              endIndex = contactDiv - degIndex;
            }

            int startIndexList = (i * numberItemInUpload).toInt();
            int endIndexList = degIndex < 0
                ? startIndexList + (endIndex * numberItemInUpload).toInt()
                : (endIndex * numberItemInUpload).toInt();
            var subList = contactRequests.sublist(startIndexList, endIndexList);
            await importContact(subList, contactRequests.length);
          }
        } else {
          await importContact(contactRequests, contactRequests.length);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  int _sumItemUpload = 0;

  Future<void> importContact(List<ContactRequest> contactRequests, int totalUpload) async {
    if (_sumItemUpload > 0) {
      // delay to avoid Too Many Attempts error from server
      await Future.delayed(const Duration(seconds: 1));
    }
    var resource = await _contactRepository.importContact(contactRequests);
    if (resource.isSuccess) {
      _sumItemUpload += contactRequests.length;
      if (_sumItemUpload <= totalUpload) {
        if (_sumItemUpload == totalUpload) {
          await _contactRepository.getAllContact();
        }
      }
    }
  }

  String _getDialCode(String phone) {
    if (phone.isNotEmpty && phone.trim().startsWith("+")) {
      String dialCode = "";
      final List<CountryPhoneCode> _phoneCodes = AppUtils.appCountryCodes;
      for (int i = 4; i > 1; i--) {
        var subPhone = phone.substring(0, i);
        bool isExist = _phoneCodes.indexWhere((item) => item.dialCode == subPhone) >= 0;
        if (isExist) {
          return dialCode;
        }
      }
    }
    return "";
  }

  String _formatPhone(String phone) {
    return phone.replaceAll(" ", "").replaceAll("-", "").replaceAll(RegExp(r'(?:_|[^\w\s])+'), '');
  }
}
