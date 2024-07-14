class AppApis {
  static const String domainAPI = "http://api.mou.center";

  static const String domainFacebook = "https://graph.facebook.com/v6.0";
  static const String domainGoogle = "https://www.googleapis.com/gmail/v1";
  static const String domainGoogleMaps = "https://maps.googleapis.com/maps";

  static String staticMapUrl() =>
      "$domainGoogleMaps/api/staticmap?center=%1,%2&zoom=16&size=600x400&markers=color:red%7Clabel:C%7C%1,%2&key=%3";

  static String register() => "/api/v1/register";

  static String me() => "/api/v1/me";

  static String existPhone() => "/api/v1/exist-phone";

  static String getContacts() => "/api/v1/contacts?is_personal=1";

  static String getEventsByDate(
    String date,
    int page, {
    String userType = 'personal',
  }) =>
      "/api/v1/event/date?start_date=$date&page=$page&user_type=$userType";

  static String checkEventDateOfMonth(
    String startDate,
    String endDate, {
    String type = 'personal',
  }) =>
      "/api/v1/event/month?type=$type&start_date=$startDate&end_date=$endDate";

  static String getCountEvent({
    List<String>? eventTypes,
    String userType = 'personal',
    int tab = 1,
  }) {
    String baseUrl = "/api/v1/event/status/count?user_type=$userType&tab=$tab";
    return eventTypes != null ? baseUrl + eventTypes.map((e) => '&type[]=$e').join() : baseUrl;
  }

  static String getEventsByConfirm(
    int page, {
    List<String>? eventTypes,
    String userType = 'personal',
  }) {
    final baseUrl = "/api/v1/event/status/for-you-to-confirm?page=$page&user_type=$userType";
    return eventTypes != null ? baseUrl + eventTypes.map((e) => '&type[]=$e').join() : baseUrl;
  }

  static String getEventsByWaiting(
    int page, {
    List<String>? eventTypes,
    String userType = 'personal',
  }) {
    final baseUrl = "/api/v1/event/status/waiting-to-confirm?page=$page&user_type=$userType";
    return eventTypes != null ? baseUrl + eventTypes.map((e) => '&type[]=$e').join() : baseUrl;
  }

  static String getEventsByConfirmed(
    int page, {
    List<String>? eventTypes,
    String userType = 'personal',
  }) {
    final baseUrl = "/api/v1/event/status/confirmed?page=$page&user_type=$userType";
    return eventTypes != null ? baseUrl + eventTypes.map((e) => '&type[]=$e').join() : baseUrl;
  }

  static String createEvent() => "/api/v1/event";

  static String updateEvent(int id) => "/api/v1/event/$id/update";

  static String deleteEvent(int id) => "/api/v1/event/$id";

  static String confirmEvent(int id) => "/api/v1/event/$id/confirm";

  static String denyEvent(int id) => "/api/v1/event/$id/deny";

  static String leaveEvent(int id) => "/api/v1/event/$id/leave";

  static String acceptRoster(int id) => "/api/v1/personal/rosters/$id/accept";

  static String declineRoster(int id) => "/api/v1/personal/rosters/$id/decline";

  static String deleteRoster(int id) => "/api/v1/business/rosters/$id/delete";

  static String searchUsers(String search) => "/api/v1/user/search?q=$search";

  static String linkContact(int id) => "/api/v1/contacts/$id/link";

  static String addContact() => "/api/v1/contacts";

  static String editContact(int id) => "/api/v1/contacts/$id/edit";

  static String deleteContact(int id) => "/api/v1/contacts/$id";

  static String updateProfile() => "/api/v1/me/profile";

  static String updateAvatar() => "/api/v1/me/avatar";

  static String importContact() => "/api/v1/contacts/import-contacts";

  static String updateSetting() => "/api/v1/me/setting";

  static String connectContactFacebook() => "/api/v1/facebook/connect";

  static String importContactFacebook() => "/api/v1/facebook/import";

  static String getFacebookProfile(String token) => "/me?fields=id,name&access_token=$token";

  static String getFacebookFriends(String token) =>
      "/me/friends?fields=id,name&access_token=$token";

  static String sendFeedBack() => "/api/v1/feedback";

  static String getEventAlarmDevice() => "/api/v1/event/alarm-device";

  static String getUpdateFCMToken() => "/api/v1/me/fcm-token";

  static String getDeleteFCMToken(String token) => "/api/v1/me/fcm-token/$token";

  static String deleteAccount() => "/api/v1/user/destroy";

  static String getCorpInvited(int page) => "/api/v1/business/personal/company-invite?page=$page";

  static String acceptCorpInvitation(int corpId) =>
      "/api/v1/business/personal/company-invite/$corpId/accept";

  static String denyCorpInvitation(int corpId) =>
      "/api/v1/business/personal/company-invite/$corpId/deny";

  static String doneTask(int taskId) => "/api/v1/business/personal/event-task/$taskId/done";

  static String getProjectDetail(int projectId) => "/api/v1/business/personal/project/$projectId";

  static String getGoogleMapLinkOpen(String lat, String lon) =>
      "https://www.google.com/maps/search/?api=1&query=$lat,$lon";

  static String exportReport(int eventId) => "/exports/report/project-task/$eventId";

  static String sendSMS() => "/api/v1/event/send-sms";

  static String pushNotify() => "/api/v1/send-notify";

  static String sendEmail() => "/api/v1/change-phone/send-mail";

  static String changePhone() => "/api/v1/change-phone";

  static String getNotifications({
    String type = 'personal',
    int page = 1,
    int limit = 10,
  }) =>
      "/api/v1/notifications?type=$type&page=$page&limit=$limit";

  static String countNotifications({String type = 'personal'}) =>
      "/api/v1/notifications/count?type=$type";

  static String getAllTodos() => "/api/v1/todo";
  static String createTodo() => "/api/v1/todo";
  static String updateTodo(int todoId) => "/api/v1/todo/$todoId";
  static String getTodoDetail(int todoId) => "/api/v1/todo/$todoId";
  static String completeTodo(int todoId) => "/api/v1/todo/$todoId/completed";
  static String overlineTodo(int todoId) => "/api/v1/todo/$todoId/overline";
  static String deleteTodo(int todoId) => "/api/v1/todo/$todoId";
  static String orderTodo() => "/api/v1/todo/order";

  static String getWorkData({
    int page = 1,
    required String status, // open/progress/done
    List<String> types = const [], // TASK/PROJECT_TASK/ROSTER
  }) =>
      "/api/v1/personal/general?page=$page&status=$status${types.map((e) => '&type[]=$e').join()}";
}
