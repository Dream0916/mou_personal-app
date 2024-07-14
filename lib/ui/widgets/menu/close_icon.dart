import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mou_app/utils/app_images.dart';

class CloseIcon extends StatelessWidget {
  final bool isShowKeyboard;
  final VoidCallback? onTap;
  const CloseIcon({super.key,required this.isShowKeyboard,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (!isShowKeyboard)
            Padding(
              padding: EdgeInsets.only(bottom: Platform.isIOS ? 26.0 : 16.0),
              child: Container(
                width: 50,
                //height: 98,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: <Widget>[
                    Image.asset(AppImages.bgOpenBar),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Container(
                        //alignment: Alignment.bottomCenter,
                        height: 47,
                        width: 47,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.icOpenBar),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          child: InkWell(
                            onTap: onTap,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            child: Container(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          Container(
            width: 7,
            //width: 7,
            height: double.infinity,
            //color: AppColors.red,

            child: Image.asset(
              AppImages.icClosedbarLine,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
