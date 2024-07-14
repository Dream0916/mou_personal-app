import 'dart:io';

import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/core/models/gender.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/register_profile/register_profile_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_loading.dart';
import 'package:mou_app/ui/widgets/choose_photo_dialog.dart';
import 'package:mou_app/ui/widgets/country_phone_code_dialog.dart';
import 'package:mou_app/ui/widgets/date_picker/date_picker_dialog.dart' as dt;
import 'package:mou_app/ui/widgets/input_text_field_container.dart';
import 'package:mou_app/ui/widgets/loading_full_screen.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_globals.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:provider/provider.dart';

class RegisterProfileArguments {
  final String phone;
  final String dialCode;

  RegisterProfileArguments({
    required this.phone,
    required this.dialCode,
  });
}

class RegisterProfilePage extends StatelessWidget {
  final RegisterProfileArguments arguments;

  RegisterProfilePage({required this.arguments});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<RegisterProfileViewModel>(
      viewModel: RegisterProfileViewModel(
        authRepository: Provider.of(context),
        arguments: arguments,
      ),
      onViewModelReady: (viewModel) => viewModel,
      builder: (context, viewModel, child) {
        return StreamBuilder<bool>(
          stream: viewModel.loadingSubject,
          builder: (context, snapshot) {
            bool isLoading = snapshot.data ?? false;
            return LoadingFullScreen(
              loading: isLoading,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                key: viewModel.scaffoldKey,
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    viewModel.changeFinishBackground();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.bgRegister),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: _buildBody(context, viewModel),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, RegisterProfileViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              onPressed: () => AppGlobals.logout(context),
              icon: Image.asset(
                AppImages.icClose,
                height: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 49),
            child: Column(
              children: <Widget>[
                _buildAvatar(context, viewModel),
                const SizedBox(height: 20),
                _buildInputName(context, viewModel),
                const SizedBox(height: 20),
                _buildInputBirthDay(context, viewModel),
                const SizedBox(height: 20),
                _buildInputGender(context, viewModel),
                const SizedBox(height: 20),
                _buildInputEmail(context, viewModel),
                const SizedBox(height: 20),
                _buildInputCountry(context, viewModel),
                const SizedBox(height: 20),
                _buildInputCity(context, viewModel),
                const SizedBox(height: 30),
                _buildButtonFinish(context, viewModel),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, RegisterProfileViewModel viewModel) {
    final width = MediaQuery.of(context).size.width;
    final widthContainer = width - 100;
    final heightContainer = widthContainer / 4 * 2.5;
    return InkWell(
      onTap: () {
        _showChoosePhotoDialog(context, viewModel);
        viewModel.changeFinishBackground();
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          StreamBuilder<File?>(
            stream: viewModel.avatarFileSubject,
            builder: (context, snapshot) {
              File? avatar = snapshot.data;
              return Container(
                width: widthContainer,
                height: heightContainer,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 5),
                  )
                ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: avatar != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          avatar,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(child: SvgPicture.asset(AppImages.icAddSVG)),
              );
            },
          ),
          StreamBuilder<bool?>(
            stream: viewModel.avatarLoadingSubject,
            builder: (context, snapShot) {
              bool loading = snapShot.data ?? false;
              if (loading) {
                return const AppLoadingIndicator();
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildInputName(BuildContext context, RegisterProfileViewModel viewModel) {
    return InputTextFieldContainer(
      child: TextFormField(
        focusNode: viewModel.nameFocusNode,
        controller: viewModel.nameController,
        style: TextStyle(
          color: AppColors.normal,
          fontWeight: FontWeight.w500,
          fontSize: AppFontSize.textQuestion,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: allTranslations.text(AppLanguages.name),
          hintStyle: TextStyle(
            color: AppColors.textPlaceHolder,
            fontSize: AppFontSize.textQuestion,
            fontWeight: FontWeight.normal,
          ),
          contentPadding: EdgeInsets.only(left: 5),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onSaved: viewModel.changeFinishBackground(),
        onChanged: viewModel.changeFinishBackground(),
        onFieldSubmitted: (text) {
          _showDatePicker(context, viewModel);
          viewModel.changeFinishBackground();
        },
      ),
    );
  }

  Widget _buildInputBirthDay(BuildContext context, RegisterProfileViewModel viewModel) {
    return InkWell(
      onTap: () {
        _showDatePicker(context, viewModel);
        viewModel.changeFinishBackground();
      },
      child: InputTextFieldContainer(
        child: StreamBuilder<DateTime?>(
          stream: viewModel.birthOfDateSubject,
          builder: (context, snapShot) {
            var birthOfDate = snapShot.data;
            if (snapShot.hasData) {
              var formatter = new DateFormat(AppConstants.dateFormat);
              String formatted = formatter.format(birthOfDate!);
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  formatted,
                  style: TextStyle(
                    color: AppColors.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: AppFontSize.textQuestion,
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  allTranslations.text(AppLanguages.dateOfBirth),
                  style: TextStyle(
                    fontSize: AppFontSize.textQuestion,
                    color: AppColors.textPlaceHolder,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildInputGender(BuildContext context, RegisterProfileViewModel viewModel) {
    return InkWell(
      onTap: () {
        _showGenders(context, viewModel);
        viewModel.changeFinishBackground();
      },
      child: InputTextFieldContainer(
        child: StreamBuilder<Gender?>(
          stream: viewModel.genderSubject,
          builder: (context, snapShot) {
            var gender = snapShot.data;
            if (snapShot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  gender?.name ?? "",
                  style: TextStyle(
                    color: AppColors.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: AppFontSize.textQuestion,
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  allTranslations.text(AppLanguages.gender),
                  style: TextStyle(
                    fontSize: AppFontSize.textQuestion,
                    color: AppColors.textPlaceHolder,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildInputEmail(BuildContext context, RegisterProfileViewModel viewModel) {
    return InputTextFieldContainer(
      child: TextFormField(
        focusNode: viewModel.emailFocusNode,
        controller: viewModel.emailController,
        style: TextStyle(
          color: AppColors.normal,
          fontWeight: FontWeight.w500,
          fontSize: AppFontSize.textQuestion,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: allTranslations.text(AppLanguages.email),
          hintStyle: TextStyle(
            color: AppColors.textPlaceHolder,
            fontSize: AppFontSize.textQuestion,
            fontWeight: FontWeight.normal,
          ),
          contentPadding: EdgeInsets.only(left: 5),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onSaved: viewModel.changeFinishBackground(),
        onChanged: viewModel.changeFinishBackground(),
        onFieldSubmitted: (text) => viewModel.changeFinishBackground(),
      ),
    );
  }

  Widget _buildInputCountry(BuildContext context, RegisterProfileViewModel viewModel) {
    return InkWell(
      onTap: () {
        _showCountryDialog(context, viewModel);
        viewModel.changeFinishBackground();
      },
      child: InputTextFieldContainer(
        child: StreamBuilder<CountryPhoneCode?>(
          stream: viewModel.countrySubject,
          builder: (context, snapShot) {
            var country = snapShot.data;
            if (snapShot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  country?.name ?? "",
                  style: TextStyle(
                    color: AppColors.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: AppFontSize.textQuestion,
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  allTranslations.text(AppLanguages.country),
                  style: TextStyle(
                    fontSize: AppFontSize.textQuestion,
                    color: AppColors.textPlaceHolder,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildInputCity(BuildContext context, RegisterProfileViewModel viewModel) {
    return InputTextFieldContainer(
      child: TextFormField(
        focusNode: viewModel.cityFocusNode,
        controller: viewModel.cityController,
        style: TextStyle(
            color: AppColors.normal,
            fontWeight: FontWeight.w500,
            fontSize: AppFontSize.textQuestion),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: allTranslations.text(AppLanguages.city),
            hintStyle: TextStyle(
                color: AppColors.textPlaceHolder,
                fontSize: AppFontSize.textQuestion,
                fontWeight: FontWeight.normal),
            contentPadding: EdgeInsets.only(left: 5)),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onSaved: viewModel.changeFinishBackground(),
        onChanged: viewModel.changeFinishBackground(),
        onFieldSubmitted: (text) => viewModel.changeFinishBackground(),
      ),
    );
  }

  Widget _buildButtonFinish(
    BuildContext context,
    RegisterProfileViewModel viewModel,
  ) {
    return StreamBuilder<bool>(
      stream: viewModel.finishBackgroundSubject,
      builder: (context, snapshot) {
        final isEnable = snapshot.data ?? false;
        return InkWell(
          onTap: isEnable ? viewModel.onFinish : null,
          child: Image.asset(
            AppImages.btnActiveLogin,
            height: 60,
            width: 60,
            fit: BoxFit.scaleDown,
          ),
        );
      },
    );
  }

  void _showDatePicker(BuildContext context, RegisterProfileViewModel viewModel) {
    final height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        backgroundColor: AppColors.bgColor,
        context: context,
        builder: (BuildContext context) {
          var birthOfDate = viewModel.birthOfDateSubject.valueOrNull;
          return dt.DatePickerDialog(
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

  void _showGenders(BuildContext context, RegisterProfileViewModel viewModel) {
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
                padding: const EdgeInsets.only(top: 10, left: 25, bottom: 10),
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
      },
    );
  }

  void _showCountryDialog(BuildContext context, RegisterProfileViewModel viewModel) {
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

  void _showChoosePhotoDialog(BuildContext context, RegisterProfileViewModel viewModel) {
    bool loading = viewModel.avatarLoadingSubject.valueOrNull ?? false;
    if (!loading) {
      showDialog(
        context: context,
        builder: (context) => PickerPhotoDialog(onSelected: (file) async {
          await viewModel.onSelectPhoto(file);
        }),
      );
    }
  }
}
