import 'package:mou_app/core/responses/project_detail/employee_detail.dart';

class TaskDetail {
  int? id;
  String? title;
  String? startDate;
  String? endDate;
  String? comment;
  EmployeeDetail? employee;
  String? status;
  String? employeeConfirm;

  TaskDetail(
      {this.id,
      this.title,
      this.startDate,
      this.endDate,
      this.comment,
      this.employee,
      this.status,
      this.employeeConfirm});

  TaskDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    comment = json['comment'];
    employee = json['employee'] != null
        ? new EmployeeDetail.fromJson(json['employee'])
        : null;
    status = json['status'];
    employeeConfirm = json['employee_confirm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['comment'] = this.comment;
    if (this.employee != null) {
      data['employee'] = this.employee?.toJson();
    }
    data['status'] = this.status;
    data['employee_confirm'] = this.employeeConfirm;
    return data;
  }
}
