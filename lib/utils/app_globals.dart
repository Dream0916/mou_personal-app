import 'package:flutter/material.dart';
// import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/services/firebase_service.dart';
import 'package:mou_app/helpers/push_notification_helper.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/utils/app_shared.dart';
import 'package:rxdart/rxdart.dart';

class AppGlobals {
  static final _sessionExpiredSubject = BehaviorSubject<bool>.seeded(false);

  static Stream<bool> get sessionExpiredSubject => _sessionExpiredSubject.stream.distinct();

  static void setSessionExpired(bool value) => _sessionExpiredSubject.add(value);

  static Future<void> logout(BuildContext context, {dynamic arguments}) async {
    await AppShared.clear();
    await FirebaseService.logout();
    await PushNotificationHelper.deleteToken();
    // await AppDatabase.clearData();
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routers.LOGIN,
      (router) => false,
      arguments: arguments,
    );
    AppGlobals.setSessionExpired(false);
  }

  static bool _contactsUploaded = false;

  static bool get contactsUploaded => _contactsUploaded;

  static void setContactsUploaded(bool value) => _contactsUploaded = value;

  static OverlayEntry? _overlayEntry;

  static void setOverlayEntry(OverlayEntry overlayEntry) {
    _overlayEntry?.remove();
    _overlayEntry = overlayEntry;
  }

  static void removeOverlayEntry() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
