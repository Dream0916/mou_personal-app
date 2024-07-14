import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/services/wifi_service.dart';
import 'package:mou_app/helpers/translations.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_languages.dart';
import 'package:rxdart/rxdart.dart';

class AppContent extends StatefulWidget {
  final Widget Function(Stream<int>)? menuBarBuilder;
  final Widget Function(bool hasInternet)? headerBuilder;
  final Widget Function(bool hasInternet) childBuilder;
  final ImageProvider? headerImage;
  final Widget? overlay;

  const AppContent({
    super.key,
    this.menuBarBuilder,
    this.headerBuilder,
    required this.childBuilder,
    this.headerImage,
    this.overlay,
  });

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  final _tabGestureObserveStream = BehaviorSubject<int>();

  @override
  void dispose() {
    super.dispose();
    _tabGestureObserveStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: WifiService.wifiSubject,
      builder: (_, snapshot) {
        bool hasInternet = snapshot.hasData ? snapshot.data != ConnectivityResult.none : true;

        return GestureDetector(
          onTap: () => _tabGestureObserveStream.add(DateTime.now().microsecondsSinceEpoch),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, AppColors.bgColor, AppColors.bgColor2],
                stops: [0.1, 0.11, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: <Widget>[
                widget.headerBuilder == null
                    ? widget.childBuilder.call(hasInternet)
                    : Stack(
                        children: [
                          Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    alignment: FractionalOffset.bottomCenter,
                                    image:
                                        widget.headerImage ?? AssetImage(AppImages.bgCalendarNew),
                                  ),
                                ),
                                child: widget.headerBuilder!.call(hasInternet),
                              ),
                              Flexible(child: widget.childBuilder.call(hasInternet)),
                            ],
                          ),
                          if (!hasInternet)
                            Positioned(
                              bottom: 0,
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                color: AppColors.redColor.withOpacity(0.8),
                                child: Text(
                                  allTranslations.text(AppLanguages.noInternet),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: widget.menuBarBuilder?.call(_tabGestureObserveStream.stream) ??
                      const SizedBox(),
                ),
                Positioned.fill(child: widget.overlay ?? const SizedBox()),
              ],
            ),
          ),
        );
      },
    );
  }
}
