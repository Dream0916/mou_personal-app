import 'package:drift/drift.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/databases/table/todos.dart';

part 'todo_dao.g.dart';

@DriftAccessor(tables: [Todos])
class TodoDao extends DatabaseAccessor<AppDatabase> with _$TodoDaoMixin {
  final AppDatabase db;

  TodoDao(this.db) : super(db);

  Future<List<Todo>> getAllTodos() => select(todos).get();

  Stream<List<Todo>> watchAllParentTodos(List<String> types) => (select(todos)
        ..where((t) => t.parentId.equals(0))
        ..where((t) => t.type.isIn(types))
        ..orderBy([(t) => OrderingTerm(expression: t.order, mode: OrderingMode.asc)]))
      .watch();

  Stream<List<Todo>> watchAllTodosByParentId(int parentId) => (select(todos)
        ..where((t) => t.parentId.equals(parentId))
        ..orderBy([(t) => OrderingTerm(expression: t.order, mode: OrderingMode.asc)]))
      .watch();

  Future<Todo?> getLocalTodoById(int todoId) =>
      (select(todos)..where((t) => t.id.equals(todoId))).getSingleOrNull();

  Stream<Todo?> watchTodoById(int todoId) =>
      (select(todos)..where((t) => t.id.equals(todoId))).watchSingle();

  // insert single
  Future insertTodo(Todo todo) => into(todos).insert(todo, mode: InsertMode.insertOrReplace);

  // insert list
  Future insertTodos(List<Todo> newTodos) async => await batch((batch) {
        batch.insertAll(todos, newTodos, mode: InsertMode.insertOrReplace);
      });

  Future updateTodo(Todo todo) => update(todos).replace(todo);

  Future deleteTodo(Todo todo) => delete(todos).delete(todo);

  Future deleteTodoById(int id) => (delete(todos)..where((e) => e.id.equals(id))).go();

  Future deleteAll() => delete(todos).go();
}
