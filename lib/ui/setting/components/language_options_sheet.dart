import 'package:flutter/material.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/ui/setting/setting_viewmodel.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_languages.dart';

class LanguageOptionsSheet extends StatelessWidget {
  final SettingViewModel _viewModel;

  const LanguageOptionsSheet(this._viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _viewModel.selectedLanguageSubject,
      builder: (context, snapshot) {
        final language = snapshot.data ?? 'en';
        return StreamBuilder<bool>(
          stream: _viewModel.loadingSubject,
          builder: (context, loadingSnapshot) {
            final isLoading = loadingSnapshot.data ?? false;
            return Container(
              padding: EdgeInsets.only(top: 5, bottom: 8),
              child: AbsorbPointer(
                absorbing: isLoading,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Wrap(
                      children: <Widget>[
                        _OptionTile(
                          title: allTranslations.text(AppLanguages.english),
                          langCode: "en",
                          selectedLanguage: language,
                          onTap: _viewModel.updateLanguage,
                        ),
                        _OptionTile(
                          title: allTranslations.text(AppLanguages.portuguese),
                          langCode: "pt",
                          selectedLanguage: language,
                          onTap: _viewModel.updateLanguage,
                        ),
                        _OptionTile(
                          title: allTranslations.text(AppLanguages.spanish),
                          langCode: "es",
                          selectedLanguage: language,
                          onTap: _viewModel.updateLanguage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final String langCode;
  final String selectedLanguage;
  final ValueChanged<String> onTap;

  const _OptionTile({
    required this.title,
    required this.langCode,
    required this.selectedLanguage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.normal,
          fontWeight: selectedLanguage == langCode
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      onTap: () => onTap(langCode),
      contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 0),
    );
  }
}
