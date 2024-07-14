import 'package:flutter/material.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/splash/splash_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseWidget<SplashViewModel>(
        viewModel: SplashViewModel(
          service: Provider.of(context),
          authRepository: Provider.of(context),
          eventRepository: Provider.of(context),
        ),
        onViewModelReady: (viewModel) => viewModel..checkLogged(),
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: LottieBuilder.asset(
                'assets/anim/splashback.json',
                animate: true,
                repeat: false,
                height: 400,
              ),
            ),
          );
        },
      ),
    );
  }
}
