import 'package:flutter/material.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/helpers/common_helper.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_images.dart';

class PhoneCodeButton extends StatelessWidget {
  final CountryPhoneCode? phoneCodeSelected;
  final VoidCallback? onPressed;

  const PhoneCodeButton({
    super.key,
    this.phoneCodeSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final CountryPhoneCode? phoneCode = phoneCodeSelected;
    return InkWell(
      splashColor: Colors.black,
      onTap: onPressed,
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 22,
            child: Image.asset(
              phoneCode != null
                  ? CommonHelper.getFlagPath(phoneCode.code.toLowerCase())
                  : AppImages.flagUSA,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            phoneCode != null ? phoneCode.dialCode : "+1",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.normal,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          )
        ],
      ),
    );
  }
}
