import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mou_app/core/repositories/project_repository.dart';
import 'package:mou_app/core/responses/project_detail/project_detail_response.dart';
import 'package:mou_app/core/responses/project_detail/task_detail.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class ProjectDetailViewModel extends BaseViewModel {
  final ProjectRepository projectRepository;
  final int? projectId;

  var projectDetailSubject = BehaviorSubject<ProjectDetailResponse>();
  var indexTaskShowSubject = BehaviorSubject<int>();
  var hiddenProjectInfoSubject = BehaviorSubject<bool>();
  var isShowDescriptionSubject = BehaviorSubject<bool>();

  ProjectDetailViewModel({
    required this.projectRepository,
    required this.projectId,
  });

  void initData() async {
    setLoading(true);
    var resource = await projectRepository.getProjectDetail(projectId ?? 0);
    if (resource.isSuccess == true) {
      var data = resource.data;
      projectDetailSubject.add(data ?? ProjectDetailResponse());
      hiddenProjectInfoSubject.add(false);
      print(resource);
    } else {
      projectDetailSubject.add(ProjectDetailResponse());
    }
    setLoading(false);
  }

  String getProjectDate(List<TaskDetail> tasks) {
    String result = "";
    var startDateHour = "";
    var endDateHour = "";

    if (tasks.length > 1) {
      final taskFirst = tasks.first;
      startDateHour = taskFirst.startDate ?? "";

      final taskLast = tasks.last;
      endDateHour = taskLast.endDate ?? "";
    } else if (tasks.length == 1) {
      var task = tasks.first;
      startDateHour = task.startDate ?? "";
      endDateHour = task.endDate ?? "";
    } else {
      return "";
    }

    var startDate = DateTime.parse(startDateHour);
    var startDateString = DateFormat("dd/MM/yy").format(startDate).toString();

    result = startDateString;
    if (endDateHour.isNotEmpty) {
      var endDate = DateTime.parse(endDateHour);
      var endDateString = DateFormat("dd/MM/yy").format(endDate).toString();
      result += " - " + endDateString;
    }
    return result;
  }

  String getTeams(List<EmployeeResponsible> teams) {
    String result = "";
    if (teams.isEmpty) return result;

    var lstTeam = teams.map<String>((employee) => employee.name ?? "").toList();
    result = lstTeam.join(", ");

    return result;
  }

  void showHiddenProjectInfo() {
    var isHidden = hiddenProjectInfoSubject.value;
    hiddenProjectInfoSubject.add(!isHidden);
  }

  void showHiddenDescription() {
    var isHidden = isShowDescriptionSubject.valueOrNull ?? false;
    isShowDescriptionSubject.add(!isHidden);
  }

  void showTaskDetail(int indexRow) {
    var currentIndex = indexTaskShowSubject.valueOrNull ?? -1;
    if (currentIndex == indexRow) {
      indexTaskShowSubject.add(-1);
    } else {
      indexTaskShowSubject.add(indexRow);
    }
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  @override
  void dispose()  {
    projectRepository.cancel();
    projectDetailSubject.close();
    hiddenProjectInfoSubject.close();
    indexTaskShowSubject.close();
    isShowDescriptionSubject.close();
    super.dispose();
  }
}
