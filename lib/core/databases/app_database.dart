import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:mou_app/core/databases/dao/contact_dao.dart';
import 'package:mou_app/core/databases/dao/corp_dao.dart';
import 'package:mou_app/core/databases/dao/event_check_dao.dart';
import 'package:mou_app/core/databases/dao/notification_dao.dart';
import 'package:mou_app/core/databases/dao/todo_dao.dart';
import 'package:mou_app/core/databases/table/contacts.dart';
import 'package:mou_app/core/databases/table/corps.dart';
import 'package:mou_app/core/databases/table/event_checks.dart';
import 'package:mou_app/core/databases/table/notifications.dart';
import 'package:mou_app/core/databases/table/todos.dart';
import 'package:mou_app/utils/app_types/event_page_type.dart';
import 'package:mou_app/utils/app_types/event_status.dart';
import 'package:mou_app/utils/app_types/event_task_type.dart';
import 'package:mou_app/utils/app_types/work_status.dart';

import 'converter/list_converter.dart';
import 'converter/map_converter.dart';
import 'dao/event_dao.dart';
import 'table/events.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Events, Contacts, EventChecks, Corps, Todos, Notifications],
  daos: [EventDao, ContactDao, EventCheckDao, CorpDao, TodoDao, NotificationDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(SqfliteQueryExecutor.inDatabaseFolder(path: "mou_v1.1.0.sqlite"));
  static AppDatabase? _instance;

  static AppDatabase? instance() {
    if (_instance == null) _instance = AppDatabase();
    return _instance;
  }

  @override
  int get schemaVersion => 15;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (Migrator migrator, int from, int to) async {
        for (final table in allTables) {
          await migrator.deleteTable(table.actualTableName);
          await migrator.createTable(table);
        }
      },
    );
  }

  static Future<void> clearData() async {
    // await _instance?.eventCheckDao.deleteAll();
    // await _instance?.eventDao.deleteAll();
    // await _instance?.contactDao.deleteAll();
    // await _instance?.corpDao.deleteAll();
    // await _instance?.todoDao.deleteAll();
  }
}
