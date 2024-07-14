import 'dart:io';

import 'package:collection/collection.dart';
import 'package:mou_app/core/models/gender.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/utils/app_apis.dart';
import 'package:mou_app/utils/app_configs.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommonHelper {
  static String convertPhoneNumber(String phoneNumber, {String code = "+84"}) {
    if (phoneNumber.isEmpty) return phoneNumber;
    if (phoneNumber.startsWith("0")) {
      phoneNumber = phoneNumber.replaceFirst("0", "");
    }
    if (phoneNumber.startsWith("${code}0")) {
      phoneNumber = phoneNumber.replaceFirst("${code}0", "");
    }
    if (phoneNumber.startsWith("$code")) {
      phoneNumber = phoneNumber.replaceFirst("$code", "");
    }
    return "$code$phoneNumber";
  }

  static String getFlagPath(String countryCode) {
    if (countryCode.isEmpty) return AppImages.flagUSA;
    return "assets/flags/${countryCode.toLowerCase()}.png";
  }

  static List<Gender> getGenders() {
    List<Gender> genders = <Gender>[];
    genders
        .add(Gender(type: 0, name: allTranslations.text(AppLanguages.female)));
    genders.add(Gender(type: 1, name: allTranslations.text(AppLanguages.male)));
    return genders;
  }

  static String getNameGender(int type) {
    final genders = getGenders();
    var gender = genders.firstWhereOrNull((gender) => gender.type == type);
    if (gender != null) {
      return "${gender.name}";
    }
    return "";
  }

  static bool regEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static Map<String, dynamic> encodeMap(Map<String, dynamic> map) {
    map.forEach((key, value) {
      if (value is DateTime) {
        map[key] = value.toString();
      }
    });
    return map;
  }

  static String getGoogleStaticMapUrl(String lat, String long) {
    String url = AppApis.staticMapUrl();
    List<String> params = <String>[]
      ..add(lat)
      ..add(long)
      ..add(AppConfigs.googleApiKey);
    return formatText(url, params);
  }

  static String formatText(String string, List<String> params) {
    String result = string;
    for (int i = 1; i < params.length + 1; i++) {
      result = result.replaceAll('%$i', params[i - 1]);
    }
    return result;
  }

  static Future openMap(String lat, String long) async {
    var mapSchema = 'geo:$lat,$long?q=$lat,$long&zoom=16';
    if (await canLaunchUrlString(mapSchema)) {
      await launchUrlString(mapSchema);
    } else {
      var url = AppApis.getGoogleMapLinkOpen(lat, long);
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch $mapSchema';
      }
    }
  }

  static Future<String> tempFile({String? suffix}) async {
    suffix ??= 'tmp';

    if (!suffix.startsWith('.')) {
      suffix = '.$suffix';
    }
    var uuid = DateTime.now().millisecondsSinceEpoch;
    var tmpDir = await getTemporaryDirectory();
    var path = '${join(tmpDir.path, uuid.toString())}$suffix';
    var parent = dirname(path);
    Directory(parent).createSync(recursive: true);

    return path;
  }
}
