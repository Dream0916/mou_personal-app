import 'package:flutter/material.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/corp/components/corp_view.dart';
import 'package:provider/provider.dart';

import 'corp_viewmodel.dart';

class CorpPage extends StatelessWidget {
  const CorpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<CorpViewModel>(
      viewModel: CorpViewModel(Provider.of(context)),
      onViewModelReady: (viewModel) => viewModel..initData(),
      builder: (context, viewModel, child) => const CorpView(),
    );
  }
}
