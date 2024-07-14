import 'dart:typed_data';

import 'package:animation_list/animation_list.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/import_contact_device/import_contact_device_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_body.dart';
import 'package:mou_app/ui/widgets/app_content.dart';
import 'package:mou_app/ui/widgets/app_loading.dart';
import 'package:mou_app/ui/widgets/loading_full_screen.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:provider/provider.dart';

class ImportContactDevicePage extends StatelessWidget {
  final bool isRegister;

  ImportContactDevicePage({this.isRegister = false});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ImportContactDeviceViewModel>(
      viewModel: ImportContactDeviceViewModel(
        contactRepository: Provider.of(context),
        permissionsService: Provider.of(context),
        isRegister: isRegister,
      ),
      onViewModelReady: (viewModel) => viewModel..initData(),
      builder: (context, viewModel, child) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          key: viewModel.scaffoldKey,
          backgroundColor: Colors.white,
          body: StreamBuilder<bool>(
            stream: viewModel.loadingSubject.stream,
            builder: (context, snapShot) {
              bool isLoading = snapShot.data ?? false;
              return LoadingFullScreen(
                loading: isLoading,
                child: AppBody(
                  child: AppContent(
                    headerBuilder: (hasInternet) => _buildHeader(context, viewModel, hasInternet),
                    childBuilder: (_) => _buildBody(context, viewModel),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, ImportContactDeviceViewModel viewModel, bool hasInternet) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 100,
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 17, left: 13, right: 5),
          child: Row(
            children: <Widget>[
              isRegister
                  ? const SizedBox()
                  : IconButton(
                      onPressed: viewModel.goBack,
                      icon: Image.asset(
                        AppImages.icCloseAddEvent,
                        width: 16,
                        fit: BoxFit.cover,
                      ),
                    ),
              const Spacer(),
              if (hasInternet)
                IconButton(
                  onPressed: viewModel.onSubmit,
                  icon: Image.asset(AppImages.icAccept, width: 23),
                  padding: const EdgeInsets.only(bottom: 10, right: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ImportContactDeviceViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      width: double.maxFinite,
      height: double.maxFinite,
      child: StreamBuilder<List<Contact>>(
        stream: viewModel.contactDevicesSubject,
        builder: (context, snapShot) {
          final List<Contact>? contacts = snapShot.data ?? null;
          if (contacts == null) {
            return Container(
              padding: const EdgeInsets.only(top: 10),
              alignment: Alignment.topCenter,
              child: const AppLoadingIndicator(),
            );
          } else {
            return AnimationList(
              duration: AppConstants.ANIMATION_LIST_DURATION,
              reBounceDepth: AppConstants.ANIMATION_LIST_RE_BOUNCE_DEPTH,
              padding: EdgeInsets.zero,
              children: contacts.map((contact) {
                final Uint8List? avatar = contact.avatar;
                final String phoneNumber = contact.phones
                        ?.where((element) => element.value?.isNotEmpty ?? false)
                        .firstOrNull
                        ?.value ??
                    '';
                return ListTile(
                  leading: avatar != null && avatar.isNotEmpty
                      ? Image.memory(avatar, fit: BoxFit.cover)
                      : Image.asset(AppImages.imgAvatarDefault, fit: BoxFit.cover),
                  title: Text(
                    contact.displayName ?? "",
                    style: TextStyle(
                      fontSize: AppFontSize.textQuestion,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: phoneNumber.isNotEmpty ? Text(phoneNumber) : SizedBox(),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
