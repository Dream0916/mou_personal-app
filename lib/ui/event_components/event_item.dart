import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/databases/converter/creator_converter.dart';
import 'package:mou_app/core/models/creator.dart';
import 'package:mou_app/core/models/time_in_alarm.dart';
import 'package:mou_app/core/models/user.dart';
import 'package:mou_app/core/repositories/event_repository.dart';
import 'package:mou_app/core/services/wifi_service.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/widgets/slidable/app_slidable.dart';
import 'package:mou_app/ui/widgets/widget_image_network.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_shared.dart';
import 'package:mou_app/utils/app_types/slidable_action_type.dart';
import 'package:mou_app/utils/app_utils.dart';

class EventItem extends StatefulWidget {
  final Event event;
  final EventRepository repository;
  final void Function(String message, {bool isError})? showSnackBar;
  final VoidCallback? onRefreshParent;
  final bool showDateLabel;

  const EventItem({
    super.key,
    required this.event,
    required this.repository,
    required this.showSnackBar,
    this.onRefreshParent,
    this.showDateLabel = true,
  });

  @override
  _EventItemState createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  bool get waitingToConfirm => widget.event.waitingToConfirm ?? false;
  final ValueNotifier<bool> _isCreator = ValueNotifier(true);

  DateTime? get startDate => AppUtils.convertStringToDateTime(widget.event.startDate ?? '');

  DateTime? get endDate => AppUtils.convertStringToDateTime(widget.event.endDate ?? '');

  bool get isBeforeStartDate => startDate != null && DateTime.now().isBefore(startDate!);

  bool get hasEndDate =>
      endDate != null &&
      (DateTime(startDate!.year, startDate!.month, startDate!.day) !=
          DateTime(endDate!.year, endDate!.month, endDate!.day));
  String alarmToolTip = "";

  @override
  void initState() {
    super.initState();
    _getIsCreator();
    _getAlarmTime();
  }

  _getIsCreator() async {
    if (widget.event.creator != null) {
      final creator = CreatorConverter().fromSql(jsonEncode(widget.event.creator));
      _isCreator.value = creator.id == await AppShared.getUserID();
    }
  }

