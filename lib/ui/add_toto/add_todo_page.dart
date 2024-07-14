import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/add_toto/add_todo_viewmodel.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/widgets/app_content.dart';
import 'package:mou_app/ui/widgets/loading_full_screen.dart';
import 'package:mou_app/ui/widgets/menu/app_menu_bar.dart';
import 'package:mou_app/ui/widgets/todo/todo_header.dart';
import 'package:mou_app/ui/widgets/word_counter_text_field.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/extensions/string_extensions.dart';
import 'package:provider/provider.dart';

class AddTodoArgs {
  final Todo? todo;
  final bool isEdit;

  const AddTodoArgs({this.todo, this.isEdit = false});
}

class AddTodoPage extends StatefulWidget {
  final AddTodoArgs? args;

  const AddTodoPage({this.args = const AddTodoArgs()});

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  Todo? get _todo => widget.args?.todo;

  bool get _isEdit => widget.args?.isEdit ?? false;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<AddTodoViewModel>(
      viewModel: AddTodoViewModel(Provider.of(context)),
      onViewModelReady: (viewModel) => viewModel..initData(widget.args),
      builder: (context, viewModel, child) {
        return StreamBuilder<bool>(
          stream: viewModel.loadingSubject,
          builder: (context, snapshot) {
            bool isLoading = snapshot.data ?? false;

            return LoadingFullScreen(
              loading: isLoading,
              child: Scaffold(
                body: AppContent(
                  menuBarBuilder: (stream) => AppMenuBar(tabObserveStream: stream),
                  headerBuilder: (hasInternet) => TodoHeader(
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      icon: Image.asset(
                        AppImages.icCloseAddEvent,
                        width: 16,
                        fit: BoxFit.cover,
                      ),
                    ),
                    action: hasInternet
                        ? IconButton(
                            onPressed: viewModel.createUpdateTodo,
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.fromLTRB(8, 0, 10, 5),
                            icon: Image.asset(
                              AppImages.icAccept,
                              width: 24,
                            ),
                          )
                        : null,
                  ),
                  childBuilder: (hasInternet) => hasInternet
                      ? GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            viewModel.isTypingTitle
                                .add(viewModel.titleController.text.trim().isNotEmpty);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24, top: 7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_todo == null ||
                                    (_todo!.type == "SINGLE" && _todo!.parentId == 0) ||
                                    (_todo!.type == "GROUP" &&
                                        (_todo!.children?.isEmpty ?? true) &&
                                        _isEdit))
                                  _buildOptions(viewModel),
                                const SizedBox(height: 5),
                                _buildTitle(viewModel),
                                if (_todo == null || (_todo!.parentId == 0 && _isEdit))
                                  _buildTagSomeone(viewModel),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOptions(AddTodoViewModel viewModel) {
    return ValueListenableBuilder<bool>(
      valueListenable: viewModel.isSingle,
      builder: (_, isSingle, __) {
        return SizedBox(
          height: 50,
          child: Row(
            children: [
              Flexible(
                child: Center(
                  child: RadioListTile<bool>(
                    dense: true,
                    visualDensity: const VisualDensity(horizontal: -4, vertical: 0),
                    activeColor: AppColors.mainColor,
                    title: Text(
                      allTranslations.text(AppLanguages.single).inFirstLetterCaps,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.normal,
                      ),
                    ),
                    value: true,
                    groupValue: isSingle,
                    onChanged: (_) {
                      viewModel.isSingle.value = true;
                    },
                  ),
                ),
              ),
              Flexible(
                child: Center(
                  child: RadioListTile<bool>(
                    dense: true,
                    visualDensity: const VisualDensity(horizontal: -4, vertical: 0),
                    activeColor: AppColors.mainColor,
                    title: Text(allTranslations.text(AppLanguages.list).inFirstLetterCaps,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.normal)),
                    value: false,
                    groupValue: isSingle,
                    onChanged: (_) {
                      setState(() {
                        viewModel.isSingle.value = false;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(AddTodoViewModel viewModel) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          StreamBuilder<bool?>(
            stream: viewModel.isTypingTitle,
            builder: (context, snapshot) {
              final enableAnim = snapshot.data ?? false;

              return Container(
                alignment: Alignment.centerLeft,
                width: 50,
                padding: const EdgeInsets.only(bottom: 6),
                child: enableAnim
                    ? Lottie.asset(
                        AppImages.animEvent,
                        width: 34,
                        repeat: false,
                      )
                    : Image.asset(
                        AppImages.icEvent,
                        width: 34,
                        fit: BoxFit.cover,
                      ),
              );
            },
          ),
          Expanded(
            child: WordCounterTextField(
              controller: viewModel.titleController,
              focusNode: viewModel.titleFocusNode,
              hintText: allTranslations.text(AppLanguages.todoTitle),
              maxLength: 30,
              onChanged: (value) {
                if (value.isEmpty) {
                  viewModel.isTypingTitle.add(false);
                }
              },
              onFieldSubmitted: (value) => viewModel.isTypingTitle.add(value.trim().isNotEmpty),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagSomeone(AddTodoViewModel viewModel) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          StreamBuilder<bool?>(
            stream: viewModel.isTagSomeOne,
            builder: (context, snapshot) {
              final enableAnim = snapshot.data ?? false;

              return Container(
                alignment: Alignment.centerLeft,
                width: 50,
                padding: const EdgeInsets.only(bottom: 4, left: 6),
                child: enableAnim
                    ? Lottie.asset(
                        AppImages.animTagSomeOne,
                        width: 22,
                        repeat: false,
                      )
                    : Image.asset(
                        AppImages.icTagSomeOne,
                        width: 22,
                        fit: BoxFit.cover,
                      ),
              );
            },
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                viewModel.isTypingTitle.add(viewModel.titleController.text.trim().isNotEmpty);
                Navigator.pushNamed(
                  context,
                  Routers.CONTACTS,
                  arguments: viewModel.contacts,
                ).then((value) {
                  if (value != null && value is List<Contact>) {
                    viewModel.isTagSomeOne.add(value.isNotEmpty);
                    viewModel.setContacts(value);
                  }
                });
              },
              child: StreamBuilder<String>(
                stream: viewModel.contactSubject,
                builder: (context, snapShot) {
                  var data = snapShot.data ?? "";
                  return Text(
                    data.isEmpty ? allTranslations.text(AppLanguages.tagSomeone) : data,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.textDatePicker,
                      fontWeight: FontWeight.normal,
                      color: data.isEmpty ? AppColors.textPlaceHolder : AppColors.normal,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
