import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/login/components/phone_code_button.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_languages.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final CountryPhoneCode? phoneCodeSelected;
  final VoidCallback? onSubmitted;
  final VoidCallback? onPhoneCodePressed;

  const PhoneNumberInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.phoneCodeSelected,
    this.onSubmitted,
    this.onPhoneCodePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 210),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            allTranslations.text(AppLanguages.phoneNumber),
            style: TextStyle(
              fontSize: 16,
              color: AppColors.header,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              PhoneCodeButton(
                phoneCodeSelected: phoneCodeSelected,
                onPressed: onPhoneCodePressed,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Center(
                  child: TextField(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: AppColors.normal,
                      height: 1,
                    ),
                    keyboardType: TextInputType.phone,
                    controller: controller,
                    focusNode: focusNode,
                    onSubmitted: (value) => onSubmitted?.call(),
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: Platform.isIOS ? 1 : 0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          )
        ],
      ),
    );
  }
}
