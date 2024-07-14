import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mou_app/core/responses/project_detail/project_detail_response.dart';
import 'package:mou_app/core/responses/project_detail/task_detail.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/project_detail/project_detail_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_body.dart';
import 'package:mou_app/ui/widgets/app_content.dart';
import 'package:mou_app/ui/widgets/app_loading.dart';
import 'package:mou_app/ui/widgets/menu/app_menu_bar.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_types/app_types.dart';
import 'package:mou_app/utils/app_utils.dart';
import 'package:provider/provider.dart';

class ProjectDetailPage extends StatelessWidget {
  final ProjectDetailArgument argument;

  ProjectDetailPage({required this.argument});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ProjectDetailViewModel>(
      viewModel: ProjectDetailViewModel(
        projectRepository: Provider.of(context),
        projectId: argument.projectId,
      ),
      onViewModelReady: (viewModel) => viewModel..initData(),
      builder: (context, viewModel, child) => Scaffold(
        key: viewModel.scaffoldKey,
        backgroundColor: const Color(0xfffafbfc),
        body: AppBody(
          child: AppContent(
            headerBuilder: (_) => _buildHeader(context, viewModel),
            childBuilder: (_) => _buildBody(context, viewModel),
            menuBarBuilder: (stream) => AppMenuBar(tabObserveStream: stream),
            headerImage: AssetImage(AppImages.bgProject),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProjectDetailViewModel viewModel) {
    return SafeArea(
      child: Container(
        height: 93,
        width: double.maxFinite,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: viewModel.goBack,
              icon: Image.asset(
                AppImages.icClose,
                color: Colors.white,
                width: 18,
              ),
            ),
            const Spacer(flex: 1),
            Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                argument.projectName,
                style: TextStyle(
                  fontSize: AppFontSize.textTitlePage,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Spacer(flex: 1),
            const SizedBox(width: 35)
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProjectDetailViewModel viewModel) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Container(
          color: const Color(0xfffafbfc),
          width: double.maxFinite,
          height: double.maxFinite,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: StreamBuilder<ProjectDetailResponse>(
              stream: viewModel.projectDetailSubject,
              builder: (context, snapshot) {
                var projectDetail = snapshot.data;
                if (projectDetail == null)
                  return Container(
                    padding: const EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: const AppLoadingIndicator(),
                  );
                return _buildContent(projectDetail, context, viewModel);
              },
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: InkWell(
            onTap: viewModel.showHiddenProjectInfo,
            child: StreamBuilder<bool>(
              stream: viewModel.hiddenProjectInfoSubject,
              builder: (context, snapShot) {
                var isHidden = snapShot.data ?? false;
                if (snapShot.data == null) return SizedBox();
                return Container(
                  alignment: Alignment.bottomRight,
                  height: 20,
                  child: Image.asset(
                    isHidden ? AppImages.icEye : AppImages.icEyeClose,
                    height: isHidden ? 12 : 16,
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: StreamBuilder<bool>(
            stream: viewModel.isShowDescriptionSubject,
            builder: (context, snapShot) {
              var isShow = snapShot.data ?? false;
              if (!isShow) return SizedBox();
              return _buildDescriptionInfo();
            },
          ),
        )
      ],
    );
  }

  Widget _buildDescriptionInfo() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            SizedBox(width: 15),
            this._buildDescriptionInfoItem(
              AppUtils.getStatusColor(TaskStatus.DONE),
              allTranslations.text(AppLanguages.doneInTime),
            ),
            SizedBox(width: 15),
            this._buildDescriptionInfoItem(
              AppUtils.getStatusColor(TaskStatus.NOT_DONE),
              allTranslations.text(AppLanguages.notDoneInTime),
            ),
            SizedBox(width: 15),
            this._buildDescriptionInfoItem(
              AppUtils.getStatusColor(TaskStatus.IN_PROGRESS),
              allTranslations.text(AppLanguages.inProgress),
            ),
            SizedBox(width: 15),
            this._buildDescriptionInfoItem(
              AppUtils.getStatusColor(TaskStatus.WAITING),
              allTranslations.text(AppLanguages.waitingToStart),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionInfoItem(Color statusColor, String description) {
    return Row(
      children: <Widget>[
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          description,
          style: TextStyle(fontSize: 8, color: Colors.black),
        )
      ],
    );
  }

  Widget _buildContent(
    ProjectDetailResponse projectDetail,
    BuildContext context,
    ProjectDetailViewModel viewModel,
  ) {
    var companyName = projectDetail.companyName;
    var projectDate = viewModel.getProjectDate(projectDetail.tasks ?? []);
    var description = projectDetail.description;
    var client = projectDetail.client;
    var responsible = projectDetail.employeeResponsible?.name ?? "";
    var teams = viewModel.getTeams(projectDetail.teams ?? []);

    return Column(
      children: <Widget>[
        StreamBuilder<bool>(
          stream: viewModel.hiddenProjectInfoSubject,
          builder: (context, snapShot) {
            var isHidden = snapShot.data ?? false;
            if (isHidden) return SizedBox();
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 43, right: 43),
              child: Column(
                children: <Widget>[
                  _buildItemProject(companyName ?? "", AppImages.icCorp),
                  _buildItemProject(projectDate, AppImages.icDateHour),
                  _buildItemMultiLineProject(
                      context, description ?? "", AppImages.icCommentProject),
                  _buildItemProject(client ?? "", AppImages.icAddClient),
                  _buildItemProject(responsible, AppImages.icAddTagResponsible),
                  _buildItemMultiLineProject(
                      context, teams, AppImages.icTagTheTeam),
                ],
              ),
            );
          },
        ),
        InkWell(
          onTap: viewModel.showHiddenDescription,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 20, left: 25),
            child: Image.asset(
              AppImages.icInfo,
              fit: BoxFit.cover,
            ),
          ),
        ),
        this._buildListTask(context, projectDetail.tasks ?? [], viewModel),
      ],
    );
  }

  Widget _buildItemProject(String content, String assetName) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: 40,
                  child: Image.asset(
                    assetName,
                    width: 24,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSize.textButton,
                    color: AppColors.normal,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemMultiLineProject(
      BuildContext context, String content, String assetName) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: 40,
            child: Image.asset(
              assetName,
              width: 24,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: width - 136,
            child: Text(
              content,
              style: TextStyle(
                fontSize: AppFontSize.textButton,
                color: AppColors.normal,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListTask(BuildContext context, List<TaskDetail> tasks,
      ProjectDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 6),
      child: Column(
        children: List.generate(tasks.length, (index) {
          return this._buildItemTaskRow(tasks[index], index, viewModel);
        }),
      ),
    );
  }

  Widget _buildItemTaskRow(
      TaskDetail task, int index, ProjectDetailViewModel viewModel) {
    var startDate =
        task.startDate != null ? DateTime.parse(task.startDate ?? "") : null;
    var endDate =
        task.endDate != null ? DateTime.parse(task.endDate ?? "") : null;
    var colorStatus = AppUtils.getStatusColor(task.status ?? "");
    return Column(
      children: <Widget>[
        StreamBuilder<int>(
          stream: viewModel.indexTaskShowSubject,
          builder: (context, snapShot) {
            var indexItem = snapShot.data ?? -1;
            if (indexItem == index) {
              return _buildTaskDetail(task, index, viewModel);
            } else {
              return _buildItemTask(
                  task, startDate!, endDate!, index, colorStatus, viewModel);
            }
          },
        ),
        SizedBox(
          height: 6,
        ),
      ],
    );
  }

  Widget _buildItemTask(
    TaskDetail task,
    DateTime startDate,
    DateTime endDate,
    int index,
    Color colorStatus,
    ProjectDetailViewModel viewModel,
  ) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 26,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 7),
            decoration: new BoxDecoration(
                color: colorStatus,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(8.0),
                  bottomLeft: const Radius.circular(8.0),
                )),
            child: Text(
              task.title ?? "",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.black, fontSize: AppFontSize.textButton),
            ),
          ),
        ),
        SizedBox(width: 1),
        Container(
          height: 26,
          width: 51,
          alignment: Alignment.center,
          color: colorStatus,
          child: Text(
            DateFormat("dd-MM").format(startDate),
            style: TextStyle(
                color: Colors.black, fontSize: AppFontSize.textButton),
          ),
        ),
        SizedBox(width: 1),
        Container(
          height: 26,
          width: 51,
          alignment: Alignment.center,
          color: colorStatus,
          child: Text(
            DateFormat("dd-MM").format(endDate),
            style: TextStyle(
                color: Colors.black, fontSize: AppFontSize.textButton),
          ),
        ),
        SizedBox(width: 1),
        InkWell(
          onTap: () => viewModel.showTaskDetail(index),
          child: Container(
            height: 26,
            width: 51,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
                color: colorStatus,
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(8.0),
                  bottomRight: const Radius.circular(8.0),
                )),
            child: Text(
              "Abc",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white, fontSize: AppFontSize.textButton),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskDetail(
      TaskDetail task, int index, ProjectDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(left: 7, top: 4, bottom: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xffbabdc8), width: 0.1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(task.comment ?? "",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black, fontSize: 13)),
            ),
          ),
          InkWell(
            onTap: () => viewModel.showTaskDetail(index),
            child: Container(
              alignment: Alignment.topCenter,
              width: 51,
              child: Text(
                "Abc",
                maxLines: 1,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProjectDetailArgument {
  final int projectId;
  final String projectName;

  ProjectDetailArgument(this.projectId, this.projectName);
}
