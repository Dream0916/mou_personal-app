import 'package:flutter/material.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';

class OnboardingSlide2 extends StatelessWidget {
  const OnboardingSlide2({super.key});

  String _text(String text) => allTranslations.text(text);

  TextStyle get _textStyle => TextStyle(color: Color(0xFF545252), fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.onboardingBackground2,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(flex: 34),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _text(AppLanguages.letSStartOpeningTheSideMenu),
                    style: _textStyle,
                  ),
                  const SizedBox(width: 6),
                  Image.asset(AppImages.icMenuClosed, width: 45),
                ],
              ),
            ),
            const Spacer(flex: 34),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(AppImages.imgSlide_2),
                  Positioned(
                    top: MediaQuery.sizeOf(context).height * .058,
                    right: 0,
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * .37,
                      child: Text(
                        _text(AppLanguages.thisIsYourCalendarPage),
                        style: _textStyle.copyWith(height: 1.5),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.sizeOf(context).height * .15,
                    left: 16,
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * .47,
                      child: Text(
                        _text(AppLanguages.createAndShareWithFamily),
                        style: _textStyle.copyWith(height: 1.5),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.sizeOf(context).height * .03,
                    right: MediaQuery.sizeOf(context).width * .25,
                    child: Text(
                      _text(AppLanguages.yourSettings),
                      style: _textStyle,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 64),
          ],
        ),
      ),
    );
  }
}
