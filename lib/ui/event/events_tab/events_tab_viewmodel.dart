import 'dart:async';

import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/models/list_response.dart';
import 'package:mou_app/core/repositories/event_repository.dart';
import 'package:mou_app/core/resource.dart';
import 'package:mou_app/ui/base/loadmore_viewmodel.dart';
import 'package:mou_app/utils/app_types/event_status.dart';
import 'package:mou_app/utils/app_types/event_task_type.dart';
import 'package:rxdart/rxdart.dart';

class EventsTabViewModel extends LoadMoreViewModel<Event> {
  final EventRepository _repository;
  final EventStatus status;
  final void Function(List<EventTaskType> eventTypes) onRefreshParent;

  final filterMenuVisibleSubject = BehaviorSubject<bool>.seeded(false);
  final unselectedFiltersSubject = BehaviorSubject<List<EventTaskType>>.seeded([]);
  StreamSubscription? _observeFilterModeSubscription;

  List<EventTaskType> get selectedFilters =>
      EventTaskType.values.where((e) => !unselectedFiltersSubject.value.contains(e)).toList();

  EventsTabViewModel(
    this._repository,
    this.status,
    this.onRefreshParent,
  );

  @override
  Future<Resource<ListResponse>> onSyncResource(int page) {
    return _repository.getEventsByTypes(
      status,
      page,
      eventTypes: selectedFilters,
    );
  }

  onInit() {
    if (status == EventStatus.WAITING) {
      unselectedFiltersSubject
          .add(EventTaskType.values.where((e) => e != EventTaskType.EVENT).toList());
    }
    _observeFilterModeSubscription = unselectedFiltersSubject.listen((unselectedModes) {
      filterMenuVisibleSubject.add(false);
      onRefreshParent.call(selectedFilters);
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
    _repository.cancel();
    await filterMenuVisibleSubject.drain();
    filterMenuVisibleSubject.close();
    await unselectedFiltersSubject.drain();
    unselectedFiltersSubject.close();
    _observeFilterModeSubscription?.cancel();
    super.dispose();
  }
}
