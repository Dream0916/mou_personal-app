import 'package:flutter/material.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/type/todo_type.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/todos/todos_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_content.dart';
import 'package:mou_app/ui/widgets/app_loading.dart';
import 'package:mou_app/ui/widgets/filters/filter_button.dart';
import 'package:mou_app/ui/widgets/filters/filter_button_content.dart';
import 'package:mou_app/ui/widgets/menu/app_menu_bar.dart';
import 'package:mou_app/ui/widgets/todo/todo_group_item.dart';
import 'package:mou_app/ui/widgets/todo/todo_header.dart';
import 'package:mou_app/ui/widgets/todo/todo_single_item.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:provider/provider.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
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
    return BaseWidget<TodosViewModel>(
      viewModel: TodosViewModel(Provider.of(context), Provider.of(context)),
      onViewModelReady: (viewModel) => viewModel..fetchTodos(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: AppContent(
            menuBarBuilder: (stream) => AppMenuBar(tabObserveStream: stream),
            headerBuilder: (hasInternet) => TodoHeader(
              onAddTotoPressed: () {
                reset();
                viewModel.onAddNew();
              },
              hasInternet: hasInternet,
            ),
            childBuilder: (hasInternet) => GestureDetector(
              onTap: () {
                if (viewModel.filterMenuVisibleSubject.value) {
                  viewModel.filterMenuVisibleSubject.add(false);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: StreamBuilder<List<TodoType>>(
                  stream: viewModel.typesSubject,
                  builder: (context, typesSnapshot) {
                    List<TodoType> selectedTypes = typesSnapshot.data ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 24, bottom: 10),
                          child: StreamBuilder<bool>(
                            stream: viewModel.filterMenuVisibleSubject,
                            builder: (context, filterSnapshot) {
                              return FilterButton(
                                onExpanded: viewModel.onFilterButtonPressed,
                                expanded: filterSnapshot.data ?? false,
                                filterOptions: FilterButtonContent(
                                  iconAssets: TodoType.values
                                      .map((e) => (e.activeIcon, e.inactiveIcon))
                                      .toList(),
                                  selectedIndexes:
                                      selectedTypes.map((e) => TodoType.values.indexOf(e)).toList(),
                                  onFilterOptionPressed: (index) {
                                    reset();
                                    viewModel.onFilterTypePressed(TodoType.values[index]);
                                  },
                                  size: const Size(210, 32),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder<bool>(
                            stream: viewModel.loadingSubject,
                            builder: (_, loadingSnapshot) {
                              bool isLoading = loadingSnapshot.data ?? true;
                              return isLoading
                                  ? const AppLoadingIndicator()
                                  : StreamBuilder<List<Todo>>(
                                      stream: viewModel.watchAllParentTodos(),
                                      builder: (_, todoSnapshot) {
                                        List<Todo> localTodos =
                                            justReordered ? todos : (todoSnapshot.data ?? []);

                                        return RefreshIndicator(
                                          color: AppColors.mainColor,
                                          backgroundColor: Colors.white,
                                          onRefresh: viewModel.fetchTodos,
                                          child: localTodos.isNotEmpty
                                              ? ReorderableListView(
                                                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                                                  proxyDecorator: proxyDecorator,
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
                                                  children:
                                                      List.generate(localTodos.length, (index) {
                                                    Todo todo = localTodos[index];
                                                    bool isSingle = todo.type == "SINGLE";

                                                    return Padding(
                                                      key: ValueKey(todo.id),
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: isSingle
                                                          ? TodoSingleItem(
                                                              todo: todo,
                                                              todoRepository: Provider.of(context),
                                                              showSnackBar: viewModel.showSnackBar,
                                                              hasInternet: hasInternet,
                                                              onCallback: reset,
                                                            )
                                                          : TodoGroupItem(
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
                                                    "Nothing here",
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
                      ],
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}
