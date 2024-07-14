import 'package:drift/drift.dart';

class Corps extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text().nullable()();

  TextColumn get logo => text().nullable()();

  @JsonKey("role_name")
  TextColumn get roleName => text().named("role_name").nullable()();

  @JsonKey("confirmed")
  BoolColumn get confirmed => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
