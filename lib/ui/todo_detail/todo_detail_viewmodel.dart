import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/databases/dao/todo_dao.dart';
import 'package:mou_app/core/repositories/todo_repository.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/ui/add_toto/add_todo_page.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';

class TodoDetailViewModel extends BaseViewModel {
  final int todoId;
  final TodoRepository todoRepository;
  final TodoDao todoDao;

  TodoDetailViewModel({
    required this.todoId,
    required this.todoRepository,
    required this.todoDao,
  });

  Future<void> fetchTodoDetail() async {
    setLoading(true);
    await todoRepository.getTodoDetail(todoId);
    setLoading(false);
  }

  // to watch child todos
  Stream<List<Todo>> watchAllTodosByParentId() => todoRepository.watchAllTodosByParentId(todoId);

  // to watch latest update of parent todo
  Stream<Todo?> watchTodoById() => todoRepository.watchTodoById(todoId);

  void onAddNew(Todo? todo) {
    if (todo == null) return;
    Navigator.pushNamed(
      context,
      Routers.ADD_TODO,
      arguments: AddTodoArgs(todo: todo),
    ).then((_) => fetchTodoDetail());
  }

  // newTodos: list todos after reorder, newOrders: list order of all item in newTodos
  Future<void> orderTodo(List<Todo> newTodos) async {
    List<Todo> sortedTodos = [];
    for (Todo todo in newTodos) {
      sortedTodos.add(todo.copyWith(order: Value(newTodos.indexOf(todo) + 1)));
    }
    await todoDao.insertTodos(sortedTodos);
    await todoRepository.orderTodo(newTodos);
  }

  @override
  void dispose() async {
    todoRepository.cancel();
    super.dispose();
  }
}
