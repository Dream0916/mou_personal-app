import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mou_app/utils/app_colors.dart';

class AppBody extends StatelessWidget {
  final Widget child;
  final Color statusBarColor;

  const AppBody({
    super.key,
    required this.child,
    this.statusBarColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.bgColor2,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return SafeArea(
      top: false,
      bottom: !Platform.isIOS,
      child: child,
    );
  }
}
