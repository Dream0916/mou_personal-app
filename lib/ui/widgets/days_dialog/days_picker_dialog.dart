import 'package:flutter/material.dart';
import 'package:mou_app/core/models/day_in_week.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/widgets/days_dialog/days_picker_dialog_viewmodel.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_font_size.dart';

class DaysPickerDialog extends StatelessWidget {
  final double? height;
  final List<DayInWeek>? itemsSelected;
  final Function(List<DayInWeek> daysInWeek)? onCallBack;

  DaysPickerDialog({this.height, this.itemsSelected, this.onCallBack});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<DaysPickerDialogViewModel>(
      viewModel:
          DaysPickerDialogViewModel(daysInWeekSelected: itemsSelected ?? []),
      onViewModelReady: (viewModel) => viewModel..initData(),
      builder: (context, viewModel, child) {
        return Container(
          height: height,
          child: StreamBuilder<bool>(
            stream: viewModel.isChangedSubject,
            builder: (context, snapShot) {
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: viewModel.daysInWeek?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      highlightColor: Colors.grey,
                      onTap: () {
                        viewModel.setDaysInWeekSelected(
                            viewModel.daysInWeek?[index] ?? DayInWeek());
                        onCallBack!(viewModel.daysInWeekSelected);
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 45,
                        padding: const EdgeInsets.only(left: 35),
                        child: Text(
                          viewModel.daysInWeek?[index].name ?? "",
                          style: TextStyle(
                              fontSize: AppFontSize.textDatePicker,
                              color: AppColors.normal,
                              fontWeight: viewModel.checkExist(
                                      viewModel.daysInWeek?[index] ??
                                          DayInWeek())
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                    );
                  });
            },
          ),
        );
      },
    );
  }
}
