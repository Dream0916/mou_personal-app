import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/repositories/auth_repository.dart';
import 'package:mou_app/core/repositories/event_repository.dart';
import 'package:mou_app/core/services/firebase_service.dart';
import 'package:mou_app/core/services/wifi_service.dart';
import 'package:mou_app/helpers/push_notification_local_helper.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/send_notification_local.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/utils/app_globals.dart';
import 'package:mou_app/utils/app_shared.dart';

class SplashViewModel extends BaseViewModel {
  final FirebaseService service;
  final AuthRepository authRepository;
  final EventRepository eventRepository;

  SplashViewModel({
    required this.service,
    required this.authRepository,
    required this.eventRepository,
  });

  void checkLogged() {
    Future.delayed(const Duration(seconds: 3), () async {
      String accessToken = await AppShared.getAccessToken() ?? '';
      bool hasInternet = await WifiService.isConnectivity();
      if (accessToken.isNotEmpty) {
        if (hasInternet) {
          final resource = await authRepository.getMeInfo();
          if (resource.isSuccess) {
            final resource = await eventRepository.getEventAlarmDevice();
            if (resource.isSuccess) {
              await PushNotificationLocalHelper.getInstance().cancelAll();
              await AppShared.setNotifyIdManagementList(null);

              List<Event> events = resource.data ?? [];
              for (Event event in events) {
                SendNotificationLocal.registerLocalNotification(event);
              }
            }
            Navigator.pushReplacementNamed(context, Routers.HOME);
          } else {
            await AppGlobals.logout(context);
          }
        } else {
          Navigator.pushReplacementNamed(context, Routers.HOME);
        }
      } else {
        await AppGlobals.logout(context);
      }
    });
  }
}
