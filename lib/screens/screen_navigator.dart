import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/models/setting.dart';
import 'package:ihome/screens/offline_screen.dart';
import 'package:ihome/widgets/custom_tab_bar.dart';
import 'package:ihome/widgets/page_control.dart';
import '/generated/l10n.dart';

class ScreenNavigator extends StatefulWidget {
  final List<ScreenInfo> screens;
  final double? tabBarBlur;
  final Color? tabBackgroundColor;
  final TabItemStyle? tabSelectedStyle;
  final TabItemStyle? tabUnselectedStyle;

  const ScreenNavigator({
    required this.screens,
    this.tabBarBlur,
    this.tabBackgroundColor,
    this.tabSelectedStyle,
    this.tabUnselectedStyle,
  });

  @override
  State<StatefulWidget> createState() => _ScreenNavigatorState();
}

class _ScreenNavigatorState extends State<ScreenNavigator>
    with SingleTickerProviderStateMixin {
  Duration duration = Duration(
      seconds: int.parse(Setting.getValueByKey("timeout", 15).toString()));

  int screenIndex = 0;
  late TabController controller;
  bool inactive = false;
  Timer? inactiveTimer;
  Timer? timer;
  String backgroundImage = "assets/images/bg1.jpg";

  @override
  void initState() {
    super.initState();

    controller = TabController(
        length: widget.screens.length, vsync: this, initialIndex: screenIndex);
    controller.addListener(() {
      setState(() {
        screenIndex = controller.index;
      });
    });

    List<String> bgs = [
      "assets/images/bg0.jpg",
      "assets/images/bg2.jpg",
      "assets/images/bg3.jpg",
      "assets/images/bg4.jpg",
      "assets/images/bg5.jpg",
    ];

    timer = Timer.periodic(const Duration(minutes: 5), (t) {
      //Set bg
      setState(() {
        backgroundImage = bgs[min(
            (DateTime.now().hour / (24 ~/ bgs.length)).ceil() - 1,
            bgs.length - 1)];
      });

      //Set brightness
      if (inactive) Utils.setBrightness(calcClockModeBrightness());
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    });
  }

  @override
  void dispose() {
    inactiveTimer?.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (event) {
          onInteraction();
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 20,
                          right: 64,
                        ),
                        child: PageControl(
                          currentIndex: screenIndex,
                          pageCount: widget.screens.length,
                          size: 8,
                          horizontalMargin: 10,
                          selectedColor: Colors.white,
                          unselectedColor: MyColors.gray,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      children: widget.screens.map((e) {
                        return e.screen;
                      }).toList(),
                    ),
                  ),
                  buildNavigationBar(),
                ],
              ),
            ),
            if (inactive) ...[OfflineScreen()],
          ],
        ),
      ),
    );
  }

  Widget buildNavigationBar() {
    return CustomTabBar(
      blur: widget.tabBarBlur,
      onTap: controller.animateTo,
      selectedIndex: screenIndex,
      selectedItemStyle: widget.tabSelectedStyle,
      unselectedItemStyle: widget.tabUnselectedStyle,
      backgroundColor: widget.tabBackgroundColor,
      items: widget.screens
          .map(
            (screenInfo) => CustomNavigationBarItem(
              label: screenInfo.tabTitle,
              icon: screenInfo.tabIcon,
            ),
          )
          .toList(),
    );
  }

  onInteraction() {
    Utils.setBrightness(calcClockModeBrightness());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    setState(() {
      inactive = false;
    });

    inactiveTimer?.cancel();
    inactiveTimer = Timer(duration, onInactive);
  }

  onInactive() {
    if (States.popupActive) {
      return;
    }
    double brigthness = 0;
    if (Setting.getValueByKey("clock_mode", false) == true) {
      brigthness = calcClockModeBrightness();
    }
    setState(() {
      inactive = true;
    });
    Utils.setBrightness(brigthness);
  }
}

class ScreenInfo {
  Widget screen;
  IconData tabIcon;
  String tabTitle;
  ScreenInfo(
    this.screen,
    this.tabIcon,
    this.tabTitle,
  );
}

double calcClockModeBrightness() {
  double brightness = 1;

  if (Setting.getValueByKey("force_dim", false) == true) {
    return int.parse(Setting.getValueByKey("brightness", 0).toString()) / 100;
  }

  List<int> wakeAtList = Setting.getValueByKey("wake_at", [6, 0]) as List<int>;
  List<int> dimAtList = Setting.getValueByKey("dim_at", [22, 0]) as List<int>;
  DateTime now = DateTime.now();
  if (wakeAtList[0] < dimAtList[0]) {
    DateTime wakeAt = DateTime(
      now.year,
      now.month,
      now.day,
      wakeAtList[0],
      wakeAtList[1],
    );
    DateTime dimAt = DateTime(
      now.year,
      now.month,
      now.day,
      dimAtList[0],
      dimAtList[1],
    );

    if (now.isBefore(wakeAt) || now.isAfter(dimAt)) {
      brightness =
          int.parse(Setting.getValueByKey("brightness", 0).toString()) / 100;
      ;
    } else {
      brightness = 1;
    }
  } else {
    DateTime wakeAt = DateTime(
      now.year,
      now.month,
      now.day,
      wakeAtList[0],
      wakeAtList[1],
    );
    DateTime dimAt = DateTime(
      now.year,
      now.month,
      now.day,
      dimAtList[0],
      dimAtList[1],
    );

    if (now.isBefore(wakeAt) && now.isAfter(dimAt)) {
      brightness =
          int.parse(Setting.getValueByKey("brightness", 0).toString()) / 100;
      ;
    } else {
      brightness = 1;
    }
  }
  return brightness;
}
