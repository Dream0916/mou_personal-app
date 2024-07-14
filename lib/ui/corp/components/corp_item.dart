import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/widgets/slidable/app_slidable.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_types/slidable_action_type.dart';

import '../../../utils/app_colors.dart';

class CorpItem extends StatelessWidget {
  final Corp corp;
  final ValueChanged<Corp>? onAcceptPressed;
  final ValueChanged<Corp>? onDeletePressed;
  final bool hasInternet;

  const CorpItem({
    super.key,
    required this.corp,
    this.onAcceptPressed,
    this.onDeletePressed,
    this.hasInternet = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool confirmed = corp.confirmed ?? false;
    return AppSlidable<SlidableActionType>(
      key: ValueKey(corp.id),
      enabled: hasInternet,
      actions: confirmed ? [SlidableActionType.DELETE] : [],
      onActionPressed: (type) {
        return switch (type) {
          SlidableActionType.EXPORT => null,
          SlidableActionType.EDIT => null,
          SlidableActionType.DELETE => onDeletePressed?.call(corp),
          SlidableActionType.ACCEPT => null,
          SlidableActionType.DENY => null,
        };
      },
      margin: const EdgeInsets.only(left: 22, right: 26),
      child: Container(
        padding: EdgeInsets.fromLTRB(14, 7, 11, 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          crossAxisAlignment: confirmed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: corp.logo ?? "",
                  height: 31,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          corp.name ?? "",
                          style: TextStyle(
                            color: AppColors.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: AppFontSize.textButton,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!confirmed) ...[
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => onDeletePressed?.call(corp),
                          child: Container(
                            height: 13,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            child: Image.asset(AppImages.icDeny),
                          ),
                        ),
                        const SizedBox(width: 9),
                        InkWell(
                          onTap: () => onAcceptPressed?.call(corp),
                          child: Container(
                            height: 13,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            child: Image.asset(AppImages.icAcceptG),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!confirmed)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text.rich(
                        TextSpan(
                          text: "${S.text(AppLanguages.invitedYouToJoinCompanyAs)} ",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: AppColors.normal,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: corp.roleName,
                              style: TextStyle(
                                color: AppColors.normal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
