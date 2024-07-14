import 'dart:io';

import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart' hide DatePickerDialog;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/core/models/gender.dart';
import 'package:mou_app/core/responses/register_response.dart';
import 'package:mou_app/helpers/common_helper.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/edit_profile/edit_profile_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_body.dart';
import 'package:mou_app/ui/widgets/app_content.dart';
import 'package:mou_app/ui/widgets/choose_photo_dialog.dart';
import 'package:mou_app/ui/widgets/country_phone_code_dialog.dart';
import 'package:mou_app/ui/widgets/date_picker/date_picker_dialog.dart';
import 'package:mou_app/ui/widgets/loading_full_screen.dart';
import 'package:mou_app/ui/widgets/menu/app_menu_bar.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:mou_app/utils/app_shared.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<EditProfileViewModel>(
      viewModel: EditProfileViewModel(userRepository: Provider.of(context)),
      onViewModelReady: (viewModel) => viewModel,
      builder: (context, viewModel, child) => StreamBuilder<bool>(
        stream: viewModel.loadingSubject,
        builder: (context, snapshot) {
          var isLoading = snapshot.data ?? false;
          return LoadingFullScreen(
            loading: isLoading,
            child: Scaffold(
              body: AppBody(
                child: _buildContentContainer(context, viewModel),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentContainer(
    BuildContext context,
    EditProfileViewModel viewModel,
  ) {
    return AppContent(
      menuBarBuilder: (stream) => AppMenuBar(tabObserveStream: stream),
      childBuilder: (hasInternet) => Stack(
        children: <Widget>[
          _buildContent(context, viewModel, hasInternet),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: AppConstants.appBarHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      alignment: FractionalOffset.bottomCenter,
                      image: AssetImage(AppImages.bgCalendarNews),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 10, right: 16, bottom: 16, left: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(AppImages.icArrowRight, width: 13),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      if (hasInternet)
                        IconButton(
                          icon: StreamBuilder<bool>(
                            stream: viewModel.isEditingSubject,
                            builder: (context, snapShot) {
                              var isEditing = snapShot.data ?? false;
                              if (isEditing) {
                                return Image.asset(
                                  AppImages.icAccept,
                                  height: 14,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Image.asset(
                                  AppImages.icEdit,
                                  height: 20,
                                  fit: BoxFit.cover,
                                );
                              }
                            },
                          ),
                          onPressed: viewModel.onChangeEditing,
                        ),
                    ],
                  ),
                ),
                Image.asset(
                  AppImages.icProfile,
                  height: 35,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, EditProfileViewModel viewModel, bool hasInternet) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(gradient: AppColors.bgGradient),
      child: SingleChildScrollView(
        child: StreamBuilder<RegisterResponse>(
          stream: AppShared.getUser().asStream(),
          builder: (context, snapShot) {
            var user = snapShot.data ?? null;
            return StreamBuilder<bool>(
              stream: viewModel.isEditingSubject,
              builder: (context, snapshot) {
                var isEditing = snapshot.data ?? false;
                return Column(
                  children: <Widget>[
                    const SizedBox(height: AppConstants.appBarHeight - 40),
                    InkWell(
                      onTap: () => _showChoosePhotoDialog(
                        context,
                        viewModel,
                        isEditing,
                      ),
                      child: StreamBuilder<File>(
                        stream: viewModel.avatarFileSubject,
                        builder: (context, snapshot) {
                          var avatarFile = snapshot.data ?? null;
                          return Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Image.asset(
                                AppImages.bgProfile,
                                height: 290,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                height: 230,
                                margin: EdgeInsets.only(top: 30),
                                width: MediaQuery.of(context).size.width - 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: avatarFile != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(11),
                                        child: Image.file(
                                          avatarFile,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : user == null || user.avatar == null
                                        ? const SizedBox()
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(11),
                                            child: Image.network(
                                              user.avatar ?? "",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                              ),
                              StreamBuilder<bool>(
                                stream: viewModel.avatarLoadingSubject,
                                builder: (context, snapshot) {
                                  var isAvatarLoading = snapshot.data ?? false;
                                  if (isAvatarLoading) {
                                    return LoadingAnimationWidget.staggeredDotsWave(
                                        color: AppColors.mainColor, size: 40);
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      child: Column(
                        children: [
                          _buildPhoneNumber(
                            context,
                            viewModel,
                            user?.dialCode ?? "",
                            user?.phoneNumber ?? "",
                            isEditing,
                          ),
                          const SizedBox(height: 22),
                          _buildName(
                            context,
                            viewModel,
                            user?.name ?? "",
                            isEditing,
                          ),
                          const SizedBox(height: 22),
                          _buildBirthDay(
                            context,
                            viewModel,
                            user?.birthDay ?? "",
                            isEditing,
                          ),
                          const SizedBox(height: 22),
                          _buildGender(
                            context,
                            viewModel,
                            user?.gender ?? 0,
                            isEditing,
                          ),
                          const SizedBox(height: 22),
                          _buildEmail(context, viewModel, user?.email ?? "", isEditing),
                          SizedBox(height: isEditing ? 0 : 22),
                          _buildLiveIn(
                            context,
                            viewModel,
                            user?.fullAddress ?? "",
                            isEditing,
                          ),
                          const SizedBox(height: 22),
                          if (isEditing) ...[
                            _buildCountry(context, viewModel, isEditing),
                            const SizedBox(height: 22),
                            _buildCity(context, viewModel, isEditing),
                            const SizedBox(height: 22),
                          ],
                          if (hasInternet) _buildBtnImport(context, viewModel),
                          if (hasInternet && isEditing)
                            OutlinedButton(
                              onPressed: viewModel.deleteAccount,
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                side: BorderSide.none,
                                minimumSize: Size(165, 30),
                                backgroundColor: AppColors.redColor,
                              ),
                              child: Text(
                                S.text(AppLanguages.deleteAccount),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          const SizedBox(height: 22),
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBtnImport(BuildContext context, EditProfileViewModel viewModel) {
    return OutlinedButton(
      onPressed: () => Navigator.pushNamed(context, Routers.IMPORT_CONTACT_DEVICE),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        side: BorderSide.none,
        minimumSize: Size(165, 30),
        backgroundColor: AppColors.mainColor,
      ),
      child: Text(
        allTranslations.text(AppLanguages.importContacts),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildLiveIn(
      BuildContext context, EditProfileViewModel viewModel, String fullAddress, bool isEditing) {
    return isEditing
        ? SizedBox()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 130,
                child: Text(
                  allTranslations.text(AppLanguages.livesIn),
                  style: TextStyle(
                    fontSize: AppFontSize.nameList,
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "$fullAddress",
                    style: TextStyle(
                      fontSize: AppFontSize.textQuestion,
                      color: AppColors.normal,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              )
            ],
          );
  }

  Widget _buildCity(BuildContext context, EditProfileViewModel viewModel, bool isEditing) {
    var cityTrans = allTranslations.text(AppLanguages.city);
    return !isEditing
        ? SizedBox()
        : Row(
            children: <Widget>[
              Container(
                width: 130,
                child: Text("${cityTrans[0].toUpperCase()}${cityTrans.substring(1)}",
                    style: TextStyle(
                        fontSize: AppFontSize.nameList,
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        TextFormField(
                          controller: viewModel.cityController,
                          decoration: InputDecoration(
                              hintText: allTranslations.text(AppLanguages.city),
                              isDense: true,
                              border: InputBorder.none),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                              fontSize: AppFontSize.textQuestion,
                              color: AppColors.normal,
                              fontWeight: FontWeight.w500),
                          onFieldSubmitted: (text) {},
                        ),
                        // Container(
                        //   width: double.maxFinite,
                        //   height: 0.5,
                        //   color: AppColors.normal.withOpacity(0.5),
                        // )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
  }

  Widget _buildCountry(BuildContext context, EditProfileViewModel viewModel, bool isEditing) {
    var countryTrans = allTranslations.text(AppLanguages.country);
    return !isEditing
        ? SizedBox()
        : Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                width: 130,
                child: Text("${countryTrans[0].toUpperCase()}${countryTrans.substring(1)}",
                    style: TextStyle(
                        fontSize: AppFontSize.nameList,
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Align(
                  alignment: isEditing ? Alignment.centerLeft : Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      if (isEditing) {
                        this._showCountryDialog(context, viewModel);
                      }
                    },
                    child: Column(
                      crossAxisAlignment:
                          isEditing ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: <Widget>[
                        StreamBuilder<CountryPhoneCode>(
                          stream: viewModel.countrySubject,
                          builder: (context, snapshot) {
                            var country = snapshot.data ?? null;
                            return Text(
                              country?.name ?? "",
                              style: TextStyle(
                                fontSize: AppFontSize.textQuestion,
                                color: AppColors.normal,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
  }

  Widget _buildEmail(
      BuildContext context, EditProfileViewModel viewModel, String email, bool isEditing) {
    return Row(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          width: 130,
          child: Text(allTranslations.text(AppLanguages.eMail),
              style: TextStyle(
                  fontSize: AppFontSize.nameList,
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                if (isEditing) {}
              },
              child: Column(
                crossAxisAlignment: isEditing ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: <Widget>[
                  isEditing
                      ? TextFormField(
                          controller: viewModel.emailController,
                          decoration: InputDecoration(
                              hintText: allTranslations.text(AppLanguages.email),
                              isDense: true,
                              border: InputBorder.none),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                              fontSize: AppFontSize.textQuestion,
                              color: AppColors.normal,
                              fontWeight: FontWeight.w500),
                          onFieldSubmitted: (text) {},
                        )
                      : Text(
                          "$email",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: AppFontSize.textQuestion,
                              color: AppColors.normal,
                              fontWeight: FontWeight.w500),
                        ),
                  // Container(
                  //   width: double.maxFinite,
                  //   height: isEditing ? 0.5 : 0,
                  //   color: AppColors.normal.withOpacity(0.5),
                  // )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildGender(
      BuildContext context, EditProfileViewModel viewModel, int? type, bool isEditing) {
    final name = type == null ? "" : CommonHelper.getNameGender(type);
    var genderTrans = allTranslations.text(AppLanguages.gender);
    return Row(
      children: <Widget>[
        Container(
          width: 130,
          child: Text(
            "${genderTrans[0].toUpperCase()}${genderTrans.substring(1)}",
            style: TextStyle(
              fontSize: AppFontSize.nameList,
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: isEditing ? Alignment.centerLeft : Alignment.centerRight,
            child: InkWell(
              onTap: () {
                if (isEditing) {
                  _showGenders(context, viewModel);
                }
              },
              child: Column(
                crossAxisAlignment: isEditing ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: <Widget>[
                  StreamBuilder<Gender>(
                    stream: viewModel.genderSubject,
                    builder: (context, snapshot) {
                      var gender = snapshot.data ?? null;
                      return Text(
                        isEditing
                            ? gender != null
                                ? gender.name
                                : name
                            : name,
                        style: TextStyle(
                          fontSize: AppFontSize.textQuestion,
                          color: AppColors.normal,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBirthDay(
      BuildContext context, EditProfileViewModel viewModel, String birthDay, bool isEditing) {
    DateFormat formatter = new DateFormat(AppConstants.dateFormat);
    String formatted = "";
    if (birthDay.isNotEmpty) {
      var parsedDate = DateTime.parse('$birthDay 00:00:00.000');
      formatted = formatter.format(parsedDate);
    }

    return Row(
      children: <Widget>[
        SizedBox(
          width: 130,
          child: Text(
            allTranslations.text(AppLanguages.dateOfBirth),
            style: TextStyle(
              fontSize: AppFontSize.nameList,
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: isEditing ? Alignment.centerLeft : Alignment.centerRight,
            child: InkWell(
              onTap: () {
                if (isEditing) {
                  _showDatePicker(context, viewModel);
                }
              },
              child: Column(
                crossAxisAlignment: isEditing ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: <Widget>[
                  StreamBuilder<DateTime>(
                    stream: viewModel.birthOfDateSubject,
                    builder: (context, snapshot) {
                      var birthOfDate = snapshot.data ?? null;
                      String birthDayFormatted = "";
                      if (birthOfDate != null) {
                        birthDayFormatted = formatter.format(birthOfDate);
                      }
                      return Text(
                        isEditing ? birthDayFormatted : "$formatted",
                        style: TextStyle(
                          fontSize: AppFontSize.textQuestion,
                          color: AppColors.normal,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildName(
      BuildContext context, EditProfileViewModel viewModel, String name, bool isEditing) {
    var nameTrans = allTranslations.text(AppLanguages.name);
    return Row(
      children: <Widget>[
        Container(
          width: 130,
          child: Text(
            "${nameTrans[0].toUpperCase()}${nameTrans.substring(1)}",
            style: TextStyle(
              fontSize: AppFontSize.nameList,
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                if (isEditing) {}
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  isEditing
                      ? TextFormField(
                          onFieldSubmitted: (text) {},
                          controller: viewModel.nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: allTranslations.text(AppLanguages.name),
                            hintStyle: TextStyle(
                              fontSize: AppFontSize.textQuestion,
                              fontWeight: FontWeight.normal,
                              color: AppColors.normal,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                            fontSize: AppFontSize.textQuestion,
                            color: AppColors.normal,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          "$name",
                          style: TextStyle(
                            fontSize: AppFontSize.textQuestion,
                            color: AppColors.normal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  // Container(
                  //   width: double.maxFinite,
                  //   height: isEditing ? 0.5 : 0,
                  //   color: AppColors.normal.withOpacity(0.5),
                  // )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPhoneNumber(BuildContext context, EditProfileViewModel viewModel, String dialCode,
      String phoneNumber, bool isEditing) {
    return Row(
      children: <Widget>[
        Container(
          width: 130,
          child: Text(
            allTranslations.text(AppLanguages.loginNumber),
            style: TextStyle(
                fontSize: AppFontSize.nameList,
                color: AppColors.mainColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Align(
            alignment: isEditing ? Alignment.centerLeft : Alignment.centerRight,
            child: Text(
              "$dialCode$phoneNumber",
              style: TextStyle(
                  fontSize: AppFontSize.textQuestion,
                  color: AppColors.normal,
                  fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }

  void _showDatePicker(BuildContext context, EditProfileViewModel viewModel) {
    final height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          var birthOfDate = viewModel.birthOfDateSubject.valueOrNull;
          return DatePickerDialog(
              height: height / 3,
              day: birthOfDate != null ? birthOfDate.day : DateTime.now().day,
              month: birthOfDate != null ? birthOfDate.month : DateTime.now().month,
              year: birthOfDate != null ? birthOfDate.year : DateTime.now().year,
              onCallBack: (day, month, year) {
                print("day $day month $month year $year");
                viewModel.changeBirthOfDate(day, month, year);
              });
        });
  }

  void _showGenders(BuildContext context, EditProfileViewModel viewModel) {
    showModalBottomSheet(
        backgroundColor: AppColors.bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 120,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: 120,
                  child: AnimationList(
                    duration: AppConstants.ANIMATION_LIST_DURATION,
                    reBounceDepth: AppConstants.ANIMATION_LIST_RE_BOUNCE_DEPTH,
                    children: viewModel.genders.map((e) {
                      return TextButton(
                        onPressed: () {
                          viewModel.genderSubject.add(e);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            e.name,
                            style: TextStyle(
                              color: AppColors.normal,
                              fontWeight: viewModel.genderSubject.valueOrNull != null &&
                                      e.type == viewModel.genderSubject.valueOrNull?.type
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: AppFontSize.textDatePicker,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _showCountryDialog(BuildContext context, EditProfileViewModel viewModel) {
    showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return SizedBox();
      },
      context: context,
      transitionBuilder: (context, animation1, animation2, widget) {
        return Transform.scale(
          scale: animation1.value,
          child: Opacity(
            opacity: animation1.value,
            child: WillPopScope(
              onWillPop: () async => false,
              child: CountryPhoneCodeDialog(
                phoneCodeCallBack: viewModel.changeCountry,
                isPhoneCode: false,
                title: allTranslations.text(AppLanguages.countries),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showChoosePhotoDialog(
      BuildContext context, EditProfileViewModel viewModel, bool isEditing) {
    bool loading = viewModel.avatarLoadingSubject.valueOrNull ?? false;
    if (!loading && isEditing) {
      showDialog(
        context: context,
        builder: (context) => PickerPhotoDialog(onSelected: (file) async {
          await viewModel.onSelectPhoto(file);
        }),
      );
    }
  }
}
