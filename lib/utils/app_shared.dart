// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:mou_app/core/models/event_count.dart';
import 'package:mou_app/core/models/notify_id_management.dart';
import 'package:mou_app/core/responses/register_response.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class AppShared {
  static const String keyAccessToken = "keyMouAccessToken";
  static const String keyUser = "keyMouUser";
  static const String keyUserID = "keyMouUserID";
  static const String keyEventCount = "keyMouEventCount";
  static const String keyNotifyIdManagement = "keyNotifyIdManagement";
  static const String keyFCMToken = "keyFCMToken";
  static const String keyMe = "keyMe";
  static const String keyCountNotification = "keyCountNotification";

  static final prefs = RxSharedPreferences(SharedPreferences.getInstance());

  static Future<void> setAccessToken(String accessToken) =>
      prefs.setString(keyAccessToken, accessToken);

  static Future<String?> getAccessToken() => prefs.getString(keyAccessToken);

  static Future<void> setFCMToken(String token) =>
      prefs.setString(keyFCMToken, token);

  static Future<String?> getFCMToken() => prefs.getString(keyFCMToken);

  static Future<void> setUserID(int? userID) => prefs.setInt(keyUserID, userID);

  static Future<int?> getUserID() => prefs.getInt(keyUserID);

  static Future<void> setEventCount(EventCount? eventCount) async {
    final json = eventCount == null ? "" : jsonEncode(eventCount.toJson());
    prefs.setString(keyEventCount, json);
  }

  static Future<EventCount> getEventCount() async {
    final String json = await prefs.getString(keyEventCount) ?? "";
    if (json.length == 0) return EventCount();
    return EventCount.fromJson(jsonDecode(json));
  }

  static Future<void> setUser(RegisterResponse user) async {
    final json = user == null ? "" : jsonEncode(user.toJson());
    return prefs.setString(keyUser, json);
  }

  static Future<RegisterResponse> getUser() async {
    final String json = await prefs.getString(keyUser) ?? "";
    if (json.length == 0) return RegisterResponse();
    return RegisterResponse.fromJson(jsonDecode(json));
  }

  static Stream<String?> watchLanguageCode() {
    return prefs.getStringStream(keyUser).asyncMap((event) => event != null
        ? RegisterResponse.fromJson(jsonDecode(event)).settings?.languageCode
        : null);
  }

  static Future<void> setNotifyIdManagementList(
      NotifyIdManagementList? notifyIds) async {
    final String json = notifyIds == null ? "" : jsonEncode(notifyIds.toJson());
    print("setNotifyIdManagementList $json");
    prefs.setString(keyNotifyIdManagement, json);
  }

  static Future<NotifyIdManagementList> getNotifyIdManagementList() async {
    final String json = await prefs.getString(keyNotifyIdManagement) ?? "";
    print("getNotifyIdManagementList $json");
    if (json.length == 0) return NotifyIdManagementList();
    return NotifyIdManagementList.fromJson(jsonDecode(json));
  }

  static Future<void> setCountNotification(int value) =>
      prefs.setInt(keyCountNotification, value);

  static Future<int> getCountNotification() async =>
      await prefs.getInt(keyCountNotification) ?? 0;

  static Stream<int?> watchCountNotification() {
    return prefs.getIntStream(keyCountNotification);
  }

  static Future<void> clear() async {
    prefs.clear();
  }
}
