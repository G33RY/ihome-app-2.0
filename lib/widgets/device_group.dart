import 'package:flutter/material.dart';
import 'package:ihome/helpers/constants.dart';
import 'package:ihome/models/device.dart';
import 'package:ihome/models/device_group.dart';
import 'package:ihome/widgets/my_button.dart';

class DeviceGroupWidget extends StatelessWidget {
  DeviceGroup group;
  final Function() onTap;
  final Function() onLongTap;

  DeviceGroupWidget({
    required this.group,
    required this.onTap,
    required this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    String subtitle = "";
    subtitle = "${((group.percentage ?? 0) * 100).toInt()}%";

    return MyButton(
      margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 25,
      ),
      boxDecoration: BoxDecoration(
        color: group.isOn ? Colors.white : MyColors.white60,
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: onTap,
      onLongTap: onLongTap,
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15, bottom: 10, top: 5),
              child: Icon(
                group.type.icon,
                size: 35,
                color: group.isOn ? MyColors.orange : MyColors.gray,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                group.name,
                overflow: TextOverflow.clip,
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: "SFCompact",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: group.isOn ? Colors.black : MyColors.gray,
                ),
              ),
            ),
            Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: "SFCompact",
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: group.isOn ? MyColors.gray60 : MyColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
