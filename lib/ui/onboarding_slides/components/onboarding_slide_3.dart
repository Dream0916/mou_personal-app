import 'package:flutter/material.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';

class OnboardingSlide3 extends StatelessWidget {
  const OnboardingSlide3({super.key});

  String _text(String text) => allTranslations.text(text);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.onboardingBackground3,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(flex: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _text(AppLanguages.hereInEvents),
                style: TextStyle(color: Color(0xFF545252), fontSize: 14),
              ),
              const SizedBox(width: 6),
              Image.asset(AppImages.icSlideEvents, width: 42),
            ],
          ),
          const Spacer(flex: 16),
          _Section(
            asset: AppImages.imgSlide_3_1,
            text: _text(AppLanguages.everyTimeYouReceiveAnEventOrAnything),
          ),
          const Spacer(flex: 20),
          _Section(
            asset: AppImages.imgSlide_3_2,
            text: _text(AppLanguages.everyTimeYouCreateAnEventAndIt),
          ),
          const Spacer(flex: 20),
          _Section(
            asset: AppImages.imgSlide_3_3,
            text: _text(AppLanguages.onceTheEventsOrAnything),
          ),
          const Spacer(flex: 20),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String asset;
  final String text;

  const _Section({required this.asset, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(asset, width: 160),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xFF545252),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
