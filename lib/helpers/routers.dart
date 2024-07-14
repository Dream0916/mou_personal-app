import 'package:flutter/material.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/requests/change_phone_request.dart';
import 'package:mou_app/ui/add_contact/add_contact_page.dart';
import 'package:mou_app/ui/add_event/add_event_page.dart';
import 'package:mou_app/ui/add_toto/add_todo_page.dart';
import 'package:mou_app/ui/change_number/change_number_page.dart';
import 'package:mou_app/ui/contacts/contacts_page.dart';
import 'package:mou_app/ui/corp/corp_page.dart';
import 'package:mou_app/ui/edit_profile/edit_profile_page.dart';
import 'package:mou_app/ui/event/event_page.dart';
import 'package:mou_app/ui/feedback/feedback_page.dart';
import 'package:mou_app/ui/home/home_page.dart';
import 'package:mou_app/ui/import_contact_device/import_contact_device_page.dart';
import 'package:mou_app/ui/login/login_page.dart';
import 'package:mou_app/ui/month_calendar/month_calendar_page.dart';
import 'package:mou_app/ui/onboarding_slides/onboarding_slides_page.dart';
import 'package:mou_app/ui/project_detail/project_detail_page.dart';
import 'package:mou_app/ui/register_profile/register_profile_page.dart';
import 'package:mou_app/ui/send_email/send_email_page.dart';
import 'package:mou_app/ui/setting/setting_page.dart';
import 'package:mou_app/ui/todo_detail/todo_detail_page.dart';
import 'package:mou_app/ui/todos/todos_page.dart';
import 'package:mou_app/ui/work/work_page.dart';

class Routers {
  static const String ROOT = "/";
  static const String SPLASH = "/splash";
  static const String LOGIN = "/login";
  static const String VERIFY_CODE = "/verifyCode";
  static const String REGISTER_PROFILE = "/update_profile";
  static const String EDIT_PROFILE = "/edit_profile";
  static const String HOME = "/home";
  static const String MONTH_CALENDAR = "/month_calendar";
  static const String EVENT = "/event";
  static const String SETTING = "/setting";
  static const String ADD_EVENT = "/add_event";
  static const String ADD_CONTACT = "/add_contact";
  static const String EDIT_CONTACT = "/edit_contact";
  static const String FEEDBACK = "/feedback";
  static const String IMPORT_CONTACT_DEVICE = "/import_contact_device";
  static const String CORP = "/corp";
  static const String PROJECT_DETAIL = "/project_detail";
  static const String SEND_EMAIL = "/send-email";
  static const String CHANGE_NUMBER = "/change_number";
  static const String ONBOARDING = "/onboarding";
  static const String CONTACTS = "/contacts";
  static const String WORK = "/work";
  static const String TODOS = "/todos";
  static const String TODO_DETAIL = "/todo_detail";
  static const String ADD_TODO = "/add_todo";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var arguments = settings.arguments;
    switch (settings.name) {
      case HOME:
        DateTime? selectedDay;
        if (arguments is DateTime) {
          selectedDay = arguments;
        } else if (arguments is String) {
          selectedDay = DateTime.tryParse("$arguments");
        }
        return _animRoute(HomePage(selectedDay: selectedDay));
      case MONTH_CALENDAR:
        return _animRoute(MonthCalendarPage(selectedDay: arguments as DateTime));
      case LOGIN:
        return _animRoute(LoginPage(message: arguments as Map<String, dynamic>?));
      case EVENT:
        final int index = arguments is int ? arguments : int.tryParse('${arguments ?? '0'}') ?? 0;
        return _animRoute(EventPage(index: index));
      case SETTING:
        final String routeName = arguments is String ? arguments : '';
        return _animRoute(SettingPage(routeName: routeName));
      case ADD_CONTACT:
        return _animRoute(AddContactPage(), beginOffset: top);
      case FEEDBACK:
        return _animRoute(FeedbackPage(), beginOffset: top);
      case EDIT_PROFILE:
        return _animRoute(EditProfilePage(), beginOffset: top);
      case REGISTER_PROFILE:
        if (arguments is RegisterProfileArguments) {
          return _animRoute(RegisterProfilePage(arguments: arguments));
        } else {
          throw 'RegisterProfileArguments not found';
        }
      case ADD_EVENT:
        var event = arguments as Event?;
        return _animRoute(AddEventPage(event: event));
      case IMPORT_CONTACT_DEVICE:
        var isRegister = arguments as bool? ?? false;
        return _animRoute(ImportContactDevicePage(isRegister: isRegister));
      case CORP:
        return _animRoute(CorpPage());
      case PROJECT_DETAIL:
        return _animRoute(ProjectDetailPage(argument: arguments as ProjectDetailArgument));
      case SEND_EMAIL:
        return _animRoute(SendEmailPage());
      case CHANGE_NUMBER:
        return _animRoute(ChangeNumberPage(request: arguments as ChangeNumberRequest));
      case ONBOARDING:
        return _animRoute(OnboardingSlidesPage());
      case CONTACTS:
        final List<Contact> contacts = arguments is List<Contact> ? arguments : [];
        return _animRoute(ContactsPage(contactsSelected: contacts));
      case WORK:
        return _animRoute(WorkPage());
      case TODOS:
        return _animRoute(TodosPage());
      case ADD_TODO:
        return _animRoute(AddTodoPage(args: arguments as AddTodoArgs?));
      case TODO_DETAIL:
        int todoId = arguments is Todo ? arguments.id : int.tryParse('${arguments ?? '0'}') ?? 0;
        return _animRoute(TodoDetailPage(todoId: todoId));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Route _animRoute(Widget page, {Offset? beginOffset}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = beginOffset ?? Offset(0.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static Offset center = Offset(0.0, 0.0);
  static Offset top = Offset(0.0, 1.0);
  static Offset bottom = Offset(0.0, -1.0);
  static Offset left = Offset(-1.0, 0.0);
  static Offset right = Offset(1.0, 0.0);
}
