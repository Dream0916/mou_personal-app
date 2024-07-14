class PushNotifyRequest {
  PushNotifyRequest({
    this.title,
    this.message,
    this.notifyType,
  });

  String? title;
  String? message;
  String? notifyType;

  PushNotifyRequest copyWith({
    String? title,
    String? message,
    String? notifyType,
  }) =>
      PushNotifyRequest(
        title: title ?? this.title,
        message: message ?? this.message,
        notifyType: notifyType ?? this.notifyType,
      );

  factory PushNotifyRequest.fromJson(Map<String, dynamic> json) =>
      PushNotifyRequest(
        title: json["title"],
        message: json["message"],
        notifyType: json["notify_type"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        "notify_type": notifyType,
      };
}
