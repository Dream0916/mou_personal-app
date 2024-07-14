import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/core/models/user.dart';
import 'package:mou_app/core/repositories/contact_repository.dart';
import 'package:mou_app/core/requests/contact_request.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/utils/app_shared.dart';
import 'package:mou_app/utils/app_utils.dart';
import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';

class AddContactViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();

  final photoFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  final photoController = TextEditingController();
  final searchController = TextEditingController();
  final searchingSubject = BehaviorSubject<bool>();
  final autoValidateForm = BehaviorSubject<bool>();
  final usersSubject = BehaviorSubject<List<User>>();
  final phoneCodeSubject = BehaviorSubject<CountryPhoneCode>();

  final ContactRequest contactRequest = ContactRequest();
  final ContactRepository repository;

  String query = "";

  AddContactViewModel(this.repository) {
    searchController.addListener(() {
      final search = searchController.text;
      if (query == search) return;
      query = search;
      searchingSubject.add(search.isNotEmpty);
      autoValidateForm.add(false);
      if (search.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 300), () => _fetchContacts());
      } else {
        usersSubject.add([]);
      }
    });
  }

  Future<void> fetchDataFlags() async {
    final user = await AppShared.getUser();
    final phoneCode = AppUtils.appCountryCodes
        .firstWhere((phoneCode) => phoneCode.code.toLowerCase() == user.countryCode);
    contactRequest.dialCode = phoneCode.dialCode;
    this.phoneCodeSubject.add(phoneCode);
  }

  @override
  void dispose() async {
    repository.cancel();
    photoController.dispose();
    searchController.dispose();
    await phoneCodeSubject.drain();
    phoneCodeSubject.close();
    await autoValidateForm.drain();
    autoValidateForm.close();
    await searchingSubject.drain();
    searchingSubject.close();
    super.dispose();
  }

  _fetchContacts() async {
    this.repository.cancel();
    // this.usersSubject.add(null);
    this.usersSubject.add([]);
    final resource = await repository.searchUsers(searchController.text);
    this.usersSubject.add(resource.data ?? []);
    if (resource.isError) showSnackBar(resource.message ?? "", isError: true);
  }

  void addContact() async {
    FocusScope.of(context).unfocus();
    FormState? formState = formKey.currentState;
    if (formState?.validate() == true) {
      formState?.save();
      this.setLoading(true);
      final resource = await repository.addContact(contactRequest);
      if (resource.isError) {
        showSnackBar(resource.message ?? "", isError: true);
      } else {
        Navigator.pop(context);
      }
      this.setLoading(false);
    } else {
      autoValidateForm.add(true);
    }
  }

  void linkContact(User user) async {
    FocusScope.of(context).unfocus();
    this.setLoading(true);
    final resource = await repository.linkContact(user.id ?? 0);
    if (resource.isError) {
      showSnackBar(resource.message ?? "", isError: true);
    } else {
      Navigator.pop(context);
    }
    this.setLoading(false);
  }

  void savedName(String value) {
    contactRequest.name = value;
  }

  void savedPhoneNumber(String value) {
    contactRequest.phoneNumber = value;
  }

  void savedPhoto(File file) {
    contactRequest.avatar = file;
    photoController.text = path.basename(file.path);
  }

  void changePhoneCode(CountryPhoneCode phoneCode) {
    contactRequest.dialCode = phoneCode.dialCode;
    phoneCodeSubject.add(phoneCode);
  }
}