  _getAlarmTime() {
    if (timeInAlarmData.isNotEmpty && widget.event.alarm != null) {
      var lstAlarm = widget.event.alarm?.split(";");
      if (lstAlarm != null && lstAlarm.length > 0) {
        var timeInAlarmLocal = <TimeInAlarm>[];
        for (int i = 0; i < lstAlarm.length; i++) {
          var timeInAlarmExist =
              timeInAlarmData.firstWhereOrNull((item) => item.value == lstAlarm[i]);
          if (timeInAlarmExist != null) {
            timeInAlarmLocal.add(timeInAlarmExist);
          }
        }
        alarmToolTip = timeInAlarmLocal.map<String>((item) => item.name ?? "").toList().join("; ");
      }
    }
  }

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
    Creator? creator =
        widget.event.creator != null ? Creator.fromJson(widget.event.creator!) : null;
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
                Image.asset(AppImages.icEventB, width: 30),
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 12),
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
                      ValueListenableBuilder<bool>(
                        valueListenable: _isCreator,
                        builder: (_, isCreator, __) {
                          return AppSlidable<SlidableActionType>(
                            key: ValueKey(widget.event.id),
                            enabled: hasInternet && (!waitingToConfirm || isCreator),
                            actions: isCreator
                                ? [
                                    if (isBeforeStartDate) SlidableActionType.EDIT,
                                    SlidableActionType.DELETE,
                                  ]
                                : [
                                    isBeforeStartDate
                                        ? SlidableActionType.DENY
                                        : SlidableActionType.DELETE
                                  ],
                            onActionPressed: (type) {
                              return switch (type) {
                                SlidableActionType.EXPORT => null,
                                SlidableActionType.EDIT => _onEditEvent(),
                                SlidableActionType.DELETE => _onDeletePressed(context),
                                SlidableActionType.ACCEPT => null,
                                SlidableActionType.DENY => _onLeavePressed(context),
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
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            AppUtils.convertBetweenTimeToTime(
                                              startDateTime: startDate ?? DateTime.now(),
                                              endDateTime: endDate,
                                              showEndDate: widget.event.showEndDate ?? true,
                                            ),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.mainColor,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(width: 20),
                                                if (alarmToolTip.isNotEmpty)
                                                  Tooltip(
                                                    key: const ValueKey('alarm'),
                                                    message: alarmToolTip,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 16, vertical: 10),
                                                    showDuration: const Duration(seconds: 3),
                                                    verticalOffset: 12,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.9),
                                                      borderRadius: BorderRadius.circular(9),
                                                      border: Border.all(
                                                          color: AppColors.textPlaceHolder),
                                                    ),
                                                    textStyle: TextStyle(color: AppColors.normal),
                                                    margin:
                                                        const EdgeInsets.symmetric(horizontal: 10),
                                                    child: SvgPicture.asset(AppImages.icBell,
                                                        height: 14),
                                                    triggerMode: TooltipTriggerMode.tap,
                                                  ),
                                                const SizedBox(width: 20),
                                                if (widget.event.comment?.isNotEmpty ?? false)
                                                  Tooltip(
                                                    key: const ValueKey('comment'),
                                                    message: widget.event.comment!,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 16, vertical: 10),
                                                    showDuration: const Duration(seconds: 3),
                                                    verticalOffset: 12,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.9),
                                                      borderRadius: BorderRadius.circular(9),
                                                      border: Border.all(
                                                          color: AppColors.textPlaceHolder),
                                                    ),
                                                    textStyle: TextStyle(color: AppColors.normal),
                                                    margin:
                                                        const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Image.asset(
                                                      AppImages.icCommentActive,
                                                      color: const Color(0xFF919090),
                                                      width: 28,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    triggerMode: TooltipTriggerMode.tap,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 64),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        widget.event.title ?? "",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.normal,
                                        ),
                                      ),
                                      if (widget.event.place != null) ...[
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            SvgPicture.asset(AppImages.icLocationSVG, height: 15),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                widget.event.place ?? '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: const Color(0xFFB1B1B1),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                      if (users.isNotEmpty)
                                        SizedBox(
                                          height: 39,
                                          child: ListView.separated(
                                            padding: const EdgeInsets.only(top: 8),
                                            physics: const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                users.length + (creator?.avatar != null ? 1 : 0),
                                            separatorBuilder: (context, index) =>
                                                const SizedBox(width: 8),
                                            itemBuilder: (context, index) {
                                              String? avatar;
                                              bool isAccepted = false;
                                              if (creator?.avatar != null) {
                                                avatar = index == 0
                                                    ? creator!.avatar
                                                    : users[index - 1].avatar;
                                                isAccepted = index == 0
                                                    ? true
                                                    : users[index - 1].isAccepted ?? false;
                                              } else {
                                                avatar = users[index].avatar;
                                                isAccepted = users[index].isAccepted ?? false;
                                              }
                                              return Stack(
                                                children: [
                                                  WidgetImageNetwork(url: avatar ?? ''),
                                                  if (index != 0 && !isAccepted)
                                                    Positioned.fill(
                                                      child: DecoratedBox(
                                                        decoration: BoxDecoration(
                                                          color: AppColors.redColor.withOpacity(.5),
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (!isCreator && waitingToConfirm)
                                  Positioned(
                                    top: 14,
                                    right: 16,
                                    width: 64,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () => _onDenyPressed(context),
                                          child: Image.asset(AppImages.icDeny, width: 16),
                                        ),
                                        GestureDetector(
                                          onTap: _onAcceptEvent,
                                          child: Image.asset(AppImages.icAcceptG, width: 26),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
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

  void _onDenyPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          allTranslations.text(AppLanguages.denyEventWarning),
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
              _onDenyEvent();
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

  _onDenyEvent() async {
    final resource = await widget.repository.denyEvent(widget.event.id);
    if (resource.isSuccess) {
      widget.showSnackBar?.call(
        allTranslations.text(AppLanguages.denyEventSuccessful),
        isError: false,
      );
      widget.onRefreshParent?.call();
    } else {
      widget.showSnackBar?.call(resource.message ?? "");
    }
  }

  _onAcceptEvent() async {
    final resource = await widget.repository.confirmEvent(widget.event.id);
    if (resource.isSuccess) {
      widget.showSnackBar?.call(
        allTranslations.text(AppLanguages.confirmEventSuccessful),
        isError: false,
      );
      widget.onRefreshParent?.call();
    } else {
      widget.showSnackBar?.call(resource.message ?? "");
    }
  }

  _onEditEvent() {
    Navigator.pushNamed(context, Routers.ADD_EVENT, arguments: widget.event);
  }

  void _onDeletePressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          allTranslations.text(AppLanguages.deleteEventWarning),
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
              _onDeleteEvent();
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

  _onDeleteEvent() async {
    final resource = await widget.repository.deleteEvent(widget.event.id);
    if (resource.isSuccess) {
      widget.showSnackBar?.call(
        allTranslations.text(AppLanguages.deleteEventSuccessful),
        isError: false,
      );
      widget.onRefreshParent?.call();
    } else {
      widget.showSnackBar?.call(resource.message ?? "");
    }
  }

  void _onLeavePressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          allTranslations.text(AppLanguages.leaveEventWarning),
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
              _onLeaveEvent();
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

  _onLeaveEvent() async {
    final resource = await widget.repository.leaveEvent(widget.event.id);
    if (resource.isSuccess) {
      widget.showSnackBar?.call(
        allTranslations.text(AppLanguages.leaveEventSuccessful),
        isError: false,
      );
      widget.onRefreshParent?.call();
    } else {
      widget.showSnackBar?.call(resource.message ?? "");
    }
  }
}
