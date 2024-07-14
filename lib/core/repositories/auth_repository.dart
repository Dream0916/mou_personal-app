import 'package:dio/dio.dart';
import 'package:mou_app/core/network_bound_resource.dart';
import 'package:mou_app/core/requests/change_phone_request.dart';
import 'package:mou_app/core/requests/user_request.dart';
import 'package:mou_app/core/resource.dart';
import 'package:mou_app/core/responses/register_response.dart';
import 'package:mou_app/core/services/api_service.dart';
import 'package:mou_app/helpers/resource_type.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/utils/app_apis.dart';
import 'package:mou_app/utils/app_clients.dart';
import 'package:mou_app/utils/app_shared.dart';

class AuthRepository {
  CancelToken _cancelToken = CancelToken();

  Future<Resource<RegisterResponse>> registerUser(UserRequest userRequest) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<RegisterResponse, RegisterResponse>(
      createCall: () => APIService.registerUser(userRequest, _cancelToken),
      parsedData: (json) => RegisterResponse.fromJson(json),
      saveCallResult: (registerResponse) async {
        AppShared.setUserID(registerResponse.id);
        AppShared.setUser(registerResponse);
      },
    );
    return resource.getAsObservable();
  }

  Future<Resource<RegisterResponse>> getMeInfo() {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<RegisterResponse, RegisterResponse>(
      createCall: () => APIService.getMeInfo(_cancelToken),
      parsedData: (json) => RegisterResponse.fromJson(json),
      saveCallResult: (registerResponse) async {
        final String languageCode = registerResponse.settings?.languageCode ?? '';
        await allTranslations.setNewLanguage(languageCode);
        await AppShared.setUserID(registerResponse.id);
        await AppShared.setUser(registerResponse);
      },
    );
    return resource.getAsObservable();
  }

  Future<Resource<String>> checkExistPhone() async {
    try {
      String api = AppApis.existPhone();
      Response response = await AppClients().get(api);
      return Resource<String>(
        data: response.data["message"],
        status: ResourceType.SUCCESS,
      );
    } on DioException catch (e) {
      return Resource<String>.withError(e);
    }
  }

  Future<Resource<String>> sendEmail(String email) {
    return NetworkBoundResource<dynamic, String>(
      createCall: () => APIService.sendEmail(email),
      parsedData: (json) {
        if (json is Map<String, dynamic>) {
          if (json.containsKey("message")) {
            return json["message"] as String;
          }
        }
        return "";
      },
    ).getAsObservable();
  }

  Future<Resource<String>> changePhone(ChangeNumberRequest request) {
    return NetworkBoundResource<dynamic, String>(
      createCall: () => APIService.changePhone(request),
      parsedData: (json) {
        if (json is Map<String, dynamic>) {
          if (json.containsKey("message")) {
            return json["message"] as String;
          }
        }
        return "";
      },
    ).getAsObservable();
  }

  cancel() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }
}
