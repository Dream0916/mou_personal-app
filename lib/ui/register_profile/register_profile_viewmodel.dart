import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/core/models/gender.dart';
import 'package:mou_app/core/repositories/auth_repository.dart';
import 'package:mou_app/core/requests/user_request.dart';
import 'package:mou_app/helpers/common_helper.dart';
import 'package:mou_app/helpers/image_helper.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/ui/register_profile/register_profile_page.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:rxdart/rxdart.dart';

class RegisterProfileViewModel extends BaseViewModel {
  final AuthRepository authRepository;
  final RegisterProfileArguments arguments;

  RegisterProfileViewModel({
    required this.authRepository,
    required this.arguments,
  });

  var nameFocusNode = FocusNode();
  var nameController = TextEditingController();
  var emailFocusNode = FocusNode();
  var emailController = TextEditingController();
  var cityFocusNode = FocusNode();
  var cityController = TextEditingController();

  var birthOfDateSubject = BehaviorSubject<DateTime>();
  var genderSubject = BehaviorSubject<Gender>();
  var countrySubject = BehaviorSubject<CountryPhoneCode>();
  var avatarLoadingSubject = BehaviorSubject<bool>();
  var avatarFileSubject = BehaviorSubject<File>();

  List<Gender> genders = CommonHelper.getGenders();

  BehaviorSubject<bool> finishBackgroundSubject = BehaviorSubject<bool>();

  void changeBirthOfDate(int day, int month, int year) {
    var birthDate = DateTime(year, month, day);
    birthOfDateSubject.add(birthDate);
  }

  void changeCountry(CountryPhoneCode phoneCode) {
    countrySubject.add(phoneCode);
  }

  onSelectPhoto(File? file) async {
    if (file != null) {
      avatarLoadingSubject.add(true);
      final width = MediaQuery.of(context).size.width;
      File fileCrop =
          await ImageHelper.cropImage(file, (width - 80).round().toInt(), width.round().toInt());
      avatarFileSubject.add(fileCrop);
      avatarLoadingSubject.add(false);
    }
  }

  onFinish() {
    FocusScope.of(context).unfocus();
    if (validate) {
      setLoading(true);
      UserRequest userRequest = UserRequest(
        name: nameController.text,
        email: emailController.text,
        avatar: avatarFileSubject.value,
        birthday: birthOfDateSubject.value,
        gender: genderSubject.value.type,
        countryCode: countrySubject.value.code,
        city: cityController.text,
        phoneNumber: arguments.phone,
        dialCode: arguments.dialCode,
      );

      authRepository.registerUser(userRequest).then((response) async {
        if (response.isSuccess) {
          final data = response.data;
          if (data == null) return;
          // await Navigator.pushReplacementNamed(context, Routers.ONBOARDING);
          await Navigator.pushNamed(
            context,
            Routers.IMPORT_CONTACT_DEVICE,
            arguments: true,
          );
        } else {
          showSnackBar(response.message ?? "");
        }
        setLoading(false);
      }).catchError((error) {
        showSnackBar(error.toString());
        setLoading(false);
      });
    }
  }

  bool get validate {
    if (avatarFileSubject.valueOrNull == null) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseChooseAvatar));
      return false;
    } else if (nameController.text.trim().isEmpty) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseInputName));
      return false;
    } else if (birthOfDateSubject.valueOrNull == null) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseChooseDateOfBirth));
      return false;
    } else if (genderSubject.valueOrNull == null) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseChooseGender));
      return false;
    } else if (emailController.text.trim().isEmpty) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseInputEmail));
      return false;
    } else if (countrySubject.valueOrNull == null) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseChooseCountry));
      return false;
    } else if (cityController.text.trim().isEmpty) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseInputCity));
      return false;
    }
    return true;
  }

  changeFinishBackground() {
    File? avatar = avatarFileSubject.valueOrNull;
    String name = nameController.text;
    DateTime? birthOfDate = birthOfDateSubject.valueOrNull;
    Gender? gender = genderSubject.valueOrNull;
    String email = emailController.text;
    CountryPhoneCode? countryPhoneCode = countrySubject.valueOrNull;
    String city = cityController.text;
    if (avatar == null || birthOfDate == null || gender == null || countryPhoneCode == null) {
      finishBackgroundSubject.add(false);
      return;
    } else if (name.isEmpty || name.isNotEmpty && name.trim() == "") {
      finishBackgroundSubject.add(false);
      return;
    } else if (email.isEmpty || email.isNotEmpty && email.trim() == "") {
      finishBackgroundSubject.add(false);
      return;
    } else if (city.isEmpty || city.isNotEmpty && city.trim() == "") {
      finishBackgroundSubject.add(false);
      return;
    }
    finishBackgroundSubject.add(true);
    return;
  }

  @override
  void dispose() {
    authRepository.cancel();

    avatarFileSubject.close();
    avatarLoadingSubject.close();
    countrySubject.close();
    genderSubject.close();
    birthOfDateSubject.close();
    finishBackgroundSubject.close();

    nameController.dispose();
    emailController.dispose();
    cityController.dispose();

    super.dispose();
  }
}
