import 'package:flutter/material.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/models/creator.dart';
import 'package:mou_app/core/repositories/todo_repository.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/ui/add_toto/add_todo_page.dart';
import 'package:mou_app/ui/widgets/slidable/app_slidable.dart';
import 'package:mou_app/ui/widgets/widget_image_network.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_types/slidable_action_type.dart';

class TodoGroupItem extends StatelessWidget {
  final Todo todo;
  final TodoRepository todoRepository;
  final void Function(String message, {bool isError})? showSnackBar;
  final bool hasInternet;
  final VoidCallback? onCallback;

  const TodoGroupItem({
    super.key,
    required this.todo,
    required this.todoRepository,
    this.showSnackBar,
    this.hasInternet = true,
    this.onCallback,
  });

  void _onEdit(BuildContext context) {
    onCallback?.call();
    Navigator.pushNamed(
      context,
      Routers.ADD_TODO,
      arguments: AddTodoArgs(
        todo: todo,
        isEdit: true,
      ),
    );
  }

  Future<void> _onDelete() async {
    var response = await todoRepository.deleteTodo(todo.id);
    if (response.isSuccess) {
      onCallback?.call();
      if (todo.parentId != 0) {
        await todoRepository.getTodoDetail(todo.parentId);
      }
    } else {
      showSnackBar?.call(response.message ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    Creator? creator = todo.creator != null ? Creator.fromJson(todo.creator!) : null;
    List<Contact> users = todo.users?.map((e) => Contact.fromJson(e)).toList() ?? [];

    return AppSlidable<SlidableActionType>(
      key: ValueKey(todo.id),
      enabled: hasInternet,
      actions: [
        SlidableActionType.EDIT,
        SlidableActionType.DELETE,
      ],
      onActionPressed: (type) {
        return switch (type) {
          SlidableActionType.EXPORT => null,
          SlidableActionType.EDIT => _onEdit(context),
          SlidableActionType.DELETE => _onDelete(),
          SlidableActionType.ACCEPT => null,
          SlidableActionType.DENY => null,
        };
      },
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routers.TODO_DETAIL,
          arguments: todo,
        ),
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 13, 4, 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                todo.title,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.mainColor,
                ),
              ),
              if (users.isNotEmpty)
                Container(
                  height: 31,
                  margin: const EdgeInsets.only(top: 12),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length + (creator?.avatar != null ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      String? avatar;
                      int? userContactId;
                      if (creator?.avatar != null) {
                        avatar = index == 0 ? creator!.avatar : users[index - 1].avatar;
                        userContactId = index == 0 ? creator!.id : users[index - 1].userContactId;
                      } else {
                        avatar = users[index].avatar;
                        userContactId = users[index].userContactId;
                      }
                      return avatar != null && userContactId != null
                          ? WidgetImageNetwork(url: avatar)
                          : const SizedBox();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
