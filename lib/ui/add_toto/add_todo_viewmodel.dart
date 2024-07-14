import 'package:flutter/material.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/repositories/todo_repository.dart';
import 'package:mou_app/core/requests/todo_request.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/add_toto/add_todo_page.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:rxdart/rxdart.dart';

class AddTodoViewModel extends BaseViewModel {
  final TodoRepository todoRepository;

  AddTodoViewModel(this.todoRepository);

  Todo? _todo;
  bool _isEdit = false;
  final ValueNotifier<bool> isSingle = ValueNotifier(true);
  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final isTypingTitle = BehaviorSubject<bool?>();
  final isTagSomeOne = BehaviorSubject<bool?>();
  final contactSubject = BehaviorSubject<String>();
  List<Contact> contacts = [];

  void initData(AddTodoArgs? args) {
    _todo = args?.todo;
    _isEdit = args?.isEdit ?? false;
    if (_isEdit) {
      isSingle.value = _todo == null || _todo!.type == "SINGLE";
      titleController.text = _todo?.title ?? "";
      List<Contact> _contacts =
          _todo?.users?.map<Contact>((item) => Contact.fromJson(item)).toList() ?? [];
      setContacts(_contacts);
      isTypingTitle.add(titleController.text.trim().isNotEmpty);
      isTagSomeOne.add(_contacts.isNotEmpty);
    }
  }

  void setContacts(List<Contact> contacts) {
    this.contacts = contacts;
    List<String> contactsString = this.contacts.map<String>((item) => item.name ?? "").toList();
    if (contactsString.length > 0) {
      contactSubject.add(contactsString.join(", "));
    } else {
      contactSubject.add("");
    }
  }

  Future<void> createUpdateTodo() async {
    FocusScope.of(context).unfocus();
    if (titleController.text.trim().isEmpty) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseInputTitle));
      return;
    }
    setLoading(true);
    TodoRequest todoRequest = TodoRequest(
      todoId: _todo?.id,
      title: titleController.text,
      type: isSingle.value ? "SINGLE" : "GROUP",
      parentId: _todo == null
          ? 0
          : (_todo!.type == "SINGLE"
              ? _todo!.parentId
              : _isEdit
                  ? 0
                  : _todo!.id),
      contactIds: contacts.map((e) => e.id).toList(),
    );
    bool isCreateNew = _todo == null || (_todo!.type == "GROUP" && !_isEdit);
    var response = isCreateNew
        ? await todoRepository.createTodo(todoRequest)
        : await todoRepository.updateTodo(todoRequest);
    setLoading(false);
    if (response.isSuccess) {
      if (_todo?.type == "GROUP" && !_isEdit) {
        await todoRepository.getTodoDetail(_todo!.id);
      }
      Navigator.pop(context);
    } else {
      showSnackBar(response.message ?? '');
    }
  }

  @override
  void dispose() async {
    todoRepository.cancel();
    isSingle.dispose();
    titleController.dispose();
    titleFocusNode.dispose();
    isTypingTitle.drain();
    isTypingTitle.close();
    contactSubject.drain();
    contactSubject.close();
    isTagSomeOne.drain();
    isTagSomeOne.close();
    super.dispose();
  }
}
