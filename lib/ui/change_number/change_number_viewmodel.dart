import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/core/repositories/auth_repository.dart';
import 'package:mou_app/core/requests/change_phone_request.dart';
import 'package:mou_app/type/verify_type.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/ui/widgets/verification_code/verification_code_dialog.dart';
import 'package:mou_app/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class ChangeNumberViewModel extends BaseViewModel {
  final newPhoneController = TextEditingController();
  final activeSubject = BehaviorSubject<bool>();
  final dialCodeSubject = BehaviorSubject<CountryPhoneCode>();
  final dialCodesSubject = BehaviorSubject<List<CountryPhoneCode>>();

  final AuthRepository authRepository;

  ChangeNumberViewModel(this.authRepository);

  Future<void> fetchData(String code) async {
    dialCodesSubject.add(AppUtils.appCountryCodes);
    dialCodeSubject
        .add(AppUtils.appCountryCodes.firstWhereOrNull((e) => e.code.toLowerCase() == 'us') ??
            CountryPhoneCode(
              name: 'United States',
              dialCode: '+1',
              code: 'US',
            ));
  }

  void onNewPhoneChanged(String text) {
    activeSubject.add(text.isNotEmpty);
  }

  void onSubmitPressed(ChangeNumberRequest request) async {
    FocusScope.of(context).unfocus();
    String phone = newPhoneController.text;
    if (phone.startsWith("0")) {
      phone = phone.replaceFirst("0", "");
    }
    final String dialCode = dialCodeSubject.valueOrNull?.dialCode ?? "+1";

    final ChangeNumberRequest newRequest = request.copyWith(
      phoneNumber: phone,
      dialCode: dialCode,
    );
    final result = await _showSmsCodeInputDialog(newRequest);
    if (result is String && result.isNotEmpty) {
      showSnackBar(result);
    }
  }

  Future<dynamic> _showSmsCodeInputDialog(ChangeNumberRequest request) {
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: false,
      barrierLabel: "",
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => VerificationCodeDialog(
        verifyType: VerifyType.CHANGE_PHONE,
        dialCode: request.dialCode,
        phoneNumber: request.phoneNumber,
        changeNumberRequest: request,
      ),
    );
  }

  @override
  void dispose() {
    activeSubject.close();
    activeSubject.close();
    dialCodeSubject.close();
    dialCodeSubject.close();
    newPhoneController.dispose();
    super.dispose();
  }

  void changeDialCode(CountryPhoneCode phoneCode) {
    dialCodeSubject.add(phoneCode);
  }
}
