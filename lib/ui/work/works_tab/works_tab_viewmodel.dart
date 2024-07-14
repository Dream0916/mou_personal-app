import 'dart:async';

import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/models/list_response.dart';
import 'package:mou_app/core/repositories/event_repository.dart';
import 'package:mou_app/core/resource.dart';
import 'package:mou_app/ui/base/loadmore_viewmodel.dart';
import 'package:mou_app/utils/app_types/event_task_type.dart';
import 'package:mou_app/utils/app_types/work_status.dart';
import 'package:rxdart/rxdart.dart';

class WorkTabViewModel extends LoadMoreViewModel<Event> {
  final WorkStatus workStatus;
  final EventRepository eventRepository;

  WorkTabViewModel({
    required this.workStatus,
    required this.eventRepository,
  });

  final filterMenuVisibleSubject = BehaviorSubject<bool>.seeded(false);
  final unselectedFiltersSubject = BehaviorSubject<List<EventTaskType>>.seeded([]);
  StreamSubscription? _observeFilterModeSubscription;

  List<EventTaskType> get selectedFilters => EventTaskType.workPageTypes
      .where((e) => !unselectedFiltersSubject.value.contains(e))
      .toList();

  @override
  Future<Resource<ListResponse>> onSyncResource(int page) async {
    return eventRepository.getWorks(
      page: page,
      workStatus: workStatus,
      types: selectedFilters.length == EventTaskType.workPageTypes.length ? [] : selectedFilters,
    );
  }

  onInit() {
    _observeFilterModeSubscription = unselectedFiltersSubject.listen((unselectedModes) {
      filterMenuVisibleSubject.add(false);
      onRefresh();
    });
  }

  void onFilterButtonPressed() {
    if (!filterMenuVisibleSubject.value) {
      filterMenuVisibleSubject.add(true);
    }
  }

  void onFilterModePressed(EventTaskType eventTaskType) async {
    final unselectedFilters = unselectedFiltersSubject.value;
    if (unselectedFilters.contains(eventTaskType)) {
      unselectedFilters.remove(eventTaskType);
    } else {
      unselectedFilters.add(eventTaskType);
    }
    unselectedFiltersSubject.add(unselectedFilters);
  }

  @override
  void dispose() async {
    eventRepository.cancel();
    await filterMenuVisibleSubject.drain();
    filterMenuVisibleSubject.close();
    await unselectedFiltersSubject.drain();
    unselectedFiltersSubject.close();
    _observeFilterModeSubscription?.cancel();
    super.dispose();
  }
}
