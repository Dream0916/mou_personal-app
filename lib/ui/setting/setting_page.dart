import 'package:flutter/material.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/setting/components/language_options_sheet.dart';
import 'package:mou_app/ui/setting/setting_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_body.dart';
import 'package:mou_app/ui/widgets/app_content.dart';
import 'package:mou_app/ui/widgets/loading_full_screen.dart';
import 'package:mou_app/ui/widgets/menu/app_menu_bar.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingPage extends StatefulWidget {
  final String routeName;

  const SettingPage({super.key, required this.routeName});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    if (widget.routeName.isNotEmpty) {
      Future.delayed(
        Duration(milliseconds: 500),
        () => Navigator.pushNamed(context, widget.routeName),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SettingViewModel>(
      viewModel: SettingViewModel(Provider.of(context)),
      onViewModelReady: (viewModel) => viewModel,
      builder: (context, viewModel, child) => Scaffold(
        key: viewModel.scaffoldKey,
        body: StreamBuilder<bool>(
          stream: viewModel.loadingSubject,
          builder: (context, snapshot) {
            return LoadingFullScreen(
              loading: snapshot.data ?? false,
              child: AppBody(
                child: AppContent(
                  menuBarBuilder: (stream) => AppMenuBar(tabObserveStream: stream),
                  headerBuilder: (_) => Container(
                    height: AppConstants.appBarHeight,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 13),
                      child: Image(
                        image: AssetImage(AppImages.icSettings_g),
                        height: 47,
                      ),
                    ),
                  ),
                  childBuilder: (hasInternet) => _buildContent(viewModel, hasInternet),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(SettingViewModel viewModel, bool hasInternet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 10),
        _buildItem(
          viewModel,
          pathIcon: AppImages.icAccount,
          title: allTranslations.text(AppLanguages.accountProfile),
          onPressed: viewModel.onGoToEditProfile,
        ),
        _buildItem(
          viewModel,
          pathIcon: AppImages.icCorp,
          title: allTranslations.text(AppLanguages.corp),
          onPressed: viewModel.onGoToCorp,
        ),
        /*  _buildItem(
          viewModel,
          pathIcon: AppImages.icBusy,
          title: allTranslations.text(AppLanguages.busyMode),
          action: _buildBusyModeAction(viewModel),
        ),*/
        _buildItem(
          viewModel,
          pathIcon: AppImages.icLanguage,
          title: allTranslations.text(AppLanguages.language),
          onPressed: () => _showBottomSheet(viewModel),
        ),
        _buildItemDonate(
          viewModel,
          pathIcon: AppImages.icDonate,
          title: allTranslations.text(AppLanguages.donate),
          onPressed: () async {
            if (await canLaunchUrlString(AppConstants.linkDonate)) {
              await launchUrlString(AppConstants.linkDonate);
            } else {
              print(AppConstants.linkDonate);
            }
          },
        ),
        const SizedBox(height: 5),
        _buildItemFeedback(
          viewModel,
          pathIcon: AppImages.icFeedback,
          title: allTranslations.text(AppLanguages.feedback),
          onPressed: () => Navigator.pushNamed(context, Routers.FEEDBACK),
        ),
        _buildItemAbout(
          viewModel,
          pathIcon: AppImages.icAbout,
          title: allTranslations.text(AppLanguages.about),
          onPressed: () async {
            if (await canLaunchUrlString(AppConstants.linkAbout)) {
              await launchUrlString(AppConstants.linkAbout);
            } else {
              print(AppConstants.linkAbout);
            }
          },
        ),
        if (hasInternet)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: GestureDetector(
                onTap: viewModel.showDialogConfirmLogout,
                child: Image.asset(
                  AppImages.icLogout,
                  height: 60,
                  width: 60,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildItemDonate(
    SettingViewModel viewModel, {
    String? title,
    Widget? action,
    String? pathIcon,
    GestureTapCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 26),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "$pathIcon",
                width: 30,
                height: 30,
              ),
              SizedBox(width: 20),
              Expanded(
                  child: Text(
                title ?? "",
                style:
                    TextStyle(fontSize: 18, color: AppColors.normal, fontWeight: FontWeight.bold),
              )),
              action ?? Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemAbout(
    SettingViewModel viewModel, {
    String? title,
    Widget? action,
    String? pathIcon,
    GestureTapCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 26),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                pathIcon ?? "",
                width: 40,
                height: 40,
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                title ?? "",
                style:
                    TextStyle(fontSize: 18, color: AppColors.normal, fontWeight: FontWeight.bold),
              )),
              SizedBox(width: 15),
              action ?? Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    SettingViewModel viewModel, {
    String? pathIcon,
    String? title,
    Widget? action,
    GestureTapCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 26),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                pathIcon ?? "",
                width: 35,
                height: 35,
              ),
              SizedBox(width: 15),
              Expanded(
                  child: Text(
                title ?? "",
                style:
                    TextStyle(fontSize: 18, color: AppColors.normal, fontWeight: FontWeight.bold),
              )),
              SizedBox(width: 15),
              action ?? Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemFeedback(
    SettingViewModel viewModel, {
    String? pathIcon,
    String? title,
    Widget? action,
    GestureTapCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 26),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                pathIcon ?? "",
                width: 30,
                height: 30,
              ),
              SizedBox(width: 20),
              Expanded(
                  child: Text(
                title ?? "",
                style:
                    TextStyle(fontSize: 18, color: AppColors.normal, fontWeight: FontWeight.bold),
              )),
              SizedBox(width: 15),
              action ?? Container()
            ],
          ),
        ),
      ),
    );
  }

  _showBottomSheet(SettingViewModel viewModel) async {
    return showModalBottomSheet(
      backgroundColor: AppColors.bgColor,
      context: context,
      elevation: 0,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      builder: (_) => LanguageOptionsSheet(viewModel),
    );
  }
}
