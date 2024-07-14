class EventCount {
  int? forYouToConfirm;
  int? waitingToConfirm;
  int? confirmed;

  EventCount({this.forYouToConfirm, this.waitingToConfirm, this.confirmed});

  EventCount.fromJson(Map<String, dynamic> json) {
    this.forYouToConfirm = json['for_you_to_confirm'];
    this.waitingToConfirm = json['waiting_to_confirm'];
    this.confirmed = json['confirmed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['for_you_to_confirm'] = this.forYouToConfirm;
    data['waiting_to_confirm'] = this.waitingToConfirm;
    data['confirmed'] = this.confirmed;
    return data;
  }
}
