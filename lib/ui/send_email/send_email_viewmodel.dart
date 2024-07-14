import 'package:flutter/material.dart';
import 'package:mou_app/core/repositories/auth_repository.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/helpers/validators_helper.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:rxdart/rxdart.dart';

class SendEmailViewModel extends BaseViewModel {
  final emailController = TextEditingController();
  final activeSubject = BehaviorSubject<bool>();

  final AuthRepository authRepository;

  SendEmailViewModel(this.authRepository);

  void onEmailChanged(String text) {
    activeSubject.add(text.isNotEmpty);
  }

  void onSendPressed() {
    String email = emailController.text;
    String validate = ValidatorsHelper.validateEmail(email);
    if (validate.isNotEmpty) {
      showSnackBar(validate);
    } else {
      FocusScope.of(context).unfocus();
      _onSendEmail(email);
    }
  }

  void _onSendEmail(String email) {
    setLoading(true);
    authRepository.sendEmail(email).then((value) {
      setLoading(false);
      if (value.isSuccess) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              content: Text(value.data ?? ""),
              actions: <Widget>[
                TextButton(
                  child: Text(allTranslations.text(AppLanguages.ok)),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ],
            );
          },
        );
      } else {
        showSnackBar(value.message ?? '');
      }
    }).catchError((error) {
      setLoading(false);
      showSnackBar(error.toString());
    });
  }

  @override
  void dispose() {
    activeSubject.close();
    activeSubject.close();
    emailController.dispose();
    super.dispose();
  }
}
