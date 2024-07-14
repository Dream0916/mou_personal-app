import 'package:flutter/material.dart';
import 'package:mou_app/utils/app_types/bubble_button_type.dart';

class OtherIcon extends StatelessWidget {
  final BubbleButtonType type;
  final VoidCallback onTap;

  const OtherIcon({
    super.key,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: const Color(0xffdf6058),
        child: Padding(
          padding: EdgeInsets.all(type == BubbleButtonType.Event ? 10 : 12),
          child: Image.asset(
            type.icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
