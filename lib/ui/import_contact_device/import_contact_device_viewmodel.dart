import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/core/repositories/contact_repository.dart';
import 'package:mou_app/core/requests/contact_request.dart';
import 'package:mou_app/core/responses/register_response.dart';
import 'package:mou_app/helpers/permissions_service.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_loading.dart';
import 'package:mou_app/utils/app_dialcode.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_shared.dart';
import 'package:mou_app/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class ImportContactDeviceViewModel extends BaseViewModel {
  final ContactRepository contactRepository;
  final PermissionsService permissionsService;
  final bool isRegister;

  ImportContactDeviceViewModel({
    required this.contactRepository,
    required this.permissionsService,
    required this.isRegister,
  });

  BehaviorSubject<List<Contact>> contactDevicesSubject = BehaviorSubject<List<Contact>>();
  BehaviorSubject<String> processDataUploadSubject = BehaviorSubject<String>();

  List<CountryPhoneCode> phoneCodes = AppUtils.appCountryCodes;
  List<CountryPhoneCode> phoneCodeFourChars = [];
  List<CountryPhoneCode> phoneCodeThreeChars = [];
  List<CountryPhoneCode> phoneCodeTwoChars = [];
  bool isProcessingUpload = false;
  int sumItemUpload = 0;
  RegisterResponse? currentUser;

  void initData() async {
    if (await permissionsService.hasContactsPermission()) {
      setInitContacts();
    } else {
      var result =
          await permissionsService.requestContactsPermission(onPermissionDenied: permissionDenied);
      if (result) {
        setInitContacts();
      } else {
        navigateNext();
      }
    }
  }

  void setInitContacts() async {
    // Get all contacts from device
    var contacts = await ContactsService.getContacts();
    if (contacts.isNotEmpty) {
      contacts = contacts
          .where((contact) =>
              contact.phones != null &&
              contact.phones!.isNotEmpty &&
              contact.phones!.first.value!.length > 6)
          .toList();

      //Lọc lại danh sách liên hệ khi đầu số không nằm trong danh sách liên hệ tổng đài
      List<Contact> contactFilter = <Contact>[];
      for (int i = 0; i < contacts.length; i++) {
        String phone = contacts.toList()[i].phones!.first.value ?? '';
        var lstDialCode = appDialCodes.where((item) => phone.contains(item)).toList();
        if (lstDialCode.isEmpty) {
          contactFilter.add(contacts.toList()[i]);
        }
      }
      contacts = contactFilter;
    }
    contactDevicesSubject.add(contacts.toList());
    currentUser = await AppShared.getUser();
    await fetchDataPhoneCode();
  }

  Future<void> fetchDataPhoneCode() async {
    if (phoneCodes.isNotEmpty) {
      this.phoneCodeFourChars = this.phoneCodes.where((item) => item.dialCode.length == 4).toList();
      this.phoneCodeThreeChars =
          this.phoneCodes.where((item) => item.dialCode.length == 3).toList();
      this.phoneCodeTwoChars = this.phoneCodes.where((item) => item.dialCode.length == 2).toList();
    }
  }

  String getNameSocialApp(Contact contact) {
    if (contact.androidAccountType != null) {
      switch (contact.androidAccountType!) {
        case AndroidAccountType.facebook:
          return "Facebook";
        case AndroidAccountType.whatsapp:
          return "WhatsApp";
        case AndroidAccountType.google:
          return "Google";
        case AndroidAccountType.other:
          return "";
      }
    }
    return "";
  }

  String _getDialCode(String phone) {
    String result = "";
    bool isExistDialCode = false;
    if (phone.isNotEmpty) {
      isExistDialCode = phone.indexOf("+") != -1;
      if (isExistDialCode) {
        String dialCodeExist = "";
        for (int i = 4; i > 1; i--) {
          var subPhone = phone.substring(0, i);
          bool isExist = this.checkExistDialCode(subPhone);
          if (isExist) {
            dialCodeExist = subPhone;
            break;
          }
        }
        return dialCodeExist;
      }
    }
    return result;
  }

  bool checkExistDialCode(String subStringPhone) {
    switch (subStringPhone.length) {
      case 4:
        return phoneCodeFourChars.indexWhere((item) => item.dialCode == subStringPhone) != -1;
      case 3:
        return phoneCodeThreeChars.indexWhere((item) => item.dialCode == subStringPhone) != -1;
      default:
        return phoneCodeTwoChars.indexWhere((item) => item.dialCode == subStringPhone) != -1;
    }
  }

  String _formatPhone(String phone) {
    return phone.replaceAll(" ", "").replaceAll("-", "").replaceAll(RegExp(r'(?:_|[^\w\s])+'), '');
  }

  onSubmit() async {
    List<Contact> contacts = contactDevicesSubject.valueOrNull ?? [];
    if (contacts.isNotEmpty) {
      final user = await AppShared.getUser();
      List<ContactRequest> contactRequests = <ContactRequest>[];
      for (int i = 0; i < contacts.length; i++) {
        Contact contact = contacts[i];
        String phone = contact.phones
                ?.where((element) => element.value?.isNotEmpty ?? false)
                .firstOrNull
                ?.value ??
            '';
        String dialCode = _getDialCode(phone);
        String formattedPhone = _formatPhone(dialCode.isEmpty
            ? phone.startsWith("0")
                ? phone.replaceFirst("0", "")
                : phone
            : phone.replaceFirst(dialCode, ""));

        contactRequests.add(
          ContactRequest(
            name: contact.displayName ?? formattedPhone,
            phoneNumber: formattedPhone,
            dialCode: dialCode.isEmpty ? user.dialCode : dialCode,
            avatar: null,
          ),
        );
      }

      try {
        int numberItemInUpload = 20;
        processDataUploadSubject.add(
            "$sumItemUpload/${contactRequests.length}  ${allTranslations.text(AppLanguages.uploadingContact)}");
        showResultUpload();
        if (contactRequests.length > numberItemInUpload) {
          //Lấy số lần có gửi request submit contact
          double contactDiv = contactRequests.length.toDouble() / numberItemInUpload.toDouble();
          for (double i = 0; i < contactDiv; i++) {
            //Kiểm tra số item đầu tiên có đủ với một lần gọi hay không
            double degIndex = contactDiv - (i + 1).toDouble();
            double endIndex = 0;
            if (degIndex < 0) {
              endIndex = (contactDiv - i.toDouble()).abs();
            } else {
              endIndex = contactDiv - degIndex;
            }

            int startIndexList = (i * numberItemInUpload).toInt();
            int endIndexList = degIndex < 0
                ? startIndexList + (endIndex * numberItemInUpload).toInt()
                : (endIndex * numberItemInUpload).toInt();
            var subList = contactRequests.sublist(startIndexList, endIndexList);
            await importContact(subList, contactRequests.length);
          }
        } else {
          await importContact(contactRequests, contactRequests.length);
        }
        navigateNext();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> importContact(List<ContactRequest> contactRequests, int totalUpload) async {
    if (sumItemUpload > 0) {
      // delay to avoid Too Many Attempts error from server
      await Future.delayed(const Duration(seconds: 1));
    }
    var resource = await contactRepository.importContact(contactRequests);
    if (resource.isSuccess) {
      sumItemUpload += contactRequests.length;
      if (sumItemUpload <= totalUpload) {
        if (sumItemUpload == totalUpload) {
          processDataUploadSubject.add(allTranslations.text(AppLanguages.savingContacts));
          await contactRepository.getAllContact();
          showSnackBar(allTranslations.text(AppLanguages.importContactsSuccess), isError: false);
        } else {
          processDataUploadSubject.add(
              "$sumItemUpload/$totalUpload  ${allTranslations.text(AppLanguages.uploadingContact)}");
        }
      }
    } else {
      isProcessingUpload = false;
      showSnackBar(resource.message ?? "");
    }
  }

  void navigateNext() {
    Navigator.pop(context);
    if (isRegister) {
      Navigator.pushReplacementNamed(context, Routers.ONBOARDING);
    } else {
      Navigator.pop(context);
    }
  }

  void showResultUpload() {
    if (!isProcessingUpload) {
      isProcessingUpload = true;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: StreamBuilder<String>(
              stream: this.processDataUploadSubject,
              builder: (context, snapShot) {
                var data = snapShot.data ?? "";
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(data, style: TextStyle(fontSize: AppFontSize.textButton)),
                    const SizedBox(width: 10),
                    const AppLoadingIndicator(size: 20),
                  ],
                );
              },
            ),
          );
        },
      );
    }
  }

  permissionDenied() {
    print("Permission denied");
  }

  goBack() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    processDataUploadSubject.drain();
    processDataUploadSubject.close();

    contactDevicesSubject.drain();
    contactDevicesSubject.close();
    super.dispose();
  }
}
