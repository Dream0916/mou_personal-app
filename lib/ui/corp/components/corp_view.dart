import 'package:flutter/material.dart';
import 'package:mou_app/ui/corp/components/corp_app_bar.dart';
import 'package:mou_app/ui/corp/components/corp_list.dart';
import 'package:mou_app/ui/corp/corp_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_body.dart';
import 'package:mou_app/ui/widgets/app_content.dart';
import 'package:mou_app/ui/widgets/menu/app_menu_bar.dart';
import 'package:provider/provider.dart';

class CorpView extends StatelessWidget {
  const CorpView({super.key});

  @override
  Widget build(BuildContext context) {
    final CorpViewModel viewModel = Provider.of(context);
    return Scaffold(
      key: viewModel.scaffoldKey,
      body: AppBody(
        child: AppContent(
          menuBarBuilder: (stream) => AppMenuBar(tabObserveStream: stream),
          headerBuilder: (_) => const CorpAppBar(),
          childBuilder: (hasInternet) => CorpList(hasInternet: hasInternet),
        ),
      ),
    );
  }
}
