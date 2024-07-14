import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/core/models/gender.dart';
import 'package:mou_app/core/repositories/user_repository.dart';
import 'package:mou_app/core/requests/user_request.dart';
import 'package:mou_app/core/resource.dart';
import 'package:mou_app/core/responses/register_response.dart';
import 'package:mou_app/helpers/common_helper.dart';
import 'package:mou_app/helpers/push_notification_helper.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/utils/app_globals.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_shared.dart';
import 'package:mou_app/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileViewModel extends BaseViewModel {
  final UserRepository userRepository;

  EditProfileViewModel({required this.userRepository});

  BehaviorSubject<bool> isEditingSubject = BehaviorSubject<bool>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  BehaviorSubject<Gender> genderSubject = BehaviorSubject<Gender>();
  BehaviorSubject<DateTime> birthOfDateSubject = BehaviorSubject<DateTime>();
  BehaviorSubject<CountryPhoneCode> countrySubject = BehaviorSubject<CountryPhoneCode>();
  BehaviorSubject<bool> avatarLoadingSubject = BehaviorSubject<bool>();
  BehaviorSubject<File> avatarFileSubject = BehaviorSubject<File>();

  List<Gender> genders = CommonHelper.getGenders();

  onChangeEditing() async {
    FocusScope.of(context).unfocus();
    setLoading(true);
    var isEditing = isEditingSubject.valueOrNull ?? false;
    if (!isEditing) {
      var profileInfo = await AppShared.getUser();
      if (profileInfo.id != null) {
        nameController.text = profileInfo.name ?? "";
        emailController.text = profileInfo.email ?? "";
        cityController.text = profileInfo.city ?? "";

        var gender = genders.firstWhereOrNull((item) => item.type == (profileInfo.gender ?? 0));
        if (gender != null) {
          genderSubject.add(gender);
        }

        if (profileInfo.birthDay != null) {
          var parsedDate = DateTime.parse('${profileInfo.birthDay} 00:00:00.000');
          birthOfDateSubject.add(parsedDate);
        }

        if (profileInfo.countryCode != null) {
          var countryInfo = AppUtils.appCountryCodes.firstWhereOrNull(
              (item) => item.code.toLowerCase() == profileInfo.countryCode?.toLowerCase());
          if (countryInfo != null) {
            countrySubject.add(countryInfo);
          }
        }
      }
      isEditingSubject.add(!isEditing);
    } else {
      if (validate()) {
        var userRequest = UserRequest(
          name: nameController.text,
          email: emailController.text,
          birthday: birthOfDateSubject.value,
          gender: genderSubject.value.type,
          countryCode: countrySubject.value.code,
          city: cityController.text,
        );

        Resource<RegisterResponse> result = await userRepository.updateProfile(userRequest);
        if (result.isSuccess) {
          showSnackBar(
            allTranslations.text(AppLanguages.profileUpdatedSuccess),
            isError: false,
          );
        } else {
          showSnackBar(result.message ?? "");
        }
        isEditingSubject.add(!isEditing);
      }
    }
    setLoading(false);
  }

  bool validate() {
    if (nameController.text.isEmpty ||
        (nameController.text.isNotEmpty && nameController.text.trim() == "")) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseInputName));
      return false;
    } else if (birthOfDateSubject.valueOrNull == null) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseChooseDateOfBirth));
      return false;
    } else if (genderSubject.valueOrNull == null) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseChooseGender));
      return false;
    } else if (emailController.text.isEmpty ||
        (emailController.text.isNotEmpty && emailController.text.trim() == "")) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseInputEmail));
      return false;
    } else if (emailController.text.isNotEmpty &&
        emailController.text.trim() != "" &&
        !CommonHelper.regEmail(emailController.text)) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseValidEmail));
      return false;
    } else if (countrySubject.valueOrNull == null) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseChooseCountry));
      return false;
    } else if (cityController.text.isEmpty ||
        (cityController.text.isNotEmpty && cityController.text.trim() == "")) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseInputCity));
      return false;
    }
    return true;
  }

  onSelectPhoto(File? file) async {
    if (file != null) {
      avatarLoadingSubject.add(true);
      print("Start crop");
      var response = await userRepository.updateAvatar(file);
      if (response.isSuccess) {
        avatarFileSubject.add(file);
        showSnackBar(
          allTranslations.text(AppLanguages.avatarUpdatedSuccess),
          isError: false,
        );
      } else {
        showSnackBar(response.message ?? "");
      }
      avatarLoadingSubject.add(false);
    }
  }

  void changeCountry(CountryPhoneCode phoneCode) {
    countrySubject.add(phoneCode);
  }

  void changeBirthOfDate(int day, int month, int year) {
    var birthDate = new DateTime(year, month, day);
    birthOfDateSubject.add(birthDate);
  }

  Future<void> deleteAccount() async {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text(allTranslations.text(AppLanguages.deleteAccount).toUpperCase()),
          content: Text(allTranslations.text(AppLanguages.deleteAccountConfirm)),
          actions: <Widget>[
            TextButton(
              child: Text(
                allTranslations.text(AppLanguages.cancel).toUpperCase(),
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(allTranslations.text(AppLanguages.ok).toUpperCase()),
              onPressed: () async {
                Navigator.pop(context);
                setLoading(true);
                final deleteAccountResource = await userRepository.deleteAccount();

                if (deleteAccountResource.isSuccess) {
                  PushNotificationHelper.getToken().then((firebaseToken) async {
                    try {
                      await userRepository.deleteFCMToken(firebaseToken);
                    } catch (e) {
                      print("Error: $e");
                    } finally {
                      setLoading(false);
                      showSnackBar(
                        allTranslations.text(AppLanguages.accountDeletedSuccessfully),
                        isError: false,
                      );
                      await AppGlobals.logout(context);
                    }
                  });
                } else {
                  showSnackBar(deleteAccountResource.message ?? "");
                  setLoading(false);
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    cityController.dispose();

    avatarFileSubject.drain();
    avatarFileSubject.close();

    avatarLoadingSubject.drain();
    avatarLoadingSubject.close();

    genderSubject.drain();
    genderSubject.close();

    birthOfDateSubject.drain();
    birthOfDateSubject.close();

    countrySubject.drain();
    countrySubject.close();

    isEditingSubject.drain();
    isEditingSubject.close();

    userRepository.cancel();
    super.dispose();
  }
}
