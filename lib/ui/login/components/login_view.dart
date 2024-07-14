import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mou_app/core/models/country_phone_code.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/login/components/change_number_button.dart';
import 'package:mou_app/ui/login/components/phone_number_input.dart';
import 'package:mou_app/ui/login/login_viewmodel.dart';
import 'package:mou_app/ui/widgets/country_phone_code_dialog.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';

class LoginView extends StatelessWidget {
  final LoginViewModel viewModel;

  const LoginView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: viewModel.scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.bgLogin),
              fit: BoxFit.fill,
            ),
          ),
          child: StreamBuilder<bool>(
            stream: viewModel.loadingSubject,
            builder: (context, loadingSnapshot) {
              bool isLoading = loadingSnapshot.data ?? false;
              return Column(
                children: <Widget>[
                  const Expanded(flex: 135, child: SizedBox(height: 24)),
                  SizedBox(
                    height: 140,
                    child: Image.asset(
                      AppImages.logoLogin,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Expanded(flex: 65, child: SizedBox(height: 24)),
                  StreamBuilder<CountryPhoneCode?>(
                    stream: viewModel.phoneCodeSubject,
                    builder: (context, snapshot) {
                      final CountryPhoneCode? phoneCodeSelected = snapshot.data;
                      return PhoneNumberInput(
                        controller: viewModel.phoneNumberController,
                        focusNode: viewModel.phoneFocusNode,
                        phoneCodeSelected: phoneCodeSelected,
                        onPhoneCodePressed: () => _showPhoneCodeDialog(context),
                        onSubmitted: viewModel.onPressedLogin,
                      );
                    },
                  ),
                  Expanded(flex: isLoading ? 25 : 35, child: SizedBox()),
                  StreamBuilder<String>(
                    stream: viewModel.phoneNumberSubject,
                    builder: (context, snapshot) {
                      final String phoneText = snapshot.data ?? "";
                      return isLoading
                          ? Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: LottieBuilder.asset(
                                AppImages.animLoginLoading,
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                                repeat: true,
                              ),
                            )
                          : InkWell(
                              onTap: phoneText.isNotEmpty ? viewModel.onPressedLogin : null,
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset(
                                AppImages.btnActiveLogin,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            );
                    },
                  ),
                  const Expanded(flex: 255, child: SizedBox(height: 24)),
                  ChangeNumberButton(),
                  const SizedBox(height: 15),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showPhoneCodeDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => const SizedBox(),
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
