import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/models/time_in_alarm.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/widgets/alarm_dialog/time_in_alarm_dialog_viewmodel.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_font_size.dart';

class TimeInAlarmDialog extends StatelessWidget {
  final double? height;
  final List<TimeInAlarm>? itemsSelected;
  final Function(List<TimeInAlarm> timesInAlarm)? onCallBack;

  TimeInAlarmDialog({this.height, this.itemsSelected, this.onCallBack});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<TimeInAlarmDialogViewModel>(
      viewModel: TimeInAlarmDialogViewModel(timeInAlarmsSelected: this.itemsSelected),
      onViewModelReady: (viewModel) => viewModel..initData(),
      builder: (context, viewModel, child) {
        return Container(
          height: height,
          child: StreamBuilder<bool>(
            stream: viewModel.isChangedSubject,
            builder: (context, snapShot) {
              final List<TimeInAlarm> alarms = viewModel.timeInAlarms ?? [];
              return AnimationList(
                duration: AppConstants.ANIMATION_LIST_DURATION,
                reBounceDepth: AppConstants.ANIMATION_LIST_RE_BOUNCE_DEPTH,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 20),
                children: alarms.map((e) {
                  bool isSelected = viewModel.checkExist(e);
                  return InkWell(
                    highlightColor: Colors.grey,
                    onTap: () {
                      viewModel.setDaysInWeekSelected(e);
                      onCallBack!(viewModel.timeInAlarmsSelected ?? []);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 45,
                      padding: const EdgeInsets.only(left: 35, bottom: 10),
                      child: Text(
                        e.name ?? "",
                        style: TextStyle(
                          fontSize: AppFontSize.textDatePicker,
                          color: viewModel.checkExist(e)
                              ? AppColors.normal
                              : AppColors.normal.withOpacity(0.5),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}
