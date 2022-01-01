import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ihome/models/constants.dart';
import 'package:ihome/widgets/custom_tab_bar.dart';
import 'package:ihome/widgets/page_control.dart';
import '/generated/l10n.dart';

class ScreenNavigator extends StatefulWidget {
  final List<ScreenInfo> screens;
  final double? tabBarBlur;
  final Color? tabBackgroundColor;
  final TabItemStyle? tabSelectedStyle;
  final TabItemStyle? tabUnselectedStyle;
  final AssetImage? backgroundImage;

  const ScreenNavigator({
    required this.screens,
    this.tabBarBlur,
    this.tabBackgroundColor,
    this.tabSelectedStyle,
    this.tabUnselectedStyle,
    this.backgroundImage,
  });

  @override
  State<StatefulWidget> createState() => _ScreenNavigatorState();
}

class _ScreenNavigatorState extends State<ScreenNavigator>
    with SingleTickerProviderStateMixin {
  int screenIndex = 0;
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: widget.screens.length, vsync: this);
    controller.addListener(() {
      setState(() {
        screenIndex = controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: widget.backgroundImage != null
              ? DecorationImage(
                  image: widget.backgroundImage!,
                  fit: BoxFit.cover,
                )
              : null,
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
                  return SingleChildScrollView(
                    child: e.screen,
                  );
                }).toList(),
              ),
            ),
            buildNavigationBar(),
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
