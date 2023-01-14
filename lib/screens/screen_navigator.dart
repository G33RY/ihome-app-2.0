import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihome/MainCubit.dart';
import 'package:ihome/helpers/utils.dart';
import 'package:ihome/helpers/constants.dart';
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

  ScreenNavigator({
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
  Duration duration = const Duration(seconds: 15);

  int screenIndex = 0;
  late TabController controller;
  bool inactive = false;
  Timer? inactiveTimer;
  Timer? timer;
  late MainState state;
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

    final List<String> bgs = [
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
      if (inactive) {
        Utils.setBrightness(
          calcClockModeBrightness(
            forceDim: state.getSetting('force_dim', false) as bool,
            wakeAt: state.getSetting('wake_at', 6) as int,
            dimAt: state.getSetting('dim_at', 22) as int,
            brightness: state.getSetting('brightness', 1) as num,
          ),
        );
      }
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    });

    MainCubit cubit = BlocProvider.of<MainCubit>(context);
    state = cubit.state;

    duration = Duration(
      seconds: int.parse(state.getSetting('timeout', 15).toString()),
    );
    onInteraction();
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
            BlocListener<MainCubit, MainState>(
              listener: (context, state) {
                setState(() {
                  this.state = state;

                  duration = Duration(
                    seconds:
                        int.parse(state.getSetting('timeout', 15).toString()),
                  );
                });
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
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
    Utils.setBrightness(
      calcClockModeBrightness(
        forceDim: state.getSetting('force_dim', false) as bool,
        wakeAt: state.getSetting('wake_at', 6) as int,
        dimAt: state.getSetting('dim_at', 22) as int,
        brightness: state.getSetting('brightness', 1) as num,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    setState(() {
      inactive = false;
    });

    inactiveTimer?.cancel();
    inactiveTimer = Timer(duration, onInactive);
  }

  void onInactive() {
    if (States.popupActive) {
      return;
    }
    double brigthness = 0;
    if (state.getSetting('clock_mode', false) == true) {
      brigthness = calcClockModeBrightness(
        forceDim: state.getSetting('force_dim', false) as bool,
        wakeAt: state.getSetting('wake_at', 6) as int,
        dimAt: state.getSetting('dim_at', 22) as int,
        brightness: state.getSetting('brightness', 1) as num,
      );
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

double calcClockModeBrightness({
  bool forceDim = false,
  num brightness = 1,
  int wakeAt = 6,
  int dimAt = 22,
}) {
  if (forceDim) {
    return brightness.toDouble();
  }

  final DateTime now = DateTime.now();
  if (wakeAt < dimAt) {
    if (now.hour > wakeAt && now.hour < dimAt) {
      return 1;
    }
    return brightness.toDouble();
  }

  if (now.hour > wakeAt || now.hour < dimAt) {
    return 1;
  }

  return brightness.toDouble();
}
