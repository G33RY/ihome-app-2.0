import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihome/helpers/constants.dart';
import 'package:ihome/widgets/my_button.dart';

import '/generated/l10n.dart';

class IconPicker extends StatelessWidget {
  final IconData icon;
  final Function(IconData value) onChange;
  const IconPicker({
    required this.onChange,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: cupertinoIcons.map((_icon) {
        return MyButton(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(5),
          boxDecoration: BoxDecoration(
            border: Border.all(
              color: icon == _icon ? MyColors.orange : Colors.transparent,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            _icon,
            size: 40,
            color: Colors.white,
          ),
          onTap: () => onChange(_icon),
        );
      }).toList(),
    );
  }
}

List<IconData> cupertinoIcons = [
  CupertinoIcons.sunset_fill,
  CupertinoIcons.sunrise_fill,
  CupertinoIcons.house_fill,
  CupertinoIcons.house_fill,
  CupertinoIcons.clock_fill,
  CupertinoIcons.tv_fill,
  CupertinoIcons.game_controller_solid,
  CupertinoIcons.person_fill,
  CupertinoIcons.play_circle_fill,
  CupertinoIcons.money_dollar,
  CupertinoIcons.alarm_fill,
  CupertinoIcons.heart_fill,
  CupertinoIcons.bed_double_fill,
  CupertinoIcons.zzz,
];
