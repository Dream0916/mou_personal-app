import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/models/creator.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/todo_detail/todo_detail_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_content.dart';
import 'package:mou_app/ui/widgets/app_loading.dart';
import 'package:mou_app/ui/widgets/menu/app_menu_bar.dart';
import 'package:mou_app/ui/widgets/todo/todo_header.dart';
import 'package:mou_app/ui/widgets/todo/todo_single_item.dart';
import 'package:mou_app/ui/widgets/widget_image_network.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_styles.dart';
import 'package:mou_app/utils/app_utils.dart';
import 'package:provider/provider.dart';

const double avatarHeight = 38;
const double avatarWidth = 61;
const double spacer = 10;

class TodoDetailPage extends StatefulWidget {
  final int todoId;

  const TodoDetailPage({super.key, required this.todoId});

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  List<Todo> todos = [];
  bool justReordered = false; // This variable to check if list todos was just reordered

  void reset() {
    if (justReordered) {
      setState(() {
        justReordered = false;
      });
    }
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          elevation: 0,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<TodoDetailViewModel>(
      viewModel: TodoDetailViewModel(
        todoId: widget.todoId,
        todoRepository: Provider.of(context),
        todoDao: Provider.of(context),
      ),
      onViewModelReady: (viewModel) => viewModel..fetchTodoDetail(),
      builder: (context, viewModel, child) {
        return StreamBuilder<Todo?>(
          stream: viewModel.watchTodoById(),
          builder: (_, todoSnapshot) {
            Todo? parentTodo = todoSnapshot.data;
            final String dateTimeString = parentTodo?.updatedAt ?? parentTodo?.createdAt ?? '';
            final DateTime dateTime =
                AppUtils.convertStringToDateTime(dateTimeString)?.toLocal() ?? DateTime.now();
            final String updatedAt = DateFormat('dd/MM/yy HH:mm').format(dateTime);

            Creator? creator =
                parentTodo?.creator != null ? Creator.fromJson(parentTodo!.creator!) : null;
            List<Contact> users = parentTodo?.users?.map((e) => Contact.fromJson(e)).toList() ?? [];
            List<Contact> displayedUsers =
                users.where((e) => e.avatar != null && e.userContactId != null).toList();
            String updatedBy = parentTodo?.updatedBy ?? creator?.name ?? '';

            return Scaffold(
              backgroundColor: AppColors.bgColor,
              body: AppContent(
                menuBarBuilder: (stream) => AppMenuBar(tabObserveStream: stream),
                headerBuilder: (hasInternet) => TodoHeader(
                  onAddTotoPressed: () {
                    reset();
                    viewModel.onAddNew(parentTodo);
                  },
                  hasInternet: hasInternet,
                  title: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppColors.mainColor,
                        AppColors.colorGradient2,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    child: Text(
                      parentTodo?.title ?? '',
                      style: AppStyles.heading7Style.copyWith(
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    constraints: const BoxConstraints(maxWidth: 30),
                    icon: Image.asset(
                      AppImages.icArrowRight,
                      width: 12,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // add this gap to center title
                  action: const SizedBox(width: 30),
                ),
                childBuilder: (hasInternet) => StreamBuilder<bool>(
                  stream: viewModel.loadingSubject,
                  builder: (context, snapshot) {
                    bool isLoading = snapshot.data ?? true;
                    return isLoading
                        ? const AppLoadingIndicator()
                        : StreamBuilder<List<Todo>>(
                            stream: viewModel.watchAllTodosByParentId(),
                            builder: (_, todoSnapshot) {
                              List<Todo> localTodos =
                                  justReordered ? todos : (todoSnapshot.data ?? []);
                              int avatarLength =
                                  displayedUsers.length + (creator?.avatar != null ? 1 : 0);

                              return RefreshIndicator(
                                color: AppColors.mainColor,
                                backgroundColor: Colors.white,
                                onRefresh: viewModel.fetchTodoDetail,
                                child: localTodos.isNotEmpty
                                    ? ReorderableListView(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        padding: const EdgeInsets.fromLTRB(20, 10, 22, 0),
                                        proxyDecorator: proxyDecorator,
                                        header: Container(
                                          height: avatarHeight,
                                          margin: const EdgeInsets.only(top: 1, bottom: 17),
                                          child: ListView.separated(
                                            physics: const BouncingScrollPhysics(),
                                            padding: EdgeInsets.only(
                                                left: (MediaQuery.of(context).size.width -
                                                            (avatarLength * avatarWidth +
                                                                (avatarLength - 1) * spacer)) /
                                                        2 -
                                                    22),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: avatarLength,
                                            separatorBuilder: (context, index) =>
                                                const SizedBox(width: spacer),
                                            itemBuilder: (context, index) {
                                              String? avatar;
                                              if (creator?.avatar != null) {
                                                avatar = index == 0
                                                    ? creator!.avatar
                                                    : displayedUsers[index - 1].avatar;
                                              } else {
                                                avatar = displayedUsers[index].avatar;
                                              }
                                              return avatar != null
                                                  ? WidgetImageNetwork(
                                                      url: avatar,
                                                      height: avatarHeight,
                                                      width: avatarWidth,
                                                    )
                                                  : const SizedBox();
                                            },
                                          ),
                                        ),
                                        footer: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 24),
                                            child: Text(
                                              'Last updated by $updatedBy on $updatedAt',
                                              style: AppStyles.bodyStyle.copyWith(
                                                color: const Color(0xFF969493),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        onReorder: (int oldIndex, int newIndex) {
                                          if (!hasInternet) return;
                                          setState(() {
                                            if (newIndex > oldIndex) {
                                              newIndex -= 1;
                                            }
                                            final item = localTodos.removeAt(oldIndex);
                                            localTodos.insert(newIndex, item);
                                            todos = localTodos;
                                            justReordered = true;
                                          });
                                          viewModel.orderTodo(localTodos);
                                        },
                                        children: List.generate(localTodos.length, (index) {
                                          Todo todo = localTodos[index];

                                          return Padding(
                                            key: ValueKey(todo.id),
                                            padding: const EdgeInsets.only(bottom: 20),
                                            child: TodoSingleItem(
                                              todo: todo,
                                              todoRepository: Provider.of(context),
                                              showSnackBar: viewModel.showSnackBar,
                                              hasInternet: hasInternet,
                                              onCallback: reset,
                                            ),
                                          );
                                        }),
                                      )
                                    : Center(
                                        child: Text(
                                          allTranslations.text(AppLanguages.nothingHere),
                                          style: TextStyle(
                                            fontSize: AppFontSize.textQuestion,
                                            color: AppColors.mainColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                              );
                            },
                          );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
