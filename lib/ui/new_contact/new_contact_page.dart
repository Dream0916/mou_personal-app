import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/new_contact/new_contact_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_content.dart';
import 'package:mou_app/ui/widgets/app_loading.dart';
import 'package:mou_app/ui/widgets/menu/app_menu_bar.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_images.dart';

class NewContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<NewContactViewModel>(
      viewModel: NewContactViewModel(),
      onViewModelReady: (viewModel) => viewModel,
      builder: (context, viewModel, child) => Scaffold(
        key: viewModel.scaffoldKey,
        body: AppContent(
          headerImage: AssetImage(AppImages.bgProject),
          headerBuilder: (_) => _buildAppBar(context, viewModel),
          menuBarBuilder: (stream) => AppMenuBar(tabObserveStream: stream),
          childBuilder: (_) => _buildContent(context, viewModel),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, NewContactViewModel viewModel) {
    return SafeArea(
      top: false,
      child: Container(
        height: 93,
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: StreamBuilder<bool>(
                stream: viewModel.isSwitchOffStream,
                builder: (context, snapshot) {
                  final bool isSwitch = snapshot.data ?? false;
                  return InkWell(
                    onTap: () {
                      viewModel.isSwitchOffStream.add(!isSwitch);
                    },
                    child: isSwitch
                        ? Image.asset(AppImages.icSwitchOn, height: 16)
                        : Image.asset(AppImages.icSwitchOff, height: 16),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 31),
              child: _buildButtonAdd(context, viewModel),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {},
                child: Icon(Icons.contacts),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonAdd(BuildContext context, NewContactViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Center(
        child: Material(
          elevation: 5,
          color: AppColors.buttonFabs,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.add, color: Colors.white, size: 22),
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, Routers.ADD_CONTACT);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, NewContactViewModel viewModel) {
//    final projectDao = Provider.of<ProjectDao>(context);
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height - 93,
      width: size.width,
      color: Color(0xfffafbfc),
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: StreamBuilder<bool>(
        stream: viewModel.loadingSubject,
        builder: (context, snapLoading) {
          var loading = snapLoading.data ?? false;
          if (loading) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[const AppLoadingIndicator()],
            );
          }
          return AnimationList(
            duration: AppConstants.ANIMATION_LIST_DURATION,
            reBounceDepth: AppConstants.ANIMATION_LIST_RE_BOUNCE_DEPTH,
            children: List.generate(20, (index) => _buildCell(context, viewModel, index)),
          );
        },
      ),
    );
  }

  Widget _buildCell(BuildContext context, NewContactViewModel viewModel, int index) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 40,
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 46,
                width: 75,
                margin: EdgeInsets.only(bottom: 27.5),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.photo0),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Name",
                    style: TextStyle(
                      color: Color(0xff505050),
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                      color: Color(0xff939598),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: Icon(
              Icons.check,
              color: index % 2 == 0 ? Colors.red[600] : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
