import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/databases/dao/todo_dao.dart';
import 'package:mou_app/core/models/list_response.dart';
import 'package:mou_app/core/network_bound_resource.dart';
import 'package:mou_app/core/requests/todo_request.dart';
import 'package:mou_app/core/resource.dart';
import 'package:mou_app/core/services/api_service.dart';

class TodoRepository {
  final TodoDao todoDao;

  TodoRepository(this.todoDao);

  CancelToken _cancelToken = CancelToken();

  Future<Resource<ListResponse<Todo>>> getAllTodos() async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<ListResponse<Todo>, ListResponse<Todo>>(
      createCall: () => APIService.getAllTodos(_cancelToken),
      parsedData: (json) => ListResponse<Todo>.fromJson(
        json,
        (element) => Todo.fromJson(element),
      ),
      saveCallResult: (response) async {
        await todoDao.deleteAll();
        List<Todo> todos = response.data ?? [];
        for (int i = 0; i < todos.length; i++) {
          await todoDao.insertTodo(todos[i].copyWith(order: Value(i + 1)));
        }
      },
    );
    return resource.getAsObservable();
  }

  Future<Resource<Todo>> createTodo(TodoRequest todoRequest) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<Todo, Todo>(
      createCall: () => APIService.createTodo(todoRequest, _cancelToken),
      parsedData: (json) => Todo.fromJson(json['data']),
      saveCallResult: (todo) async => await todoDao.insertTodo(todo),
    );
    return resource.getAsObservable();
  }

  Future<Resource<Todo>> updateTodo(TodoRequest todoRequest) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<Todo, Todo>(
      createCall: () => APIService.updateTodo(todoRequest, _cancelToken),
      parsedData: (json) => Todo.fromJson(json['data']),
      saveCallResult: (todo) async => await todoDao.insertTodo(todo),
    );
    return resource.getAsObservable();
  }

  Future<Resource<Todo>> getTodoDetail(int todoId) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    return NetworkBoundResource<Todo, Todo>(
      createCall: () => APIService.getTodoDetail(todoId, _cancelToken),
      parsedData: (json) => Todo.fromJson(json['data']),
      saveCallResult: (result) async {
        // keep current local order of todo
        Todo? todo = await todoDao.getLocalTodoById(todoId);
        await todoDao.insertTodo(result.copyWith(order: Value(todo?.order ?? 1)));
        List<Todo> childTodos = result.children?.map((e) => Todo.fromJson(e)).toList() ?? [];
        for (int i = 0; i < childTodos.length; i++) {
          await todoDao.insertTodo(childTodos[i].copyWith(order: Value(i + 1)));
        }
      },
    ).getAsObservable();
  }

  Future<Resource<dynamic>> completeTodo(int todoId) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    return NetworkBoundResource<dynamic, dynamic>(
      createCall: () => APIService.completeTodo(todoId, _cancelToken),
      parsedData: (json) => json,
      saveCallResult: (todo) async => await todoDao.deleteTodoById(todoId),
    ).getAsObservable();
  }

  Future<Resource<Todo>> overlineTodo(int todoId) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<Todo, Todo>(
      createCall: () => APIService.overlineTodo(todoId, _cancelToken),
      parsedData: (json) => Todo.fromJson(json['data']),
      saveCallResult: (todo) async {
        Todo? localTodo = await todoDao.getLocalTodoById(todoId);
        await todoDao.insertTodo(todo.copyWith(order: Value(localTodo?.order ?? 1)));
      },
    );
    return resource.getAsObservable();
  }

  Future<Resource<dynamic>> deleteTodo(int todoId) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<dynamic, dynamic>(
      createCall: () => APIService.deleteTodo(todoId, _cancelToken),
      parsedData: (json) => json,
      saveCallResult: (todo) async => await todoDao.deleteTodoById(todoId),
    );
    return resource.getAsObservable();
  }

  Future<Resource<dynamic>> orderTodo(List<Todo> newTodos) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();

    List<int> ids = newTodos.map((e) => e.id).toList();
    List<int> newOrders = newTodos.map((e) => newTodos.indexOf(e) + 1).toList();

    final resource = NetworkBoundResource<dynamic, dynamic>(
      createCall: () => APIService.orderTodo(
        ids,
        newOrders,
        _cancelToken,
      ),
      parsedData: (json) => json,
    );
    return resource.getAsObservable();
  }

  Stream<List<Todo>> watchAllParentTodos({
    List<String> types = const ["SINGLE", "GROUP"],
  }) =>
      todoDao.watchAllParentTodos(types);

  Stream<List<Todo>> watchAllTodosByParentId(int parenId) =>
      todoDao.watchAllTodosByParentId(parenId);

  Stream<Todo?> watchTodoById(int todoId) => todoDao.watchTodoById(todoId);

  cancel() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }
}
