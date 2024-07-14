import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/databases/dao/todo_dao.dart';
import 'package:mou_app/core/repositories/todo_repository.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/type/todo_type.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class TodosViewModel extends BaseViewModel {
  final TodoRepository todoRepository;
  final TodoDao todoDao;

  TodosViewModel(
    this.todoRepository,
    this.todoDao,
  );

  final filterMenuVisibleSubject = BehaviorSubject<bool>.seeded(false);
  final typesSubject = BehaviorSubject<List<TodoType>>.seeded(TodoType.values);

  Future<void> fetchTodos() async {
    setLoading(true);
    await todoRepository.getAllTodos();
    setLoading(false);
  }

  Stream<List<Todo>> watchAllParentTodos() => todoRepository.watchAllParentTodos(
      types: typesSubject.value.map((type) => type.name).toList());

  void onAddNew() {
    Navigator.pushNamed(context, Routers.ADD_TODO);
  }

  void onFilterButtonPressed() {
    filterMenuVisibleSubject.add(!filterMenuVisibleSubject.value);
  }

  void onFilterTypePressed(TodoType todoType) async {
    List<TodoType> selectedTypes = List.from(typesSubject.value);
    if (selectedTypes.contains(todoType)) {
      selectedTypes.remove(todoType);
    } else {
      selectedTypes.add(todoType);
    }
    typesSubject.add(selectedTypes);
    onFilterButtonPressed();
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
    await filterMenuVisibleSubject.drain();
    filterMenuVisibleSubject.close();
    await typesSubject.drain();
    typesSubject.close();
    super.dispose();
  }
}
