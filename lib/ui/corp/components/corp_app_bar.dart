import 'package:flutter/material.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_images.dart';

class CorpAppBar extends StatelessWidget {
  const CorpAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.appBarHeight,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 16, right: 16, top:22),
      child: Row(
        children: [
          IconButton(
            constraints: const BoxConstraints(maxWidth: 30),
            icon: Image.asset(
              AppImages.icArrowRight,
              width: 12,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Image(
                image: AssetImage(AppImages.icCorpG),
                height: 42,
              ),
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}
