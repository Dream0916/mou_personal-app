import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/models/user.dart';
import 'package:mou_app/core/repositories/event_repository.dart';
import 'package:mou_app/core/services/wifi_service.dart';
import 'package:mou_app/helpers/send_notification_local.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/widgets/slidable/app_slidable.dart';
import 'package:mou_app/ui/widgets/widget_image_network.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_types/app_types.dart';
import 'package:mou_app/utils/app_types/slidable_action_type.dart';
import 'package:mou_app/utils/app_types/work_status.dart';
import 'package:mou_app/utils/app_utils.dart';

class TaskItem extends StatefulWidget {
  final Event event;
  final EventRepository repository;
  final void Function(String message, {bool isError})? showSnackBar;
  final VoidCallback? onRefreshParent;
  final bool showDateLabel;

  const TaskItem({
    super.key,
    required this.event,
    required this.repository,
    required this.showSnackBar,
    this.onRefreshParent,
    this.showDateLabel = true,
  });

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  DateTime? get startDate => AppUtils.convertStringToDateTime(widget.event.startDate ?? '');

  DateTime? get endDate => AppUtils.convertStringToDateTime(widget.event.endDate ?? '');

  bool get hasEndDate =>
      endDate != null &&
      (DateTime(startDate!.year, startDate!.month, startDate!.day) !=
          DateTime(endDate!.year, endDate!.month, endDate!.day));

  bool get waitingToConfirm => widget.event.waitingToConfirm ?? false;

  bool get isWaiting => widget.event.status == TaskStatus.WAITING;

  bool get isInProgress => widget.event.status == TaskStatus.IN_PROGRESS;

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
    String status = widget.event.status ?? '';
    Color statusColor = AppUtils.getStatusColor(status);
    WorkStatus? workStatus = widget.event.workStatus;
    if (status.isEmpty && workStatus != null) {
      statusColor = workStatus.gradientColor;
    }

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
                SvgPicture.asset(AppImages.icTaskSVG),
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
                        actions: isWaiting || isInProgress
                            ? [SlidableActionType.ACCEPT, SlidableActionType.DENY]
                            : [SlidableActionType.DELETE],
                        onActionPressed: (type) {
                          return switch (type) {
                            SlidableActionType.EXPORT => null,
                            SlidableActionType.EDIT => null,
                            SlidableActionType.DELETE => _onDeletePressed(context),
                            SlidableActionType.ACCEPT => _onDoneTask(),
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
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    statusColor,
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(right: widget.showDateLabel ? 60 : 0),
                                          child: Text(
                                            widget.event.title ?? '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.normal,
                                            ),
                                          ),
                                        ),
                                        if ((widget.event.storeName?.isNotEmpty ?? false) ||
                                            (widget.event.comment?.isNotEmpty ?? false)) ...[
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              if (widget.event.storeName?.isNotEmpty ?? false) ...[
                                                SvgPicture.asset(AppImages.icLocationSVG,
                                                    height: 15),
                                                const SizedBox(width: 6),
                                                Text(
                                                  widget.event.storeName ?? '',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: const Color(0xFFB1B1B1),
                                                  ),
                                                ),
                                              ],
                                              const Spacer(),
                                              if (widget.event.comment?.isNotEmpty ?? false)
                                                Tooltip(
                                                  key: ValueKey('comment ${widget.event.id}'),
                                                  message: widget.event.comment,
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
                                        ],
                                        if (users.isNotEmpty)
                                          SizedBox(
                                            height: 41,
                                            child: ListView.separated(
                                              physics: const BouncingScrollPhysics(),
                                              padding: const EdgeInsets.only(top: 10),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: users.length,
                                              separatorBuilder: (context, index) =>
                                                  const SizedBox(width: 8),
                                              itemBuilder: (context, index) {
                                                User user = users[index];
                                                String? avatar = user.avatar;
                                                bool isAccepted = user.isAccepted ?? false;

                                                return Stack(
                                                  children: [
                                                    WidgetImageNetwork(url: avatar ?? ''),
                                                    if (!isAccepted)
                                                      Positioned.fill(
                                                        child: DecoratedBox(
                                                          decoration: BoxDecoration(
                                                            color:
                                                                AppColors.redColor.withOpacity(.5),
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
                                      onTap: _onAcceptTask,
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

  void _onDenyPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          allTranslations.text(AppLanguages.denyTaskWarning),
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
              _onDenyTask();
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

  _onDenyTask() async {
    final resource = await widget.repository.denyEvent(widget.event.id);
    if (resource.isSuccess) {
      widget.showSnackBar?.call(
        allTranslations.text(AppLanguages.denyTaskSuccessful),
        isError: false,
      );
      widget.onRefreshParent?.call();
    } else {
      widget.showSnackBar?.call(resource.message ?? "");
    }
  }

  _onAcceptTask() async {
    final resource = await widget.repository.confirmEvent(widget.event.id);
    if (resource.isSuccess) {
      // Đăng ký sự kiên vào thiết bị
      SendNotificationLocal.registerLocalNotification(widget.event);
      widget.showSnackBar?.call(
        allTranslations.text(AppLanguages.confirmTaskSuccessful),
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
          allTranslations.text(AppLanguages.leaveTaskWarning),
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
              _onLeaveTask();
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
  

  _onLeaveTask() async {
    final resource = await widget.repository.leaveEvent(widget.event.id);
    if (resource.isSuccess) {
      //Hủy đăng ký thông báo sư kiên ở thiết bị
      SendNotificationLocal.removeEventRegisterFromDevice(widget.event);
      widget.showSnackBar?.call(
        allTranslations.text(AppLanguages.leaveTaskSuccessful),
        isError: false,
      );
      widget.onRefreshParent?.call();
    } else {
      widget.showSnackBar?.call(resource.message ?? "");
    }
  }

  _onDoneTask() async {
    final resource = await widget.repository.confirmDoneTask(widget.event.id);
    if (resource.isSuccess) {
      widget.showSnackBar?.call(
        allTranslations.text(AppLanguages.doneTaskSuccessful),
        isError: false,
      );
      widget.onRefreshParent?.call();
    } else {
      widget.showSnackBar?.call(resource.message ?? "");
    }
  }

  void _onDeletePressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          allTranslations.text(AppLanguages.deleteTaskWarning),
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
              _onDeleteTask();
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

  _onDeleteTask() async {
    final resource = await widget.repository.deleteEvent(widget.event.id);
    if (resource.isSuccess) {
      widget.showSnackBar?.call(
        allTranslations.text(AppLanguages.deleteTaskSuccess),
        isError: false,
      );
      widget.onRefreshParent?.call();
    } else {
      widget.showSnackBar?.call(resource.message ?? "");
    }
  }
}
