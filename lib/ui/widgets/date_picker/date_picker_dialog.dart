import 'package:flutter/cupertino.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/widgets/date_picker/date_picker_viewmodel.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_languages.dart';

class DatePickerDialog extends StatelessWidget {
  final double height;
  final int day;
  final int month;
  final int year;
  final Function(int day, int month, int year)? onCallBack;

  DatePickerDialog(
      {this.height = 150,
      this.day = 0,
      this.month = 0,
      this.year = 0,
      this.onCallBack});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<DatePickerViewModel>(
      viewModel: DatePickerViewModel(),
      onViewModelReady: (viewModel) =>
          viewModel..initData(day: day, month: month, year: year),
      builder: (context, viewModel, child) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.bgColor,
            borderRadius: BorderRadius.circular(15)
          ),
          alignment: Alignment.center,
          height: height,
          width: double.maxFinite,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              this._buildDay(context, viewModel),
              SizedBox(width: 20),
              this._buildMonth(context, viewModel),
              SizedBox(width: 20),
              this._buildYear(context, viewModel)
            ],
          ),
        );
      },
    );
  }

  Widget _buildDay(BuildContext context, DatePickerViewModel viewModel) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          height: 40,
          child: Text(
            allTranslations.text(AppLanguages.day),
            style: TextStyle(
                fontSize: AppFontSize.textDatePicker, color: AppColors.normal),
          ),
        ),
        StreamBuilder<List<int>>(
          stream: viewModel.daysStream,
          builder: (context, snapShot) {
            List<int>? days = snapShot.data ?? viewModel.days;
            return Container(
              height: height - 40,
              width: 70,
              child: CupertinoPicker(
                scrollController: viewModel.dayController,
                itemExtent: 30,
                onSelectedItemChanged: (int index) {
                  viewModel.setDay(viewModel.days[index]);
                  if (onCallBack != null) {
                    onCallBack!(
                      viewModel.days[index],
                      viewModel.month,
                      viewModel.year,
                    );
                  }
                },
                children: new List<Widget>.generate(
                  days.length,
                  (int index) {
                    return Center(
                      child: Text(
                        "${days[index]}",
                        style: TextStyle(
                            fontSize: AppFontSize.datePickerValueSelected,
                            color: AppColors.normal),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildMonth(BuildContext context, DatePickerViewModel viewModel) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          height: 40,
          child: Text(
            allTranslations.text(AppLanguages.month),
            style: TextStyle(
                fontSize: AppFontSize.textDatePicker, color: AppColors.normal),
          ),
        ),
        Container(
          height: height - 40,
          width: 70,
          child: CupertinoPicker(
            scrollController: new FixedExtentScrollController(
                initialItem: viewModel.month - 1),
            itemExtent: 30,
            onSelectedItemChanged: (int index) {
              viewModel.setMonth(viewModel.months[index]);
              viewModel.changeMonths();
              if (onCallBack != null) {
                onCallBack!(viewModel.day, viewModel.month,
                    viewModel.year);
              }
            },
            children: new List<Widget>.generate(viewModel.months.length,
                (int index) {
              return Center(
                child: Text(
                  "${viewModel.months[index]}",
                  style: TextStyle(
                      fontSize: AppFontSize.datePickerValueSelected,
                      color: AppColors.normal),
                ),
              );
            }),
          ),
        )
      ],
    );
  }

  Widget _buildYear(BuildContext context, DatePickerViewModel viewModel) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          height: 40,
          child: Text(
            allTranslations.text(AppLanguages.year),
            style: TextStyle(
                fontSize: AppFontSize.textDatePicker, color: AppColors.normal),
          ),
        ),
        Container(
          height: height - 40,
          width: 70,
          child: CupertinoPicker(
            scrollController: new FixedExtentScrollController(
              initialItem: viewModel.year == 0
                  ? 0
                  : DateTime.now().year - (viewModel.year),
            ),
            itemExtent: 30,
            onSelectedItemChanged: (int index) {
              viewModel.setYear(viewModel.years[index]);
              if (onCallBack != null) {
                onCallBack!(
                  viewModel.day,
                  viewModel.month,
                  viewModel.year,
                );
              }
            },
            children: new List<Widget>.generate(viewModel.years.length,
                (int index) {
              return Center(
                child: Text(
                  "${viewModel.years[index]}",
                  style: TextStyle(
                      fontSize: AppFontSize.datePickerValueSelected,
                      color: AppColors.normal),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
