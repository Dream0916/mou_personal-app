import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/databases/dao/contact_dao.dart';
import 'package:mou_app/core/databases/dao/corp_dao.dart';
import 'package:mou_app/core/databases/dao/event_check_dao.dart';
import 'package:mou_app/core/databases/dao/event_dao.dart';
import 'package:mou_app/core/databases/dao/notification_dao.dart';
import 'package:mou_app/core/databases/dao/todo_dao.dart';
import 'package:mou_app/core/repositories/auth_repository.dart';
import 'package:mou_app/core/repositories/contact_repository.dart';
import 'package:mou_app/core/repositories/corp_repository.dart';
import 'package:mou_app/core/repositories/event_repository.dart';
import 'package:mou_app/core/repositories/notification_repository.dart';
import 'package:mou_app/core/repositories/project_repository.dart';
import 'package:mou_app/core/repositories/todo_repository.dart';
import 'package:mou_app/core/repositories/user_repository.dart';
import 'package:mou_app/core/services/firebase_service.dart';
import 'package:mou_app/core/services/wifi_service.dart';
import 'package:mou_app/helpers/permissions_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [...independentServices, ...dependentServices];

List<SingleChildWidget> independentServices = [
  Provider.value(value: AppDatabase.instance()),
  Provider.value(value: AuthRepository()),
  Provider.value(value: UserRepository()),
  Provider.value(value: ProjectRepository()),
  Provider.value(value: FirebaseService()),
  Provider.value(value: WifiService()),
  Provider.value(value: PermissionsService()),
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<AppDatabase, EventDao>(update: (context, database, dao) => database.eventDao),
  ProxyProvider<AppDatabase, EventCheckDao>(update: (_, database, __) => database.eventCheckDao),
  ProxyProvider<AppDatabase, ContactDao>(update: (context, database, dao) => database.contactDao),
  ProxyProvider<AppDatabase, CorpDao>(update: (context, database, dao) => database.corpDao),
  ProxyProvider<AppDatabase, TodoDao>(update: (context, database, dao) => database.todoDao),
  ProxyProvider<AppDatabase, NotificationDao>(
    update: (_, database, __) => database.notificationDao,
  ),
  ProxyProvider2<EventDao, EventCheckDao, EventRepository>(
    update: (context, eventDao, eventCheckDao, repository) =>
        EventRepository(eventDao, eventCheckDao),
  ),
  ProxyProvider<ContactDao, ContactRepository>(
    update: (context, contactDao, repository) => ContactRepository(contactDao),
  ),
  ProxyProvider<CorpDao, CorpRepository>(
    update: (context, corpDao, repository) => CorpRepository(corpDao),
  ),
  ProxyProvider<TodoDao, TodoRepository>(
    update: (context, todoDao, repository) => TodoRepository(todoDao),
  ),
  ProxyProvider<NotificationDao, NotificationRepository>(
    update: (context, dao, repository) => NotificationRepository(dao),
  ),
];
