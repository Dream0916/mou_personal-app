class TodoRequest {
  final int? todoId;
  final String title;
  final String type;
  final int parentId;
  final List<int> contactIds;

  TodoRequest({
    this.todoId,
    this.title = '',
    this.type = 'SINGLE',
    this.parentId = 0,
    this.contactIds = const <int>[],
  });
}
