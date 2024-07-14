import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/models/user.dart';
import 'package:mou_app/core/repositories/event_repository.dart';
import 'package:mou_app/core/services/wifi_service.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/widgets/slidable/app_slidable.dart';
import 'package:mou_app/ui/widgets/widget_image_network.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_types/slidable_action_type.dart';
import 'package:mou_app/utils/app_utils.dart';

class RosterItem extends StatefulWidget {
  final Event event;
  final EventRepository repository;
  final void Function(String message, {bool isError})? showSnackBar;
  final VoidCallback? onRefreshParent;
  final bool showDateLabel;

  const RosterItem({
    super.key,
    required this.event,
    required this.repository,
    required this.showSnackBar,
    this.onRefreshParent,
    this.showDateLabel = true,
  });

  @override
  _RosterItemState createState() => _RosterItemState();
}

class _RosterItemState extends State<RosterItem> {
  bool get waitingToConfirm => widget.event.waitingToConfirm ?? false;

  DateTime? get startDate => AppUtils.convertStringToDateTime(widget.event.startDate ?? '');

  DateTime? get endDate => AppUtils.convertStringToDateTime(widget.event.endDate ?? '');

  bool get isBeforeStartDate => startDate != null && DateTime.now().isBefore(startDate!);

  bool get hasEndDate =>
      endDate != null &&
      (DateTime(startDate!.year, startDate!.month, startDate!.day) !=
          DateTime(endDate!.year, endDate!.month, endDate!.day));

