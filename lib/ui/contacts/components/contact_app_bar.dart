import 'package:flutter/material.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_images.dart';

class ContactAppBar extends StatelessWidget {
  final ValueChanged<String>? onSearchPressed;
  final VoidCallback? onAcceptPressed;

  const ContactAppBar({
    this.onSearchPressed,
    this.onAcceptPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Image.asset(
              AppImages.icCloseAddEvent,
              width: 16,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F6EF),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.borderColor),
                ),
                padding: const EdgeInsets.only(left: 20),
                margin: const EdgeInsets.only(left: 12, right: 16),
                child: TextField(
                  style: TextStyle(fontSize: AppFontSize.textQuestion, color: AppColors.normal),
                  decoration: InputDecoration(
                    suffixIcon: Transform.translate(
                      offset: Offset(8, 0),
                      child: Icon(
                        Icons.search,
                        size: 20,
                        color: AppColors.mainColor,
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: onSearchPressed,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onAcceptPressed,
            icon: Image.asset(
              AppImages.icAccept,
              width: 25,
            ),
          )
        ],
      ),
    );
  }
}
