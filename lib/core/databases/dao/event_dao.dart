import 'package:drift/drift.dart';
import 'package:mou_app/utils/app_types/event_page_type.dart';
import 'package:mou_app/utils/app_types/event_status.dart';
import 'package:mou_app/utils/app_types/work_status.dart';

import '../app_database.dart';
import '../table/events.dart';

part 'event_dao.g.dart';

@DriftAccessor(tables: [Events])
class EventDao extends DatabaseAccessor<AppDatabase> with _$EventDaoMixin {
  final AppDatabase db;

  EventDao(this.db) : super(db);

  Future<List<Event>> getEventsByID(int id) =>
      (select(events)..where((t) => t.id.equals(id))).get();

  Future updateEvent(Event event) => into(events).insert(
        event,
        mode: InsertMode.insertOrReplace,
      );

  Future deleteAll() => delete(events).go();

  Future deleteEventByID(int id) => (delete(events)..where((e) => e.id.equals(id))).go();

  /// HOME EVENTS PAGE
  Future insertHomeEvent(Event event) => into(events).insert(
        event.copyWith(pageType: Value(EventPageType.EVENT_PAGE)),
        mode: InsertMode.insertOrReplace,
      );

  Stream<List<Event>> watchHomeEventsByDate(DateTime dateTime) => (select(events)
        ..where(
            (t) => t.pageType.isIn([EventPageType.HOME_PAGE.name, EventPageType.EVENT_PAGE.name]) & t.dateLocal.equals(dateTime))
        ..orderBy([(t) => OrderingTerm(expression: t.sort, mode: OrderingMode.asc)]))
      .watch();

  Future deleteHomeEventsByDate(DateTime dateTime) => (delete(events)
        ..where(
            (t) => 
            t.pageType.isIn([EventPageType.HOME_PAGE.name, EventPageType.EVENT_PAGE.name]) & 
            t.dateLocal.equals(dateTime)))
      .go();

  Future<int> countHomeEventsByDate(DateTime dateTime) => (select(events)
        ..where(
            (t) => t.pageType.isIn([EventPageType.HOME_PAGE.name, EventPageType.EVENT_PAGE.name]) & t.dateLocal.equals(dateTime)))
      .get()
      .then((value) => value.length);

  /// EVENTS PAGE
  Future insertEvent(Event event) => into(events).insert(
        event.copyWith(pageType: Value(EventPageType.EVENT_PAGE)),
        mode: InsertMode.insertOrReplace,
      );

  Stream<List<Event>> watchEventsByTypeAndEventStatus(
          EventStatus eventStatus, List<String> types) =>
      (select(events)
            ..where((t) =>
                t.pageType.equals(EventPageType.EVENT_PAGE.name) &
                t.eventStatus.equals(eventStatus.name) &
                t.type.isIn(types))
            ..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc)]))
          .watch();

  Stream<List<Event>> watchEventsByEventStatus(EventStatus eventStatus) => (select(events)
        ..where((t) =>
            t.pageType.equals(EventPageType.EVENT_PAGE.name) &
            t.eventStatus.equals(eventStatus.name))
        ..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc)]))
      .watch();

  Future deleteEventsByStatus(EventStatus eventStatus) => (delete(events)
        ..where((t) =>
            t.pageType.equals(EventPageType.EVENT_PAGE.name) &
            t.eventStatus.equals(eventStatus.name)))
      .go();

  Future<int> countEventsByStatus(EventStatus eventStatus) => (select(events)
        ..where((t) =>
            t.pageType.equals(EventPageType.EVENT_PAGE.name) &
            t.eventStatus.equals(eventStatus.name)))
      .get()
      .then((value) => value.length);

  /// WORKS PAGE
  Future insertWork(Event event) => into(events).insert(
        event.copyWith(pageType: Value(EventPageType.WORK_PAGE)),
        mode: InsertMode.insertOrReplace,
      );

  Stream<List<Event>> watchWorksByTypeAndStatus(WorkStatus workStatus, List<String> types) =>
      (select(events)
            ..where((t) =>
                t.pageType.equals(EventPageType.WORK_PAGE.name) &
                t.workStatus.equals(workStatus.name) & 
                t.dateLocal.equals(DateTime.now()) & 
                t.type.isIn(types))
            ..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.asc)]))
          .watch();

  Stream<List<Event>> watchWorksByStatus(WorkStatus workStatus) => (select(events)
        ..where((t) =>
            t.pageType.equals(EventPageType.WORK_PAGE.name) & 
            t.dateLocal.equals(DateTime.now()) & 
            t.workStatus.equals(workStatus.name))
        ..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.asc)]))
      .watch();

  Future deleteWorksByStatus(WorkStatus workStatus) => (delete(events)
        ..where((t) =>
            t.pageType.equals(EventPageType.WORK_PAGE.name) & t.workStatus.equals(workStatus.name)))
      .go();

  Future<int> countWorksByStatus(WorkStatus workStatus) => (select(events)
        ..where((t) =>
            t.pageType.equals(EventPageType.WORK_PAGE.name) & t.workStatus.equals(workStatus.name)))
      .get()
      .then((value) => value.length);
}