  Widget dateLabel({bool isStartDate = true}) {
    String date = (isStartDate ? widget.event.startDate : widget.event.endDate) ?? '';
    return Container(
      padding: EdgeInsets.fromLTRB(isStartDate ? 15 : 18, 5, 15, 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFF2DF77),
            Color(0xFFDBB970),
          ],
        ),
      ),
      child: Text(
        "${AppUtils.convertDayToString(
          AppUtils.convertStringToDateTime(date) ?? DateTime.now(),
          format: "dd/MM EEE",
        )}",
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<User> users = widget.event.users?.map((e) => User.fromJson(e)).toList() ?? [];

    return StreamBuilder<ConnectivityResult>(
      stream: WifiService.wifiSubject,
      builder: (_, snapshot) {
        bool hasInternet = snapshot.hasData && snapshot.data != ConnectivityResult.none;

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
          child: Bounceable(
            onTap: () {},
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topLeft,
              children: [
                SvgPicture.asset(AppImages.icRosterSVG),
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topLeft,
                    children: [
                      if (widget.showDateLabel)
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Row(
                              children: List.generate(hasEndDate ? 2 : 1, (index) {
                                return Align(
                                  widthFactor: index == 0 ? 1 : 0.8,
                                  child: dateLabel(isStartDate: index == 0),
                                );
                              }),
                            ),
                            dateLabel(),
                          ],
                        ),
                      AppSlidable<SlidableActionType>(
                        key: ValueKey(widget.event.id),
                        enabled: hasInternet && !waitingToConfirm,
                        actions: [
                          isBeforeStartDate ? SlidableActionType.DENY : SlidableActionType.DELETE
                        ],
                        onActionPressed: (type) {
                          return switch (type) {
                            SlidableActionType.EXPORT => null,
                            SlidableActionType.EDIT => null,
                            SlidableActionType.DELETE => _onDeletePressed(context),
                            SlidableActionType.ACCEPT => null,
                            SlidableActionType.DENY => _onCancelPressed(context),
                          };
                        },
                        margin: EdgeInsets.only(top: widget.showDateLabel ? 28 : 0),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    const Color(0xFFF4ECC8),
                                    Colors.white,
                                  ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  WidgetImageNetwork(
                                    url: widget.event.companyPhoto ?? '',
                                    height: 31,
                                    width: 50,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppUtils.convertBetweenTimeToTime(
                                            startDateTime: startDate ?? DateTime.now(),
                                            endDateTime: endDate,
                                          ),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.mainColor,
                                              letterSpacing: 1.2),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.icLocationSVG,
                                              height: 15,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                widget.event.storeName ??
                                                    widget.event.companyName ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: const Color(0xFFB1B1B1),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (users.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Stack(
                                              children: [
                                                WidgetImageNetwork(
                                                  url: users.first.avatar ?? '',
                                                ),
                                                if (widget.event.status != "Y")
                                                  Positioned.fill(
                                                    child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        color: AppColors.redColor.withOpacity(.5),
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (waitingToConfirm)
                              Positioned(
                                top: 14,
                                right: 16,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () => _onDenyPressed(context),
                                      child: Image.asset(AppImages.icDeny, width: 16),
                                    ),
                                    const SizedBox(width: 24),
                                    GestureDetector(
                                      onTap: _onAcceptRoster,
                                      child: Image.asset(AppImages.icAcceptG, width: 26),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onCancelPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          allTranslations.text(AppLanguages.cancelRosterWarning),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              allTranslations.text(AppLanguages.cancel),
              style: TextStyle(color: AppColors.redColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              _onCancelRoster();
            },
            child: Text(
              allTranslations.text(AppLanguages.accept),
              style: TextStyle(color: AppColors.greenColor),
            ),
          ),
        ],
      ),
    );
  }

  _onCancelRoster() async {
    final resource = await widget.repository.declineRoster(widget.event.id);
    if (resource.isSuccess) {
      if (widget.showSnackBar != null) {
        widget.showSnackBar!(
          allTranslations.text(AppLanguages.cancelRosterSuccess),
          isError: false,
        );
      }
    } else {
      if (widget.showSnackBar != null) widget.showSnackBar!(resource.message ?? "");
    }
  }

  void _onDeletePressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          allTranslations.text(AppLanguages.deleteRosterWarning),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              allTranslations.text(AppLanguages.cancel),
              style: TextStyle(color: AppColors.redColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _onDeleteRoster();
            },
            child: Text(
              allTranslations.text(AppLanguages.ok),
              style: TextStyle(color: AppColors.greenColor),
            ),
          ),
        ],
      ),
    );
  }

  _onDeleteRoster() async {
    final resource = await widget.repository.deleteRoster(widget.event.id);
    if (resource.isSuccess) {
      widget.showSnackBar?.call(
        allTranslations.text(AppLanguages.deleteRosterSuccess),
        isError: false,
      );
      widget.onRefreshParent?.call();
    } else {
      widget.showSnackBar?.call(resource.message ?? "");
    }
  }

  void _onDenyPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          allTranslations.text(AppLanguages.denyRosterWarning),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              allTranslations.text(AppLanguages.cancel),
              style: TextStyle(color: AppColors.redColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _onDenyRoster();
            },
            child: Text(
              allTranslations.text(AppLanguages.ok),
              style: TextStyle(color: AppColors.greenColor),
            ),
          ),
        ],
      ),
    );
  }

  _onDenyRoster() async {
    // final resource = await widget.repository.denyEvent(widget.event.id);
    final resource = await widget.repository.declineRoster(widget.event.id);
    if (resource.isSuccess) {
      widget.showSnackBar?.call(
        allTranslations.text(AppLanguages.denyRosterSuccess),
        isError: false,
      );
      widget.onRefreshParent?.call();
    } else {
      widget.showSnackBar?.call(resource.message ?? "");
    }
  }

  _onAcceptRoster() async {
    final resource = await widget.repository.acceptRoster(widget.event.id);
    if (resource.isSuccess) {
      if (widget.showSnackBar != null) {
        widget.showSnackBar!(
          allTranslations.text(AppLanguages.confirmRosterSuccessful),
          isError: false,
        );
      }
    } else {
      if (widget.showSnackBar != null) widget.showSnackBar!(resource.message ?? "");
    }
  }
}
