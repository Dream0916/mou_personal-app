import 'package:flutter/material.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_types/app_types.dart';

class PickerFileOptionsDialog extends StatelessWidget {
  final Function(String mediaType) onCallback;
  final bool isGallery;

  PickerFileOptionsDialog({required this.onCallback, this.isGallery = true});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      if (index == 0) {
        return TextButton(
          onPressed: () => this.onCallback(MediaType.IMAGE),
          child: Container(
            width: double.maxFinite,
            child: Text(
              allTranslations.text(isGallery
                  ? AppLanguages.choosePhoto
                  : AppLanguages.takeAPhoto),
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: AppFontSize.textDatePicker,
              ),
            ),
          ),
        );
      } else {
        return TextButton(
          onPressed: () => this.onCallback(MediaType.VIDEO),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              allTranslations.text(isGallery
                  ? AppLanguages.chooseVideo
                  : AppLanguages.recordVideo),
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: AppFontSize.textDatePicker,
              ),
            ),
          ),
        );
      }
    });
  }
}
