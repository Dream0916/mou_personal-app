import 'package:flutter/material.dart';
import 'package:mou_app/core/repositories/corp_repository.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:mou_app/utils/app_languages.dart';

class CorpViewModel extends BaseViewModel {
  final CorpRepository corpRepository;

  CorpViewModel(this.corpRepository);

  int _currentPage = 0;
  bool _loadingData = false;
  bool hasMore = true;

  final scrollController = ScrollController();

  void initData() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (hasMore) {
          _loadData(isLoadMore: true);
        }
      }
    });
    _loadData();
  }

  Future<void> _loadData({bool isLoadMore = false}) async {
    if (!_loadingData) {
      if (!hasMore) return;
      _loadingData = true;
      if (!isLoadMore) setLoading(true);
      final resource = await corpRepository.getCorpInvited(_currentPage + 1);
      if (resource.isSuccess) {
        final data = resource.data;
        _currentPage = data?.meta?.currentPage ?? -1;
        final lastPage = data?.meta?.lastPage ?? -1;
        hasMore = _currentPage < lastPage;
      } else {
        showSnackBar(resource.message ?? "");
      }
      if (!isLoadMore) setLoading(false);
      _loadingData = false;
    }
  }

  Future<void> acceptCorpInvitation(int corpId) async {
    setLoading(true);
    final resource = await corpRepository.acceptCorpInvitation(corpId);
    if (resource.isSuccess) {
      showSnackBar(
        allTranslations.text(AppLanguages.hasAcceptedCompanyInvitation),
        isError: false,
      );
    } else {
      showSnackBar(resource.message ?? "");
    }
    setLoading(false);
  }

  Future<void> denyCorpInvitation(int corpId) async {
    setLoading(true);
    final resource = await corpRepository.denyCorpInvitation(corpId);
    if (resource.isSuccess) {
      showSnackBar(allTranslations.text(AppLanguages.declinedCompanyInvitation), isError: false);
    } else {
      showSnackBar(resource.message ?? "");
    }
    setLoading(false);
  }

  Future<void> refresh() async {
    _loadingData = false;
    _currentPage = 0;
    hasMore = true;
    setLoading(true);
    await _loadData();
  }
}
