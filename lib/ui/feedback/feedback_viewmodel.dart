import 'package:flutter/material.dart';
import 'package:mou_app/core/repositories/user_repository.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:rxdart/rxdart.dart';

class FeedbackViewModel extends BaseViewModel {
  final UserRepository userRepository;
  final textController = TextEditingController();
  final hasSaveSubject = BehaviorSubject<bool>();

  FeedbackViewModel({required this.userRepository}) {
    textController.addListener(() {
      final text = textController.text;
      hasSaveSubject.add(text.isNotEmpty);
    });
  }

  void addFeedBack() async {
    FocusScope.of(context).unfocus();
    if (isValidate()) {
      loadingSubject.add(true);
      final resource = await userRepository.sendFeedBack(feedBack: textController.text);
      if (resource.isSuccess == true) {
        loadingSubject.add(false);
        showSnackBar(
          allTranslations.text(AppLanguages.feedbackSuccess),
          isError: false,
        );
        Navigator.pop(context);
      } else {
        showSnackBar(resource.message ?? "");
        loadingSubject.add(false);
      }
    }
  }

  bool isValidate() {
    if (textController.text.length < 10) {
      showSnackBar(allTranslations.text(AppLanguages.pleaseEnterCharGreaterFeedback));
      return false;
    }
    return true;
  }

  @override
  void dispose() async {
    textController.dispose();
    await hasSaveSubject.drain();
    hasSaveSubject.close();
    super.dispose();
  }
}
