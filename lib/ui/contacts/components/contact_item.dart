import 'package:flutter/material.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_font_size.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;
  final bool isSelected;
  final ValueChanged<Contact>? onItemPressed;

  const ContactItem({
    super.key,
    required this.contact,
    required this.isSelected,
    this.onItemPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onItemPressed?.call(contact),
      contentPadding: const EdgeInsets.only(left: 30, right: 16),
      leading: Container(
        height: 45,
        width: 72,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: contact.avatar == null
              ? null
              : DecorationImage(
                  image: NetworkImage(contact.avatar ?? ""),
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Text(
        contact.name ?? "",
        style: TextStyle(
          fontSize: AppFontSize.nameList,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: AppColors.normal,
        ),
      ),
    );
  }
}
