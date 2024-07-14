import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:lottie/lottie.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/models/time_in_alarm.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/add_event/add_event_viewmodel.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/widgets/alarm_dialog/time_in_alarm_dialog.dart';
import 'package:mou_app/ui/widgets/app_body.dart';
import 'package:mou_app/ui/widgets/app_content.dart';
import 'package:mou_app/ui/widgets/date_hour_picker/date_hour_picker_dialog.dart';
import 'package:mou_app/ui/widgets/loading_full_screen.dart';
import 'package:mou_app/ui/widgets/menu/app_menu_bar.dart';
import 'package:mou_app/ui/widgets/word_counter_text_field.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_utils.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  final Event? event;

  AddEventPage({required this.event});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<AddEventViewModel>(
      viewModel: AddEventViewModel(
        event: widget.event,
        eventRepository: Provider.of(context),
        userRepository: Provider.of(context),
      ),
      onViewModelReady: (viewModel) => viewModel..initData(),
      builder: (context, viewModel, child) {
        return StreamBuilder<bool>(
          stream: viewModel.loadingSubject.stream,
          builder: (context, snapshot) {
            bool isLoading = snapshot.data ?? false;
            return LoadingFullScreen(
              loading: isLoading,
              child: Scaffold(
                key: viewModel.scaffoldKey,
                body: AppBody(
                  child: AppContent(
                    menuBarBuilder: (stream) => AppMenuBar(tabObserveStream: stream),
                    headerBuilder: (hasInternet) => _buildHeader(context, viewModel, hasInternet),
                    childBuilder: (hasInternet) => hasInternet
                        ? GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              viewModel.isTypingTitle
                                  .add(viewModel.titleController.text.trim().isNotEmpty);
                              viewModel.isTypingComment
                                  .add(viewModel.commentController.text.trim().isNotEmpty);
                              viewModel.isTypingPlace
                                  .add(viewModel.placeController.text.trim().isNotEmpty);
                            },
                            child: _buildBody(context, viewModel),
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AddEventViewModel viewModel, bool hasInternet) {
    return Container(
      height: AppConstants.appBarHeight,
      width: double.maxFinite,
      padding: const EdgeInsets.only(left: 12, right: 14, top: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Bounceable(
            onTap: () {},
            child: IconButton(
              onPressed: viewModel.goBack,
              icon: Image.asset(
                AppImages.icCloseAddEvent,
                width: 16,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Spacer(),
          Container(
            height: 50,
            padding: const EdgeInsets.only(bottom: 6),
            child: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                AppUtils.openLink(AppConstants.eventLauncherLink);
              },
              child: Image.asset(AppImages.icEvent_g),
            ),
          ),
          const Spacer(),
          if (hasInternet)
            Bounceable(
              onTap: () {},
              child: IconButton(
                onPressed: viewModel.createEvent,
                icon: Image.asset(
                  AppImages.icAccept,
                  height: 14,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AddEventViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildWriteTitle(context, viewModel),
            _buildStartDateHour(context, viewModel),
            _buildEndDateHour(context, viewModel),
            _buildWriteAComment(context, viewModel),
            _buildTagSomeone(context, viewModel),
            _buildPlace(context, viewModel),
            _buildAlarm(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildWriteTitle(BuildContext context, AddEventViewModel viewModel) {
    return SizedBox(
      height: 65,
      child: Row(
        children: [
          StreamBuilder<bool?>(
            stream: viewModel.isTypingTitle,
            builder: (context, snapshot) {
              final enableAnim = snapshot.data ?? false;
              return Container(
                alignment: Alignment.centerLeft,
                width: 45,
                child: enableAnim
                    ? Lottie.asset(
                        AppImages.animEvent,
                        width: 34,
                        repeat: false,
                      )
                    : Image.asset(
                        AppImages.icEvent,
                        width: 34,
                        fit: BoxFit.cover,
                      ),
              );
            },
          ),
          Expanded(
            child: WordCounterTextField(
              controller: viewModel.titleController,
              focusNode: viewModel.titleFocusNode,
              hintText: allTranslations.text(AppLanguages.writeTitle),
              maxLength: 35,
              onTap: () {
                viewModel.isTypingComment.add(viewModel.commentController.text.trim().isNotEmpty);
                viewModel.isTypingPlace.add(viewModel.placeController.text.trim().isNotEmpty);
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  viewModel.isTypingTitle.add(false);
                }
              },
              onFieldSubmitted: (value) => viewModel.isTypingTitle.add(value.trim().isNotEmpty),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartDateHour(BuildContext context, AddEventViewModel viewModel) {
    return SizedBox(
      height: 65,
      child: Row(
        children: [
          StreamBuilder<bool?>(
            stream: viewModel.isTypingDate,
            builder: (context, snapshot) {
              bool isShowAnim = snapshot.data ?? false;
              return Container(
                alignment: Alignment.center,
                width: 45,
                padding: const EdgeInsets.only(right: 10),
                child: isShowAnim
                    ? Lottie.asset(
                        AppImages.animDate,
                        width: 22,
                        repeat: false,
                      )
                    : Image.asset(
                        AppImages.icDateHour,
                        width: 22,
                        fit: BoxFit.cover,
                      ),
              );
            },
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                viewModel.isTypingTitle.add(viewModel.titleController.text.trim().isNotEmpty);
                viewModel.isTypingComment.add(viewModel.commentController.text.trim().isNotEmpty);
                viewModel.isTypingPlace.add(viewModel.placeController.text.trim().isNotEmpty);
                _showDatePicker(viewModel);
              },
              child: StreamBuilder<String>(
                stream: viewModel.startDateHourSubject,
                builder: (context, snapshot) {
                  String startDate = snapshot.data ?? "";
                  return Text(
                    startDate.isEmpty ? allTranslations.text(AppLanguages.dateAndHour) : startDate,
                    style: TextStyle(
                      fontSize: AppFontSize.textDatePicker,
                      color: startDate.isEmpty ? AppColors.textPlaceHolder : AppColors.normal,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEndDateHour(BuildContext context, AddEventViewModel viewModel) {
    return StreamBuilder<String>(
      stream: viewModel.endDateHourSubject,
      builder: (context, snapshot) {
        var endDate = snapshot.data ?? "";
        return endDate.isEmpty
            ? const SizedBox()
            : Container(
                height: 25,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 45),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () => _showDatePicker(viewModel),
                        child: Text(
                          endDate,
                          style: TextStyle(
                            fontSize: AppFontSize.textDatePicker,
                            color: AppColors.normal,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }

  Widget _buildWriteAComment(BuildContext context, AddEventViewModel viewModel) {
    return Container(
      height: 65,
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: <Widget>[
          StreamBuilder<bool?>(
            stream: viewModel.isTypingComment,
            builder: (context, snapshot) {
              final enableAnim = snapshot.data ?? false;
              return Container(
                alignment: Alignment.centerLeft,
                width: 45,
                padding: const EdgeInsets.only(left: 4, bottom: 7),
                child: enableAnim
                    ? Lottie.asset(
                        AppImages.animComment,
                        width: 30,
                        repeat: false,
                      )
                    : Image.asset(
                        AppImages.icCommentActive,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
              );
            },
          ),
          Expanded(
            child: WordCounterTextField(
              controller: viewModel.commentController,
              focusNode: viewModel.commentFocusNode,
              hintText: allTranslations.text(AppLanguages.writeAComment),
              maxLength: 100,
              onTap: () {
                viewModel.isTypingTitle.add(viewModel.titleController.text.trim().isNotEmpty);
                viewModel.isTypingPlace.add(viewModel.placeController.text.trim().isNotEmpty);
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  viewModel.isTypingComment.add(false);
                }
              },
              onFieldSubmitted: (value) => viewModel.isTypingComment.add(value.trim().isNotEmpty),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagSomeone(BuildContext context, AddEventViewModel viewModel) {
    return SizedBox(
      height: 65,
      child: Row(
        children: <Widget>[
          StreamBuilder<bool?>(
            stream: viewModel.isTagSomeOne,
            builder: (context, snapshot) {
              final enableAnim = snapshot.data ?? false;
              return Container(
                alignment: Alignment.center,
                width: 45,
                padding: const EdgeInsets.only(right: 10),
                child: enableAnim
                    ? Lottie.asset(
                        AppImages.animTagSomeOne,
                        width: 22,
                        repeat: false,
                      )
                    : Image.asset(
                        AppImages.icTagSomeOne,
                        width: 22,
                        fit: BoxFit.cover,
                      ),
              );
            },
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                viewModel.isTypingTitle.add(viewModel.titleController.text.trim().isNotEmpty);
                viewModel.isTypingComment.add(viewModel.commentController.text.trim().isNotEmpty);
                viewModel.isTypingPlace.add(viewModel.placeController.text.trim().isNotEmpty);
                Navigator.pushNamed(
                  context,
                  Routers.CONTACTS,
                  arguments: viewModel.contacts,
                ).then((value) {
                  viewModel.isTagSomeOne.add(value is List<Contact> && value.isNotEmpty);
                  viewModel.setContacts(value as List<Contact>? ?? []);
                });
              },
              child: StreamBuilder<String>(
                stream: viewModel.contactSubject,
                builder: (context, snapShot) {
                  var data = snapShot.data ?? "";
                  return Text(
                    data.isEmpty ? allTranslations.text(AppLanguages.tagSomeone) : data,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.textDatePicker,
                      fontWeight: FontWeight.normal,
                      color: data.isEmpty ? AppColors.textPlaceHolder : AppColors.normal,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlace(BuildContext context, AddEventViewModel viewModel) {
    return Container(
      height: 65,
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          StreamBuilder<bool?>(
            stream: viewModel.isTypingPlace,
            builder: (context, snapshot) {
              final enableAnim = snapshot.data ?? false;
              return Container(
                alignment: Alignment.center,
                width: 45,
                padding: const EdgeInsets.only(right: 10, bottom: 8),
                child: enableAnim
                    ? Lottie.asset(
                        AppImages.animPlace,
                        height: 41.4,
                        repeat: false,
                      )
                    : Image.asset(
                        AppImages.icPlace,
                        width: 15.5,
                        fit: BoxFit.cover,
                      ),
              );
            },
          ),
          Expanded(
            child: WordCounterTextField(
              controller: viewModel.placeController,
              focusNode: viewModel.placeFocusNode,
              hintText: allTranslations.text(AppLanguages.place),
              maxLength: 30,
              onTap: () {
                viewModel.isTypingTitle.add(viewModel.titleController.text.trim().isNotEmpty);
                viewModel.isTypingComment.add(viewModel.commentController.text.trim().isNotEmpty);
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  viewModel.isTypingPlace.add(false);
                }
              },
              onFieldSubmitted: (value) => viewModel.isTypingPlace.add(value.trim().isNotEmpty),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarm(BuildContext context, AddEventViewModel viewModel) {
    return Container(
      height: 65,
      child: Row(
        children: <Widget>[
          StreamBuilder<bool?>(
            stream: viewModel.isSelectAlarm,
            builder: (context, snapshot) {
              final enableAnim = snapshot.data ?? false;
              return Container(
                alignment: Alignment.center,
                width: 45,
                padding: const EdgeInsets.only(right: 10),
                child: enableAnim
                    ? Lottie.asset(
                        AppImages.animAlarm,
                        width: 22,
                        repeat: false,
                      )
                    : Image.asset(
                        AppImages.icAlarm,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
              );
            },
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                viewModel.isTypingTitle.add(viewModel.titleController.text.trim().isNotEmpty);
                viewModel.isTypingComment.add(viewModel.commentController.text.trim().isNotEmpty);
                viewModel.isTypingPlace.add(viewModel.placeController.text.trim().isNotEmpty);
                _showTimeInAlarmDialog(context, viewModel);
              },
              child: StreamBuilder<List<TimeInAlarm>>(
                stream: viewModel.alarmsSubject,
                builder: (context, snapshot) {
                  var data = snapshot.data ?? <TimeInAlarm>[];
                  return Text(
                    data.isEmpty
                        ? allTranslations.text(AppLanguages.alarm)
                        : data.map<String>((item) => item.name ?? "").toList().join("; "),
                    style: TextStyle(
                      fontSize: AppFontSize.textDatePicker,
                      color: data.isEmpty ? AppColors.textPlaceHolder : AppColors.normal,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showTimeInAlarmDialog(BuildContext context, AddEventViewModel viewModel) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: AppColors.bgColor,
      context: context,
      builder: (BuildContext context) {
        return TimeInAlarmDialog(
          height: 290,
          itemsSelected: viewModel.timesInAlarm,
          onCallBack: (timesInAlarm) {
            viewModel.isSelectAlarm.add(timesInAlarm.isNotEmpty);
            viewModel.setTimeInAlarm(timesInAlarm);
          },
        );
      },
    );
  }

  void _showDatePicker(AddEventViewModel viewModel) {
    final height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        DateTime? startDate =
            viewModel.startDateHour == null ? DateTime.now() : viewModel.startDateHour;
        DateTime? endDate = viewModel.endDateHour;

        return DateHourPickerDialog(
          height: height / 2,
          startHour: startDate?.hour ?? 0,
          startMinute: startDate?.minute ?? 0,
          startDay: startDate?.day ?? 0,
          startMonth: startDate?.month ?? 0,
          startYear: startDate?.year ?? 0,
          endHour: endDate?.hour ?? 0,
          endMinute: endDate?.minute ?? 0,
          endDay: endDate?.day ?? 0,
          endMonth: endDate?.month ?? 0,
          endYear: endDate?.year ?? 0,
          onCallBack: viewModel.setDateHour,
        );
      },
    ).then((value) => viewModel.isTypingDate.add(viewModel.startDateHour != null));
  }
}
