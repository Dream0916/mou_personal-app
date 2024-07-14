import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/databases/dao/corp_dao.dart';
import 'package:mou_app/core/models/list_response.dart';
import 'package:mou_app/core/network_bound_resource.dart';
import 'package:mou_app/core/resource.dart';
import 'package:mou_app/core/services/api_service.dart';

class CorpRepository {
  final CorpDao corpDao;

  CorpRepository(this.corpDao);

  CancelToken _cancelToken = CancelToken();

  Future<Resource<ListResponse<Corp>>> getCorpInvited(int page) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<ListResponse<Corp>, ListResponse<Corp>>(
      createCall: () => APIService.getCorpInvited(page, _cancelToken),
      parsedData: (json) {
        if (json is Map<String, dynamic>) {
          return ListResponse<Corp>.fromJson(
            json,
            (employee) => Corp.fromJson(employee),
          );
        } else {
          return ListResponse<Corp>();
        }
      },
      saveCallResult: (response) async {
        List<Corp> corps = response.data ?? [];
        if (response.meta?.currentPage == 1 || response.meta == null) {
          await corpDao.deleteAll();
        }
        for (Corp corp in corps) {
          await corpDao.insertCorp(corp);
        }
      },
      loadFromDb: () => null,
    );
    return resource.getAsObservable();
  }

  Future<Resource<dynamic>> acceptCorpInvitation(int corpId) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<dynamic, dynamic>(
      createCall: () => APIService.acceptCorpInvitation(corpId, _cancelToken),
      parsedData: (json) => {},
      saveCallResult: (_) async {
        Corp? corp = await corpDao.getCorpByID(corpId);
        if (corp != null) {
          await corpDao.insertCorp(corp.copyWith(confirmed: Value(true)));
        }
      },
      loadFromDb: () => null,
    );
    return resource.getAsObservable();
  }

  Future<Resource<dynamic>> denyCorpInvitation(int corpId) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    final resource = NetworkBoundResource<dynamic, dynamic>(
      createCall: () => APIService.denyCorpInvitation(corpId, _cancelToken),
      parsedData: (json) => {},
      saveCallResult: (data) async {
        await corpDao.deleteCorpById(corpId);
      },
      loadFromDb: () => null,
    );
    return resource.getAsObservable();
  }

  cancel() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }
}
