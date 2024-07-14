import 'package:flutter/material.dart';
import 'package:mou_app/core/repositories/event_repository.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class MonthCalendarViewModel extends BaseViewModel {
  final focusedDaySubject = BehaviorSubject<DateTime>();
  final eventsSubject = BehaviorSubject<Map<DateTime, List<dynamic>>>();
  final EventRepository repository;

  MonthCalendarViewModel(this.repository);

  init(DateTime selected) async {
    focusedDaySubject.add(selected);
    await fetchEvents();
  }

  Future<void> fetchEvents() async {
    DateTime focusedDay = focusedDaySubject.value;
    DateTime fromDate = DateTime(focusedDay.year, focusedDay.month, 1);
    DateTime toDate = DateTime(focusedDay.year, focusedDay.month + 1, 0);
    repository.cancel();
    final dbEventChecks = await repository.getDBEventChecks(fromDate, toDate);
    _updateEvents(dbEventChecks);

    final resource = await repository.getEventChecks(fromDate, toDate);
    focusedDay = focusedDaySubject.value;
    if (fromDate.isBefore(focusedDay) && toDate.isAfter(focusedDay)) {
      _updateEvents(resource.data ?? {});
    }
  }

  void _updateEvents(Map<String, dynamic> eventChecks) {
    Map<DateTime, List<dynamic>> events = {};
    eventChecks.forEach((key, value) => events[DateTime.parse(key)] = [value]);
    eventsSubject.add(events);
  }

  void onAddPressed() {
    Navigator.pushNamed(context, Routers.ADD_EVENT);
  }

  onDaySelected(DateTime day) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routers.HOME,
      (router) => false,
      arguments: day,
    );
  }

  @override
  void dispose() async {
    await eventsSubject.drain();
    eventsSubject.close();
    await focusedDaySubject.drain();
    focusedDaySubject.close();
    super.dispose();
  }
}
