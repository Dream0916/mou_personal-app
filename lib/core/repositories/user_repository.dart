import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mou_app/core/models/setting.dart';
import 'package:mou_app/core/requests/user_request.dart';
import 'package:mou_app/core/responses/register_response.dart';
import 'package:mou_app/core/services/api_service.dart';
import 'package:mou_app/utils/app_shared.dart';

import '../network_bound_resource.dart';
import '../resource.dart';

class UserRepository {
  CancelToken _cancelToken = CancelToken();

  Future<Resource<RegisterResponse>> updateProfile(
      UserRequest userRequest) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<RegisterResponse, RegisterResponse>(
      createCall: () => APIService.updateProfile(userRequest, _cancelToken),
      parsedData: (json) => RegisterResponse.fromJson(json),
      saveCallResult: (registerResponse) async {
        AppShared.setUser(registerResponse);
      },
    );
    return resource.getAsObservable();
  }

  Future<Resource<RegisterResponse>> updateAvatar(File avatarFile) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<RegisterResponse, RegisterResponse>(
      createCall: () => APIService.updateAvatar(avatarFile, _cancelToken),
      parsedData: (json) => RegisterResponse.fromJson(json),
      saveCallResult: (registerResponse) async {
        AppShared.setUser(registerResponse);
      },
    );
    return resource.getAsObservable();
  }

  Future<Resource<dynamic>> updateSetting(
      {String languageCode = "", bool? busyMode}) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<dynamic, dynamic>(
      createCall: () =>
          APIService.updateSetting(languageCode, busyMode, _cancelToken),
      parsedData: (json) => json,
      saveCallResult: (registerResponse) async {
        RegisterResponse user = await AppShared.getUser();
        if (user.settings == null) user.settings = Setting();
        if (languageCode.isNotEmpty) {
          user.settings?.languageCode = languageCode;
        }
        if (busyMode != null) {
          user.settings?.busyMode = busyMode ? 1 : 0;
        }
        await AppShared.setUser(user);
      },
    );
    return resource.getAsObservable();
  }

  Future<Resource<dynamic>> updateFCMToken(
      {required String token, required String deviceOS}) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<dynamic, dynamic>(
        createCall: () =>
            APIService.upDateFCMToken(token, deviceOS, _cancelToken),
        parsedData: (json) => json);
    return resource.getAsObservable();
  }

  Future<Resource<dynamic>> deleteFCMToken(String fcmToken) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<dynamic, dynamic>(
        createCall: () => APIService.deleteFCMToken(fcmToken, _cancelToken),
        parsedData: (json) => json);
    return resource.getAsObservable();
  }

  Future<Resource<dynamic>> deleteAccount() async {
    final resource = NetworkBoundResource<dynamic, dynamic>(
      createCall: () => APIService.deleteAccount(),
      parsedData: (json) => json,
    );
    return resource.getAsObservable();
  }

  Future<Resource<dynamic>> sendFeedBack({required String feedBack}) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<dynamic, dynamic>(
      createCall: () => APIService.sendFeedBack(feedBack, _cancelToken),
      parsedData: (json) => json,
      saveCallResult: (response) async => print(response),
    );
    return resource.getAsObservable();
  }

  cancel() {
    if (_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }
}
