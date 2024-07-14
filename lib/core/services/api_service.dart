import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/requests/change_phone_request.dart';
import 'package:mou_app/core/requests/contact_request.dart';
import 'package:mou_app/core/requests/event_request.dart';
import 'package:mou_app/core/requests/push_notify_request.dart';
import 'package:mou_app/core/requests/todo_request.dart';
import 'package:mou_app/core/requests/user_request.dart';
import 'package:mou_app/utils/app_apis.dart';
import 'package:mou_app/utils/app_clients.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_utils.dart';
import 'package:path/path.dart' as path;

class APIService {
  static Future<Response<dynamic>> getEventsByDate(
      DateTime dateTime, int page, CancelToken cancelToken) async {
    final value = AppUtils.convertDayToString(dateTime, format: "yyyy-MM-dd");
    final api = AppApis.getEventsByDate(value, page);
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> checkEventDateOfMonth(
      DateTime fromDate, DateTime toDate, CancelToken cancelToken) async {
    final String from = AppUtils.convertDayToString(fromDate, format: "yyyy-MM-dd");
    final String to = AppUtils.convertDayToString(toDate, format: "yyyy-MM-dd");
    final api = AppApis.checkEventDateOfMonth(from, to);
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> getCountEvent(
    CancelToken cancelToken, {
    List<String>? eventTypes,
    int tab = 1,
  }) async {
    final api = AppApis.getCountEvent(eventTypes: eventTypes, tab: tab);
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> getEventsByConfirm(
    int page,
    CancelToken cancelToken, {
    List<String>? eventTypes,
  }) async {
    final api = AppApis.getEventsByConfirm(page, eventTypes: eventTypes);
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> getEventsByWaiting(int page, CancelToken cancelToken,
      {List<String>? eventTypes}) async {
    final api = AppApis.getEventsByWaiting(page, eventTypes: eventTypes);
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> getEventsByConfirmed(int page, CancelToken cancelToken,
      {List<String>? eventTypes}) async {
    final api = AppApis.getEventsByConfirmed(page, eventTypes: eventTypes);
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> getContacts(CancelToken cancelToken) async {
    final api = AppApis.getContacts();
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> createEvent(
      EventRequest eventRequest, CancelToken cancelToken) async {
    var users = {};
    if (eventRequest.userIds != null && eventRequest.userIds!.length > 0) {
      users = {
        for (int i = 0; i < eventRequest.userIds!.length; i++)
          i.toString(): eventRequest.userIds?[i].toString()
      };
    }
    var data = {
      "title": eventRequest.title,
      "start_date": DateFormat("yyyy-MM-dd HH:mm:ss").format(eventRequest.startDate!),
      "end_date": eventRequest.endDate != null
          ? DateFormat("yyyy-MM-dd HH:mm:ss").format(eventRequest.endDate!)
          : "",
      "comment": eventRequest.comment,
      "repeat": eventRequest.repeat,
      "alarm": eventRequest.alarm,
      "place": eventRequest.place,
      "busy_mode": eventRequest.busyMode,
      "users": users
    };

    final api = AppApis.createEvent();
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> updateEvent(
      EventRequest eventRequest, CancelToken cancelToken) async {
    var users = {};
    if (eventRequest.userIds != null && eventRequest.userIds!.length > 0) {
      users = {
        for (int i = 0; i < eventRequest.userIds!.length; i++)
          i.toString(): eventRequest.userIds?[i].toString()
      };
    }
    var data = {
      "title": eventRequest.title,
      "start_date": DateFormat("yyyy-MM-dd HH:mm:ss").format(eventRequest.startDate!),
      "end_date": eventRequest.endDate != null
          ? DateFormat("yyyy-MM-dd HH:mm:ss").format(eventRequest.endDate!)
          : "",
      "comment": eventRequest.comment,
      "repeat": eventRequest.repeat == "0" ? "" : eventRequest.repeat,
      "alarm": eventRequest.alarm,
      "place": eventRequest.place,
      "busy_mode": eventRequest.busyMode,
      "users": users
    };

    final api = AppApis.updateEvent(eventRequest.id ?? 0);
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> registerUser(UserRequest userRequest, CancelToken cancelToken) {
    String imgPath = userRequest.avatar?.path ?? "";
    var formatter = new DateFormat(AppConstants.dateFormatUpload);
    FormData data = FormData.fromMap({
      "name": userRequest.name,
      "email": userRequest.email,
      "avatar": MultipartFile.fromFileSync(
        imgPath,
        filename: path.basename(imgPath),
      ),
      "birthday": formatter.format(userRequest.birthday!),
      "gender": userRequest.gender,
      "country_code": userRequest.countryCode?.toLowerCase(),
      "city": userRequest.city,
      "phone_number": userRequest.phoneNumber,
      "dial_code": userRequest.dialCode
    });

    String api = AppApis.register();
    return AppClients(multiPart: true).post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> getMeInfo(CancelToken cancelToken) {
    String api = AppApis.me();
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> deleteEvent(int id, CancelToken cancelToken) async {
    final api = AppApis.deleteEvent(id);
    return AppClients().delete(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> confirmEvent(int id, CancelToken cancelToken) async {
    final api = AppApis.confirmEvent(id);
    return AppClients().post(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> denyEvent(int id, CancelToken cancelToken) async {
    final api = AppApis.denyEvent(id);
    return AppClients().post(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> leaveEvent(int id, CancelToken cancelToken) async {
    final api = AppApis.leaveEvent(id);
    return AppClients().post(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> acceptRoster(int id, CancelToken cancelToken) async {
    final api = AppApis.acceptRoster(id);
    return AppClients().post(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> declineRoster(int id, CancelToken cancelToken) async {
    final api = AppApis.declineRoster(id);
    return AppClients().post(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> deleteRoster(int id, CancelToken cancelToken) async {
    final api = AppApis.deleteRoster(id);
    return AppClients().delete(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> searchUsers(String search, CancelToken cancelToken) async {
    final api = AppApis.searchUsers(search);
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> linkContact(int id, CancelToken cancelToken) async {
    final api = AppApis.linkContact(id);
    return AppClients().post(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> addContact(
      ContactRequest contactRequest, CancelToken cancelToken) async {
    String imgPath = contactRequest.avatar?.path ?? "";
    FormData data = FormData.fromMap({
      "name": contactRequest.name,
      "avatar": MultipartFile.fromFileSync(
        imgPath,
        filename: path.basename(imgPath),
      ),
      "phone_number": contactRequest.phoneNumber,
      "dial_code": contactRequest.dialCode
    });
    final api = AppApis.addContact();
    final clients = AppClients(multiPart: true);
    return clients.post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> editContact(
      int id, ContactRequest contactRequest, CancelToken cancelToken) {
    String imgPath = contactRequest.avatar?.path ?? "";
    Map<String, dynamic> map = {
      "name": contactRequest.name,
      "phone_number": contactRequest.phoneNumber,
      "dial_code": contactRequest.dialCode
    };
    if (imgPath.isNotEmpty) {
      map.addAll({
        "avatar": MultipartFile.fromFileSync(
          imgPath,
          filename: path.basename(imgPath),
        ),
      });
    }
    FormData data = FormData.fromMap(map);
    final api = AppApis.editContact(id);
    final clients = AppClients(multiPart: true);
    return clients.post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> deleteContact(Contact contact, CancelToken cancelToken) {
    final api = AppApis.deleteContact(contact.id);
    return AppClients().delete(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> updateProfile(UserRequest userRequest, CancelToken cancelToken) {
    var formatter = new DateFormat(AppConstants.dateFormatUpload);
    var data = {
      "name": userRequest.name,
      "email": userRequest.email,
      "birthday": formatter.format(userRequest.birthday!),
      "gender": userRequest.gender.toString(),
      "country_code": userRequest.countryCode?.toLowerCase(),
      "city": userRequest.city,
    };

    String api = AppApis.updateProfile();
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> updateAvatar(File avatarPath, CancelToken cancelToken) {
    String imgPath = avatarPath.path;
    FormData data = FormData.fromMap({
      "avatar": MultipartFile.fromFileSync(
        imgPath,
        filename: path.basename(imgPath),
      )
    });

    String api = AppApis.updateAvatar();
    return AppClients(multiPart: true).post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> importContacts(
      List<ContactRequest> contacts, CancelToken cancelToken) async {
    var params = {};
    if (contacts.isNotEmpty) {
      params = {for (int i = 0; i < contacts.length; i++) i.toString(): contacts[i].toJson()};
    }
    var data = {"contacts": params};
    final api = AppApis.importContact();
    return AppClients(multiPart: true).post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> updateSetting(
      String languageCode, bool? busyMode, CancelToken cancelToken) {
    String api = AppApis.updateSetting();
    Map<String, dynamic> data = {};
    if (busyMode != null) data["busy_mode"] = busyMode ? "1" : "0";
    if (languageCode.isNotEmpty) data["language_code"] = languageCode;
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> connectContactFacebook(
      String facebookID, List<String> friendIDs, CancelToken cancelToken) {
    String api = AppApis.connectContactFacebook();
    Map<String, dynamic> data = {};
    if (facebookID.isNotEmpty) data['facebook_id'] = facebookID;
    if (friendIDs.isNotEmpty) data['friends'] = friendIDs;
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> importContactFacebook(
      List<String> friendIDs, CancelToken cancelToken) {
    String api = AppApis.importContactFacebook();
    Map<String, dynamic> data = {};
    if (friendIDs.isNotEmpty) data['friends'] = friendIDs;
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> sendFeedBack(String feedBack, CancelToken cancelToken) {
    String api = AppApis.sendFeedBack();
    Map<String, dynamic> data = {};
    data["content"] = feedBack;
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> getEventAlarmDevice(CancelToken cancelToken) {
    String api = AppApis.getEventAlarmDevice();
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> upDateFCMToken(
      String token, String deviceOS, CancelToken cancelToken) {
    String api = AppApis.getUpdateFCMToken();
    Map<String, dynamic> data = {};
    data["token"] = token;
    data["device"] = deviceOS;
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> deleteFCMToken(String fcmToken, CancelToken cancelToken) {
    String api = AppApis.getDeleteFCMToken(fcmToken);
    return AppClients().delete(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> deleteAccount() {
    final api = AppApis.deleteAccount();
    return AppClients().delete(api);
  }

  static Future<Response<dynamic>> getCorpInvited(int page, CancelToken cancelToken) {
    String api = AppApis.getCorpInvited(page);
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> acceptCorpInvitation(int corpId, CancelToken cancelToken) {
    String api = AppApis.acceptCorpInvitation(corpId);
    return AppClients().post(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> denyCorpInvitation(int corpId, CancelToken cancelToken) {
    String api = AppApis.denyCorpInvitation(corpId);
    return AppClients().post(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> doneTask(int taskId, CancelToken cancelToken) {
    String api = AppApis.doneTask(taskId);
    return AppClients().post(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> getProjectDetail(int projectId, CancelToken cancelToken) {
    String api = AppApis.getProjectDetail(projectId);
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> sendSMS(List<int> contactIDs, CancelToken cancelToken) async {
    var params = {};
    if (contactIDs.isNotEmpty) {
      params = {for (int i = 0; i < contactIDs.length; i++) i.toString(): contactIDs[i]};
    }
    var data = {"contacts": params};

    final api = AppApis.sendSMS();
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> pushNotify(PushNotifyRequest request) async {
    final data = request.toJson();
    final api = AppApis.pushNotify();
    return AppClients().post(api, data: data);
  }

  static Future<Response<dynamic>> sendEmail(String email) {
    String api = AppApis.sendEmail();
    final Map<String, dynamic> data = {"email": email, "send_to": 0};
    return AppClients().post(api, data: data);
  }

  static Future<Response<dynamic>> changePhone(ChangeNumberRequest request) {
    String api = AppApis.changePhone();
    return AppClients().patch(api, data: request.toJson());
  }

  static Future<Response<dynamic>> getNotifications(int page, CancelToken cancelToken) async {
    final api = AppApis.getNotifications(page: page);
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> countNotifications() {
    final api = AppApis.countNotifications();
    return AppClients().get(api);
  }

  static Future<Response<dynamic>> getAllTodos(CancelToken cancelToken) async {
    final api = AppApis.getAllTodos();
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> createTodo(
      TodoRequest todoRequest, CancelToken cancelToken) async {
    var data = FormData.fromMap({
      "title": todoRequest.title,
      "type": todoRequest.type.toUpperCase(),
      "parent_id": todoRequest.parentId,
    });
    data.fields.addAll(
      todoRequest.contactIds.map((id) => MapEntry("contact_ids[]", id.toString())),
    );

    final api = AppApis.createTodo();
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> updateTodo(
      TodoRequest todoRequest, CancelToken cancelToken) async {
    var data = FormData.fromMap({
      "title": todoRequest.title,
      "type": todoRequest.type.toUpperCase(),
      "parent_id": todoRequest.parentId,
    });
    data.fields.addAll(
      todoRequest.contactIds.map((id) => MapEntry("contact_ids[]", id.toString())),
    );

    final api = AppApis.updateTodo(todoRequest.todoId ?? 0);
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> getTodoDetail(int todoId, CancelToken cancelToken) {
    String api = AppApis.getTodoDetail(todoId);
    return AppClients().get(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> completeTodo(int todoId, CancelToken cancelToken) {
    String api = AppApis.completeTodo(todoId);
    return AppClients().post(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> overlineTodo(int todoId, CancelToken cancelToken) {
    String api = AppApis.overlineTodo(todoId);
    return AppClients().post(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> deleteTodo(int todoId, CancelToken cancelToken) {
    String api = AppApis.deleteTodo(todoId);
    return AppClients().delete(api, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> orderTodo(
      List<int> ids, List<int> orders, CancelToken cancelToken) async {
    var data = FormData.fromMap({});
    data.fields.addAll(
      ids.map((id) => MapEntry("ids[]", id.toString())),
    );
    data.fields.addAll(
      orders.map((order) => MapEntry("orders[]", order.toString())),
    );
    final api = AppApis.orderTodo();
    return AppClients().post(api, data: data, cancelToken: cancelToken);
  }

  static Future<Response<dynamic>> getWorkData(
    CancelToken cancelToken, {
    int page = 1,
    required String status,
    List<String> types = const [],
  }) async {
    final api = AppApis.getWorkData(page: page, status: status, types: types);
    return AppClients().get(api, cancelToken: cancelToken);
  }
}
