import 'package:mou_app/core/models/event_count.dart';
import 'package:mou_app/core/repositories/event_repository.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/utils/app_types/event_task_type.dart';
import 'package:rxdart/rxdart.dart';

class EventViewModel extends BaseViewModel {
  final indexSubject = BehaviorSubject<int>.seeded(0);
  final eventCountSubject = BehaviorSubject<EventCount>();

  final EventRepository _eventRepository;

  EventViewModel(this._eventRepository);

  fetchEventCount({List<EventTaskType> eventTypes = EventTaskType.values}) async {
    int tab = indexSubject.value + 1;
    final resource = await _eventRepository.getCountEvent(
      eventTypes: tab == 2 ? EventTaskType.values : eventTypes,
      tab: tab,
    );
    eventCountSubject.add(resource.data ?? EventCount());
  }

  void onTabChanged(int index) => indexSubject.add(index);

  @override
  void dispose() async {
    _eventRepository.cancel();
    await indexSubject.drain();
    indexSubject.close();
    await eventCountSubject.drain();
    eventCountSubject.close();
    super.dispose();
  }
}
