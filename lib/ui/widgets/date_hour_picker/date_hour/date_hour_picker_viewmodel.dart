import 'package:flutter/material.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:date_utilities/date_utilities.dart';

class DateHourPickerViewModel extends BaseViewModel {
  DateHourPickerViewModel();

  var daysSubject = BehaviorSubject<List<int>>();
  var isEnabledSubject = BehaviorSubject<bool>.seeded(true);

  FixedExtentScrollController? dayController;

  late int hour, minute, day, month, year;
  List<int> hours = <int>[];
  List<int> minutes = <int>[];
  List<int> days = <int>[];
  List<int> months = <int>[];
  List<int> years = <int>[];

  void initData({
    required int hour,
    required int minute,
    required int day,
    required int month,
    required int year,
    bool isStartDate = true,
  }) {
    DateTime now = DateTime.now();
    this.hour = hour == 0 ? now.hour : hour;
    this.minute = minute == 0 ? now.minute : minute;
    this.day = day == 0 ? now.day : day;
    this.month = month == 0 ? now.month : month;
    this.year = year == 0 ? now.year : year;
    isEnabledSubject.add(isStartDate);

    this.addHours();
    this.addMinutes();
    this.addDays();
    this.addMonth();
    this.addYear();

    dayController = FixedExtentScrollController(initialItem: this.day - 1);
  }

  void addHours() {
    for (int i = 0; i <= 23; i++) {
      hours.add(i);
    }
  }

  void addMinutes() {
    for (int i = 0; i <= 59; i++) {
      minutes.add(i);
    }
  }

  void addDays() {
    var dateUtility = DateUtilities();
    int? daysInMonth = dateUtility.daysInMonth(month, year);
    for (int i = 1; i <= daysInMonth!; i++) {
      days.add(i);
    }
    daysSubject.add(days);
  }

  void addMonth() {
    for (int i = 1; i <= 12; i++) {
      months.add(i);
    }
  }

  void addYear() {
    for (int i = 0; i <= 5; i++) {
      years.add(DateTime.now().year + i);
    }
  }

  int getIndexYearOfList() {
    return years.indexOf(this.year);
  }

  void setHour(int hour) {
    this.hour = hour;
  }

  void setMinute(int minute) {
    this.minute = minute;
  }

  void setDay(int day) {
    this.day = day;
  }

  void setMonth(int month) {
    this.month = month;
  }

  void setYear(int year) {
    this.year = year;
  }

  void changeMonths() {
    var dateUtility = DateUtilities();
    int? daysInMonth = dateUtility.daysInMonth(month, year);

    //Kiểm tra nếu số ngày tháng trước đó lớn hơn số ngày tháng được chọn
    //thì reset lại về ngày 1
    if (days.length > (daysInMonth ?? 0)) {
      if (day > (daysInMonth ?? 0)) {
        day = 1;
        dayController?.animateToItem(day - 1,
            duration: Duration(microseconds: 20), curve: Curves.bounceIn);
      }
    }
    days.clear();
    daysSubject.add(days);
    for (int i = 1; i <= (daysInMonth ?? 0); i++) {
      days.add(i);
    }

    daysSubject.add(days);
  }

  @override
  void dispose() async {
    await daysSubject.drain();
    daysSubject.close();
    await isEnabledSubject.drain();
    isEnabledSubject.close();
    super.dispose();
  }
}
