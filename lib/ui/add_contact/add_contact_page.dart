import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/core/models/user.dart';
import 'package:mou_app/helpers/reg_ex_input_formatter.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/helpers/validators_helper.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/widgets/app_body.dart';
import 'package:mou_app/ui/widgets/app_content.dart';
import 'package:mou_app/ui/widgets/app_loading.dart';
import 'package:mou_app/ui/widgets/choose_photo_dialog.dart';
import 'package:mou_app/ui/widgets/contact_field.dart';
import 'package:mou_app/ui/widgets/country_phone_code_dialog.dart';
import 'package:mou_app/ui/widgets/loading_full_screen.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:provider/provider.dart';
import 'add_contact_viewmodel.dart';

class AddContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<AddContactViewModel>(
      viewModel: AddContactViewModel(Provider.of(context)),
      onViewModelReady: (viewModel) => viewModel.fetchDataFlags(),
      builder: (context, viewModel, child) => StreamBuilder<bool>(
        stream: viewModel.loadingSubject,
        builder: (context, snapshot) {
          return LoadingFullScreen(
            loading: snapshot.data,
            child: Scaffold(
              key: viewModel.scaffoldKey,
              body: AppBody(
                child: AppContent(
                  headerBuilder: (_) => _buildHeader(context, viewModel),
                  childBuilder: (_) => StreamBuilder<bool>(
                    stream: viewModel.searchingSubject,
                    builder: (context, snapshot) {
                      bool searching = snapshot.data ?? false;
                      return Column(
                        children: <Widget>[
                          _buildSearch(viewModel),
                          searching ? _buildContacts(viewModel) : _buildFormContact(viewModel)
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AddContactViewModel viewModel) {
    return Container(
      height: AppConstants.appBarHeight,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Image.asset(
              AppImages.icClose,
              color: Colors.white,
              width: 17,
              fit: BoxFit.cover,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
          ),
          StreamBuilder<bool>(
            stream: viewModel.searchingSubject,
            builder: (context, snapshot) {
              bool searching = snapshot.data ?? false;
              return searching
                  ? const SizedBox()
                  : IconButton(
                      icon: Image.asset(AppImages.icAccept),
                      onPressed: viewModel.addContact,
                    );
            },
          )
        ],
      ),
    );
  }

  Widget _buildSearch(AddContactViewModel viewModel) {
    return Container(
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xfff7f7f8),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        controller: viewModel.searchController,
        textInputAction: TextInputAction.search,
        autofocus: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          suffixIcon: Icon(Icons.search, color: Color(0xffbebdbd)),
          isDense: false,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContact(AddContactViewModel viewModel) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 38.0, right: 20, bottom: 20),
            child: StreamBuilder<bool>(
                stream: viewModel.autoValidateForm,
                builder: (context, snapshot) {
                  return Form(
                    key: viewModel.formKey,
                    autovalidateMode: (snapshot.data ?? false)
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5),
                        Text(
                          allTranslations.text(AppLanguages.or),
                          style: TextStyle(fontSize: 18, color: Color(0xff939598)),
                        ),
                        SizedBox(height: 10),
                        ContactField(
                          onTap: () => _choosePhoto(context, viewModel),
                          controller: viewModel.photoController,
                          textInputAction: TextInputAction.next,
                          validator: ValidatorsHelper.validatePhoto(),
                          pathIcon: AppImages.icAccount,
                          keyHint: AppLanguages.addPhoto,
                          readOnly: true,
                        ),
                        SizedBox(height: 10),
                        ContactField(
                          initFocusNode: viewModel.nameFocusNode,
                          nextFocusNode: viewModel.phoneFocusNode,
                          textInputAction: TextInputAction.next,
                          validator: ValidatorsHelper.validateName(),
                          pathIcon: AppImages.icEvent,
                          keyHint: AppLanguages.name,
                          onSaved: (p0) {
                            viewModel.savedName(p0 ?? "");
                          },
                        ),
                        SizedBox(height: 10),
                        _buildPhoneField(context, viewModel),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildContacts(AddContactViewModel viewModel) {
    return Expanded(
      child: StreamBuilder<List<User>>(
        stream: viewModel.usersSubject,
        builder: (context, snapshot) {
          final users = snapshot.data;
          if (users == null) return const AppLoadingIndicator();
          if (users.length == 0) return Container();
          return ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: AnimationList(
              duration: AppConstants.ANIMATION_LIST_DURATION,
              reBounceDepth: AppConstants.ANIMATION_LIST_RE_BOUNCE_DEPTH,
              padding: EdgeInsets.all(0),
              children: users.map((user) {
                return user.id == null
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: AppLoadingIndicator(),
                      )
                    : _buildItemContact(context, viewModel, user);
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemContact(BuildContext context, AddContactViewModel viewModel, User user) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: 90,
            height: 56,
            margin: EdgeInsets.only(left: 22, right: 14),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(3)),
              image: DecorationImage(
                image: NetworkImage(user.avatar ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.name ?? "",
                  style: TextStyle(fontSize: 18, color: Color(0xff939598)),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.fullAddress ?? "",
                  style: TextStyle(fontSize: 18, color: Color(0xff939598)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => viewModel.linkContact(user),
          )
        ],
      ),
    );
  }

  void _choosePhoto(BuildContext context, AddContactViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => PickerPhotoDialog(
        onSelected: viewModel.savedPhoto,
        aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
        initAspectRatio: CropAspectRatioPreset.ratio4x3,
        presets: [CropAspectRatioPreset.ratio4x3],
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context, AddContactViewModel viewModel) {
    return ContactField(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(AppImages.icCalling, width: 32, height: 28, fit: BoxFit.scaleDown),
          SizedBox(width: 18),
          _buildButtonPhoneCode(context, viewModel)
        ],
      ),
      initFocusNode: viewModel.phoneFocusNode,
      keyboardType: TextInputType.phone,
      inputFormatters: [RegExInputFormatter.onlyNumber()],
      validator: ValidatorsHelper.validatePhone(),
      keyHint: AppLanguages.phone,
      onSaved: (p0) {
        viewModel.savedPhoneNumber(p0 ?? "");
      },
    );
  }

  Widget _buildButtonPhoneCode(BuildContext context, AddContactViewModel viewModel) {
    return InkWell(
      splashColor: Colors.black,
      onTap: () => _showPhoneCodeDialog(context, viewModel),
      child: StreamBuilder<CountryPhoneCode>(
        stream: viewModel.phoneCodeSubject,
        builder: (context, snapshot) {
          final phoneCode = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              phoneCode != null ? phoneCode.dialCode : "+1",
              style: TextStyle(fontSize: 17, color: Color(0xff8B8986)),
            ),
          );
        },
      ),
    );
  }

  void _showPhoneCodeDialog(BuildContext context, AddContactViewModel viewModel) {
    showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => SizedBox(),
      context: context,
      transitionBuilder: (context, animation1, animation2, widget) {
        return Transform.scale(
          scale: animation1.value,
          child: Opacity(
            opacity: animation1.value,
            child: WillPopScope(
              onWillPop: () async => false,
              child: CountryPhoneCodeDialog(
                phoneCodeCallBack: viewModel.changePhoneCode,
                title: allTranslations.text(AppLanguages.phoneCodes),
                isPhoneCode: false,
              ),
            ),
          ),
        );
      },
    );
  }
}
