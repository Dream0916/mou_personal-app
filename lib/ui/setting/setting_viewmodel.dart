import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/repositories/user_repository.dart';
import 'package:mou_app/helpers/push_notification_helper.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/utils/app_globals.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_shared.dart';
import 'package:rxdart/rxdart.dart';

class SettingViewModel extends BaseViewModel {
  final selectedLanguageSubject = BehaviorSubject<String>();

  final UserRepository repository;
  StreamSubscription? _languageSubscription;

  SettingViewModel(this.repository) {
    _languageSubscription = AppShared.watchLanguageCode().listen(
      (langCode) {
        selectedLanguageSubject.add(
          langCode ?? GlobalTranslations().currentLanguage,
        );
      },
    );
  }

  void showDialogConfirmLogout() {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(allTranslations.text(AppLanguages.logout).toUpperCase()),
          content: Text(allTranslations.text(AppLanguages.doYouWantLogOut)),
          actions: <Widget>[
            TextButton(
              child: Text(
                allTranslations.text(AppLanguages.cancel).toUpperCase(),
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                allTranslations.text(AppLanguages.ok).toUpperCase(),
                style: TextStyle(color: Colors.green), // Set the color here
              ),
              onPressed: () => PushNotificationHelper.getToken().then((firebaseToken) async {
                final resource = await repository.deleteFCMToken(firebaseToken);
                if (resource.isSuccess) {
                  await AppGlobals.logout(context);
                } else {
                  showSnackBar(resource.message ?? "");
                }
              }),
            )
          ],
        );
      },
    );
  }

  void onGoToEditProfile() {
    Navigator.pushNamed(context, Routers.EDIT_PROFILE);
  }

  void onGoToCorp() {
    Navigator.pushNamed(context, Routers.CORP);
  }

  @override
  void dispose() async {
    repository.cancel();
    await selectedLanguageSubject.drain();
    selectedLanguageSubject.close();
    _languageSubscription?.cancel();
    super.dispose();
  }

  updateLanguage(String code) async {
    Navigator.pop(context);
    if (code == selectedLanguageSubject.valueOrNull) return;
    setLoading(true);
    final resource = await repository.updateSetting(languageCode: code);
    if (resource.isSuccess) {
      await allTranslations.setNewLanguage(code);
    } else {
      showSnackBar(resource.message ?? "");
    }
    setLoading(false);
  }
}
