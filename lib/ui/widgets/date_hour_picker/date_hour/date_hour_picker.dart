import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/widgets/date_hour_picker/date_hour/date_hour_picker_viewmodel.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';

class DateHourPicker extends StatefulWidget {
  final double height;
  final String title;
  final bool isStartDate;
  final int hour;
  final int minute;
  final int day;
  final int month;
  final int year;
  final Function(
    int hour,
    int minute,
    int day,
    int month,
    int year,
  )? onCallBack;

  DateHourPicker(
    this.height,
    this.title,
    this.isStartDate,
    this.hour,
    this.minute,
    this.day,
    this.month,
    this.year,
    this.onCallBack,
  );

  @override
  State<DateHourPicker> createState() => _DateHourPickerState();
}

class _DateHourPickerState extends State<DateHourPicker> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<DateHourPickerViewModel>(
      viewModel: DateHourPickerViewModel(),
      onViewModelReady: (viewModel) => viewModel.initData(
        hour: widget.hour,
        minute: widget.minute,
        day: widget.day,
        month: widget.month,
        year: widget.year,
        isStartDate: widget.isStartDate,
      ),
      builder: (context, viewModel, child) => Container(
        alignment: Alignment.center,
        height: widget.height,
        width: double.maxFinite,
        child: StreamBuilder<bool>(
          stream: viewModel.isEnabledSubject,
          builder: (context, snapshot) {
            bool isEnabled = snapshot.data ?? true;

            return Stack(
              children: [
                IgnorePointer(
                  ignoring: !isEnabled,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(flex: 18, child: _buildDay(context, viewModel)),
                        Expanded(flex: 18, child: _buildMonth(context, viewModel)),
                        Expanded(flex: 28, child: _buildYear(context, viewModel)),
                        Expanded(flex: 18, child: _buildHour(context, viewModel)),
                        Expanded(flex: 18, child: _buildMinute(context, viewModel)),
                      ],
                    ),
                  ),
                ),
                if (!widget.isStartDate)
                  Positioned(
                    top: 4,
                    left: 12,
                    height: 30,
                    child: IconButton(
                      onPressed: () {
                        widget.onCallBack?.call(
                          isEnabled ? 0 : viewModel.hour,
                          isEnabled ? 0 : viewModel.minute,
                          isEnabled ? 0 : viewModel.day,
                          isEnabled ? 0 : viewModel.month,
                          isEnabled ? 0 : viewModel.year,
                        );
                        viewModel.isEnabledSubject.add(!isEnabled);
                      },
                      icon: Transform.rotate(
                        angle: isEnabled ? 0 : 0.785398,
                        child: Image.asset(
                          AppImages.icClose,
                        ),
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHour(BuildContext context, DateHourPickerViewModel viewModel) {
    return StreamBuilder<bool>(
      stream: viewModel.isEnabledSubject,
      builder: (context, snapshot) {
        bool isEnabled = snapshot.data ?? true;
        int hourSelected = viewModel.hour;

        return Column(
          children: [
            widget.isStartDate && widget.title.isEmpty
                ? const SizedBox.shrink()
                : const SizedBox(height: 30),
            Container(
              alignment: Alignment.bottomCenter,
              height: 30,
              child: Text(
                allTranslations.text(AppLanguages.hour),
                style: TextStyle(
                  fontSize: AppFontSize.textDatePicker,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: widget.height - 60,
              width: 60,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: viewModel.hour,
                ),
                itemExtent: 70,
                squeeze: 1.5,
                backgroundColor: Colors.transparent,
                selectionOverlay: SizedBox.shrink(),
                looping: true,
                diameterRatio: 4,
                onSelectedItemChanged: (int index) {
                  int hour = viewModel.hours[index];
                  viewModel.setHour(hour);
                  widget.onCallBack?.call(
                    viewModel.hour,
                    viewModel.minute,
                    viewModel.day,
                    viewModel.month,
                    viewModel.year,
                  );
                  setState(() {
                    hourSelected = hour;
                  });
                },
                children: List.generate(
                  viewModel.hours.length,
                  (int index) {
                    int hour = viewModel.hours[index];
                    bool isSelected = hourSelected == hour;

                    return Center(
                      child: Text(
                        hour.toString(),
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: isSelected
                              ? AppFontSize.datePickerValueSelected
                              : AppFontSize.datePickerValueUnSelect,
                          color: isSelected && isEnabled ? AppColors.normal : AppColors.textHint,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildMinute(BuildContext context, DateHourPickerViewModel viewModel) {
    return StreamBuilder<bool>(
      stream: viewModel.isEnabledSubject,
      builder: (context, snapshot) {
        bool isEnabled = snapshot.data ?? true;
        int minSelected = viewModel.minute;

        return Column(
          children: <Widget>[
            widget.isStartDate
                ? widget.title.isNotEmpty
                    ? const SizedBox(height: 30)
                    : const SizedBox.shrink()
                : const SizedBox(height: 30),
            Container(
              alignment: Alignment.bottomCenter,
              height: 30,
              child: Text(
                allTranslations.text(AppLanguages.minute),
                style: TextStyle(
                  fontSize: AppFontSize.textDatePicker,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: widget.height - 60,
              width: 60,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: viewModel.minute),
                itemExtent: 70,
                squeeze: 1.5,
                backgroundColor: Colors.transparent,
                selectionOverlay: const SizedBox.shrink(),
                looping: true,
                diameterRatio: 4,
                onSelectedItemChanged: (int index) {
                  int minute = viewModel.minutes[index];
                  viewModel.setMinute(minute);
                  widget.onCallBack?.call(
                    viewModel.hour,
                    viewModel.minute,
                    viewModel.day,
                    viewModel.month,
                    viewModel.year,
                  );
                  setState(() {
                    minSelected = minute;
                  });
                },
                children: List<Widget>.generate(
                  viewModel.minutes.length,
                  (int index) {
                    int minute = viewModel.minutes[index];
                    bool isSelected = minSelected == minute;

                    return Center(
                      child: Text(
                        minute.toString(),
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: isSelected
                              ? AppFontSize.datePickerValueSelected
                              : AppFontSize.datePickerValueUnSelect,
                          color: isSelected && isEnabled ? AppColors.normal : AppColors.textHint,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildDay(BuildContext context, DateHourPickerViewModel viewModel) {
    return StreamBuilder<bool>(
        stream: viewModel.isEnabledSubject,
        builder: (context, snapshot) {
          bool isEnabled = snapshot.data ?? true;
          int daySelected = viewModel.day;

          return Column(
            children: [
              widget.isStartDate
                  ? widget.title.isNotEmpty
                      ? const SizedBox(height: 30)
                      : const SizedBox.shrink()
                  : const SizedBox(height: 30),
              Container(
                alignment: Alignment.bottomCenter,
                height: 30,
                child: Text(
                  allTranslations.text(AppLanguages.day),
                  style: TextStyle(
                    fontSize: AppFontSize.textDatePicker,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              StreamBuilder<List<int>>(
                stream: viewModel.daysSubject,
                builder: (context, snapShot) {
                  List<int>? days = snapShot.data ?? viewModel.days;

                  return SizedBox(
                    height: widget.height - 60,
                    width: 60,
                    child: CupertinoPicker(
                      scrollController: viewModel.dayController,
                      itemExtent: 70,
                      squeeze: 1.5,
                      backgroundColor: Colors.transparent,
                      selectionOverlay: const SizedBox.shrink(),
                      looping: true,
                      diameterRatio: 4,
                      onSelectedItemChanged: (int index) {
                        int day = days[index];
                        viewModel.setDay(day);
                        widget.onCallBack?.call(
                          viewModel.hour,
                          viewModel.minute,
                          viewModel.days[index],
                          viewModel.month,
                          viewModel.year,
                        );
                        setState(() {
                          daySelected = day;
                        });
                      },
                      children: List<Widget>.generate(
                        viewModel.days.length,
                        (int index) {
                          int day = viewModel.days[index];
                          bool isSelected = daySelected == day;

                          return Center(
                            child: Text(
                              day.toString(),
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: isSelected
                                    ? AppFontSize.datePickerValueSelected
                                    : AppFontSize.datePickerValueUnSelect,
                                color:
                                    isSelected && isEnabled ? AppColors.normal : AppColors.textHint,
                              ),
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
        });
  }

  Widget _buildMonth(BuildContext context, DateHourPickerViewModel viewModel) {
    return StreamBuilder<bool>(
      stream: viewModel.isEnabledSubject,
      builder: (context, snapshot) {
        bool isEnabled = snapshot.data ?? true;
        int monthSelected = viewModel.month;

        return Column(
          children: <Widget>[
            widget.isStartDate
                ? widget.title.isNotEmpty
                    ? const SizedBox(height: 30)
                    : const SizedBox.shrink()
                : const SizedBox(height: 30),
            Container(
              alignment: Alignment.bottomCenter,
              height: 30,
              child: Text(
                allTranslations.text(AppLanguages.month),
                style: TextStyle(
                  fontSize: AppFontSize.textDatePicker,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: widget.height - 60,
              width: 60,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: viewModel.month - 1),
                itemExtent: 70,
                squeeze: 1.5,
                backgroundColor: Colors.transparent,
                selectionOverlay: const SizedBox.shrink(),
                looping: true,
                diameterRatio: 4,
                onSelectedItemChanged: (int index) {
                  int month = viewModel.months[index];
                  viewModel.setMonth(month);
                  viewModel.changeMonths();
                  widget.onCallBack?.call(
                    viewModel.hour,
                    viewModel.minute,
                    viewModel.day,
                    viewModel.month,
                    viewModel.year,
                  );
                  setState(() {
                    monthSelected = month;
                  });
                },
                children: List.generate(
                  viewModel.months.length,
                  (int index) {
                    int month = viewModel.months[index];
                    bool isSelected = monthSelected == month;

                    return Center(
                      child: Text(
                        month.toString(),
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: isSelected
                              ? AppFontSize.datePickerValueSelected
                              : AppFontSize.datePickerValueUnSelect,
                          color: isSelected && isEnabled ? AppColors.normal : AppColors.textHint,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildYear(BuildContext context, DateHourPickerViewModel viewModel) {
    return StreamBuilder<bool>(
        stream: viewModel.isEnabledSubject,
        builder: (context, snapshot) {
          bool isEnabled = snapshot.data ?? true;
          int yearSelected = viewModel.year;

          return Column(
            children: [
              widget.title.isNotEmpty
                  ? Container(
                      height: 30,
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: AppFontSize.datePickerValueUnSelect,
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : widget.isStartDate
                      ? const SizedBox.shrink()
                      : const SizedBox(height: 30),
              Container(
                alignment: Alignment.bottomCenter,
                height: 30,
                child: Text(
                  allTranslations.text(AppLanguages.year),
                  style: TextStyle(
                    fontSize: AppFontSize.textDatePicker,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: widget.height - 60,
                width: 60,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: viewModel.year == 0 ? 0 : viewModel.getIndexYearOfList()),
                  itemExtent: 70,
                  squeeze: 1.5,
                  backgroundColor: Colors.transparent,
                  selectionOverlay: const SizedBox.shrink(),
                  looping: true,
                  diameterRatio: 4,
                  onSelectedItemChanged: (int index) {
                    int year = viewModel.years[index];
                    viewModel.setYear(year);
                    widget.onCallBack?.call(
                      viewModel.hour,
                      viewModel.minute,
                      viewModel.day,
                      viewModel.month,
                      viewModel.year,
                    );
                    setState(() {
                      yearSelected = year;
                    });
                  },
                  children: List<Widget>.generate(
                    viewModel.years.length,
                    (int index) {
                      int year = viewModel.years[index];
                      bool isSelected = yearSelected == year;

                      return Center(
                        child: Text(
                          year.toString(),
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: isSelected
                                ? AppFontSize.datePickerValueSelected
                                : AppFontSize.datePickerValueUnSelect,
                            color: isSelected && isEnabled ? AppColors.normal : AppColors.textHint,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        });
  }
}
