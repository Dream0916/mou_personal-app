import 'package:flutter/material.dart';
import 'package:mou_app/utils/app_images.dart';

class OpenIcon extends StatelessWidget {
  final VoidCallback? onTap;

  const OpenIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 61,
      height: 128,
      child: Stack(
        alignment: Alignment.centerLeft,
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(AppImages.bgCloseBar, fit: BoxFit.fitWidth),
          Positioned(
            top: 0,
            bottom: 0,
            left: 8,
            child: InkWell(
              onTap: onTap,
              child: Image.asset(AppImages.icCloseBar, width: 30, fit: BoxFit.scaleDown),
            ),
          ),
        ],
      ),
    );
  }
}
