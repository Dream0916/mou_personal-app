import 'dart:async';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:mou_app/helpers/routers.dart';
import 'package:mou_app/ui/widgets/menu/close_icon.dart';
import 'package:mou_app/ui/widgets/menu/comingsoon.dart';
import 'package:mou_app/ui/widgets/menu/open_icon.dart';
import 'package:mou_app/ui/widgets/menu/other_icon.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:mou_app/utils/app_types/app_types.dart';
import 'package:mou_app/utils/app_types/bubble_button_type.dart';

class AppMenuBar extends StatefulWidget {
  final Function(bool isShow)? onOpenBar;
  final VoidCallback? onCloseBar;
  final Stream<int>? tabObserveStream;

  AppMenuBar({
    this.onOpenBar,
    this.tabObserveStream,
    this.onCloseBar,
  });

  @override
  _AppMenuBarState createState() => _AppMenuBarState();
}

class _AppMenuBarState extends State<AppMenuBar> with SingleTickerProviderStateMixin {
  List<bool> _floatingContentVisibility = HomeNavigationBarIcon.values.map((e) => false).toList();
  bool _isMenuBarVisible = false;
  bool _isKeyboardVisible = false;

  StreamSubscription? _observeKeyboardVisibilitySubscription;
  StreamSubscription? _observeTapGestureSubscription;

  bool _isContentVisible(HomeNavigationBarIcon icon) =>
      _floatingContentVisibility.elementAt(icon.index);

  @protected
  void initState() {
    super.initState();
    _observeKeyboardVisibilitySubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
    _observeTapGestureSubscription = widget.tabObserveStream?.distinct().listen((_) {
      if (_isMenuBarVisible) {
        _onClosePressed();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _observeKeyboardVisibilitySubscription?.cancel();
    _observeTapGestureSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BackdropFilter(
      filter: _isMenuBarVisible ? ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5) : ImageFilter.blur(),
      blendMode: BlendMode.srcOver,
      child: Container(
        width: width,
        alignment: Alignment.centerLeft,
        child: _isMenuBarVisible
            ? GestureDetector(
                onTap: _onClosePressed,
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[_buildDraw(), OpenIcon(onTap: _onClosePressed)],
                    ),
                    if (_isContentVisible(HomeNavigationBarIcon.calendarAndMore))
                      Positioned(
                        right: 61,
                        bottom: 67,
                        child: SizedBox(
                          width: 180,
                          height: 180,
                          child: Stack(
                            children: BubbleButtonType.values
                                .map(
                                  (e) => Positioned(
                                    bottom: e.positionOffset.$1,
                                    right: e.positionOffset.$2,
                                    child: OtherIcon(
                                      type: e,
                                      onTap: () => _processTabOther(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                  ],
                ),
              )
            : CloseIcon(
                isShowKeyboard: _isKeyboardVisible,
                onTap: () {
                  if (this.widget.onOpenBar != null) this.widget.onOpenBar!(!_isMenuBarVisible);
                  setState(() {
                    _isMenuBarVisible = !_isMenuBarVisible;
                  });
                },
              ),
      ),
    );
  }

  void _onClosePressed() {
    widget.onOpenBar?.call(!_isMenuBarVisible);
    setState(() {
      _isMenuBarVisible = !_isMenuBarVisible;
      _floatingContentVisibility = _floatingContentVisibility.map((e) => false).toList();
    });
  }

  void _processTabOther(BubbleButtonType type) {
    switch (type) {
      case BubbleButtonType.Settings:
        Navigator.pushNamed(context, Routers.SETTING);
        break;
      case BubbleButtonType.Event:
        Navigator.pushNamed(context, Routers.EVENT);
        break;
      case BubbleButtonType.Todo:
        Navigator.pushNamed(context, Routers.TODOS);
        break;
      case BubbleButtonType.Calendar:
        Navigator.pushNamedAndRemoveUntil(context, Routers.HOME, (router) => false);
        break;
    }
    widget.onCloseBar?.call();
    _onClosePressed();
  }

  void _onIconPressed(HomeNavigationBarIcon icon, {String? navigatingPage}) {
    setState(() {
      _floatingContentVisibility =
          _floatingContentVisibility.mapIndexed((index, e) => index == icon.index && !e).toList();
    });
    if (navigatingPage?.isNotEmpty ?? false) {
      widget.onCloseBar?.call();
      _onClosePressed();
      Navigator.pushNamed(context, navigatingPage!);
    }
  }

  _buildDraw() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: _isContentVisible(HomeNavigationBarIcon.mall) ? 16 : 40,
              ),
              if (_isContentVisible(HomeNavigationBarIcon.chat)) ...[
                const ComingSoon(),
                SizedBox(height: 150),
              ] else
                SizedBox(height: 60),
            ],
          ),
          Container(
            width: 61,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFdcbb70), Color(0xFFefda76)],
              ),
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 55),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.asset(AppImages.icMenuBarLogo),
                ),
                Expanded(child: SizedBox()),
                Column(
                  children: [
                    _MenuBarIcon(
                      onTap: () {
                        _onIconPressed(HomeNavigationBarIcon.mall);
                      },
                      icon: AppImages.icMenuBarMall,
                    ),
                    SizedBox(height: 40),
                    _MenuBarIcon(
                      onTap: () {
                        _onIconPressed(HomeNavigationBarIcon.feed);
                      },
                      icon: AppImages.icMenuBarFeed,
                    ),
                    SizedBox(height: 40),
                    _MenuBarIcon(
                      onTap: () {
                        _onIconPressed(HomeNavigationBarIcon.chat);
                      },
                      icon: AppImages.icMenuBarMessage,
                    ),
                    SizedBox(height: 40),
                    _MenuBarIcon(
                      onTap: () {
                        _onIconPressed(
                          HomeNavigationBarIcon.projects,
                          navigatingPage: Routers.WORK,
                        );
                      },
                      icon: AppImages.icMenuBarProject,
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        _onIconPressed(
                          HomeNavigationBarIcon.calendarAndMore,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Image.asset(AppImages.icMenuBarCalendar),
                            Text(
                              DateFormat("d").format(DateTime.now()),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuBarIcon extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _MenuBarIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Image.asset(icon),
      ),
    );
  }
}
