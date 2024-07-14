import 'package:drift/drift.dart';
import 'package:mou_app/core/databases/converter/list_converter.dart';
import 'package:mou_app/core/databases/converter/map_converter.dart';

class Todos extends Table {
  IntColumn get id => integer()();

  TextColumn get type => text()();

  TextColumn get title => text()();

  TextColumn get creator => text().map(const MapConverter()).nullable()();

  TextColumn get users => text().map(const ListConverter()).nullable()();

  @JsonKey("done_time")
  TextColumn get doneTime => text().named("done_time").nullable()();

  @JsonKey("parent_Id")
  IntColumn get parentId => integer().withDefault(Constant(0))();

  IntColumn get order => integer().nullable()();

  TextColumn get children => text().map(const ListConverter()).nullable()();

  @JsonKey("created_at")
  TextColumn get createdAt => text().named("created_at").nullable()();

  @JsonKey("updated_at")
  TextColumn get updatedAt => text().named("updated_at").nullable()();

  @JsonKey("updated_by")
  TextColumn get updatedBy => text().named("updated_by").nullable()();

  BoolColumn get overline => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
