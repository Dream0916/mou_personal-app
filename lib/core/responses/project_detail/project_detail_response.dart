import 'package:mou_app/core/responses/project_detail/task_detail.dart';

class ProjectDetailResponse {
  int? id;
  String? title;
  String? companyName;
  String? companyLogo;
  String? description;
  String? client;
  EmployeeResponsible? employeeResponsible;
  List<EmployeeResponsible>? teams;
  List<TaskDetail>? tasks;
  int? creatorId;

  ProjectDetailResponse({
    this.id,
    this.title,
    this.description,
    this.client,
    this.employeeResponsible,
    this.teams,
    this.tasks,
    this.companyLogo,
    this.companyName,
    this.creatorId,
  });

  factory ProjectDetailResponse.fromJson(Map<String, dynamic> json) {
    var teams = json["teams"] as List? ?? [];
    var teamsMap = teams.map((e) => EmployeeResponsible.fromJson(e)).toList();
    var employeeResponsible = json["employee_responsible"] != null
        ? EmployeeResponsible.fromJson(json["employee_responsible"])
        : null;
    var tasks = json["tasks"] as List? ?? [];
    var tasksMap = tasks.map((e) => TaskDetail.fromJson(e)).toList();

    return ProjectDetailResponse(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        client: json["client"],
        companyName: json["company_name"] ?? "",
        companyLogo: json["company_logo"] ?? "",
        employeeResponsible: employeeResponsible,
        teams: teamsMap,
        creatorId: json["creator_id"],
        tasks: tasksMap);
  }
}

class EmployeeResponsible {
  int? id;
  String? name;

  EmployeeResponsible({this.id, this.name});

  factory EmployeeResponsible.fromJson(Map<String, dynamic> json) {
    return EmployeeResponsible(
      id: json["id"],
      name: json["name"],
    );
  }
}
