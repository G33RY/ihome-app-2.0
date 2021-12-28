import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ihome/widgets/my_button.dart';
import '/generated/l10n.dart';

class CustomTabBar extends StatelessWidget {
  double? blur;
  Color? backgroundColor;
  TabItemStyle? selectedItemStyle;
  TabItemStyle? unselectedItemStyle;
  int selectedIndex;
  Function(int index) onTap;
  List<CustomNavigationBarItem> items;

  CustomTabBar({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    this.blur,
    this.backgroundColor,
    this.selectedItemStyle,
    this.unselectedItemStyle,
  });

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      color: backgroundColor,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur ?? 5,
            sigmaY: blur ?? 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buildTabs(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildTabs() {
    return [
      for (var i = 0; i < items.length; i++) ...[
        MyButton(
          onTap: () => onTap.call(i),
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                items[i].icon,
                size: selectedIndex == i
                    ? selectedItemStyle?.iconSIze
                    : unselectedItemStyle?.iconSIze,
                color: selectedIndex == i
                    ? selectedItemStyle?.iconColor
                    : unselectedItemStyle?.iconColor,
              ),
              Text(
                items[i].label,
                style: selectedIndex == i
                    ? selectedItemStyle?.textStyle
                    : unselectedItemStyle?.textStyle,
              ),
            ],
          ),
        ),
      ],
    ];
  }
}

class CustomNavigationBarItem {
  final IconData icon;
  final String label;

  const CustomNavigationBarItem({required this.label, required this.icon});
}

class TabItemStyle {
  final TextStyle textStyle;
  final double iconSIze;
  final Color iconColor;

  const TabItemStyle({
    required this.textStyle,
    required this.iconSIze,
    required this.iconColor,
  });
}
