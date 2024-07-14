import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class NewContactViewModel extends BaseViewModel {
  NewContactViewModel();

  final isSwitchOffStream = BehaviorSubject<bool>();

  @override
  void dispose() async {
    await isSwitchOffStream.drain();
    isSwitchOffStream.close();
    super.dispose();
  }
}
