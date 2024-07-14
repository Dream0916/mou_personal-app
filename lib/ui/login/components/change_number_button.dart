import 'package:flutter/material.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/utils/app_languages.dart';

class ChangeNumberButton extends StatelessWidget {
  const ChangeNumberButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, Routers.SEND_EMAIL),
        child: Text(
          allTranslations.text(AppLanguages.changeNumber),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            shadows: const <Shadow>[
              Shadow(
                blurRadius: 4,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
