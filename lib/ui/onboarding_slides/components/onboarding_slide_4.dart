import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';

class OnboardingSlide4 extends StatelessWidget {
  final VoidCallback onAddEventPressed;

  const OnboardingSlide4({super.key, required this.onAddEventPressed});

  TextStyle get _textStyle => TextStyle(
        color: Color(0xFF545252),
        fontSize: 14,
        height: 1.5,
      );

  String _text(String text) => allTranslations.text(text);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.onboardingBackground4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: max(24, MediaQuery.paddingOf(context).top),
            right: 18,
            child: Image.asset(AppImages.logoLogin, width: 75),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 42, top: 16, right: 42),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(flex: 107),
                Text(
                  _text((AppLanguages.thanksForDownloadingTheMouApp)),
                  style: _textStyle,
                ),
                Spacer(flex: 29),
                Text(
                  _text((AppLanguages.theLastThingToFinish)),
                  style: _textStyle,
                ),
                Spacer(flex: 27),
                IconButton(
                  onPressed: onAddEventPressed,
                  padding: const EdgeInsets.all(2),
                  constraints: const BoxConstraints(),
                  iconSize: 40,
                  icon: Image.asset(AppImages.icAddEvent),
                ),
                Spacer(flex: 85),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
