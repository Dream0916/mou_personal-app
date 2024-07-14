import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mou_app/core/network_bound_resource.dart';
import 'package:mou_app/core/resource.dart';
import 'package:mou_app/core/responses/project_detail/project_detail_response.dart';
import 'package:mou_app/core/services/api_service.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/utils/app_apis.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectRepository {
  CancelToken _cancelToken = CancelToken();

  ProjectRepository();

  Future<Resource<ProjectDetailResponse>> getProjectDetail(int projectId) async {
    if (_cancelToken.isCancelled) _cancelToken = CancelToken();
    return NetworkBoundResource<ProjectDetailResponse, ProjectDetailResponse>(
      createCall: () => APIService.getProjectDetail(projectId, _cancelToken),
      parsedData: (json) => ProjectDetailResponse.fromJson(json),
    ).getAsObservable();
  }

  Future<String?> downloadFile(int eventId) async {
    final String downloadUrl = AppApis.domainAPI + AppApis.exportReport(eventId);
    if (await canLaunchUrl(Uri.parse(downloadUrl))) {
      final Directory? directory = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getExternalStorageDirectory();
      if (directory != null && directory.existsSync()) {
        return FlutterDownloader.enqueue(
          url: downloadUrl,
          savedDir: directory.path,
          showNotification: false,
          openFileFromNotification: false,
        );
      } else {
        throw S.text(AppLanguages.couldNotCreateDirectory);
      }
    }
    throw S.text(AppLanguages.thisProjectCannotBeExported);
  }

  cancel() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }
}
