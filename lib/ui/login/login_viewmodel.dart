import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/core/repositories/auth_repository.dart';
import 'package:mou_app/core/requests/change_phone_request.dart';
import 'package:mou_app/core/services/firebase_service.dart';
import 'package:mou_app/core/services/wifi_service.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/type/verify_type.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/ui/widgets/verification_code/verification_code_dialog.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_shared.dart';
import 'package:mou_app/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class LoginViewModel extends BaseViewModel {
  final FirebaseService service;
  final AuthRepository authRepository;

  final phoneFocusNode = FocusNode();
  final phoneNumberController = TextEditingController();
  final phoneCodeSubject = BehaviorSubject<CountryPhoneCode>();
  final phoneNumberSubject = BehaviorSubject<String>.seeded('');

  LoginViewModel({
    required this.service,
    required this.authRepository,
  });

  void init(Map<String, dynamic>? message) {
    phoneCodeSubject
        .add(AppUtils.appCountryCodes.firstWhereOrNull((e) => e.code.toLowerCase() == 'us') ??
            CountryPhoneCode(
              name: 'United States',
              dialCode: '+1',
              code: 'US',
            ));
    phoneNumberController.addListener(onChange);
    _initDynamicLinks(message);
    _checkLogged();
  }

  void _initDynamicLinks(Map<String, dynamic>? message) async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    _navigationDeepLink(data?.link);
    _navigationSMSMessage(message);

    FirebaseDynamicLinks.instance.onLink.listen(
      _handleDynamicLink,
      onError: (e) {
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

  void _navigationSMSMessage(Map<String, dynamic>? message) async {
    if (message == null) return;
    if (message.containsKey("action")) {
      final action = message["action"] ?? "";
      print("Dynamic link action: $action");
      if (action.contains("PHONE_CHANGE")) {
        ChangeNumberRequest request = ChangeNumberRequest.fromJson(message);
        final result = await Navigator.pushNamedAndRemoveUntil(
          context,
          Routers.CHANGE_NUMBER,
          (route) => route.isFirst,
          arguments: request,
        );
        if (result is String) {
          showSnackBar(result);
        }
      }
    }
  }

  void onPressedLogin() async {
    FocusScope.of(context).unfocus();
    String phone = phoneNumberController.text.trim();
    if (phone.isNotEmpty) {
      setLoading(true);
      // delayed to waiting otp code get to phone
      await Future.delayed(const Duration(milliseconds: 3500));
      setLoading(false);
      _showSmsCodeInputDialog(phoneCodeSubject.valueOrNull?.dialCode ?? '', phone);
    } else {
      showSnackBar(allTranslations.text(AppLanguages.pleaseEnterPhone));
    }
  }

  Future<void> _showSmsCodeInputDialog(String dialCode, String phone) async {
    final result = await showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => VerificationCodeDialog(
        verifyType: VerifyType.LOGIN,
        dialCode: dialCode,
        phoneNumber: phone,
      ),
    );
    if (result is String) {
      showSnackBar(result);
    }
  }

  Future<void> _checkLogged() async {
    final String accessToken = await AppShared.getAccessToken() ?? '';
    bool hasInternet = await WifiService.isConnectivity();
    if (accessToken.isNotEmpty) {
      if (hasInternet) {
        final resource = await authRepository.getMeInfo();
        if (resource.isSuccess) {
          Navigator.pushReplacementNamed(context, Routers.HOME);
        }
      } else {
        Navigator.pushReplacementNamed(context, Routers.HOME);
      }
    }
  }

  void changePhoneCode(CountryPhoneCode phoneCode) {
    phoneCodeSubject.add(phoneCode);
  }

  void onChange() {
    String text = phoneNumberController.text;
    phoneNumberSubject.add(text);
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    phoneFocusNode.dispose();
    phoneCodeSubject.close();
    phoneNumberSubject.close();
    super.dispose();
  }

  void _handleDynamicLink(PendingDynamicLinkData dynamicLink) {}
}
