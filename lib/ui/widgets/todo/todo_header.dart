import 'package:flutter/material.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_images.dart';

class TodoHeader extends StatelessWidget {
  final VoidCallback? onAddTotoPressed;
  final Widget? leading;
  final Widget? action;
  final Widget? title;
  final bool hasInternet;

  const TodoHeader({
    super.key,
    this.onAddTotoPressed,
    this.leading,
    this.action,
    this.title,
    this.hasInternet = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: AppConstants.appBarHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 12),
          child: leading != null || action != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    leading ?? const SizedBox(),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: title ?? Image(image: AssetImage(AppImages.icToDo), height: 45),
                    ),
                    const Spacer(),
                    action ?? const SizedBox(),
                    const SizedBox(width: 16),
                  ],
                )
              : title ??
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Image(
                      image: AssetImage(AppImages.icToDo),
                      height: 45,
                    ),
                  ),
        ),
        if (hasInternet && onAddTotoPressed != null)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: InkWell(
              child: Image.asset(
                AppImages.icCircleAdd,
                width: MediaQuery.of(context).size.width * 0.244,
                fit: BoxFit.cover,
              ),
              onTap: onAddTotoPressed,
            ),
          ),
      ],
    );
  }
}
