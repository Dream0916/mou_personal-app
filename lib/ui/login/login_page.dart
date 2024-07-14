import 'package:flutter/material.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/login/components/login_view.dart';
import 'package:mou_app/ui/login/login_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final Map<String, dynamic>? message;

  const LoginPage({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<LoginViewModel>(
      viewModel: LoginViewModel(
        service: Provider.of(context),
        authRepository: Provider.of(context),
      ),
      onViewModelReady: (viewModel) => viewModel..init(message),
      builder: (context, viewModel, child) => LoginView(viewModel: viewModel),
    );
  }
}
