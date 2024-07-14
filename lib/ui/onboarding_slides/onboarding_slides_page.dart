import 'package:flutter/material.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/onboarding_slides/components/onboarding_slide_1.dart';
import 'package:mou_app/ui/onboarding_slides/components/onboarding_slide_2.dart';
import 'package:mou_app/ui/onboarding_slides/components/onboarding_slide_3.dart';
import 'package:mou_app/ui/onboarding_slides/components/onboarding_slide_4.dart';
import 'package:mou_app/ui/onboarding_slides/components/onboarding_slides_indicators.dart';
import 'package:mou_app/utils/app_languages.dart';

class OnboardingSlidesPage extends StatefulWidget {
  const OnboardingSlidesPage({super.key});

  @override
  State<OnboardingSlidesPage> createState() => _OnboardingSlidesPageState();
}

class _OnboardingSlidesPageState extends State<OnboardingSlidesPage> {
  final _slides = [
    OnboardingSlide1(),
    OnboardingSlide2(),
    OnboardingSlide3(),
  ];
  final _pageController = PageController();
  int _currentPage = 0;

  bool get isLastPage => _currentPage == _slides.length - 1;

  @override
  void initState() {
    super.initState();
    _slides.add(
      OnboardingSlide4(onAddEventPressed: _onAddEventPressed),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) => setState(() => _currentPage = index);

  void _onSkipPressed() {
    _pageController.animateToPage(
      _slides.length - 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  Future<void> _onNavigateToHome() async =>
      await Navigator.pushReplacementNamed(context, Routers.HOME);

  void _onAddEventPressed() {
    _onNavigateToHome();
    Navigator.pushNamed(context, Routers.ADD_EVENT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            controller: _pageController,
            children: _slides,
            onPageChanged: _onPageChanged,
          ),
          Positioned(
            bottom: 18,
            left: 22,
            right: 22,
            child: SafeArea(
              top: false,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  OnboardingSlidesIndicators(
                    _pageController,
                    totalPage: _slides.length,
                  ),
                  if (!isLastPage)
                    Positioned(
                      left: 0,
                      child: _BottomButton(
                        onPressed: _onSkipPressed,
                        title: AppLanguages.skip,
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _BottomButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          allTranslations.text(title).toLowerCase(),
          style: TextStyle(color: Color(0xFF545252), fontSize: 12),
        ),
      ),
    );
  }
}
