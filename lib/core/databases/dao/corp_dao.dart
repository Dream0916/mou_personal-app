import 'package:drift/drift.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/databases/table/corps.dart';

part 'corp_dao.g.dart';

@DriftAccessor(tables: [Corps])
class CorpDao extends DatabaseAccessor<AppDatabase> with _$CorpDaoMixin {
  final AppDatabase db;

  CorpDao(this.db) : super(db);

  Stream<List<Corp>> watchAllCorps() => select(corps).watch();

  Future<Corp?> getCorpByID(int id) =>
      (select(corps)..where((t) => t.id.equals(id))).getSingle();

  Future insertCorp(Corp corp) =>
      into(corps).insert(corp, mode: InsertMode.insertOrReplace);

  Future updateCorp(Corp corp) => update(corps).replace(corp);

  Future deleteCorp(Corp corp) => delete(corps).delete(corp);

  Future deleteCorpById(int id) =>
      (delete(corps)..where((e) => e.id.equals(id))).go();

  Future deleteAll() => delete(corps).go();
}
