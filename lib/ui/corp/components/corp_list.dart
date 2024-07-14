import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/databases/dao/corp_dao.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/corp/components/corp_item.dart';
import 'package:mou_app/ui/corp/corp_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_loading.dart';
import 'package:mou_app/ui/widgets/expanded_child_scroll_view.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class CorpList extends StatelessWidget {
  final bool hasInternet;

  const CorpList({
    super.key,
    this.hasInternet = true,
  });

  @override
  Widget build(BuildContext context) {
    final CorpViewModel viewModel = Provider.of(context);
    final CorpDao corpDao = Provider.of(context);

    return StreamBuilder<List<Corp>>(
      stream: corpDao.watchAllCorps(),
      builder: (context, snapshot) {
        final List<Corp> corps = snapshot.data ?? [];
        final int length = corps.length;

        return RefreshIndicator(
          color: AppColors.mainColor,
          backgroundColor: Colors.white,
          onRefresh: viewModel.refresh,
          child: corps.isEmpty && snapshot.hasData
              ? ExpandedChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Text(
                      S.text(AppLanguages.youHasNoNewInvites),
                      style: TextStyle(
                        color: Color(0xff7A7A7A),
                        fontSize: AppFontSize.textButton,
                      ),
                    ),
                  ),
                )
              : AnimationList(
                  duration: AppConstants.ANIMATION_LIST_DURATION,
                  reBounceDepth: AppConstants.ANIMATION_LIST_RE_BOUNCE_DEPTH,
                  controller: viewModel.scrollController,
                  padding: EdgeInsets.only(top: 4),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: List.generate(length + 1, (index) {
                    if (index == length) {
                      return viewModel.hasMore && hasInternet
                          ? const Padding(
                              padding: EdgeInsets.all(8),
                              child: AppLoadingIndicator(),
                            )
                          : const SizedBox();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: CorpItem(
                          corp: corps.elementAt(index),
                          onAcceptPressed: (value) => viewModel.acceptCorpInvitation(value.id),
                          onDeletePressed: (value) => viewModel.denyCorpInvitation(value.id),
                          hasInternet: hasInternet,
                        ),
                      );
                    }
                  }),
                ),
        );
      },
    );
  }
}
