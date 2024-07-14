class NotificationCenterHelper {
  static NotificationCenterHelper? _instance;

  static Function? _onChange;

  NotificationCenterHelper();

  factory NotificationCenterHelper.getInstance() {
    if (_instance == null) _instance = NotificationCenterHelper();
    return _instance!;
  }

  registerFuncOnChanged(Function onChange) {
    _onChange = onChange;
  }

  executeFuncOnChanged() {
    if (_onChange != null) _onChange!();
  }
}
