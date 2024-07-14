import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/app_colors.dart';

abstract class BaseViewModel extends ChangeNotifier {
  late BuildContext _context;

  BuildContext get context => _context;

  setContext(BuildContext value) {
    _context = value;
  }

  final loadingSubject = BehaviorSubject<bool>();
  final errorSubject = BehaviorSubject<String>();

  void setLoading(bool loading) {
    loadingSubject.add(loading);
  }

  void setError(String message) {
    errorSubject.add(message);
  }

  bool get isLoading => loadingSubject.valueOrNull ?? false;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void showSnackBar(
    String? message, {
    Color? backgroundColor,
    bool isError = true,
  }) {
    if (message == null || message.isEmpty) return;
    var snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor != null
          ? backgroundColor
          : isError
              ? AppColors.redColor.withOpacity(0.7)
              : AppColors.greenColor.withOpacity(0.7),
    );
    try {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print("Show Snack Bar Error:: $e");
    }
  }

  @override
  void dispose() async {
    await loadingSubject.drain();
    loadingSubject.close();
    await errorSubject.drain();
    errorSubject.close();
    super.dispose();
  }
}
